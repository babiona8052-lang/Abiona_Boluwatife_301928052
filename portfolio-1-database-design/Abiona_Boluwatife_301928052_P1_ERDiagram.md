# Food Delivery App — ER diagram

```mermaid
erDiagram
    direction LR
    customer {
        bigint customer_id PK
        text name
        text email UK
        timestamptz created_at
    }
    restaurant {
        bigint restaurant_id PK
        text name
        text address
        boolean active
    }
    menu_item {
        bigint menu_item_id PK
        bigint restaurant_id FK
        text name
        numeric price
        boolean available
    }
    delivery_order {
        bigint order_id PK
        bigint customer_id FK
        bigint restaurant_id FK
        timestamptz placed_at
        text status
        numeric total
        text request_key UK
    }
    order_item {
        bigint order_item_id PK
        bigint order_id FK
        bigint menu_item_id FK
        integer quantity
        numeric unit_price
    }
    restaurant ||--o{ menu_item : "restaurant_id"
    customer ||--o{ delivery_order : "customer_id"
    restaurant ||--o{ delivery_order : "restaurant_id"
    delivery_order ||--o{ order_item : "order_id"
    menu_item ||--o{ order_item : "menu_item_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Abiona_Boluwatife_301928052_ERDiagram.png)
