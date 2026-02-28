# CLAUDE.md — GymTrack Backend

## Project

GymTrack API server — gym tracking application backend.
Two fullstack developers work in vertical slices. Each developer owns their feature end-to-end.
This API serves multiple clients: web app (Next.js), future mobile app, AI/MCP services.

## Tech Stack

- **Framework**: NestJS (Node.js)
- **Database**: PostgreSQL via Supabase
- **ORM**: Prisma (schema v2, 60 models)
- **Auth**: JWT (Passport), access + refresh tokens
- **Validation**: Zod via `ZodValidationPipe`
- **Docs**: Swagger/OpenAPI (auto-generated, consumed by frontend `orval`)
- **Storage**: Supabase Storage (avatars, body photos)
- **Payments**: Stripe (subscriptions, marketplace payouts)
- **Language**: TypeScript (strict mode)

---

## Architecture Rules

### Module Structure

Every feature is a self-contained NestJS module in `src/modules/<feature>/`:

```
src/modules/workouts/
├── workouts.module.ts          # NestJS module declaration
├── workouts.controller.ts      # HTTP endpoints + Swagger decorators
├── workouts.service.ts         # Core business logic
├── sets.service.ts             # Sub-service (if main service >50 lines per method)
├── pr.service.ts               # Sub-service for PR detection
├── dto/
│   ├── create-workout.dto.ts   # Zod schema + Swagger decorators
│   ├── finish-workout.dto.ts
│   └── query-workouts.dto.ts
└── __tests__/
    ├── workouts.service.spec.ts
    └── sets.service.spec.ts
```

### Module Rules

- **One module per domain** — workouts, exercises, programs, calendar, etc.
- **Controller**: only HTTP layer — parse request, call service, return response. No business logic in controllers
- **Service**: all business logic. If a method exceeds 50 lines, extract to a sub-service
- **DTO**: every endpoint has a DTO with Zod schema. DTO = validation + Swagger docs source
- **No circular module dependencies** — if modules need to share, extract to a shared service or use events
- **Cross-module communication**: inject services via NestJS DI, never import controllers
- **Database queries**: only in services, never in controllers or guards

### Common Layer (`src/common/`)

```
src/common/
├── decorators/       # @CurrentUser(), @Roles(), @Public(), @RequirePlan()
├── guards/           # JwtAuthGuard, RolesGuard, PlanFeatureGuard
├── interceptors/     # ResponseTransform, Logging, Timeout
├── filters/          # GlobalException, PrismaException
├── pipes/            # ZodValidation
├── middleware/        # RateLimit, CORS
├── dto/              # PaginationQuery, ApiResponse
└── utils/            # pagination, calculations (1RM, volume), date helpers, i18n
```

- Guards, interceptors, filters, pipes are registered globally in `app.module.ts`
- `@CurrentUser()` decorator is the ONLY way to access the authenticated user — never `req.user`
- `@Public()` decorator skips JWT guard for open endpoints (register, login, swagger)

---

## Database & Prisma Rules

### Schema

- Schema lives in `prisma/schema.prisma` (60 models, system + user split)
- **System tables** (`sys_exercises`, `sys_programs`, `sys_foods`): JSON localization fields (`name Json`), edited only by admins/seeds
- **User tables** (`user_exercises`, `user_programs`, `user_foods`): plain String fields, user's locale
- **Polymorphic exercise references**: two nullable fields `sysExerciseId` + `userExerciseId` (exactly one filled)
- **Programs**: `source` enum (AI_GENERATED, QUICK_BUILD, ADVANCED) determines creation flow

### Query Rules

- **No raw SQL** — use Prisma Client. Only `$queryRaw` for complex aggregations with parameterized queries
- **Never `$queryRawUnsafe`** with user input — SQL injection risk
- **Always use `select` or `include`** — never return full objects with all fields
- **No N+1 queries** — use `include` for related data, or `select` with nested relations
- **Cursor pagination** for all list endpoints — never offset pagination
- **Transactions** (`prisma.$transaction()`) for multi-table writes (finish workout → update PR → create feed item)
- **Soft delete**: do NOT implement unless explicitly required — use hard delete with cascade
- **Indexes**: every foreign key column and frequently filtered column must have `@@index`
- **JSON fields**: use for flexible data (soreness map, achievement conditions, exercise notes) — but never query inside JSON (use dedicated columns for filtered data)

### Migrations

- Auto-generate with `npx prisma migrate dev --name <descriptive-name>`
- Migration names: kebab-case describing the change (`add-recovery-score`, `split-exercise-tables`)
- Never edit generated migrations manually unless fixing a rollback
- Always run `npx prisma generate` after schema changes
- Seeds in `prisma/seeds/` — separate file per domain (`exercises.seed.ts`, `plans.seed.ts`)

---

## API Design Rules

### Endpoint Conventions

- **RESTful**: `GET /workouts`, `POST /workouts`, `GET /workouts/:id`, `PATCH /workouts/:id`, `DELETE /workouts/:id`
- **kebab-case** paths: `/user-exercises`, `/workout-templates`, `/body-photos`
- **Nested resources**: `/workouts/:id/sets`, `/programs/:id/weeks` — max 2 levels deep
- **Actions**: POST for non-CRUD actions: `POST /workouts/:id/finish`, `POST /programs/:id/activate`
- **Query params** for filtering/pagination: `GET /exercises?muscleGroup=CHEST&equipment=BARBELL&cursor=xxx&limit=20`
- **No verbs in URLs** — use HTTP methods: `POST /workouts` not `POST /create-workout`

### Response Shape

All responses are wrapped by `ResponseTransformInterceptor`:

```json
{
  "data": { ... },
  "meta": {
    "timestamp": "2026-02-28T12:00:00Z",
    "pagination": { "nextCursor": "abc", "hasMore": true, "total": 150 }
  }
}
```

- Single resource: `{ data: { id, ... } }`
- List: `{ data: [...], meta: { pagination } }`
- Error: `{ error: { code: "VALIDATION_ERROR", message: "...", details: [...] } }`

### Swagger — MANDATORY

Every endpoint MUST have complete Swagger decorators:

```typescript
@ApiOperation({ summary: 'Finish active workout' })
@ApiParam({ name: 'id', type: String })
@ApiBody({ type: FinishWorkoutDto })
@ApiResponse({ status: 200, description: 'Workout finished', type: WorkoutResponseDto })
@ApiResponse({ status: 404, description: 'Workout not found' })
@ApiBearerAuth()
```

- Frontend generates types from Swagger — missing decorators = broken frontend types
- Use `@ApiTags('workouts')` on every controller
- Use `@ApiBearerAuth()` on protected endpoints
- DTO classes must have `@ApiProperty()` on every field
- Missing Swagger decorators on a new endpoint is a **blocking review issue**

---

## Authentication & Authorization

### Auth Flow

- **Register**: validate → hash password (bcrypt) → create user + settings → generate tokens → return
- **Login**: find user → verify password → generate tokens → return
- **Refresh**: verify refresh token → rotate (invalidate old, create new pair) → return
- **OAuth** (Google/Apple): verify provider token → find-or-create user → generate tokens → return

### Token Rules

- **Access token**: 15 min, JWT, contains `{ sub: userId, role }`
- **Refresh token**: 7 days, stored in `refresh_tokens` table, rotated on each use
- **Never expose** refresh tokens in response body for non-auth endpoints
- **Revoke all** refresh tokens on password change or account deletion
- **Guard**: `JwtAuthGuard` is global — all routes protected by default, use `@Public()` to opt out

### Authorization Layers

1. **JwtAuthGuard**: Is the user authenticated? (global)
2. **RolesGuard**: Does the user have the required role? (`@Roles('admin', 'trainer')`)
3. **PlanFeatureGuard**: Does the user's subscription plan allow this? (`@RequirePlan('PRO')`)
4. **Resource ownership**: Service layer checks `where: { userId }` — user can only access own data

---

## Error Handling

### Exception Classes

Use NestJS built-in exceptions — never throw generic `Error`:

```typescript
throw new NotFoundException('Workout not found');
throw new BadRequestException('Invalid set data');
throw new ForbiddenException('Upgrade to PRO to access this feature');
throw new ConflictException('Exercise with this name already exists');
throw new UnauthorizedException('Invalid credentials');
```

### Exception Filters

- `GlobalExceptionFilter`: catch-all, logs error, returns standard error response
- `PrismaExceptionFilter`: converts Prisma errors to HTTP:
  - `P2002` (unique constraint) → `409 Conflict`
  - `P2025` (record not found) → `404 Not Found`
  - `P2003` (foreign key) → `400 Bad Request`

### Rules

- **Never expose internal errors** to client — log full error, return generic message
- **Never expose stack traces** in production
- **Always log errors** with context (userId, endpoint, request body hash)
- **Prisma errors**: always caught by filter, never by service
- **Validation errors**: Zod pipe returns 400 with field-level details

---

## TypeScript Rules

- **Strict mode** — no exceptions
- **No `any`** — use `unknown` + type guards. Comment if truly unavoidable
- **Explicit return types** on all service methods and controller methods
- **`interface`** for DTOs and response shapes, **`type`** for unions
- **`const` over `let`**, never `var`
- **Exhaustive switches** — handle all enum cases, `never` for default
- **No non-null assertions** (`!`) without comment justification
- **Prisma types**: use generated types from `@prisma/client` — don't recreate

---

## Naming Conventions

- **Files**: `kebab-case.ts` (`workouts.controller.ts`, `create-workout.dto.ts`, `pr.service.ts`)
- **Classes**: PascalCase (`WorkoutsController`, `WorkoutsService`, `CreateWorkoutDto`)
- **Methods**: camelCase (`findById`, `createWorkout`, `detectPersonalRecords`)
- **Variables**: camelCase (`userId`, `workoutSets`, `isActive`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_SETS_PER_EXERCISE`, `JWT_EXPIRES_IN`)
- **Interfaces/Types**: PascalCase (`WorkoutWithSets`, `PaginatedResponse<T>`)
- **Enums**: PascalCase name, UPPER_SNAKE_CASE values (from Prisma)
- **Booleans**: `is`, `has`, `can`, `should` prefix (`isActive`, `hasSubscription`)
- **DTOs**: suffix with `Dto` (`CreateWorkoutDto`, `QueryExercisesDto`)
- **Guards**: suffix with `Guard` (`JwtAuthGuard`, `PlanFeatureGuard`)
- **Interceptors**: suffix with `Interceptor` (`ResponseTransformInterceptor`)
- **Filters**: suffix with `Filter` (`GlobalExceptionFilter`)
- **Services**: suffix with `Service` (`WorkoutsService`, `PrService`)
- **Modules**: suffix with `Module` (`WorkoutsModule`)

---

## Security Rules

- **Never commit** `.env`, API keys, secrets — use `.env.example` as template
- **Passwords**: bcrypt with salt rounds ≥ 12
- **Input validation**: Zod on every endpoint via `ZodValidationPipe`
- **SQL injection**: Prisma parameterizes by default — never `$queryRawUnsafe` with user input
- **CORS**: explicit origin whitelist in `main.ts` — never `origin: '*'` in production
- **Rate limiting**: on auth endpoints (5/min), public endpoints (60/min), API general (200/min)
- **File uploads**: validate MIME type, limit size (5MB avatar, 10MB photo), sanitize filenames
- **Sensitive data**: never log passwords, tokens, credit card numbers. Never return in API responses
- **Helmet**: use `helmet` middleware for HTTP security headers
- **RLS**: Supabase Row Level Security policies must be enabled and tested for direct DB access
- **Stripe webhooks**: verify signature with `stripe.webhooks.constructEvent()`
- **No `child_process`** or `exec` with user input — command injection risk

---

## Performance Rules

- **No N+1 queries** — use `include`/`select` with Prisma
- **Cursor pagination** on all lists — never return unbounded arrays
- **`select` only needed fields** — never return full Prisma objects
- **Indexes**: on foreign keys, frequently filtered columns, and composite indexes for common query patterns
- **Caching** (Redis, future): dashboard aggregations (5min TTL), exercise library (1h), system programs (24h)
- **Response compression**: gzip enabled in `main.ts`
- **Connection pooling**: use Supabase Supavisor — don't create new connections per request
- **Async/await**: never block event loop — use async for I/O, avoid CPU-heavy sync operations
- **Batch operations**: use `prisma.createMany()` for bulk inserts, `$transaction` for bulk updates

---

## Testing Rules

- **Unit tests**: every service method has at least one test (`*.spec.ts`)
- **E2E tests**: critical flows — auth, workout CRUD, program creation, subscription
- **Test location**: `__tests__/` folder inside each module
- **Test database**: use separate Supabase project or local Docker Postgres
- **Seeds**: test data via `prisma/seeds/` — run before test suite
- **No mocking Prisma** — test against real database
- **Naming**: `describe('WorkoutsService')` → `it('should calculate volume correctly')`
- **Coverage**: aim for 80%+ on services, 100% on auth and payment logic

---

## Git & PR Rules

### Branch Naming

```
feat/<module-name>      — feat/workouts-api, feat/programs-quick-build
fix/<description>       — fix/pr-detection-edge-case, fix/stripe-webhook-retry
refactor/<scope>        — refactor/auth-token-rotation
chore/<scope>           — chore/prisma-migration, chore/update-nestjs
```

### Commit Messages (Conventional Commits)

```
feat(workouts): add PR detection on workout finish
fix(auth): handle concurrent refresh token requests
refactor(programs): extract quick-build to separate service
chore(prisma): add index on workout_sets.workoutId
test(calendar): add e2e for bulk schedule from program
docs(swagger): complete decorators for progress module
```

- Scope = module name (`workouts`, `auth`, `programs`, `prisma`)
- Lowercase, imperative mood, <72 chars

### PR Rules

- Title = Conventional Commits format
- Description: **What**, **Why**, **How**, **API changes** (new/modified endpoints)
- Max 500 lines — split larger work
- Must pass CI (lint, test, build)
- Self-review checklist:
  - [ ] No `console.log` — use NestJS `Logger`
  - [ ] No commented-out code
  - [ ] No `TODO` without issue link
  - [ ] All new endpoints have full Swagger decorators
  - [ ] All new endpoints have at least one test
  - [ ] DTOs validated with Zod
  - [ ] No raw SQL without justification
  - [ ] No `any` types
  - [ ] Migrations included if schema changed
  - [ ] Seeds updated if new system data added

---

## Review Priority (what to check first)

1. **Security** — input validation, auth guards, data exposure, SQL injection, token handling
2. **Data integrity** — missing transactions, race conditions, cascade deletes, orphaned records
3. **Type safety** — `any`, missing types, unsafe casts, wrong Prisma return types
4. **Performance** — N+1 queries, missing select/include, no pagination, missing indexes
5. **Swagger** — missing decorators on new endpoints (blocks frontend type generation)
6. **Error handling** — generic Error instead of HttpException, missing error cases, exposed internals
7. **Naming** — convention violations, unclear method names, wrong suffixes
8. **Dead code** — unused imports, unreachable branches, commented-out code
9. **Testing** — new service methods without tests, untested edge cases
10. **Architecture** — business logic in controller, circular deps, God-service (>300 lines)
