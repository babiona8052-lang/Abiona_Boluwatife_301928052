-- Food Delivery App: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."customer" (
  "customer_id" bigint NOT NULL,
  "name" text NOT NULL,
  "email" text NOT NULL,
  "created_at" timestamptz NOT NULL,
  CONSTRAINT "pk_customer" PRIMARY KEY ("customer_id"),
  CONSTRAINT "uq_customer_0" UNIQUE ("email")
);
CREATE TABLE portfolio."restaurant" (
  "restaurant_id" bigint NOT NULL,
  "name" text NOT NULL,
  "address" text NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_restaurant" PRIMARY KEY ("restaurant_id")
);
CREATE TABLE portfolio."menu_item" (
  "menu_item_id" bigint NOT NULL,
  "restaurant_id" bigint NOT NULL,
  "name" text NOT NULL,
  "price" numeric(18,2) NOT NULL,
  "available" boolean NOT NULL,
  CONSTRAINT "pk_menu_item" PRIMARY KEY ("menu_item_id"),
  CONSTRAINT "uq_menu_item_0" UNIQUE ("restaurant_id", "name")
);
CREATE TABLE portfolio."delivery_order" (
  "order_id" bigint NOT NULL,
  "customer_id" bigint NOT NULL,
  "restaurant_id" bigint NOT NULL,
  "placed_at" timestamptz NOT NULL,
  "status" text NOT NULL,
  "total" numeric(18,2) NOT NULL,
  "request_key" text NOT NULL,
  CONSTRAINT "pk_delivery_order" PRIMARY KEY ("order_id"),
  CONSTRAINT "uq_delivery_order_0" UNIQUE ("request_key")
);
CREATE TABLE portfolio."order_item" (
  "order_item_id" bigint NOT NULL,
  "order_id" bigint NOT NULL,
  "menu_item_id" bigint NOT NULL,
  "quantity" bigint NOT NULL,
  "unit_price" numeric(18,2) NOT NULL,
  CONSTRAINT "pk_order_item" PRIMARY KEY ("order_item_id"),
  CONSTRAINT "uq_order_item_0" UNIQUE ("order_id", "menu_item_id")
);
ALTER TABLE portfolio."menu_item" ADD CONSTRAINT "fk_menu_item_0" FOREIGN KEY ("restaurant_id") REFERENCES portfolio."restaurant" ("restaurant_id");
ALTER TABLE portfolio."delivery_order" ADD CONSTRAINT "fk_delivery_order_0" FOREIGN KEY ("customer_id") REFERENCES portfolio."customer" ("customer_id");
ALTER TABLE portfolio."delivery_order" ADD CONSTRAINT "fk_delivery_order_1" FOREIGN KEY ("restaurant_id") REFERENCES portfolio."restaurant" ("restaurant_id");
ALTER TABLE portfolio."order_item" ADD CONSTRAINT "fk_order_item_0" FOREIGN KEY ("order_id") REFERENCES portfolio."delivery_order" ("order_id");
ALTER TABLE portfolio."order_item" ADD CONSTRAINT "fk_order_item_1" FOREIGN KEY ("menu_item_id") REFERENCES portfolio."menu_item" ("menu_item_id");
ALTER TABLE portfolio."menu_item" ADD CONSTRAINT "menu_item_price_positive" CHECK ("price" > 0);
ALTER TABLE portfolio."delivery_order" ADD CONSTRAINT "order_status_allowed" CHECK (("status" = 'placed') OR ("status" = 'accepted') OR ("status" = 'preparing') OR ("status" = 'completed') OR ("status" = 'cancelled'));
ALTER TABLE portfolio."order_item" ADD CONSTRAINT "order_item_quantity_positive" CHECK ("quantity" > 0);
COMMIT;
