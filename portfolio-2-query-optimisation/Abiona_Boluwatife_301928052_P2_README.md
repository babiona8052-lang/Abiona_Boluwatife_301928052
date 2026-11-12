# Food Delivery App — SQL queries

## 1. Show related delivery_order, customer, restaurant records (up to 20).

```sql
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
```

| delivery_order_order_id | delivery_order_placed_at | customer_customer_id | customer_name | restaurant_restaurant_id | restaurant_name |
| --- | --- | --- | --- | --- | --- |
| 4001 | 2026-02-10T12:15:00+00:00 | 1001 | Avery Chen | 2001 | Cedar Kitchen |

## 2. Find delivery_order records where placed_at matches "2026-02-10T12:15:00Z" (up to 20).

```sql
SELECT * FROM portfolio."delivery_order"
WHERE "placed_at" IS NOT DISTINCT FROM '2026-02-10T12:15:00Z'
ORDER BY "order_id"
LIMIT 20;
```

| order_id | customer_id | restaurant_id | placed_at | status | total | request_key |
| --- | --- | --- | --- | --- | --- | --- |
| 4001 | 1001 | 2001 | 2026-02-10T12:15:00+00:00 | accepted | 12.5 | req-seed-4001 |

## 3. Count delivery_order records for each customer_id (up to 20 groups).

```sql
SELECT "customer_id", count(*) AS record_count
FROM portfolio."delivery_order"
GROUP BY "customer_id"
ORDER BY record_count DESC, "customer_id" NULLS LAST
LIMIT 20;
```

| customer_id | record_count |
| --- | --- |
| 1001 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 2.357 | 2.353, 2.357, 2.404 | Sort → Seq Scan | 274 |
| After index | 0.301 | 0.301, 0.307, 0.291 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 2.357 ms to 0.301 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.324..2.327 rows=50 loops=1)
  Seq Scan on delivery_order (actual time=0.015..2.287 rows=50 loops=1)
Planning Time: 0.361 ms
Execution Time: 2.353 ms
```

### Before index, run 2

```text
Sort (actual time=2.329..2.332 rows=50 loops=1)
  Seq Scan on delivery_order (actual time=0.015..2.292 rows=50 loops=1)
Planning Time: 0.343 ms
Execution Time: 2.357 ms
```

### Before index, run 3

```text
Sort (actual time=2.376..2.379 rows=50 loops=1)
  Seq Scan on delivery_order (actual time=0.015..2.34 rows=50 loops=1)
Planning Time: 0.338 ms
Execution Time: 2.404 ms
```

### After index, run 1

```text
Sort (actual time=0.245..0.248 rows=50 loops=1)
  Bitmap Heap Scan on delivery_order (actual time=0.033..0.204 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.019..0.02 rows=50 loops=1)
Planning Time: 0.799 ms
Execution Time: 0.301 ms
```

### After index, run 2

```text
Sort (actual time=0.248..0.251 rows=50 loops=1)
  Bitmap Heap Scan on delivery_order (actual time=0.03..0.201 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.017 rows=50 loops=1)
Planning Time: 0.675 ms
Execution Time: 0.307 ms
```

### After index, run 3

```text
Sort (actual time=0.238..0.24 rows=50 loops=1)
  Bitmap Heap Scan on delivery_order (actual time=0.027..0.199 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.015..0.015 rows=50 loops=1)
Planning Time: 0.586 ms
Execution Time: 0.291 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Abiona_Boluwatife_301928052_P2_Queries.sql, then Abiona_Boluwatife_301928052_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Abiona_Boluwatife_301928052_P2_QueryResults.png) · [Index comparison](screenshots/Abiona_Boluwatife_301928052_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

