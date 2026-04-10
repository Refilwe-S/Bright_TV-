
---Getting monthly active users
SELECT
DATE_TRUNC('month', v.RecordDate2) AS month,
COUNT(DISTINCT v.UserID0) AS active_users
FROM workspace.data.bright_tv_viewership v
JOIN workspace.data.bright_tv_username u ON v.UserID0 = u.UserID
GROUP BY 1
ORDER BY 1;


---Get time and date separated
SELECT
v.UserID0,
v.Channel2,
TO_TIMESTAMP(v.RecordDate2, 'MM/dd/yyyy HH:mm') AS record_timestamp_utc,
FROM_UTC_TIMESTAMP(
TO_TIMESTAMP(v.RecordDate2, 'MM/dd/yyyy HH:mm'),
'Africa/Johannesburg'
) AS record_timestamp_sa,
CAST(
FROM_UTC_TIMESTAMP(
TO_TIMESTAMP(v.RecordDate2, 'MM/dd/yyyy HH:mm'),
'Africa/Johannesburg') AS DATE) AS record_date,
DATE_FORMAT(
FROM_UTC_TIMESTAMP(
TO_TIMESTAMP(v.RecordDate2, 'MM/dd/yyyy HH:mm'),
'Africa/Johannesburg'),
'HH:mm:ss') AS record_time
FROM workspace.data.bright_tv_viewership v;


---Get genders
SELECT
u.Gender,
COUNT(*) AS total_sessions,
AVG(UNIX_TIMESTAMP(v.`Duration 2`)) AS avg_watch_time
FROM workspace.data.bright_tv_viewership v
JOIN workspace.data.bright_tv_username u ON v.UserID0 = u.UserID
GROUP BY u.Gender;


---Getting age group
SELECT
CASE
WHEN u.Age < 18 THEN 'Under 18'
WHEN u.Age BETWEEN 18 AND 25 THEN '18-25'
WHEN u.Age BETWEEN 26 AND 35 THEN '26-35'
WHEN u.Age BETWEEN 36 AND 50 THEN '36-50'
ELSE '50+'
END AS age_group,
COUNT(*) AS sessions
FROM workspace.data.bright_tv_viewership v
JOIN workspace.data.bright_tv_username u ON v.UserID0 = u.UserID
GROUP BY age_group
ORDER BY sessions DESC;


---Getting provinces list
SELECT
u.Province,
COUNT(*) AS sessions
FROM workspace.data.bright_tv_viewership v
JOIN workspace.data.bright_tv_username u ON v.UserID0 = u.UserID
GROUP BY u.Province
ORDER BY sessions DESC;


---Getting channel list with viewers' average time
SELECT
v.Channel2,
COUNT(*) AS views,
AVG(UNIX_TIMESTAMP(v.`Duration 2`)) AS avg_watch_time
FROM workspace.data.bright_tv_viewership v
JOIN workspace.data.bright_tv_username u ON v.UserID0 = u.UserID
GROUP BY v.Channel2
ORDER BY views DESC
LIMIT 10;


SELECT
HOUR(v.RecordDate2) AS hour,
COUNT(*) AS sessions
FROM workspace.data.bright_tv_viewership v
JOIN workspace.data.bright_tv_username u ON v.UserID0 = u.UserID
GROUP BY hour
ORDER BY hour;


---Getting weekday and weekend sessions
SELECT
CASE
WHEN DAYOFWEEK(v.RecordDate2) IN (1,7) THEN 'Weekend'
ELSE 'Weekday'
END AS day_type,
COUNT(*) AS sessions
FROM workspace.data.bright_tv_viewership v
JOIN workspace.data.bright_tv_username u ON v.UserID0 = u.UserID
GROUP BY day_type;


SELECT
DATE(v.RecordDate2) AS date,
COUNT(*) AS sessions
FROM workspace.data.bright_tv_viewership v
JOIN workspace.data.bright_tv_username u ON v.UserID0 = u.UserID
GROUP BY date
ORDER BY sessions ASC
LIMIT 10;


WITH viewership AS (
  SELECT * FROM workspace.data.bright_tv_viewership),
user_profiles AS (
  SELECT * FROM workspace.data.bright_tv_username)
SELECT
v.UserID0,
u.Province,
COUNT(*) AS sessions,
SUM(UNIX_TIMESTAMP(v.`Duration 2`)) AS total_watch_time
FROM viewership v
JOIN user_profiles u ON v.UserID0 = u.UserID
GROUP BY v.UserID0, u.Province
ORDER BY total_watch_time DESC;


SELECT
v.UserID0,
u.Name,
u.Province,
MAX(v.RecordDate2) AS last_active
FROM workspace.data.bright_tv_viewership v
JOIN workspace.data.bright_tv_username u ON v.UserID0 = u.UserID
GROUP BY v.UserID0, u.Name, u.Province
HAVING DATEDIFF(CURRENT_DATE, MAX(v.RecordDate2)) > 14;


SELECT
u.`Social Media Handle`,
COUNT(v.UserID0) AS activity
FROM workspace.data.bright_tv_viewership v
JOIN workspace.data.bright_tv_username u ON v.UserID0 = u.UserID
WHERE u.`Social Media Handle` IS NOT NULL
GROUP BY u.`Social Media Handle`
ORDER BY activity DESC;


WITH cleaned_viewership AS (
SELECT
COALESCE(CAST(UserID0 AS STRING), '0') AS user_id,
COALESCE(Channel2, 'No Channel') AS channel,
COALESCE(UNIX_TIMESTAMP(`Duration 2`), 0) AS duration,
RecordDate2 AS recorddate_raw
FROM workspace.data.bright_tv_viewership)
SELECT * FROM cleaned_viewership;


WITH cleaned_users AS (
SELECT
COALESCE(CAST(UserID AS STRING), '0') AS user_id,
COALESCE(Name, 'No Name') AS name,
COALESCE(Surname, 'No Surname') AS surname,
COALESCE(Email, 'No Email') AS email,
COALESCE(Gender, 'No Gender') AS gender,
COALESCE(Race, 'No Race') AS race,
COALESCE(CAST(ROUND(Age, 0) AS INT), 0) AS age,
CASE
WHEN Age IS NULL THEN 'Unknown'
WHEN Age < 18 THEN 'Under 18'
WHEN Age BETWEEN 18 AND 24 THEN '18-24'
WHEN Age BETWEEN 25 AND 34 THEN '25-34'
WHEN Age BETWEEN 35 AND 44 THEN '35-44'
WHEN Age BETWEEN 45 AND 54 THEN '45-54'
ELSE '55+'
END AS age_group,
COALESCE(Province, 'No Province') AS province,
COALESCE(`Social Media Handle`, 'No Social Handle') AS social_media_handle
FROM workspace.data.bright_tv_username)
SELECT * FROM cleaned_users;

WITH user_profiles AS (
SELECT
COALESCE(CAST(UserID AS STRING), '0') AS user_id,
COALESCE(Name, 'No Name') AS name,
COALESCE(Province, 'No Province') AS province,
COALESCE(Race, 'No Race') AS race,
CASE
WHEN Province IN ('Gauteng', 'Western Cape', 'KwaZulu-Natal') THEN 'Top Provinces'
WHEN Province IS NULL THEN 'Unknown'
ELSE 'Other Provinces'
END AS province_group,
CASE
WHEN Race IN ('Black', 'White', 'Coloured', 'Indian') THEN Race
WHEN Race IS NULL THEN 'Unknown'
ELSE 'Other'
END AS race_group
FROM workspace.data.bright_tv_username),
cleaned_viewership AS (
SELECT
COALESCE(CAST(UserID0 AS STRING), '0') AS user_id,
COALESCE(Channel2, 'No Channel') AS channel,
COALESCE(CAST(UNIX_TIMESTAMP(`Duration 2`) AS DOUBLE), 0.0) AS duration
FROM workspace.data.bright_tv_viewership)
SELECT * FROM user_profiles;


WITH cleaned_users AS (
SELECT
COALESCE(CAST(UserID AS STRING), '0') AS user_id,
COALESCE(Name, 'No Name') AS name,
COALESCE(Surname, 'No Surname') AS surname,
COALESCE(Email, 'No Email') AS email,
COALESCE(Gender, 'No Gender') AS gender,
COALESCE(Race, 'No Race') AS race,
COALESCE(CAST(ROUND(Age, 0) AS INT), 0) AS age,
CASE
WHEN Age IS NULL THEN 'Unknown'
WHEN Age < 18 THEN 'Under 18'
WHEN Age BETWEEN 18 AND 24 THEN '18-24'
WHEN Age BETWEEN 25 AND 34 THEN '25-34'
WHEN Age BETWEEN 35 AND 44 THEN '35-44'
WHEN Age BETWEEN 45 AND 54 THEN '45-54'
ELSE '55+'
END AS age_group,
COALESCE(Province, 'No Province') AS province,
CASE
WHEN Province IN ('Gauteng', 'Western Cape', 'Kwazulu Natal') THEN 'Top Provinces'
WHEN Province IS NULL THEN 'Unknown'
ELSE 'Other Provinces'
END AS province_group,
CASE
WHEN Race IN ('black', 'white', 'coloured', 'indian_asian') THEN Race
WHEN Race IS NULL THEN 'Unknown'
ELSE 'Other'
END AS race_group,
COALESCE(`Social Media Handle`, 'No Social Handle') AS social_media_handle
FROM workspace.data.bright_tv_username),
cleaned_viewership AS (
SELECT
COALESCE(CAST(UserID0 AS STRING), '0') AS user_id,
COALESCE(Channel2, 'No Channel') AS channel,
COALESCE(CAST(UNIX_TIMESTAMP(`Duration 2`) AS DOUBLE), 0.0) AS duration,
RecordDate2 AS recorddate_raw,
TO_TIMESTAMP(RecordDate2, 'MM/dd/yyyy HH:mm') AS record_timestamp_utc,
FROM_UTC_TIMESTAMP(TO_TIMESTAMP(RecordDate2, 'MM/dd/yyyy HH:mm'), 'Africa/Johannesburg') AS record_timestamp_sa,
CAST(FROM_UTC_TIMESTAMP(TO_TIMESTAMP(RecordDate2, 'MM/dd/yyyy HH:mm'), 'Africa/Johannesburg') AS DATE) AS record_date,
DATE_FORMAT(FROM_UTC_TIMESTAMP(TO_TIMESTAMP(RecordDate2, 'MM/dd/yyyy HH:mm'), 'Africa/Johannesburg'), 'HH:mm:ss') AS record_time,
CASE
WHEN HOUR(FROM_UTC_TIMESTAMP(TO_TIMESTAMP(RecordDate2, 'MM/dd/yyyy HH:mm'), 'Africa/Johannesburg')) BETWEEN 5 AND 11 THEN 'Morning'
WHEN HOUR(FROM_UTC_TIMESTAMP(TO_TIMESTAMP(RecordDate2, 'MM/dd/yyyy HH:mm'), 'Africa/Johannesburg')) BETWEEN 12 AND 16 THEN 'Afternoon'
WHEN HOUR(FROM_UTC_TIMESTAMP(TO_TIMESTAMP(RecordDate2, 'MM/dd/yyyy HH:mm'), 'Africa/Johannesburg')) BETWEEN 17 AND 20 THEN 'Evening'
ELSE 'Night'
END AS time_bucket,
CASE
WHEN DAYOFWEEK(FROM_UTC_TIMESTAMP(TO_TIMESTAMP(RecordDate2, 'MM/dd/yyyy HH:mm'), 'Africa/Johannesburg')) IN (1, 7) THEN 'Weekend'
ELSE 'Weekday'
END AS week_part
FROM workspace.data.bright_tv_viewership),
base AS (
SELECT
u.user_id,
u.name,
u.surname,
u.email,
u.gender,
u.race,
u.age,
u.age_group,
u.province,
u.province_group,
u.race_group,
u.social_media_handle,
v.channel,
v.duration,
v.recorddate_raw,
v.record_timestamp_utc,
v.record_timestamp_sa,
v.record_date,
v.record_time,
v.time_bucket,
v.week_part
FROM cleaned_users u
LEFT JOIN cleaned_viewership v
ON u.user_id = v.user_id),
user_stats AS (
SELECT
user_id,
COUNT(CASE WHEN channel <> 'No Channel' THEN 1 END) AS total_views,
COUNT(DISTINCT CASE WHEN channel <> 'No Channel' THEN channel END) AS channels_watched,
COUNT(DISTINCT record_date) AS active_days,
MIN(record_date) AS first_watch_date,
MAX(record_date) AS last_watch_date,
SUM(COALESCE(duration, 0)) AS total_watch_duration,
AVG(CASE WHEN channel <> 'No Channel' THEN duration END) AS avg_watch_duration,
SUM(CASE WHEN week_part = 'Weekday' AND channel <> 'No Channel' THEN 1 ELSE 0 END) AS weekday_views,
SUM(CASE WHEN week_part = 'Weekend' AND channel <> 'No Channel' THEN 1 ELSE 0 END) AS weekend_views,
SUM(CASE WHEN time_bucket = 'Morning' AND channel <> 'No Channel' THEN 1 ELSE 0 END) AS morning_views,
SUM(CASE WHEN time_bucket = 'Afternoon' AND channel <> 'No Channel' THEN 1 ELSE 0 END) AS afternoon_views,
SUM(CASE WHEN time_bucket = 'Evening' AND channel <> 'No Channel' THEN 1 ELSE 0 END) AS evening_views,
SUM(CASE WHEN time_bucket = 'Night' AND channel <> 'No Channel' THEN 1 ELSE 0 END) AS night_views
FROM base
GROUP BY user_id),
fav_channel AS (
SELECT user_id, channel AS favorite_channel
FROM (
SELECT
user_id,
channel,
COUNT(*) AS cnt,
ROW_NUMBER() OVER (
PARTITION BY user_id
ORDER BY COUNT(*) DESC, channel
) AS rn
FROM base
WHERE channel IS NOT NULL
AND channel <> 'No Channel'
GROUP BY user_id, channel) x
WHERE rn = 1),
peak_day AS (
SELECT user_id, record_date AS peak_viewing_day
FROM (
SELECT
user_id,
record_date,
COUNT(*) AS cnt,
ROW_NUMBER() OVER (
PARTITION BY user_id
ORDER BY COUNT(*) DESC, record_date) AS rn
FROM base
WHERE record_date IS NOT NULL
AND channel <> 'No Channel'
GROUP BY user_id, record_date) x
WHERE rn = 1),
most_recent_channel AS (
SELECT user_id, channel AS most_recent_channel
FROM (
SELECT
user_id,
channel,
record_timestamp_sa,
ROW_NUMBER() OVER (
PARTITION BY user_id
ORDER BY record_timestamp_sa DESC, channel) AS rn
FROM base
WHERE record_timestamp_sa IS NOT NULL
AND channel IS NOT NULL
AND channel <> 'No Channel') x
WHERE rn = 1),
time_pref AS (
SELECT user_id, time_bucket AS preferred_time_of_day
FROM (
SELECT
user_id,
time_bucket,
COUNT(*) AS cnt,
ROW_NUMBER() OVER (
PARTITION BY user_id
ORDER BY COUNT(*) DESC, time_bucket) AS rn
FROM base
WHERE time_bucket IS NOT NULL
AND channel <> 'No Channel'
GROUP BY user_id, time_bucket) x
WHERE rn = 1),
most_recent_watch AS (
SELECT
user_id,
record_date AS most_recent_watch_date,
record_time AS most_recent_watch_time,
record_timestamp_sa AS most_recent_watch_datetime
FROM (
SELECT
user_id,
record_date,
record_time,
record_timestamp_sa,
ROW_NUMBER() OVER (
PARTITION BY user_id
ORDER BY record_timestamp_sa DESC) AS rn
FROM base
WHERE record_timestamp_sa IS NOT NULL
AND channel <> 'No Channel') x
WHERE rn = 1)
SELECT
u.user_id,
u.name,
u.surname,
u.email,
u.gender,
u.race,
u.age,
u.age_group,
u.province,
u.province_group,
u.race_group,
u.social_media_handle,
COALESCE(s.total_views, 0) AS total_views,
COALESCE(s.channels_watched, 0) AS channels_watched,
COALESCE(s.active_days, 0) AS active_days,
s.first_watch_date,
s.last_watch_date,
COALESCE(s.total_watch_duration, 0) AS total_watch_duration,
ROUND(COALESCE(s.avg_watch_duration, 0), 2) AS avg_watch_duration,
COALESCE(s.weekday_views, 0) AS weekday_views,
COALESCE(s.weekend_views, 0) AS weekend_views,
COALESCE(s.morning_views, 0) AS morning_views,
COALESCE(s.afternoon_views, 0) AS afternoon_views,
COALESCE(s.evening_views, 0) AS evening_views,
COALESCE(s.night_views, 0) AS night_views,
COALESCE(fc.favorite_channel, 'No Activity') AS favorite_channel,
pd.peak_viewing_day,
COALESCE(mrc.most_recent_channel, 'No Activity') AS most_recent_channel,
mrw.most_recent_watch_date,
mrw.most_recent_watch_time,
mrw.most_recent_watch_datetime,
COALESCE(tp.preferred_time_of_day, 'No Activity') AS preferred_time_of_day,
ROUND(
CASE
WHEN COALESCE(s.active_days, 0) = 0 THEN 0
ELSE COALESCE(s.total_views, 0) * 1.0 / s.active_days
END, 2) AS avg_views_per_active_day,
ROUND(
CASE
WHEN COALESCE(s.active_days, 0) = 0 THEN 0
ELSE COALESCE(s.total_watch_duration, 0) * 1.0 / s.active_days
END, 2) AS avg_duration_per_active_day,
CASE
WHEN COALESCE(s.total_views, 0) >= 50 THEN 'High'
WHEN COALESCE(s.total_views, 0) BETWEEN 20 AND 49 THEN 'Medium'
WHEN COALESCE(s.total_views, 0) BETWEEN 1 AND 19 THEN 'Low'
ELSE 'No Activity'
END AS activity_level,
COALESCE(s.total_views, 0) * COALESCE(s.channels_watched, 0) AS engagement_score,
CASE
WHEN s.last_watch_date IS NULL THEN NULL
ELSE DATEDIFF(CURRENT_DATE(), s.last_watch_date)
END AS recency_days,
CASE
WHEN s.last_watch_date IS NULL THEN 'No Activity'
WHEN DATEDIFF(CURRENT_DATE(), s.last_watch_date) <= 7 THEN 'Active'
WHEN DATEDIFF(CURRENT_DATE(), s.last_watch_date) <= 30 THEN 'Warm'
WHEN DATEDIFF(CURRENT_DATE(), s.last_watch_date) <= 90 THEN 'Cold'
ELSE 'Inactive'
END AS recency_bucket,
CASE
WHEN s.first_watch_date IS NULL OR s.last_watch_date IS NULL THEN 0
ELSE DATEDIFF(s.last_watch_date, s.first_watch_date)
END AS tenure_days,
CASE
WHEN COALESCE(s.weekday_views, 0) > COALESCE(s.weekend_views, 0) THEN 'Weekday Viewer'
WHEN COALESCE(s.weekend_views, 0) > COALESCE(s.weekday_views, 0) THEN 'Weekend Viewer'
WHEN COALESCE(s.total_views, 0) = 0 THEN 'No Activity'
ELSE 'Balanced'
END AS viewing_pattern
FROM cleaned_users u
LEFT JOIN user_stats s
ON u.user_id = s.user_id
LEFT JOIN fav_channel fc
ON u.user_id = fc.user_id
LEFT JOIN peak_day pd
ON u.user_id = pd.user_id
LEFT JOIN most_recent_channel mrc
ON u.user_id = mrc.user_id
LEFT JOIN time_pref tp
ON u.user_id = tp.user_id
LEFT JOIN most_recent_watch mrw
ON u.user_id = mrw.user_id;
