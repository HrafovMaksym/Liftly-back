-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('USER', 'TRAINER', 'ADMIN');

-- CreateEnum
CREATE TYPE "UnitSystem" AS ENUM ('METRIC', 'IMPERIAL');

-- CreateEnum
CREATE TYPE "Theme" AS ENUM ('LIGHT', 'DARK', 'SYSTEM');

-- CreateEnum
CREATE TYPE "OAuthProvider" AS ENUM ('GOOGLE', 'APPLE', 'GITHUB');

-- CreateEnum
CREATE TYPE "MuscleGroup" AS ENUM ('CHEST', 'BACK', 'SHOULDERS', 'BICEPS', 'TRICEPS', 'FOREARMS', 'ABS', 'OBLIQUES', 'QUADS', 'HAMSTRINGS', 'GLUTES', 'CALVES', 'TRAPS', 'LATS', 'LOWER_BACK', 'HIP_FLEXORS', 'ADDUCTORS', 'ABDUCTORS', 'NECK', 'FULL_BODY', 'CARDIO');

-- CreateEnum
CREATE TYPE "Equipment" AS ENUM ('BARBELL', 'DUMBBELL', 'KETTLEBELL', 'MACHINE', 'CABLE', 'BODYWEIGHT', 'BAND', 'SMITH_MACHINE', 'EZ_BAR', 'TRAP_BAR', 'SUSPENSION', 'MEDICINE_BALL', 'FOAM_ROLLER', 'OTHER', 'NONE');

-- CreateEnum
CREATE TYPE "ExerciseType" AS ENUM ('STRENGTH', 'CARDIO', 'FLEXIBILITY', 'PLYOMETRIC', 'OLYMPIC', 'ISOMETRIC', 'HIIT', 'YOGA');

-- CreateEnum
CREATE TYPE "Mechanic" AS ENUM ('COMPOUND', 'ISOLATION');

-- CreateEnum
CREATE TYPE "ForceType" AS ENUM ('PUSH', 'PULL', 'STATIC');

-- CreateEnum
CREATE TYPE "Difficulty" AS ENUM ('BEGINNER', 'INTERMEDIATE', 'ADVANCED', 'EXPERT');

-- CreateEnum
CREATE TYPE "WorkoutStatus" AS ENUM ('IN_PROGRESS', 'COMPLETED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "SetType" AS ENUM ('WARMUP', 'WORKING', 'DROP_SET', 'FAILURE', 'REST_PAUSE', 'CLUSTER', 'MYOREP');

-- CreateEnum
CREATE TYPE "RecordType" AS ENUM ('MAX_WEIGHT', 'MAX_REPS', 'MAX_VOLUME', 'ESTIMATED_1RM', 'MAX_DURATION');

-- CreateEnum
CREATE TYPE "ProgramGoal" AS ENUM ('STRENGTH', 'HYPERTROPHY', 'POWERLIFTING', 'ENDURANCE', 'FAT_LOSS', 'GENERAL_FITNESS', 'ATHLETIC_PERFORMANCE', 'REHABILITATION');

-- CreateEnum
CREATE TYPE "Periodization" AS ENUM ('LINEAR', 'UNDULATING', 'BLOCK', 'CONJUGATE');

-- CreateEnum
CREATE TYPE "PhotoPose" AS ENUM ('FRONT', 'BACK', 'SIDE_LEFT', 'SIDE_RIGHT', 'FRONT_FLEXED', 'BACK_FLEXED');

-- CreateEnum
CREATE TYPE "MealType" AS ENUM ('BREAKFAST', 'LUNCH', 'DINNER', 'SNACK', 'PRE_WORKOUT', 'POST_WORKOUT');

-- CreateEnum
CREATE TYPE "FriendshipStatus" AS ENUM ('PENDING', 'ACCEPTED', 'BLOCKED');

-- CreateEnum
CREATE TYPE "FeedItemType" AS ENUM ('WORKOUT_COMPLETED', 'PERSONAL_RECORD', 'ACHIEVEMENT_UNLOCKED', 'STREAK_MILESTONE', 'PROGRAM_STARTED', 'PROGRAM_COMPLETED', 'CHALLENGE_WON', 'BODY_TRANSFORMATION');

-- CreateEnum
CREATE TYPE "AchievementCategory" AS ENUM ('CONSISTENCY', 'STRENGTH', 'VOLUME', 'SOCIAL', 'MILESTONE', 'BODY', 'NUTRITION', 'SPECIAL');

-- CreateEnum
CREATE TYPE "StreakType" AS ENUM ('WORKOUT', 'NUTRITION_LOG', 'BODY_LOG');

-- CreateEnum
CREATE TYPE "ChallengeType" AS ENUM ('VOLUME', 'FREQUENCY', 'CONSISTENCY', 'SPECIFIC');

-- CreateEnum
CREATE TYPE "CoachingStatus" AS ENUM ('ACTIVE', 'PAUSED', 'ENDED');

-- CreateEnum
CREATE TYPE "SubscriptionPlan" AS ENUM ('FREE', 'PRO', 'ELITE', 'TRAINER');

-- CreateEnum
CREATE TYPE "SubscriptionStatus" AS ENUM ('ACTIVE', 'PAST_DUE', 'CANCELLED', 'EXPIRED', 'TRIALING');

-- CreateEnum
CREATE TYPE "PaymentType" AS ENUM ('SUBSCRIPTION', 'PROGRAM_PURCHASE', 'COACHING');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED');

-- CreateEnum
CREATE TYPE "AiRole" AS ENUM ('USER', 'ASSISTANT', 'SYSTEM');

-- CreateEnum
CREATE TYPE "NotificationType" AS ENUM ('REST_TIMER', 'WORKOUT_REMINDER', 'FRIEND_REQUEST', 'FRIEND_ACCEPTED', 'LIKE', 'COMMENT', 'PERSONAL_RECORD', 'ACHIEVEMENT', 'STREAK_WARNING', 'STREAK_LOST', 'COACHING_MESSAGE', 'PROGRAM_UPDATE', 'AI_SUGGESTION', 'SYSTEM');

-- CreateEnum
CREATE TYPE "Platform" AS ENUM ('WEB', 'IOS', 'ANDROID');

-- CreateEnum
CREATE TYPE "IntegrationProvider" AS ENUM ('APPLE_HEALTH', 'GOOGLE_FIT', 'GARMIN', 'WHOOP', 'OURA', 'FITBIT', 'STRAVA', 'WITHINGS', 'XIAOMI');

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL,
    "email" TEXT NOT NULL,
    "password_hash" TEXT,
    "name" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "avatar_url" TEXT,
    "bio" TEXT,
    "is_public" BOOLEAN NOT NULL DEFAULT true,
    "role" "UserRole" NOT NULL DEFAULT 'USER',
    "onboarding_done" BOOLEAN NOT NULL DEFAULT false,
    "locale" TEXT NOT NULL DEFAULT 'en',
    "timezone" TEXT NOT NULL DEFAULT 'UTC',
    "unit_system" "UnitSystem" NOT NULL DEFAULT 'METRIC',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),
    "active_program_id" UUID,
    "level" INTEGER NOT NULL DEFAULT 1,
    "total_xp" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_settings" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "default_rest_seconds" INTEGER NOT NULL DEFAULT 90,
    "show_previous_workout" BOOLEAN NOT NULL DEFAULT true,
    "auto_start_timer" BOOLEAN NOT NULL DEFAULT true,
    "weight_increment" DOUBLE PRECISION NOT NULL DEFAULT 2.5,
    "rest_timer_sound" BOOLEAN NOT NULL DEFAULT true,
    "workout_reminders" BOOLEAN NOT NULL DEFAULT true,
    "reminder_time" TEXT,
    "reminder_days" INTEGER[],
    "social_notifications" BOOLEAN NOT NULL DEFAULT true,
    "pr_notifications" BOOLEAN NOT NULL DEFAULT true,
    "show_workouts_in_feed" BOOLEAN NOT NULL DEFAULT true,
    "show_body_stats" BOOLEAN NOT NULL DEFAULT false,
    "theme" "Theme" NOT NULL DEFAULT 'SYSTEM',

    CONSTRAINT "user_settings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "oauth_accounts" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "provider" "OAuthProvider" NOT NULL,
    "provider_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "oauth_accounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "refresh_tokens" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "token" TEXT NOT NULL,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "revoked_at" TIMESTAMP(3),

    CONSTRAINT "refresh_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "exercises" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "description" TEXT,
    "instructions" TEXT,
    "muscle_group" "MuscleGroup" NOT NULL,
    "secondary_muscles" "MuscleGroup"[],
    "equipment" "Equipment" NOT NULL,
    "exercise_type" "ExerciseType" NOT NULL,
    "mechanic" "Mechanic",
    "force_type" "ForceType",
    "difficulty" "Difficulty" NOT NULL DEFAULT 'INTERMEDIATE',
    "animation_url" TEXT,
    "video_url" TEXT,
    "thumbnail_url" TEXT,
    "is_custom" BOOLEAN NOT NULL DEFAULT false,
    "created_by_user_id" UUID,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "exercises_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "exercise_notes" (
    "id" UUID NOT NULL,
    "exercise_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "note" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "exercise_notes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "workouts" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "template_id" UUID,
    "program_week_day_id" UUID,
    "name" TEXT,
    "notes" TEXT,
    "started_at" TIMESTAMP(3) NOT NULL,
    "finished_at" TIMESTAMP(3),
    "duration_seconds" INTEGER,
    "total_volume" DOUBLE PRECISION,
    "total_sets" INTEGER,
    "total_reps" INTEGER,
    "calories_burned" INTEGER,
    "rating" INTEGER,
    "perceived_effort" INTEGER,
    "status" "WorkoutStatus" NOT NULL DEFAULT 'IN_PROGRESS',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "workouts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "workout_sets" (
    "id" UUID NOT NULL,
    "workout_id" UUID NOT NULL,
    "exercise_id" UUID NOT NULL,
    "set_number" INTEGER NOT NULL,
    "set_type" "SetType" NOT NULL DEFAULT 'WORKING',
    "weight" DOUBLE PRECISION,
    "reps" INTEGER,
    "duration_seconds" INTEGER,
    "distance" DOUBLE PRECISION,
    "rpe" DOUBLE PRECISION,
    "rir" INTEGER,
    "tempo" TEXT,
    "is_personal_record" BOOLEAN NOT NULL DEFAULT false,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "workout_sets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "personal_records" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "exercise_id" UUID NOT NULL,
    "record_type" "RecordType" NOT NULL,
    "value" DOUBLE PRECISION NOT NULL,
    "reps" INTEGER,
    "achieved_at" TIMESTAMP(3) NOT NULL,
    "workout_set_id" UUID,

    CONSTRAINT "personal_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "workout_templates" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "muscle_groups" "MuscleGroup"[],
    "estimated_minutes" INTEGER,
    "is_public" BOOLEAN NOT NULL DEFAULT false,
    "usage_count" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "workout_templates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "template_exercises" (
    "id" UUID NOT NULL,
    "template_id" UUID NOT NULL,
    "exercise_id" UUID NOT NULL,
    "order" INTEGER NOT NULL,
    "sets" INTEGER NOT NULL DEFAULT 3,
    "reps_min" INTEGER,
    "reps_max" INTEGER,
    "rest_seconds" INTEGER,
    "notes" TEXT,
    "superset_group" INTEGER,

    CONSTRAINT "template_exercises_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "scheduled_workouts" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "template_id" UUID NOT NULL,
    "date" DATE NOT NULL,
    "completed" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "scheduled_workouts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "programs" (
    "id" UUID NOT NULL,
    "user_id" UUID,
    "trainer_id" UUID,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "description" TEXT,
    "cover_image_url" TEXT,
    "duration_weeks" INTEGER NOT NULL,
    "days_per_week" INTEGER NOT NULL,
    "difficulty" "Difficulty" NOT NULL,
    "goal" "ProgramGoal" NOT NULL,
    "periodization" "Periodization",
    "is_public" BOOLEAN NOT NULL DEFAULT false,
    "is_official" BOOLEAN NOT NULL DEFAULT false,
    "is_premium" BOOLEAN NOT NULL DEFAULT false,
    "price" DOUBLE PRECISION,
    "rating" DOUBLE PRECISION,
    "review_count" INTEGER NOT NULL DEFAULT 0,
    "purchase_count" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "programs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "program_weeks" (
    "id" UUID NOT NULL,
    "program_id" UUID NOT NULL,
    "week_number" INTEGER NOT NULL,
    "name" TEXT,
    "deload" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "program_weeks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "program_week_days" (
    "id" UUID NOT NULL,
    "week_id" UUID NOT NULL,
    "day_number" INTEGER NOT NULL,
    "name" TEXT,
    "is_rest_day" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "program_week_days_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "program_exercises" (
    "id" UUID NOT NULL,
    "day_id" UUID NOT NULL,
    "exercise_id" UUID NOT NULL,
    "order" INTEGER NOT NULL,
    "sets" INTEGER NOT NULL DEFAULT 3,
    "reps_min" INTEGER,
    "reps_max" INTEGER,
    "percentage_of_1rm" DOUBLE PRECISION,
    "rpe_target" DOUBLE PRECISION,
    "rest_seconds" INTEGER,
    "tempo" TEXT,
    "superset_group" INTEGER,
    "notes" TEXT,

    CONSTRAINT "program_exercises_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "body_logs" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "date" DATE NOT NULL,
    "weight" DOUBLE PRECISION,
    "body_fat" DOUBLE PRECISION,
    "muscle_mass" DOUBLE PRECISION,
    "neck" DOUBLE PRECISION,
    "shoulders" DOUBLE PRECISION,
    "chest" DOUBLE PRECISION,
    "left_bicep" DOUBLE PRECISION,
    "right_bicep" DOUBLE PRECISION,
    "waist" DOUBLE PRECISION,
    "hips" DOUBLE PRECISION,
    "left_thigh" DOUBLE PRECISION,
    "right_thigh" DOUBLE PRECISION,
    "left_calf" DOUBLE PRECISION,
    "right_calf" DOUBLE PRECISION,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "body_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "body_photos" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "date" DATE NOT NULL,
    "photo_url" TEXT NOT NULL,
    "pose" "PhotoPose" NOT NULL,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "body_photos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "foods" (
    "id" UUID NOT NULL,
    "barcode" TEXT,
    "name" TEXT NOT NULL,
    "brand" TEXT,
    "serving_size" DOUBLE PRECISION NOT NULL,
    "serving_unit" TEXT NOT NULL DEFAULT 'g',
    "calories" DOUBLE PRECISION NOT NULL,
    "protein" DOUBLE PRECISION NOT NULL,
    "carbs" DOUBLE PRECISION NOT NULL,
    "fat" DOUBLE PRECISION NOT NULL,
    "fiber" DOUBLE PRECISION,
    "sugar" DOUBLE PRECISION,
    "sodium" DOUBLE PRECISION,
    "is_custom" BOOLEAN NOT NULL DEFAULT false,
    "created_by_user_id" UUID,
    "is_verified" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "foods_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "nutrition_logs" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "date" DATE NOT NULL,
    "target_calories" INTEGER,
    "target_protein" DOUBLE PRECISION,
    "target_carbs" DOUBLE PRECISION,
    "target_fat" DOUBLE PRECISION,
    "total_calories" DOUBLE PRECISION,
    "total_protein" DOUBLE PRECISION,
    "total_carbs" DOUBLE PRECISION,
    "total_fat" DOUBLE PRECISION,
    "water_ml" INTEGER,

    CONSTRAINT "nutrition_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "meals" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "nutrition_log_id" UUID NOT NULL,
    "meal_type" "MealType" NOT NULL,
    "name" TEXT,
    "time" TIMESTAMP(3),

    CONSTRAINT "meals_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "meal_items" (
    "id" UUID NOT NULL,
    "meal_id" UUID NOT NULL,
    "food_id" UUID NOT NULL,
    "quantity" DOUBLE PRECISION NOT NULL,
    "unit" TEXT NOT NULL DEFAULT 'g',
    "calories" DOUBLE PRECISION NOT NULL,
    "protein" DOUBLE PRECISION NOT NULL,
    "carbs" DOUBLE PRECISION NOT NULL,
    "fat" DOUBLE PRECISION NOT NULL,

    CONSTRAINT "meal_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "recovery_logs" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "date" DATE NOT NULL,
    "recovery_score" INTEGER,
    "readiness_score" INTEGER,
    "stress_level" INTEGER,
    "mood" INTEGER,
    "energy_level" INTEGER,
    "hrv" DOUBLE PRECISION,
    "resting_hr" INTEGER,
    "soreness" JSONB,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "recovery_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sleep_logs" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "date" DATE NOT NULL,
    "bedtime" TIMESTAMP(3),
    "wake_time" TIMESTAMP(3),
    "duration_minutes" INTEGER,
    "quality" INTEGER,
    "source" TEXT,

    CONSTRAINT "sleep_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "friendships" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "friend_id" UUID NOT NULL,
    "status" "FriendshipStatus" NOT NULL DEFAULT 'PENDING',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "friendships_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "feed_items" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "type" "FeedItemType" NOT NULL,
    "workout_id" UUID,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "feed_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "comments" (
    "id" UUID NOT NULL,
    "feed_item_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "text" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "comments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "likes" (
    "id" UUID NOT NULL,
    "feed_item_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "likes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "achievements" (
    "id" UUID NOT NULL,
    "key" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "icon_url" TEXT,
    "category" "AchievementCategory" NOT NULL,
    "condition" JSONB NOT NULL,
    "xp_reward" INTEGER NOT NULL DEFAULT 0,
    "is_secret" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "achievements_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_achievements" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "achievement_id" UUID NOT NULL,
    "unlocked_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_achievements_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "streaks" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "type" "StreakType" NOT NULL,
    "current_days" INTEGER NOT NULL DEFAULT 0,
    "longest_days" INTEGER NOT NULL DEFAULT 0,
    "last_active_date" DATE,
    "started_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "streaks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "xp_logs" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "amount" INTEGER NOT NULL,
    "source" TEXT NOT NULL,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "xp_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "challenges" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "type" "ChallengeType" NOT NULL,
    "target" JSONB NOT NULL,
    "start_date" TIMESTAMP(3) NOT NULL,
    "end_date" TIMESTAMP(3) NOT NULL,
    "created_by_user_id" UUID,
    "is_global" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "challenges_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "challenge_participants" (
    "id" UUID NOT NULL,
    "challenge_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "progress" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "completed" BOOLEAN NOT NULL DEFAULT false,
    "joined_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "challenge_participants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "trainer_profiles" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "display_name" TEXT NOT NULL,
    "bio" TEXT,
    "specializations" TEXT[],
    "certifications" TEXT[],
    "social_links" JSONB,
    "stripe_account_id" TEXT,
    "is_verified" BOOLEAN NOT NULL DEFAULT false,
    "commission_rate" DOUBLE PRECISION NOT NULL DEFAULT 0.20,
    "rating" DOUBLE PRECISION,
    "review_count" INTEGER NOT NULL DEFAULT 0,
    "client_count" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "trainer_profiles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "purchased_programs" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "program_id" UUID NOT NULL,
    "price" DOUBLE PRECISION NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'USD',
    "purchased_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "started_at" TIMESTAMP(3),
    "current_week" INTEGER NOT NULL DEFAULT 1,

    CONSTRAINT "purchased_programs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "coaching_relations" (
    "id" UUID NOT NULL,
    "coach_id" UUID NOT NULL,
    "client_id" UUID NOT NULL,
    "status" "CoachingStatus" NOT NULL DEFAULT 'ACTIVE',
    "monthly_rate" DOUBLE PRECISION,
    "notes" TEXT,
    "started_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ended_at" TIMESTAMP(3),

    CONSTRAINT "coaching_relations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "coaching_messages" (
    "id" UUID NOT NULL,
    "relation_id" UUID NOT NULL,
    "sender_id" UUID NOT NULL,
    "text" TEXT NOT NULL,
    "attachments" JSONB,
    "read_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "coaching_messages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "reviews" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "program_id" UUID NOT NULL,
    "rating" INTEGER NOT NULL,
    "text" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "reviews_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subscriptions" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "plan" "SubscriptionPlan" NOT NULL,
    "status" "SubscriptionStatus" NOT NULL DEFAULT 'ACTIVE',
    "stripe_customer_id" TEXT,
    "stripe_sub_id" TEXT,
    "current_period_start" TIMESTAMP(3) NOT NULL,
    "current_period_end" TIMESTAMP(3) NOT NULL,
    "cancel_at_period_end" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "subscriptions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payments" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "type" "PaymentType" NOT NULL,
    "amount" DOUBLE PRECISION NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'USD',
    "status" "PaymentStatus" NOT NULL,
    "stripe_payment_id" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ai_chats" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "title" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ai_chats_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ai_messages" (
    "id" UUID NOT NULL,
    "chat_id" UUID NOT NULL,
    "role" "AiRole" NOT NULL,
    "content" TEXT NOT NULL,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ai_messages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ai_program_generations" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "input" JSONB NOT NULL,
    "output" JSONB NOT NULL,
    "accepted" BOOLEAN NOT NULL DEFAULT false,
    "program_id" UUID,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ai_program_generations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cv_analyses" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "exercise_id" UUID NOT NULL,
    "video_url" TEXT,
    "thumbnail_url" TEXT,
    "overall_score" INTEGER,
    "rep_count" INTEGER,
    "feedback" JSONB,
    "joint_angles" JSONB,
    "skeleton_data_url" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "cv_analyses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notifications" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "type" "NotificationType" NOT NULL,
    "title" TEXT NOT NULL,
    "body" TEXT NOT NULL,
    "data" JSONB,
    "read_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "device_tokens" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "token" TEXT NOT NULL,
    "platform" "Platform" NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "device_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "integrations" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "provider" "IntegrationProvider" NOT NULL,
    "access_token" TEXT,
    "refresh_token" TEXT,
    "expires_at" TIMESTAMP(3),
    "metadata" JSONB,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "integrations_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_username_key" ON "users"("username");

-- CreateIndex
CREATE UNIQUE INDEX "user_settings_user_id_key" ON "user_settings"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "oauth_accounts_provider_provider_id_key" ON "oauth_accounts"("provider", "provider_id");

-- CreateIndex
CREATE UNIQUE INDEX "refresh_tokens_token_key" ON "refresh_tokens"("token");

-- CreateIndex
CREATE INDEX "refresh_tokens_user_id_idx" ON "refresh_tokens"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "exercises_slug_key" ON "exercises"("slug");

-- CreateIndex
CREATE INDEX "exercises_muscle_group_idx" ON "exercises"("muscle_group");

-- CreateIndex
CREATE INDEX "exercises_equipment_idx" ON "exercises"("equipment");

-- CreateIndex
CREATE INDEX "exercises_created_by_user_id_idx" ON "exercises"("created_by_user_id");

-- CreateIndex
CREATE INDEX "exercise_notes_exercise_id_user_id_idx" ON "exercise_notes"("exercise_id", "user_id");

-- CreateIndex
CREATE INDEX "workouts_user_id_started_at_idx" ON "workouts"("user_id", "started_at");

-- CreateIndex
CREATE INDEX "workouts_user_id_status_idx" ON "workouts"("user_id", "status");

-- CreateIndex
CREATE INDEX "workout_sets_workout_id_idx" ON "workout_sets"("workout_id");

-- CreateIndex
CREATE INDEX "workout_sets_exercise_id_idx" ON "workout_sets"("exercise_id");

-- CreateIndex
CREATE INDEX "workout_sets_workout_id_exercise_id_idx" ON "workout_sets"("workout_id", "exercise_id");

-- CreateIndex
CREATE INDEX "personal_records_user_id_exercise_id_idx" ON "personal_records"("user_id", "exercise_id");

-- CreateIndex
CREATE INDEX "personal_records_user_id_record_type_idx" ON "personal_records"("user_id", "record_type");

-- CreateIndex
CREATE INDEX "workout_templates_user_id_idx" ON "workout_templates"("user_id");

-- CreateIndex
CREATE INDEX "template_exercises_template_id_idx" ON "template_exercises"("template_id");

-- CreateIndex
CREATE INDEX "scheduled_workouts_user_id_date_idx" ON "scheduled_workouts"("user_id", "date");

-- CreateIndex
CREATE UNIQUE INDEX "programs_slug_key" ON "programs"("slug");

-- CreateIndex
CREATE INDEX "programs_goal_idx" ON "programs"("goal");

-- CreateIndex
CREATE INDEX "programs_is_public_rating_idx" ON "programs"("is_public", "rating");

-- CreateIndex
CREATE INDEX "program_weeks_program_id_idx" ON "program_weeks"("program_id");

-- CreateIndex
CREATE INDEX "program_week_days_week_id_idx" ON "program_week_days"("week_id");

-- CreateIndex
CREATE INDEX "program_exercises_day_id_idx" ON "program_exercises"("day_id");

-- CreateIndex
CREATE INDEX "body_logs_user_id_date_idx" ON "body_logs"("user_id", "date");

-- CreateIndex
CREATE UNIQUE INDEX "body_logs_user_id_date_key" ON "body_logs"("user_id", "date");

-- CreateIndex
CREATE INDEX "body_photos_user_id_date_idx" ON "body_photos"("user_id", "date");

-- CreateIndex
CREATE UNIQUE INDEX "foods_barcode_key" ON "foods"("barcode");

-- CreateIndex
CREATE INDEX "foods_name_idx" ON "foods"("name");

-- CreateIndex
CREATE INDEX "foods_barcode_idx" ON "foods"("barcode");

-- CreateIndex
CREATE INDEX "nutrition_logs_user_id_date_idx" ON "nutrition_logs"("user_id", "date");

-- CreateIndex
CREATE UNIQUE INDEX "nutrition_logs_user_id_date_key" ON "nutrition_logs"("user_id", "date");

-- CreateIndex
CREATE INDEX "meals_nutrition_log_id_idx" ON "meals"("nutrition_log_id");

-- CreateIndex
CREATE INDEX "meal_items_meal_id_idx" ON "meal_items"("meal_id");

-- CreateIndex
CREATE INDEX "recovery_logs_user_id_date_idx" ON "recovery_logs"("user_id", "date");

-- CreateIndex
CREATE UNIQUE INDEX "recovery_logs_user_id_date_key" ON "recovery_logs"("user_id", "date");

-- CreateIndex
CREATE INDEX "sleep_logs_user_id_date_idx" ON "sleep_logs"("user_id", "date");

-- CreateIndex
CREATE UNIQUE INDEX "sleep_logs_user_id_date_key" ON "sleep_logs"("user_id", "date");

-- CreateIndex
CREATE INDEX "friendships_friend_id_idx" ON "friendships"("friend_id");

-- CreateIndex
CREATE UNIQUE INDEX "friendships_user_id_friend_id_key" ON "friendships"("user_id", "friend_id");

-- CreateIndex
CREATE INDEX "feed_items_user_id_created_at_idx" ON "feed_items"("user_id", "created_at");

-- CreateIndex
CREATE INDEX "feed_items_created_at_idx" ON "feed_items"("created_at");

-- CreateIndex
CREATE INDEX "comments_feed_item_id_idx" ON "comments"("feed_item_id");

-- CreateIndex
CREATE UNIQUE INDEX "likes_feed_item_id_user_id_key" ON "likes"("feed_item_id", "user_id");

-- CreateIndex
CREATE UNIQUE INDEX "achievements_key_key" ON "achievements"("key");

-- CreateIndex
CREATE UNIQUE INDEX "user_achievements_user_id_achievement_id_key" ON "user_achievements"("user_id", "achievement_id");

-- CreateIndex
CREATE UNIQUE INDEX "streaks_user_id_type_key" ON "streaks"("user_id", "type");

-- CreateIndex
CREATE INDEX "xp_logs_user_id_created_at_idx" ON "xp_logs"("user_id", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "challenge_participants_challenge_id_user_id_key" ON "challenge_participants"("challenge_id", "user_id");

-- CreateIndex
CREATE UNIQUE INDEX "trainer_profiles_user_id_key" ON "trainer_profiles"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "purchased_programs_user_id_program_id_key" ON "purchased_programs"("user_id", "program_id");

-- CreateIndex
CREATE UNIQUE INDEX "coaching_relations_coach_id_client_id_key" ON "coaching_relations"("coach_id", "client_id");

-- CreateIndex
CREATE INDEX "coaching_messages_relation_id_created_at_idx" ON "coaching_messages"("relation_id", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "reviews_user_id_program_id_key" ON "reviews"("user_id", "program_id");

-- CreateIndex
CREATE UNIQUE INDEX "subscriptions_user_id_key" ON "subscriptions"("user_id");

-- CreateIndex
CREATE INDEX "payments_user_id_idx" ON "payments"("user_id");

-- CreateIndex
CREATE INDEX "ai_chats_user_id_idx" ON "ai_chats"("user_id");

-- CreateIndex
CREATE INDEX "ai_messages_chat_id_idx" ON "ai_messages"("chat_id");

-- CreateIndex
CREATE INDEX "ai_program_generations_user_id_idx" ON "ai_program_generations"("user_id");

-- CreateIndex
CREATE INDEX "cv_analyses_user_id_idx" ON "cv_analyses"("user_id");

-- CreateIndex
CREATE INDEX "notifications_user_id_read_at_idx" ON "notifications"("user_id", "read_at");

-- CreateIndex
CREATE INDEX "notifications_user_id_created_at_idx" ON "notifications"("user_id", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "device_tokens_token_key" ON "device_tokens"("token");

-- CreateIndex
CREATE INDEX "device_tokens_user_id_idx" ON "device_tokens"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "integrations_user_id_provider_key" ON "integrations"("user_id", "provider");

-- AddForeignKey
ALTER TABLE "user_settings" ADD CONSTRAINT "user_settings_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "oauth_accounts" ADD CONSTRAINT "oauth_accounts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exercises" ADD CONSTRAINT "exercises_created_by_user_id_fkey" FOREIGN KEY ("created_by_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exercise_notes" ADD CONSTRAINT "exercise_notes_exercise_id_fkey" FOREIGN KEY ("exercise_id") REFERENCES "exercises"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "workouts" ADD CONSTRAINT "workouts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "workouts" ADD CONSTRAINT "workouts_template_id_fkey" FOREIGN KEY ("template_id") REFERENCES "workout_templates"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "workout_sets" ADD CONSTRAINT "workout_sets_workout_id_fkey" FOREIGN KEY ("workout_id") REFERENCES "workouts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "workout_sets" ADD CONSTRAINT "workout_sets_exercise_id_fkey" FOREIGN KEY ("exercise_id") REFERENCES "exercises"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "personal_records" ADD CONSTRAINT "personal_records_exercise_id_fkey" FOREIGN KEY ("exercise_id") REFERENCES "exercises"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "workout_templates" ADD CONSTRAINT "workout_templates_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "template_exercises" ADD CONSTRAINT "template_exercises_template_id_fkey" FOREIGN KEY ("template_id") REFERENCES "workout_templates"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "template_exercises" ADD CONSTRAINT "template_exercises_exercise_id_fkey" FOREIGN KEY ("exercise_id") REFERENCES "exercises"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "scheduled_workouts" ADD CONSTRAINT "scheduled_workouts_template_id_fkey" FOREIGN KEY ("template_id") REFERENCES "workout_templates"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "programs" ADD CONSTRAINT "programs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "program_weeks" ADD CONSTRAINT "program_weeks_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "programs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "program_week_days" ADD CONSTRAINT "program_week_days_week_id_fkey" FOREIGN KEY ("week_id") REFERENCES "program_weeks"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "program_exercises" ADD CONSTRAINT "program_exercises_day_id_fkey" FOREIGN KEY ("day_id") REFERENCES "program_week_days"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "program_exercises" ADD CONSTRAINT "program_exercises_exercise_id_fkey" FOREIGN KEY ("exercise_id") REFERENCES "exercises"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "body_logs" ADD CONSTRAINT "body_logs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "body_photos" ADD CONSTRAINT "body_photos_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "foods" ADD CONSTRAINT "foods_created_by_user_id_fkey" FOREIGN KEY ("created_by_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "nutrition_logs" ADD CONSTRAINT "nutrition_logs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "meals" ADD CONSTRAINT "meals_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "meals" ADD CONSTRAINT "meals_nutrition_log_id_fkey" FOREIGN KEY ("nutrition_log_id") REFERENCES "nutrition_logs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "meal_items" ADD CONSTRAINT "meal_items_meal_id_fkey" FOREIGN KEY ("meal_id") REFERENCES "meals"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "meal_items" ADD CONSTRAINT "meal_items_food_id_fkey" FOREIGN KEY ("food_id") REFERENCES "foods"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recovery_logs" ADD CONSTRAINT "recovery_logs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sleep_logs" ADD CONSTRAINT "sleep_logs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "friendships" ADD CONSTRAINT "friendships_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "friendships" ADD CONSTRAINT "friendships_friend_id_fkey" FOREIGN KEY ("friend_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feed_items" ADD CONSTRAINT "feed_items_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feed_items" ADD CONSTRAINT "feed_items_workout_id_fkey" FOREIGN KEY ("workout_id") REFERENCES "workouts"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "comments" ADD CONSTRAINT "comments_feed_item_id_fkey" FOREIGN KEY ("feed_item_id") REFERENCES "feed_items"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "comments" ADD CONSTRAINT "comments_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "likes" ADD CONSTRAINT "likes_feed_item_id_fkey" FOREIGN KEY ("feed_item_id") REFERENCES "feed_items"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "likes" ADD CONSTRAINT "likes_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_achievements" ADD CONSTRAINT "user_achievements_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_achievements" ADD CONSTRAINT "user_achievements_achievement_id_fkey" FOREIGN KEY ("achievement_id") REFERENCES "achievements"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "streaks" ADD CONSTRAINT "streaks_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "xp_logs" ADD CONSTRAINT "xp_logs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "challenge_participants" ADD CONSTRAINT "challenge_participants_challenge_id_fkey" FOREIGN KEY ("challenge_id") REFERENCES "challenges"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "trainer_profiles" ADD CONSTRAINT "trainer_profiles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchased_programs" ADD CONSTRAINT "purchased_programs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchased_programs" ADD CONSTRAINT "purchased_programs_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "programs"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "coaching_relations" ADD CONSTRAINT "coaching_relations_coach_id_fkey" FOREIGN KEY ("coach_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "coaching_relations" ADD CONSTRAINT "coaching_relations_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "coaching_messages" ADD CONSTRAINT "coaching_messages_relation_id_fkey" FOREIGN KEY ("relation_id") REFERENCES "coaching_relations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_program_id_fkey" FOREIGN KEY ("program_id") REFERENCES "programs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subscriptions" ADD CONSTRAINT "subscriptions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ai_chats" ADD CONSTRAINT "ai_chats_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ai_messages" ADD CONSTRAINT "ai_messages_chat_id_fkey" FOREIGN KEY ("chat_id") REFERENCES "ai_chats"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cv_analyses" ADD CONSTRAINT "cv_analyses_exercise_id_fkey" FOREIGN KEY ("exercise_id") REFERENCES "exercises"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "device_tokens" ADD CONSTRAINT "device_tokens_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
