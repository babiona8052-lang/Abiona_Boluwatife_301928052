# Food Delivery App — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| restaurant_id | menu_item records (list) |
| --- | --- |
| 2001 | [3001,3002] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| menu_item.menu_item_id | menu_item.restaurant_id | menu_item.name | restaurant.restaurant_id | restaurant.name |
| --- | --- | --- | --- | --- |
| 3001 | 2001 | Grilled Tofu Bowl | 2001 | Cedar Kitchen |
| 3002 | 2001 | Garden Salad | 2001 | Cedar Kitchen |

Key: menu_item_id.

## 2NF: depend on the whole key

menu_item: restaurant_id is a proper part of candidate key (restaurant_id, name), and determines restaurant details.

## restaurant_example

| restaurant.restaurant_id | restaurant.name |
| --- | --- |
| 2001 | Cedar Kitchen |

## menu_item_example

| menu_item.menu_item_id | menu_item.restaurant_id | menu_item.name |
| --- | --- | --- |
| 3001 | 2001 | Grilled Tofu Bowl |
| 3002 | 2001 | Garden Salad |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## customer

| customer_id | name | email | created_at |
| --- | --- | --- | --- |
| 1001 | Avery Chen | avery.chen@example.test | 2026-01-15T10:30:00+00:00 |

## restaurant

| restaurant_id | name | address | active |
| --- | --- | --- | --- |
| 2001 | Cedar Kitchen | 12 Market Street | true |

## menu_item

| menu_item_id | restaurant_id | name | price | available |
| --- | --- | --- | --- | --- |
| 3001 | 2001 | Grilled Tofu Bowl | 12.5 | true |
| 3002 | 2001 | Garden Salad | 8.25 | true |

## delivery_order

| order_id | customer_id | restaurant_id | placed_at | status | total | request_key |
| --- | --- | --- | --- | --- | --- | --- |
| 4001 | 1001 | 2001 | 2026-02-10T12:15:00+00:00 | accepted | 12.5 | req-seed-4001 |

## order_item

| order_item_id | order_id | menu_item_id | quantity | unit_price |
| --- | --- | --- | --- | --- |
| 5001 | 4001 | 3001 | 1 | 12.5 |

## Dependencies

- customer: (customer_id) → name, email, created_at
- restaurant: (restaurant_id) → name, address, active
- menu_item: (menu_item_id) → restaurant_id, name, price, available
- delivery_order: (order_id) → customer_id, restaurant_id, placed_at, status, total, request_key
- order_item: (order_item_id) → order_id, menu_item_id, quantity, unit_price

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
