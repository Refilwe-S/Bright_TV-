select * from `workspace`.`data`.`brighttv_viewership` limit 100;

select * from `workspace`.`data`.`brighttv_user_profiles` limit 100;

SELECT
    u.UserID,
    IFNULL(u.Name, 'Unknown User') AS Name,
    IFNULL(u.Gender, 'Unknown') AS Gender,

    CASE
        WHEN u.Race IS NULL THEN 'Unknown'
        WHEN u.Race = '' THEN 'Other'
        WHEN u.Race = 'None' THEN 'Not Specified'
        ELSE u.Race
    END AS Race,

    u.Age,

    CASE
        WHEN u.Age IS NULL THEN 'Unknown'
        WHEN u.Age BETWEEN 0 AND 12 THEN 'Kids'
        WHEN u.Age BETWEEN 13 AND 17 THEN 'Teens'
        WHEN u.Age BETWEEN 18 AND 24 THEN 'Young Adults'
        WHEN u.Age BETWEEN 25 AND 34 THEN 'Adults'
        WHEN u.Age BETWEEN 35 AND 44 THEN 'Mid-Age Adults'
        WHEN u.Age BETWEEN 45 AND 54 THEN 'Mature Adults'
        ELSE 'Seniors'
    END AS Age_Group,

    CASE
        WHEN u.Province IS NULL THEN 'Unknown'
        WHEN u.Province = '' THEN 'Other'
        WHEN u.Province = 'None' THEN 'Not Specified'
        ELSE u.Province
    END AS Province,

    IFNULL(v.Channel2, 'No Channel') AS Channel,
    IFNULL(v.`Duration 2`, '00:00:00') AS Duration,

    FROM_UTC_TIMESTAMP(TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg') AS LocalDateTime,

    DATE_FORMAT(FROM_UTC_TIMESTAMP(TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg'), 'yyyy-MM-dd') AS Date,
    DATE_FORMAT(FROM_UTC_TIMESTAMP(TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg'), 'HH:mm:ss') AS Time,
    DATE_FORMAT(FROM_UTC_TIMESTAMP(TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg'), 'EEEE') AS Day_Name,

    YEAR(FROM_UTC_TIMESTAMP(TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) AS Year_Value,
    MONTH(FROM_UTC_TIMESTAMP(TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) AS Month_Value,
    MONTHNAME(FROM_UTC_TIMESTAMP(TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) AS Month_Name,

    CASE
        WHEN DAYOFWEEK(FROM_UTC_TIMESTAMP(TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS Week_Type,

    CASE
        WHEN HOUR(FROM_UTC_TIMESTAMP(TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) BETWEEN 0 AND 5 THEN '01. EarlyMorning'
        WHEN HOUR(FROM_UTC_TIMESTAMP(TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) BETWEEN 6 AND 9 THEN '02. Morning'
        WHEN HOUR(FROM_UTC_TIMESTAMP(TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) BETWEEN 10 AND 11 THEN '03. LateMorning'
        WHEN HOUR(FROM_UTC_TIMESTAMP(TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) BETWEEN 12 AND 16 THEN '04. Afternoon'
        WHEN HOUR(FROM_UTC_TIMESTAMP(TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'), 'Africa/Johannesburg')) BETWEEN 17 AND 19 THEN '05. Evening'
        ELSE '06. Night'
    END AS Time_Bucket,

    HOUR(v.`Duration 2`) * 60 + MINUTE(v.`Duration 2`) AS Session_Duration_Minutes,

    CASE
        WHEN HOUR(v.`Duration 2`) * 60 + MINUTE(v.`Duration 2`) <= 10 THEN '0-10 mins'
        WHEN HOUR(v.`Duration 2`) * 60 + MINUTE(v.`Duration 2`) <= 20 THEN '11-20 mins'
        WHEN HOUR(v.`Duration 2`) * 60 + MINUTE(v.`Duration 2`) <= 30 THEN '21-30 mins'
        ELSE '30+ mins'
    END AS Duration_Bucket

FROM workspace.default.bright_tv_viewers v
LEFT JOIN workspace.default.bright_tv_user u
ON v.UserID = u.UserID;
    ON b.UserID = f.UserID
LEFT JOIN preferred_time pt
    ON b.UserID = pt.UserID
LEFT JOIN preferred_day pd
    ON b.UserID = pd.UserID

ORDER BY b.record_timestamp_sa;
