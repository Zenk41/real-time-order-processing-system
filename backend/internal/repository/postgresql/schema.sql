CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Accounts table
CREATE TABLE "accounts" (
  "account_id" UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
  "account_name" VARCHAR(50) NOT NULL,
  "account_email" VARCHAR(255) NOT NULL UNIQUE,
  "account_password" VARCHAR(255) NOT NULL,
  "otp_enabled" BOOLEAN NOT NULL DEFAULT FALSE,
  "otp_verified" BOOLEAN NOT NULL DEFAULT FALSE,
  "otp_secret" TEXT,
  "otp_auth_url" TEXT,
  "created_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
  "updated_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Address table
CREATE TABLE "address" (
  "address_id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "recipient" VARCHAR(50) NOT NULL,
  "street_address" VARCHAR(50) NOT NULL,
  "address_line2" VARCHAR(50),
  "city" VARCHAR(50) NOT NULL,
  "state" VARCHAR(50),
  "postal_code" VARCHAR(50) NOT NULL,
  "country" VARCHAR(50) NOT NULL,
  "is_default" BOOLEAN DEFAULT FALSE,
  "phone_number" VARCHAR(50),
  "address_type" VARCHAR(50),
  "created_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
  "updated_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Orders table
CREATE TABLE "orders" (
  "order_id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "account_id" UUID NOT NULL,
  "account_address_id" UUID NOT NULL,
  "payment_status" VARCHAR(50) NOT NULL,
  "order_timestamp" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
  "shipment_status" VARCHAR(50) NOT NULL,
  "order_status" VARCHAR(50) NOT NULL,
  "created_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
  "updated_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
  -- Foreign key constraints
  CONSTRAINT "fk_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("account_id") ON DELETE CASCADE,
  CONSTRAINT "fk_account_address" FOREIGN KEY ("account_address_id") REFERENCES "address" ("address_id") ON DELETE CASCADE
);

-- Account address table
CREATE TABLE "account_address" (
  "account_address_id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "account_id" UUID NOT NULL,
  "address_id" UUID NOT NULL,
  "created_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
  "updated_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
  -- Foreign key constraints
  CONSTRAINT "fk_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("account_id") ON DELETE CASCADE,
  CONSTRAINT "fk_address" FOREIGN KEY ("address_id") REFERENCES "address" ("address_id") ON DELETE CASCADE
);

-- Category table
CREATE TABLE "category" (
  "category_id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "name" VARCHAR(100) NOT NULL,
  "description" TEXT,
  "created_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
  "updated_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Product table
CREATE TABLE "product" (
  "product_id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "product_name" VARCHAR(50) NOT NULL,
  "images" JSONB,
  "product_description" TEXT,
  "quantity" INT NOT NULL DEFAULT 0,
  "clearance" BOOLEAN DEFAULT FALSE,
  "featured" BOOLEAN DEFAULT FALSE,
  "category_id" UUID,
  -- Foreign key constraint
  CONSTRAINT "fk_category" FOREIGN KEY ("category_id") REFERENCES "category" ("category_id") ON DELETE
  SET
    NULL,
    "created_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updated_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Cart table
CREATE TABLE "cart" (
  "cart_id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "account_id" UUID NOT NULL,
  "created_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
  "updated_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
  -- Foreign key constraint
  CONSTRAINT "fk_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("account_id") ON DELETE CASCADE
);

-- Cart product table
CREATE TABLE "cart_product" (
  "cart_id" UUID NOT NULL,
  "product_id" UUID NOT NULL,
  -- Foreign key constraints
  CONSTRAINT "fk_cart" FOREIGN KEY ("cart_id") REFERENCES "cart" ("cart_id") ON DELETE CASCADE,
  CONSTRAINT "fk_product" FOREIGN KEY ("product_id") REFERENCES "product" ("product_id") ON DELETE CASCADE,
  PRIMARY KEY ("cart_id", "product_id") -- Composite primary key
);

-- Product clearance table
CREATE TABLE "product_clearance" (
  "product_clearance_id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "product_id" UUID NOT NULL,
  "discount_percentage" TEXT,
  "start_date" TIMESTAMP WITH TIME ZONE,
  "end_date" TIMESTAMP WITH TIME ZONE,
  -- Foreign key constraint
  CONSTRAINT "fk_product_clearance" FOREIGN KEY ("product_id") REFERENCES "product" ("product_id") ON DELETE CASCADE
);

-- Featured product table
CREATE TABLE "featured_product" (
  "featured_id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "product_id" UUID NOT NULL,
  "start_date" TIMESTAMP WITH TIME ZONE,
  "end_date" TIMESTAMP WITH TIME ZONE,
  -- Foreign key constraint
  CONSTRAINT "fk_featured_product" FOREIGN KEY ("product_id") REFERENCES "product" ("product_id") ON DELETE CASCADE
);

-- Collections table
CREATE TABLE "collections" (
  "collection_id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "name" VARCHAR(100) NOT NULL,
  "description" TEXT,
  "created_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
  "updated_at" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Collection product table
CREATE TABLE "collection_product" (
  "collection_product_id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "collection_id" UUID NOT NULL,
  "product_id" UUID NOT NULL,
  -- Foreign key constraints
  CONSTRAINT "fk_collection" FOREIGN KEY ("collection_id") REFERENCES "collections" ("collection_id") ON DELETE CASCADE,
  CONSTRAINT "fk_product_collection" FOREIGN KEY ("product_id") REFERENCES "product" ("product_id") ON DELETE CASCADE
);

-- Order product table
CREATE TABLE "order_product" (
  "order_id" UUID NOT NULL,
  "product_id" UUID NOT NULL,
  -- Foreign key constraints
  CONSTRAINT "fk_order" FOREIGN KEY ("order_id") REFERENCES "orders" ("order_id") ON DELETE CASCADE,
  CONSTRAINT "fk_product_order" FOREIGN KEY ("product_id") REFERENCES "product" ("product_id") ON DELETE CASCADE,
  PRIMARY KEY ("order_id", "product_id")
);

-- Order history table
CREATE TABLE "order_history" (
  "order_history_id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "account_id" UUID NOT NULL,
  "address" JSONB,
  "products" JSONB,
  "payment_status" VARCHAR(50),
  "order_timestamp" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
  "shipment_status" VARCHAR(50),
  "order_status" VARCHAR(50),
  -- Foreign key to the account table
  CONSTRAINT "fk_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("account_id") ON DELETE CASCADE
);

-- Create "admin" table
CREATE TABLE "admin" (
  "admin_id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "admin_name" character varying(50) NOT NULL,
  "admin_email" character varying(255) NOT NULL,
  "admin_password" character varying(255) NOT NULL,
  "role" character varying(50) NOT NULL DEFAULT 'admin',
  "created_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("admin_id"),
  CONSTRAINT "admin_email_unique" UNIQUE ("admin_email")
);