# Food Delivery App — database design

My case study records customer, restaurant, menu_item, delivery_order, order_item.

## Users

- Customers placing food delivery orders
- Restaurant staff maintaining menus and accepting orders
- Analysts reviewing order activity

## Main operations

- Maintain customer, restaurant, and menu item records
- Place an order containing one or more menu items
- Review orders and summarize item sales

## Entities

| Entity | Information stored |
| --- | --- |
| customer | A person who places food delivery orders. |
| restaurant | A food business that maintains menu items and receives orders. |
| menu_item | A restaurant's menu entry, with scalar item attributes stored separately from restaurant details. |
| delivery_order | An order placed by one customer at one restaurant. |
| order_item | A menu item and its quantity and purchase-time unit price within an order. |

## customer

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| customer_id | BIGINT | PK | Yes |
| name | TEXT |  | Yes |
| email | TEXT | Unique | Yes |
| created_at | TIMESTAMPTZ |  | Yes |
- Unique key: (email).

## restaurant

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| restaurant_id | BIGINT | PK | Yes |
| name | TEXT |  | Yes |
| address | TEXT |  | Yes |
| active | BOOLEAN |  | Yes |


## menu_item

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| menu_item_id | BIGINT | PK | Yes |
| restaurant_id | BIGINT | FK | Yes |
| name | TEXT |  | Yes |
| price | NUMERIC(18,2) |  | Yes |
| available | BOOLEAN |  | Yes |
- restaurant_id → restaurant.restaurant_id
- Unique key: (restaurant_id, name).

## delivery_order

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| order_id | BIGINT | PK | Yes |
| customer_id | BIGINT | FK | Yes |
| restaurant_id | BIGINT | FK | Yes |
| placed_at | TIMESTAMPTZ |  | Yes |
| status | TEXT |  | Yes |
| total | NUMERIC(18,2) |  | Yes |
| request_key | TEXT | Unique | Yes |
- customer_id → customer.customer_id
- restaurant_id → restaurant.restaurant_id
- Unique key: (request_key).

## order_item

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| order_item_id | BIGINT | PK | Yes |
| order_id | BIGINT | FK | Yes |
| menu_item_id | BIGINT | FK | Yes |
| quantity | INTEGER |  | Yes |
| unit_price | NUMERIC(18,2) |  | Yes |
- order_id → delivery_order.order_id
- menu_item_id → menu_item.menu_item_id
- Unique key: (order_id, menu_item_id).

## Relationships and business rules

- Each customer email identifies at most one customer.
- Every menu item belongs to an existing restaurant.
- A menu item's price must be greater than zero.
- Every order references an existing customer.
- Every order references an existing restaurant.
- A request key can identify only one order, making concurrent retries idempotent.
- Order status is limited to placed, accepted, preparing, completed, or cancelled.
- Each order item has a quantity greater than zero.
- Every order item belongs to an existing order.
- Every order item references an existing menu item.

## Assumptions

- All identifiers are synthetic and drawn from one globally unique identifier namespace; each entity has one single-column primary key.
- An order belongs to one customer and one restaurant. Order items record the purchase-time unit price so later menu price changes do not rewrite order history.
- A repeated request_key represents a retry of the same order request and must not create another order.
- Worked normalization example: menu_item references restaurant through restaurant_id and stores only its own scalar attributes; restaurant name and address remain in restaurant. The example follows menu_item's single-column key and does not repeat ancestor roles.

