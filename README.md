# Bright_TV-
Viewership Analysis

Project Overview

This project analyzes user behavior and viewing patterns for BrightTV, with the goal of helping the business grow its subscription base and improve customer engagement.

The analysis focuses on identifying usage trends, consumption drivers, and growth opportunities using data from user profiles and viewing sessions.

Objectives
Understand user activity trends over time

Identify factors influencing content consumption

Detect low engagement periods

Recommend content strategies to increase usage

Provide data-driven initiatives to grow the user base

Dataset Description

The dataset contains:

user_id – Unique user identifier
session_start – Timestamp of each viewing session (UTC)
content_title – Name of content watched
category – Content category (e.g., Movies, Sports, Series)
watch_time_minutes – Duration of viewing
device_type – Device used (Mobile, TV, Desktop)
location – User location

Note: All timestamps were converted from UTC to South African time (SAST) for accurate analysis.

Tools & Technologies
Miro for Project Planning and Workflow mapping
Data Visualization Tools (Excel)
Databricks SQL
Canva for Finala presentation

Key Analysis Performed

1. User & Engagement Trends
Monthly active users
Daily session activity
Average watch time

2. Consumption Patterns
Peak viewing hours
Weekday vs weekend behavior
Identification of low-usage periods

3. Content Performance
Top-performing content
Most popular categories
Engagement by content type

4. User Segmentation
High vs low engagement users
New vs returning users

5. Consumption Drivers
Device usage trends
Geographic patterns

Key Insights
Strong growth in user activity over time

Peak usage occurs during evening hours

Low engagement during weekday daytime

Certain content categories drive significantly higher engagement

Mobile devices dominate consumption

Recommendations

Increase Peak Performance
Promote high-performing content during peak hours

Introduce premium or exclusive content

Boost Low Period Usage
Push notifications during low activity times

Offer short-form or trending content

Personalization & Upselling
Recommend content based on user behavior

Bundle subscriptions or offer targeted promotions

Focus on Top Content
Invest in high-performing categories

Highlight trending shows on the homepage

Future Improvements
Implement machine learning recommendation systems

Build real-time dashboards

Incorporate customer feedback data

Perform churn prediction analysis
How to Run Queries
Upload dataset to Databricks workspace

Create a table:

CREATE TABLE brighttv_data USING DELTA AS SELECT * FROM your_file;
Run analysis queries provided in the project

Author


Refilwe Sebako

Project Value

This project demonstrates how data can be used to:
Improve customer engagement
Drive business growth
Support strategic decision-making
