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