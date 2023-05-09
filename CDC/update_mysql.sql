CREATE DATABASE IF NOT EXISTS database_datajourney;
USE database_datajourney;

CREATE TABLE IF NOT EXISTS database_datajourney.example_table (
event_timestamp timestamp,
event_name varchar(255),
user_pseudo_id varchar(255)
);

INSERT INTO database_datajourney.example_table (event_timestamp, event_name, user_pseudo_id) VALUES
(153864, 'level_complete_quickplay', 'D50D60807F5347EB64EF0CD5A3D4C4CD'),
(153865, 'level_start_quickplay', 'D50D60807F5347EB64EF0CD5A3D4C4CD'),
(153866, 'level_fail_quickplay', 'D50D60807F5347EB64EF0CD5A3D4C4CD'),
(153867, 'session_start', 'D50D60807F5347EB64EF0CD5A3D4C4CD'),
(153868, 'user_engagement', 'D50D60807F5347EB64EF0CD5A3D4C4CD');
