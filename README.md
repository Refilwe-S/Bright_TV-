# BrightTV Viewership Analysis

## Project Overview

This project analyzes **user behavior and viewing patterns** for BrightTV, with the goal of:

* Growing the subscription base
* Improving customer engagement

The analysis focuses on:

* Usage trends
* Consumption drivers
* Growth opportunities

Using data from **user profiles and viewing sessions**.

---

## Objectives

* Understand user activity trends over time
* Identify factors influencing content consumption
* Detect low engagement periods
* Recommend strategies to increase usage
* Provide data-driven initiatives to grow the user base

---

## Dataset Description

| Column             | Description                           |
| ------------------ | ------------------------------------- |
| user_id            | Unique user identifier                |
| session_start      | Viewing session timestamp (UTC)       |
| content_title      | Content watched                       |
| category           | Content type (Movies, Sports, Series) |
| watch_time_minutes | Viewing duration                      |
| device_type        | Device used                           |
| location           | User location                         |

**Note:** All timestamps were converted from **UTC to SAST**

---

## Tools & Technologies

* Databricks SQL – Data transformation
* Excel – Pivot tables & charts
* Miro – Workflow design
* Canva – Presentation
* Lovable – Dashboard

---

## Workflow

Data Collection → Data Cleaning → Transformation → Analysis → Dashboard → Insights → Recommendations

---

## Project Planning

### Miro Flowchart

[View Flowchart](./2.%20Project%20Planning/Miro%20Flow-Chart.png)

### Gantt Chart

[View Gantt Chart](./2.%20Project%20Planning/Gantt%20Chart.png)

---

## Dashboard

### Dashboard Screenshot

[View Screenshot](./4.Project%20Presentation/Dashboard%20Screenshot.png)

![Dashboard](./4.Project%20Presentation/Dashboard%20Screenshot.png)

### Live Dashboard

https://brightbeam-analytics.lovable.app

---

## Key Analysis

### User & Engagement Trends

* Monthly active users
* Daily session activity
* Average watch time

### Consumption Patterns

* Peak viewing hours
* Weekday vs weekend behavior
* Low consumption periods

### Content Performance

* Top-performing content
* Most popular categories
* Channel engagement

### User Segmentation

* High vs low engagement users
* Age group analysis
* Location insights

### Consumption Drivers

* Device usage trends
* Geographic patterns
* Time-based behavior

---

## Key Insights

* Strong growth in user activity
* Peak viewing occurs in the evening
* Low engagement during weekday daytime
* Certain content drives higher engagement
* Mobile dominates user consumption

---

## Recommendations

### Improve Peak Performance

* Promote top-performing content
* Introduce exclusive content

### Increase Low Usage Periods

* Send notifications during low activity times
* Promote short-form content

### Personalization

* Recommend content based on behavior
* Use targeted promotions

### Content Strategy

* Invest in high-performing categories
* Highlight trending content

---

## Future Improvements

* Machine learning recommendations
* Real-time dashboards
* Customer feedback integration
* Churn prediction

---

## How to Run Queries

```sql
CREATE TABLE brighttv_data 
USING DELTA 
AS SELECT * FROM your_file;
```

Run your SQL queries in Databricks.

---

## Project Structure

```text
BrightTV-Analysis
│
├── 1. Project Description & Raw Data
├── 2. Project Planning
│   ├── Miro Flow-Chart.png
│   └── Gantt Chart.png
├── 3. Data Processing    
│   ├── SQL Queries.sql
│   └── Excel Analysis.xlsx
├── 4. Project Presentation
│   ├── Dashboard Screenshot.png
│   └── Dashboard Link.txt
│
└── README.md
```

---

## Author

**Refilwe Sebako**
Data Analyst | Virtual Assistant

LinkedIn: https://www.linkedin.com/in/resebako

---

## Project Value

This project demonstrates how data can be used to:

* Improve customer engagement
* Drive business growth
* Support strategic decision-making

---

## Portfolio Highlight

This project showcases:

* SQL data transformation
* Data analysis & segmentation
* Dashboard creation
* Business-driven insights
