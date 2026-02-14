# pkg 

PostgreSQL Knowledge Graph

## Purpose
This docker image provides a PostgreSQL-only stack to build and query a knowledge graph without external databases.

It includes
- `pg_search` for full-text search (like Elasticsearch)
- `pgvector` for vector search (like Pinecone/ChromaDB/Faiss/etc.)
- `Apache AGE` for graph search (like Neo4j/RedisGraph/etc.)

## Quickstart

### Docker
```bash
docker run --name pkg -p 5432:5432 \
  -e POSTGRES_PASSWORD=postgres \
  ghcr.io/heekangpark/pkg:arm-d12-pg16-k0.21-v0.8-g1.6-0.1.0
```

### docker-compose.yml
```yaml
services:
  postgres:
    image: ghcr.io/heekangpark/pkg:arm-d12-pg16-k0.21-v0.8-g1.6-0.1.0
    container_name: pkg
    ports:
      - "5432:5432"
    environment:
      POSTGRES_PASSWORD: postgres
    volumes:
      - "./pgdata:/var/lib/postgresql/data"
```

### Validation

#### pg_search

```sql
create extension pg_search;

CALL paradedb.create_bm25_test_table(
  schema_name => 'public',
  table_name => 'mock_items'
);

SELECT description, rating, category
FROM mock_items
LIMIT 3;

CREATE INDEX search_idx ON mock_items
USING bm25 (id, description, category, rating, in_stock, created_at, metadata, weight_range)
WITH (key_field='id');

SELECT description, rating, category
FROM mock_items
WHERE description ||| 'running shoes' AND rating > 2
ORDER BY rating
LIMIT 5;
```

expected output:

|      | description           | rating | category   |
| :--- | :-------------------- | :----- | :--------- |
| 1    | "White jogging shoes" | 3      | "Footwear" |
| 2    | "Generic shoes"       | 4      | "Footwear" |
| 3    | "Sleek running shoes" | 5      | "Footwear" |



#### pgvector

```sql
create extension vector;

CREATE TABLE items (id bigserial PRIMARY KEY, embedding vector(3)); 

INSERT INTO items (embedding) VALUES ('[1,2,3]'), ('[4,5,6]');

SELECT * FROM items ORDER BY embedding <-> '[3,1,2]' LIMIT 5;
```

expected output:

|      | id   | embedding |
| :--- | :--- | :-------- |
| 1    | 1    | [1,2,3]   |
| 2    | 2    | [4,5,6]   |

#### Apache AGE

```sql
CREATE EXTENSION age;
SET search_path = ag_catalog, "$user", public;

SELECT create_graph('hello_graph');

CREATE TABLE hello_table (
    id SERIAL PRIMARY KEY,
    name TEXT
);

INSERT INTO hello_table (name)
VALUES ('World'), ('Apache AGE'), ('PostgreSQL');

SELECT * FROM cypher('hello_graph', $$
    MATCH (g:Greeting)
    RETURN g.message
$$) AS (message agtype);
```

expected output:

|      | message                |
| :--- | :--------------------- |
| 1    | "Hello World from AGE" |

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.