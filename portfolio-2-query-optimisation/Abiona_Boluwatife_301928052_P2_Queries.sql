-- Show related delivery_order, customer, restaurant records (up to 20).
SELECT t0."order_id" AS "delivery_order_order_id",
       t0."placed_at" AS "delivery_order_placed_at",
       t1."customer_id" AS "customer_customer_id",
       t1."name" AS "customer_name",
       t2."restaurant_id" AS "restaurant_restaurant_id",
       t2."name" AS "restaurant_name"
FROM portfolio."delivery_order" t0
JOIN portfolio."customer" t1 ON t0."customer_id" = t1."customer_id"
JOIN portfolio."restaurant" t2 ON t0."restaurant_id" = t2."restaurant_id"
ORDER BY t0."order_id", t1."customer_id", t2."restaurant_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."order_id" AS "delivery_order_order_id",
       t0."placed_at" AS "delivery_order_placed_at",
       t1."customer_id" AS "customer_customer_id",
       t1."name" AS "customer_name",
       t2."restaurant_id" AS "restaurant_restaurant_id",
       t2."name" AS "restaurant_name"
FROM portfolio."delivery_order" t0
JOIN portfolio."customer" t1 ON t0."customer_id" = t1."customer_id"
JOIN portfolio."restaurant" t2 ON t0."restaurant_id" = t2."restaurant_id"
ORDER BY t0."order_id", t1."customer_id", t2."restaurant_id"
LIMIT 20;

-- Find delivery_order records where placed_at matches "2026-02-10T12:15:00Z" (up to 20).
SELECT * FROM portfolio."delivery_order"
WHERE "placed_at" IS NOT DISTINCT FROM '2026-02-10T12:15:00Z'
ORDER BY "order_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."delivery_order"
WHERE "placed_at" IS NOT DISTINCT FROM '2026-02-10T12:15:00Z'
ORDER BY "order_id"
LIMIT 20;

-- Count delivery_order records for each customer_id (up to 20 groups).
SELECT "customer_id", count(*) AS record_count
FROM portfolio."delivery_order"
GROUP BY "customer_id"
ORDER BY record_count DESC, "customer_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "customer_id", count(*) AS record_count
FROM portfolio."delivery_order"
GROUP BY "customer_id"
ORDER BY record_count DESC, "customer_id" NULLS LAST
LIMIT 20;
