select * from `workspace`.`data`.`brighttv_viewership` limit 100;

select * from `workspace`.`data`.`brighttv_user_profiles` limit 100;



WITH base AS (

    -- Join user table and viewership table
    SELECT
        u.UserID,
        COALESCE(u.Name, 'Unknown User') AS Name,
        IFNULL(u.Gender, 'Not Specified') AS Gender,
        IFNULL(u.Race, 'Not Specified') AS Race,
        COALESCE(u.Age, 0) AS Age,
        IFNULL(u.Province, 'Unknown Province') AS Province,
        COALESCE(v.Channel2, 'No Channel') AS Channel,
        v.RecordDate2,
        COALESCE(v.`Duration 2`, CAST('00:00:00' AS TIMESTAMP)) AS Duration,

        -- Convert UTC time to South African time
        FROM_UTC_TIMESTAMP(
            TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'),
            'Africa/Johannesburg'
        ) AS record_timestamp_sa,

        -- Extract date only
        CAST(
            FROM_UTC_TIMESTAMP(
                TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'),
                'Africa/Johannesburg'
            ) AS DATE
        ) AS record_date,

        -- Day name
        DATE_FORMAT(
            FROM_UTC_TIMESTAMP(
                TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'),
                'Africa/Johannesburg'
            ),
            'EEEE'
        ) AS day_name,

        -- Weekday vs weekend
        CASE
            WHEN DAYOFWEEK(
                FROM_UTC_TIMESTAMP(
                    TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'),
                    'Africa/Johannesburg'
                )
            ) IN (1, 7) THEN 'Weekend'
            ELSE 'Weekday'
        END AS week_type,

        -- Time of day grouping
        CASE
            WHEN HOUR(
                FROM_UTC_TIMESTAMP(
                    TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'),
                    'Africa/Johannesburg'
                )
            ) BETWEEN 5 AND 11 THEN 'Morning'
            WHEN HOUR(
                FROM_UTC_TIMESTAMP(
                    TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'),
                    'Africa/Johannesburg'
                )
            ) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS time_period,

        -- Age groups using ISNULL check
        CASE
            WHEN ISNULL(u.Age) THEN 'Unknown'
            WHEN u.Age < 18 THEN 'Under 18'
            WHEN u.Age BETWEEN 18 AND 24 THEN 'Young Adults'
            WHEN u.Age BETWEEN 25 AND 34 THEN 'Adults'
            WHEN u.Age BETWEEN 35 AND 44 THEN 'Mid-Age Adults'
            WHEN u.Age BETWEEN 45 AND 54 THEN 'Mature Adults'
            ELSE 'Seniors'
        END AS age_group,

        -- Convert duration to minutes with NULL handling
        COALESCE(
            HOUR(TO_TIMESTAMP(v.`Duration 2`, 'HH:mm:ss')) * 60
            + MINUTE(TO_TIMESTAMP(v.`Duration 2`, 'HH:mm:ss'))
            + SECOND(TO_TIMESTAMP(v.`Duration 2`, 'HH:mm:ss')) / 60.0,
            0.0
        ) AS duration_minutes

    FROM workspace.default.bright_tv_user u
    LEFT JOIN workspace.default.bright_tv_viewers v
        ON u.UserID = v.UserID
),

daily_sessions AS (

    -- Count sessions per day
    SELECT
        record_date,
        COUNT(*) AS daily_sessions
    FROM base
    WHERE record_date IS NOT NULL
    GROUP BY record_date
),

low_consumption AS (

    -- Flag low consumption days
    SELECT
        record_date,
        daily_sessions,
        AVG(daily_sessions) OVER () AS avg_daily_sessions,
        CASE
            WHEN daily_sessions < AVG(daily_sessions) OVER () THEN 'Low Consumption'
            ELSE 'Normal/High Consumption'
        END AS low_consumption_day
    FROM daily_sessions
),

user_summary AS (

    -- Create user summary
    SELECT
        UserID,
        COUNT(Channel) AS total_views,
        MAX(record_date) AS last_watch_date,

        IFNULL(DATEDIFF(CURRENT_DATE(), MAX(record_date)), 999999) AS recency_days,

        CASE
            WHEN COUNT(Channel) >= 50 THEN 'High'
            WHEN COUNT(Channel) BETWEEN 20 AND 49 THEN 'Medium'
            WHEN COUNT(Channel) BETWEEN 1 AND 19 THEN 'Low'
            ELSE 'No Activity'
        END AS activity_level
    FROM base
    GROUP BY UserID
),

favorite_channel AS (

    -- Get most watched channel per user
    SELECT
        UserID,
        COALESCE(Channel, 'No Favorite') AS favorite_channel
    FROM (
        SELECT
            UserID,
            Channel,
            COUNT(*) AS total_channel_views,
            ROW_NUMBER() OVER (
                PARTITION BY UserID
                ORDER BY COUNT(*) DESC, Channel
            ) AS rn
        FROM base
        WHERE Channel IS NOT NULL
        GROUP BY UserID, Channel
    ) x
    WHERE rn = 1
),

preferred_time AS (

    -- Get preferred time period per user
    SELECT
        UserID,
        IFNULL(time_period, 'No Preference') AS preferred_time
    FROM (
        SELECT
            UserID,
            time_period,
            COUNT(*) AS total_time_views,
            ROW_NUMBER() OVER (
                PARTITION BY UserID
                ORDER BY COUNT(*) DESC, time_period
            ) AS rn
        FROM base
        GROUP BY UserID, time_period
    ) x
    WHERE rn = 1
),

preferred_day AS (

    -- Get preferred day per user
    SELECT
        UserID,
        COALESCE(day_name, 'No Preference') AS preferred_day
    FROM (
        SELECT
            UserID,
            day_name,
            COUNT(*) AS total_day_views,
            ROW_NUMBER() OVER (
                PARTITION BY UserID
                ORDER BY COUNT(*) DESC, day_name
            ) AS rn
        FROM base
        GROUP BY UserID, day_name
    ) x
    WHERE rn = 1
)

-- Final result
SELECT
    b.UserID,
    b.Name,
    b.Gender,
    b.Race,
    b.Age,
    b.age_group,
    b.Province,
    b.Channel,
    b.RecordDate2,
    b.record_timestamp_sa,
    b.record_date,
    b.day_name,
    b.week_type,
    b.time_period,
    b.Duration,
    ROUND(b.duration_minutes, 2) AS duration_minutes,

    COALESCE(l.daily_sessions, 0) AS daily_sessions,
    ROUND(IFNULL(l.avg_daily_sessions, 0.0), 2) AS avg_daily_sessions,
    COALESCE(l.low_consumption_day, 'Unknown') AS low_consumption_day,

    COALESCE(u.total_views, 0) AS total_views,
    u.last_watch_date,
    COALESCE(u.recency_days, 999999) AS recency_days,
    COALESCE(u.activity_level, 'No Activity') AS activity_level,

    COALESCE(f.favorite_channel, 'No Favorite') AS favorite_channel,
    COALESCE(pt.preferred_time, 'No Preference') AS preferred_time,
    COALESCE(pd.preferred_day, 'No Preference') AS preferred_day

FROM base b
LEFT JOIN low_consumption l
    ON b.record_date = l.record_date
LEFT JOIN user_summary u
    ON b.UserID = u.UserID
LEFT JOIN favorite_channel f
    ON b.UserID = f.UserID
LEFT JOIN preferred_time pt
    ON b.UserID = pt.UserID
LEFT JOIN preferred_day pd
    ON b.UserID = pd.UserID

ORDER BY b.record_timestamp_sa;
