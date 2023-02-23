/* Delete the field company from the ratings_dump table */

ALTER TABLE ratings_dump
DROP COLUMN company;

SELECT * FROM ratings_dump;