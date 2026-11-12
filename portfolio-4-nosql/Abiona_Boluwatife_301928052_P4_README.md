# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection order_events for order_placed and order_accepted events. These are fictional event examples based on delivery_order, order_item, menu_item, customer, restaurant.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related menu_item details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "order_placed",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "order_item",
        "key": {
            "order_item_id": 5001
        },
        "snapshot": {
            "order_item_id": 5001,
            "order_id": 4001,
            "menu_item_id": 3001,
            "quantity": 1,
            "unit_price": 12.5
        }
    },
    "embedded": {
        "menu_item": [
            {
                "key": {
                    "menu_item_id": 3001
                },
                "snapshot": {
                    "menu_item_id": 3001,
                    "restaurant_id": 2001,
                    "name": "Grilled Tofu Bowl",
                    "price": 12.5,
                    "available": true
                },
                "via": [
                    "order_item.menu_item_id → menu_item"
                ]
            }
        ]
    },
    "references": {
        "delivery_order": [
            {
                "key": {
                    "order_id": 4001
                },
                "via": [
                    "order_item.order_id → delivery_order"
                ]
            }
        ],
        "customer": [
            {
                "key": {
                    "customer_id": 1001
                },
                "via": [
                    "order_item.order_id → delivery_order.customer_id → customer"
                ]
            }
        ],
        "restaurant": [
            {
                "key": {
                    "restaurant_id": 2001
                },
                "via": [
                    "order_item.order_id → delivery_order.restaurant_id → restaurant",
                    "order_item.menu_item_id → menu_item.restaurant_id → restaurant"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 1 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 2 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("order_events").find({"eventType":"order_placed"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "order_placed",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "order_item_id": 5001
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("order_events").find({"source.key.order_item_id":5001}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "order_placed",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "order_item_id": 5001
    }
  },
  {
    "_id": "event_000002",
    "eventType": "order_accepted",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "order_item_id": 5001
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("order_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "order_placed",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "order_item_id": 5001
    }
  },
  {
    "_id": "event_000002",
    "eventType": "order_accepted",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "order_item_id": 5001
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("order_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| order_accepted | 1 |
| order_placed | 1 |

## Validation and suitability

MongoDB inserted 2 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 2 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Abiona_Boluwatife_301928052_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Abiona_Boluwatife_301928052_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

