BrightTV Viewership Analysis

Project Overview

This project analyzes user behavior and viewing patterns for BrightTV, with the goal of:

Growing the subscription base
Improving customer engagement

The analysis focuses on:

Usage trends
Consumption drivers
Growth opportunities

using data from user profiles and viewing sessions.

Objectives
Understand user activity trends over time
Identify factors influencing content consumption
Detect low engagement periods
Recommend strategies to increase usage
Provide data-driven initiatives to grow the user base

Dataset Description
Column	Description
user_id	Unique user identifier
session_start	Viewing session timestamp (UTC)
content_title	Content watched
category	Content type (Movies, Sports, Series)
watch_time_minutes	Viewing duration
device_type	Device used
location	User location

All timestamps were converted from UTC → South African Time (SAST)

Tools & Technologies
Databricks SQL – Data transformation
Excel – Pivot tables & charts
Miro – Workflow design
Canva – Presentation
Lovable-Dashboard

Workflow

![Workflow](2.%20Project%20Planning/Miro%20Flow-Chart.png)
![Gantt](2.%20Project%20Planning/Gantt%20Chart.png)

Dashboard

![Dashboard](4.Project%20Presentation/Dashboard%20Screenshot.png)

Live Dashboard

[View BrightTV Dashboard](https://brightbeam-analytics.lovable.app)

Key Analysis
1. User & Engagement Trends
Monthly active users
Daily session activity
Average watch time
2. Consumption Patterns
Peak viewing hours
Weekday vs weekend behavior
Low consumption periods
3. Content Performance
Top-performing content
Most popular categories
Channel engagement
4. User Segmentation
High vs low engagement users
Age group analysis
Location insights
5. Consumption Drivers
Device usage trends
Geographic patterns
Time-based behavior

 Key Insights
 Strong growth in user activity
 Peak viewing occurs in the evening
 Low engagement during weekday daytime
 Certain content drives higher engagement
 Mobile dominates user consumption
 
 Recommendations
 Improve Peak Performance
Promote top-performing content
Introduce exclusive content

 Increase Low Usage Periods
Send notifications during low activity times
Promote short-form content

 Personalization
Recommend content based on behavior
Use targeted promotions

 Content Strategy
Invest in high-performing categories
Highlight trending content

 Future Improvements
Machine learning recommendations
Real-time dashboards
Customer feedback integration
Churn prediction

 How to Run Queries
CREATE TABLE brighttv_data 
USING DELTA 
AS SELECT * FROM your_file;

Run the SQL queries in Databricks.

 Project Structure
BrightTV-Analysis/
│── Project Description & Raw Data
│── Project Planning
│   └── Miro Flowchart
│   └── Ghantt Chart
│── Data Processing    
│   └── SQL/
    └── Excel/Pivot/Graphs
│── Presentation/
│   └── Slides.pdf
│── Dashboard/
│   └── Screenshots.png
│   └── Link
│   README.md

 Author

Refilwe Sebako
Data Analyst/Virtual Assistant

Project Value

This project demonstrates how data can be used to:

Improve customer engagement
Drive business growth
Support strategic decision-making

Portfolio Highlight

This project showcases:

SQL data transformation
Data analysis & segmentation
Dashboard creation
Business-driven insights
