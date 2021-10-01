CREATE TABLE books (
    id bigint not null,
    category_id int not null CONSTRAINT category_id_check CHECK (category_id = 1),
    author character varying not null,
    title character varying not null,
    year int not null
);

CREATE INDEX books_category_id_idx ON books USING btree(category_id);
CREATE INDEX year_idx on books USING btree(year);
CREATE INDEX title_idx on books USING btree(title);