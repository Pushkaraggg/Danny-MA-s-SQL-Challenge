CREATE TABLE "runners" (
  "runner_id" INTEGER,
  "registration_date" DATE
);

CREATE TABLE "customer_orders" (
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_date" TIMESTAMP
);

CREATE TABLE "runner_orders" (
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" VARCHAR(19),
  "distance" VARCHAR(7),
  "duration" VARCHAR(10),
  "cancellation" VARCHAR(23)
);

CREATE TABLE "pizza_recipes" (
  "pizza_id" INTEGER,
  "toppings" TEXT
);

CREATE TABLE "pizza_toppings" (
  "topping_id" INTEGER,
  "topping_name" TEXT
);

CREATE TABLE "pizza_names" (
  "pizza_id" INTEGER,
  "pizza_name" TEXT
);

ALTER TABLE "runner_orders" ADD FOREIGN KEY ("runner_id") REFERENCES "runners" ("runner_id");

ALTER TABLE "customer_orders" ADD FOREIGN KEY ("order_id") REFERENCES "runner_orders" ("order_id");

ALTER TABLE "customer_orders" ADD FOREIGN KEY ("pizza_id") REFERENCES "pizza_names" ("pizza_id");

ALTER TABLE "customer_orders" ADD FOREIGN KEY ("pizza_id") REFERENCES "pizza_recipes" ("pizza_id");
