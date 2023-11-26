\c sample_db;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id integer NOT NULL PRIMARY KEY,
	first_name varchar(100) NOT NULL,
	last_name varchar(100) NOT NULL,
	address varchar(100) NOT NULL,
	zip_code char(8) NOT NULL,
	created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	update_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ID用シーケンス作成
CREATE SEQUENCE sample_id_seq START 1;
-- サンブルデータの登録
INSERT INTO users (id, first_name, last_name, address, zip_code) VALUES
	(nextval('sample_id_seq'), 'Taro', 'Yamada', 'Tokyo', '200-0001'),
	(nextval('sample_id_seq'), 'Hanako', 'Yamada', 'Tokyo', '100-0001'),
	(nextval('sample_id_seq'), 'Jhon', 'Smith', 'New York', '400-0001'),
	(nextval('sample_id_seq'), 'Mike', 'world', 'San Fransisco', '300-0001');