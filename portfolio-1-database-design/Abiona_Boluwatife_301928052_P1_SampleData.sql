-- Fictional sample records for Food Delivery App.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."customer" ("customer_id", "name", "email", "created_at") VALUES (1001, 'Avery Chen', 'avery.chen@example.test', '2026-01-15T10:30:00Z');
INSERT INTO portfolio."restaurant" ("restaurant_id", "name", "address", "active") VALUES (2001, 'Cedar Kitchen', '12 Market Street', TRUE);
INSERT INTO portfolio."menu_item" ("menu_item_id", "restaurant_id", "name", "price", "available") VALUES (3001, 2001, 'Grilled Tofu Bowl', 12.5, TRUE);
INSERT INTO portfolio."menu_item" ("menu_item_id", "restaurant_id", "name", "price", "available") VALUES (3002, 2001, 'Garden Salad', 8.25, TRUE);
INSERT INTO portfolio."delivery_order" ("order_id", "customer_id", "restaurant_id", "placed_at", "status", "total", "request_key") VALUES (4001, 1001, 2001, '2026-02-10T12:15:00Z', 'accepted', 12.5, 'req-seed-4001');
INSERT INTO portfolio."order_item" ("order_item_id", "order_id", "menu_item_id", "quantity", "unit_price") VALUES (5001, 4001, 3001, 1, 12.5);
COMMIT;
