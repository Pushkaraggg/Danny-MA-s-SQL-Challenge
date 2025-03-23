CREATE TABLE "sales" (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

CREATE TABLE "menu" (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

CREATE TABLE "members" (
  "customer_id" VARCHAR(1),
  "join_date" TIMESTAMP
);

ALTER TABLE "sales" ADD FOREIGN KEY ("customer_id") REFERENCES "members" ("customer_id");

ALTER TABLE "sales" ADD FOREIGN KEY ("product_id") REFERENCES "menu" ("product_id");
