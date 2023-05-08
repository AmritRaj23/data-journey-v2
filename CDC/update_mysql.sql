CREATE DATABASE IF NOT EXISTS database_datajourney;
USE database_datajourney;

CREATE TABLE IF NOT EXISTS database_datajourney.example_table (
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
event_timestamp INTEGER,
event_name STRING,
user_pseudo_id STRING
);

INSERT INTO database_datajourney.example_table (text_col, int_col, created_at) VALUES
(1538605647313015, 'level_complete_quickplay', 'D50D60807F5347EB64EF0CD5A3D4C4CD'),
(1538606005034070, 'level_start_quickplay', 'D50D60807F5347EB64EF0CD5A3D4C4CD'),
(1538606043777092, 'level_fail_quickplay', 'D50D60807F5347EB64EF0CD5A3D4C4CD'),
(1538605475353000, 'session_start', 'D50D60807F5347EB64EF0CD5A3D4C4CD'),
('1538605515191004, 'user_engagement', '2021-05-01 00:00:00');

UPDATE database_datajourney.example_table;
