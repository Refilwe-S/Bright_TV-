-- Select and combine fields from the user table and the viewership table
SELECT
    -- Select the user ID from the user profile table
    u.UserID,

    -- Replace NULL names with 'Unknown User'
    IFNULL(u.Name, 'Unknown User') AS Name,

    -- Replace NULL gender values with 'Unknown'
    IFNULL(u.Gender, 'Unknown') AS Gender,

    -- Clean the Race column
    -- If Race is NULL, blank, or 'None', assign a cleaner value
    CASE
        WHEN u.Race IS NULL THEN 'Unknown'
        WHEN u.Race = '' THEN 'Other'
        WHEN u.Race = 'None' THEN 'Not Specified'
        ELSE u.Race
    END AS Race,

    -- Keep the original age column
    u.Age,

    -- Group users into age categories for easier analysis
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

    -- Clean the Province column
    -- If Province is NULL, blank, or 'None', assign a cleaner value
    CASE
        WHEN u.Province IS NULL THEN 'Unknown'
        WHEN u.Province = '' THEN 'Other'
        WHEN u.Province = 'None' THEN 'Not Specified'
        ELSE u.Province
    END AS Province,

    -- Replace missing channel values with 'No Channel'
    IFNULL(v.Channel2, 'No Channel') AS Channel,

    -- Rename 'Duration 2' to Duration and replace missing values with 00:00:00
    IFNULL(v.`Duration 2`, '00:00:00') AS Duration,

    -- Convert the RecordDate2 string into a timestamp
    -- Then convert it from UTC to South African time
    FROM_UTC_TIMESTAMP(
        TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'),
        'Africa/Johannesburg'
    ) AS LocalDateTime,

    -- Extract the date only from the South African timestamp
    DATE_FORMAT(
        FROM_UTC_TIMESTAMP(
            TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'),
            'Africa/Johannesburg'
        ),
        'yyyy-MM-dd'
    ) AS Date,

    -- Extract the time only from the South African timestamp
    DATE_FORMAT(
        FROM_UTC_TIMESTAMP(
            TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'),
            'Africa/Johannesburg'
        ),
        'HH:mm:ss'
    ) AS Time,

    -- Extract the full day name from the South African timestamp
    DATE_FORMAT(
        FROM_UTC_TIMESTAMP(
            TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'),
            'Africa/Johannesburg'
        ),
        'EEEE'
    ) AS Day_Name,

    -- Extract the year value from the South African timestamp
    YEAR(
        FROM_UTC_TIMESTAMP(
            TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'),
            'Africa/Johannesburg'
        )
    ) AS Year_Value,

    -- Extract the month number from the South African timestamp
    MONTH(
        FROM_UTC_TIMESTAMP(
            TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'),
            'Africa/Johannesburg'
        )
    ) AS Month_Value,

    -- Extract the month name from the South African timestamp
    MONTHNAME(
        FROM_UTC_TIMESTAMP(
            TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'),
            'Africa/Johannesburg'
        )
    ) AS Month_Name,

    -- Group each session into Weekday or Weekend
    CASE
        WHEN DAYOFWEEK(
            FROM_UTC_TIMESTAMP(
                TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'),
                'Africa/Johannesburg'
            )
        ) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS Week_Type,

    -- Group each session into time buckets based on the hour of viewing
    CASE
        WHEN HOUR(
            FROM_UTC_TIMESTAMP(
                TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'),
                'Africa/Johannesburg'
            )
        ) BETWEEN 0 AND 5 THEN '01. EarlyMorning'
        WHEN HOUR(
            FROM_UTC_TIMESTAMP(
                TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'),
                'Africa/Johannesburg'
            )
        ) BETWEEN 6 AND 9 THEN '02. Morning'
        WHEN HOUR(
            FROM_UTC_TIMESTAMP(
                TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'),
                'Africa/Johannesburg'
            )
        ) BETWEEN 10 AND 11 THEN '03. LateMorning'
        WHEN HOUR(
            FROM_UTC_TIMESTAMP(
                TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'),
                'Africa/Johannesburg'
            )
        ) BETWEEN 12 AND 16 THEN '04. Afternoon'
        WHEN HOUR(
            FROM_UTC_TIMESTAMP(
                TO_TIMESTAMP(v.RecordDate2, 'yyyy/MM/dd HH:mm'),
                'Africa/Johannesburg'
            )
        ) BETWEEN 17 AND 19 THEN '05. Evening'
        ELSE '06. Night'
    END AS Time_Bucket,

    -- Convert session duration into minutes
    -- Example: 01:30 becomes 90 minutes
    HOUR(v.`Duration 2`) * 60 + MINUTE(v.`Duration 2`) AS Session_Duration_Minutes,

    -- Group session duration into buckets
    CASE
        WHEN HOUR(v.`Duration 2`) * 60 + MINUTE(v.`Duration 2`) <= 10 THEN '0-10 mins'
        WHEN HOUR(v.`Duration 2`) * 60 + MINUTE(v.`Duration 2`) <= 20 THEN '11-20 mins'
        WHEN HOUR(v.`Duration 2`) * 60 + MINUTE(v.`Duration 2`) <= 30 THEN '21-30 mins'
        ELSE '30+ mins'
    END AS Duration_Bucket

-- Use the BrightTV viewers table as the main table
FROM workspace.default.bright_tv_viewers v

-- Join the user table to the viewers table using UserID
-- LEFT JOIN keeps all viewership records and adds matching user details
LEFT JOIN workspace.default.bright_tv_user u
ON v.UserID = u.UserID;
