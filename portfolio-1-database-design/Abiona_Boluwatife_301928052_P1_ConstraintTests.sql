-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. pk customer test. Expected: pk_customer, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "name", "email", "created_at")
VALUES (1001, 'Morgan Lee', 'morgan.lee@example.test', '2026-03-01T09:00:00Z');

-- 2. uq customer test. Expected: uq_customer_0, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "name", "email", "created_at")
VALUES (10001, 'Jordan Kim', 'avery.chen@example.test', '2026-03-01T09:01:00Z');

-- 3. nn customer name test. Expected: name, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "name", "email", "created_at")
VALUES (10002, NULL, 'nn.customer@example.test', '2026-03-01T09:02:00Z');

-- 4. pk restaurant test. Expected: pk_restaurant, SQLSTATE 23505.
INSERT INTO portfolio."restaurant" ("restaurant_id", "name", "address", "active")
VALUES (2001, 'Harbor Table', '4 Pier Road', TRUE);

-- 5. pk menu item test. Expected: pk_menu_item, SQLSTATE 23505.
INSERT INTO portfolio."menu_item" ("menu_item_id", "restaurant_id", "name", "price", "available")
VALUES (3001, 2001, 'Miso Noodles', 10.75, TRUE);

-- 6. uq menu item test. Expected: uq_menu_item_0, SQLSTATE 23505.
INSERT INTO portfolio."menu_item" ("menu_item_id", "restaurant_id", "name", "price", "available")
VALUES (10003, 2001, 'Grilled Tofu Bowl', 13, TRUE);

-- 7. fk menu item test. Expected: fk_menu_item_0, SQLSTATE 23503.
INSERT INTO portfolio."menu_item" ("menu_item_id", "restaurant_id", "name", "price", "available")
VALUES (10004, 90001, 'Crispy Dumplings', 7.5, TRUE);

-- 8. check menu item price test. Expected: menu_item_price_positive, SQLSTATE 23514.
INSERT INTO portfolio."menu_item" ("menu_item_id", "restaurant_id", "name", "price", "available")
VALUES (10005, 2001, 'Tomato Soup', 0, TRUE);

-- 9. pk delivery order test. Expected: pk_delivery_order, SQLSTATE 23505.
INSERT INTO portfolio."delivery_order" ("order_id", "customer_id", "restaurant_id", "placed_at", "status", "total", "request_key")
VALUES (4001, 1001, 2001, '2026-03-01T10:00:00Z', 'placed', 9, 'req-fresh-order-pk');

-- 10. uq delivery order test. Expected: uq_delivery_order_0, SQLSTATE 23505.
INSERT INTO portfolio."delivery_order" ("order_id", "customer_id", "restaurant_id", "placed_at", "status", "total", "request_key")
VALUES (10006, 1001, 2001, '2026-03-01T10:01:00Z', 'placed', 9, 'req-seed-4001');

-- 11. fk delivery customer test. Expected: fk_delivery_order_0, SQLSTATE 23503.
INSERT INTO portfolio."delivery_order" ("order_id", "customer_id", "restaurant_id", "placed_at", "status", "total", "request_key")
VALUES (10007, 90002, 2001, '2026-03-01T10:02:00Z', 'placed', 9, 'req-fk-customer');

-- 12. fk delivery restaurant test. Expected: fk_delivery_order_1, SQLSTATE 23503.
INSERT INTO portfolio."delivery_order" ("order_id", "customer_id", "restaurant_id", "placed_at", "status", "total", "request_key")
VALUES (10008, 1001, 90003, '2026-03-01T10:03:00Z', 'placed', 9, 'req-fk-restaurant');

-- 13. check delivery status test. Expected: order_status_allowed, SQLSTATE 23514.
INSERT INTO portfolio."delivery_order" ("order_id", "customer_id", "restaurant_id", "placed_at", "status", "total", "request_key")
VALUES (10009, 1001, 2001, '2026-03-01T10:04:00Z', 'shipped', 9, 'req-invalid-status');

-- 14. pk order item test. Expected: pk_order_item, SQLSTATE 23505.
INSERT INTO portfolio."order_item" ("order_item_id", "order_id", "menu_item_id", "quantity", "unit_price")
VALUES (5001, 4001, 3002, 1, 8.25);

-- 15. uq order item test. Expected: uq_order_item_0, SQLSTATE 23505.
INSERT INTO portfolio."order_item" ("order_item_id", "order_id", "menu_item_id", "quantity", "unit_price")
VALUES (10010, 4001, 3001, 2, 12.5);

-- 16. fk order item order test. Expected: fk_order_item_0, SQLSTATE 23503.
INSERT INTO portfolio."order_item" ("order_item_id", "order_id", "menu_item_id", "quantity", "unit_price")
VALUES (10011, 90004, 3002, 1, 8.25);

-- 17. fk order item menu test. Expected: fk_order_item_1, SQLSTATE 23503.
INSERT INTO portfolio."order_item" ("order_item_id", "order_id", "menu_item_id", "quantity", "unit_price")
VALUES (10012, 4001, 90005, 1, 8.25);

-- 18. check order item quantity test. Expected: order_item_quantity_positive, SQLSTATE 23514.
INSERT INTO portfolio."order_item" ("order_item_id", "order_id", "menu_item_id", "quantity", "unit_price")
VALUES (10013, 4001, 3002, 0, 8.25);
