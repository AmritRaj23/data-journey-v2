CREATE DATABASE IF NOT EXISTS database_name;
USE database_name;

CREATE TABLE IF NOT EXISTS database_name.example_table (
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
text_col VARCHAR(50),
int_col INT,
created_at TIMESTAMP
);

INSERT INTO database_name.example_table (text_col, int_col, created_at) VALUES
('abc', 0, '2021-05-01 00:00:00'),
('def', 1, NULL),
('ghi', -987, NOW()),
('jkl', 2786, '2021-05-01 00:00:00'),
('abc', 0, '2021-05-01 00:00:00'),
('def', 1, NULL),
('ghi', -987, NOW()),
('jkl', 2786, '2021-05-01 00:00:00'),
('abc', 0, '2021-05-01 00:00:00'),
('def', 1, NULL),
('ghi', -987, NOW()),
('jkl', 2786, '2021-05-01 00:00:00'),
('abc', 0, '2021-05-01 00:00:00'),
('def', 1, NULL),
('ghi', -987, NOW()),
('jkl', 2786, '2021-05-01 00:00:00'),
('abc', 0, '2021-05-01 00:00:00'),
('def', 1, NULL),
('ghi', -987, NOW()),
('jkl', 2786, '2021-05-01 00:00:00');

UPDATE database_name.example_table SET int_col=int_col*2;