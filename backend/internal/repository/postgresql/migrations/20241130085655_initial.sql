-- Create "accounts" table
CREATE TABLE "accounts" (
  "account_id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "account_name" character varying(50) NOT NULL,
  "account_email" character varying(255) NOT NULL,
  "account_password" character varying(255) NOT NULL,
  "otp_enabled" boolean NOT NULL DEFAULT false,
  "otp_verified" boolean NOT NULL DEFAULT false,
  "otp_secret" text NULL,
  "otp_auth_url" text NULL,
  "created_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("account_id"),
  CONSTRAINT "accounts_account_email_key" UNIQUE ("account_email")
);
-- Create "address" table
CREATE TABLE "address" (
  "address_id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "recipient" character varying(50) NOT NULL,
  "street_address" character varying(50) NOT NULL,
  "address_line2" character varying(50) NULL,
  "city" character varying(50) NOT NULL,
  "state" character varying(50) NULL,
  "postal_code" character varying(50) NOT NULL,
  "country" character varying(50) NOT NULL,
  "is_default" boolean NULL DEFAULT false,
  "phone_number" character varying(50) NULL,
  "address_type" character varying(50) NULL,
  "created_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("address_id")
);
-- Create "account_address" table
CREATE TABLE "account_address" (
  "account_address_id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "account_id" uuid NOT NULL,
  "address_id" uuid NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("account_address_id"),
  CONSTRAINT "fk_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("account_id") ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "fk_address" FOREIGN KEY ("address_id") REFERENCES "address" ("address_id") ON UPDATE NO ACTION ON DELETE CASCADE
);
-- Create "cart" table
CREATE TABLE "cart" (
  "cart_id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "account_id" uuid NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("cart_id"),
  CONSTRAINT "fk_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("account_id") ON UPDATE NO ACTION ON DELETE CASCADE
);
-- Create "category" table
CREATE TABLE "category" (
  "category_id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "name" character varying(100) NOT NULL,
  "description" text NULL,
  "created_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("category_id")
);
-- Create "product" table
CREATE TABLE "product" (
  "product_id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "product_name" character varying(50) NOT NULL,
  "images" jsonb NULL,
  "product_description" text NULL,
  "quantity" integer NOT NULL DEFAULT 0,
  "clearance" boolean NULL DEFAULT false,
  "featured" boolean NULL DEFAULT false,
  "category_id" uuid NULL,
  "created_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("product_id"),
  CONSTRAINT "fk_category" FOREIGN KEY ("category_id") REFERENCES "category" ("category_id") ON UPDATE NO ACTION ON DELETE SET NULL
);
-- Create "cart_product" table
CREATE TABLE "cart_product" (
  "cart_id" uuid NOT NULL,
  "product_id" uuid NOT NULL,
  PRIMARY KEY ("cart_id", "product_id"),
  CONSTRAINT "fk_cart" FOREIGN KEY ("cart_id") REFERENCES "cart" ("cart_id") ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "fk_product" FOREIGN KEY ("product_id") REFERENCES "product" ("product_id") ON UPDATE NO ACTION ON DELETE CASCADE
);
-- Create "collections" table
CREATE TABLE "collections" (
  "collection_id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "name" character varying(100) NOT NULL,
  "description" text NULL,
  "created_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("collection_id")
);
-- Create "collection_product" table
CREATE TABLE "collection_product" (
  "collection_product_id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "collection_id" uuid NOT NULL,
  "product_id" uuid NOT NULL,
  PRIMARY KEY ("collection_product_id"),
  CONSTRAINT "fk_collection" FOREIGN KEY ("collection_id") REFERENCES "collections" ("collection_id") ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "fk_product_collection" FOREIGN KEY ("product_id") REFERENCES "product" ("product_id") ON UPDATE NO ACTION ON DELETE CASCADE
);
-- Create "featured_product" table
CREATE TABLE "featured_product" (
  "featured_id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "product_id" uuid NOT NULL,
  "start_date" timestamptz NULL,
  "end_date" timestamptz NULL,
  PRIMARY KEY ("featured_id"),
  CONSTRAINT "fk_featured_product" FOREIGN KEY ("product_id") REFERENCES "product" ("product_id") ON UPDATE NO ACTION ON DELETE CASCADE
);
-- Create "order_history" table
CREATE TABLE "order_history" (
  "order_history_id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "account_id" uuid NOT NULL,
  "address" jsonb NULL,
  "products" jsonb NULL,
  "payment_status" character varying(50) NULL,
  "order_timestamp" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "shipment_status" character varying(50) NULL,
  "order_status" character varying(50) NULL,
  PRIMARY KEY ("order_history_id"),
  CONSTRAINT "fk_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("account_id") ON UPDATE NO ACTION ON DELETE CASCADE
);
-- Create "orders" table
CREATE TABLE "orders" (
  "order_id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "account_id" uuid NOT NULL,
  "account_address_id" uuid NOT NULL,
  "payment_status" character varying(50) NOT NULL,
  "order_timestamp" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "shipment_status" character varying(50) NOT NULL,
  "order_status" character varying(50) NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("order_id"),
  CONSTRAINT "fk_account" FOREIGN KEY ("account_id") REFERENCES "accounts" ("account_id") ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "fk_account_address" FOREIGN KEY ("account_address_id") REFERENCES "address" ("address_id") ON UPDATE NO ACTION ON DELETE CASCADE
);
-- Create "order_product" table
CREATE TABLE "order_product" (
  "order_id" uuid NOT NULL,
  "product_id" uuid NOT NULL,
  PRIMARY KEY ("order_id", "product_id"),
  CONSTRAINT "fk_order" FOREIGN KEY ("order_id") REFERENCES "orders" ("order_id") ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT "fk_product_order" FOREIGN KEY ("product_id") REFERENCES "product" ("product_id") ON UPDATE NO ACTION ON DELETE CASCADE
);
-- Create "product_clearance" table
CREATE TABLE "product_clearance" (
  "product_clearance_id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "product_id" uuid NOT NULL,
  "discount_percentage" text NULL,
  "start_date" timestamptz NULL,
  "end_date" timestamptz NULL,
  PRIMARY KEY ("product_clearance_id"),
  CONSTRAINT "fk_product_clearance" FOREIGN KEY ("product_id") REFERENCES "product" ("product_id") ON UPDATE NO ACTION ON DELETE CASCADE
);
