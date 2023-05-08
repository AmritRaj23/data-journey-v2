CREATE DATABASE IF NOT EXISTS database_datajourney;
USE database_datajourney;

CREATE TABLE IF NOT EXISTS database_datajourney.example_table (
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
event_timestamp INTEGER,
event_name STRING,
user_pseudo_id STRING
);

INSERT INTO database_datajourney.example_table (text_col, int_col, created_at) VALUES
(1538605526387002, 'level_complete_quickplay', 'D50D60807F5347EB64EF0CD5A3D4C4CD'),
(1538605456440005,'screen_view', 'D50D60807F5347EB64EF0CD5A3D4C4CD'),
(1538605649314017, 'post_score', '2D50D60807F5347EB64EF0CD5A3D4C4CD');
