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