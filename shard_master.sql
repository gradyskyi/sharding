CREATE EXTENSION postgres_fdw;

CREATE SERVER books_1_server
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS( host 'shard_1', port '5432', dbname 'postgres' );

CREATE SERVER books_2_server
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS( host 'shard_2', port '5432', dbname 'postgres' );

CREATE USER MAPPING FOR postgres
    SERVER books_1_server
    OPTIONS (user 'postgres', password 'pass');

CREATE USER MAPPING FOR postgres
    SERVER books_2_server
    OPTIONS (user 'postgres', password 'pass');

CREATE FOREIGN TABLE books_1 (
    id bigint not null,
    category_id int not null,
    author character varying not null,
    title character varying not null,
    year int not null )
    SERVER books_1_server
    OPTIONS (schema_name 'public', table_name 'books');

CREATE FOREIGN TABLE books_2 (
    id bigint not null,
    category_id int not null,
    author character varying not null,
    title character varying not null,
    year int not null )
    SERVER books_2_server
    OPTIONS (schema_name 'public', table_name 'books');

CREATE VIEW books AS
    SELECT * FROM books_1
    UNION ALL
    SELECT * FROM books_2;

CREATE RULE books_insert AS ON INSERT TO books
    DO INSTEAD NOTHING;
CREATE RULE books_update AS ON UPDATE TO books
    DO INSTEAD NOTHING;
CREATE RULE books_delete AS ON DELETE TO books
    DO INSTEAD NOTHING;

CREATE RULE books_insert_to_1 AS ON INSERT TO books
    WHERE ( category_id = 1 )
    DO INSTEAD INSERT INTO books_1 VALUES (NEW.*);

CREATE RULE books_insert_to_2 AS ON INSERT TO books
    WHERE ( category_id = 2 )
    DO INSTEAD INSERT INTO books_2 VALUES (NEW.*);


CREATE TABLE books_no_shard (
   id bigint not null,
   category_id int not null,
   author character varying not null,
   title character varying not null,
   year int not null
);

CREATE INDEX books_category_id_idx ON books_no_shard USING btree(category_id);
CREATE INDEX year_idx on books_no_shard USING btree(year);
CREATE INDEX title_idx on books_no_shard USING btree(title);