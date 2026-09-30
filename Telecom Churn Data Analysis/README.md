# Telecom Customer Churn Analysis — Power BI Dashboard

Power BI project that shows **who is churning, why, and where to focus retention** for a telecom company (826 customers, 880 subscriptions, 12 related tables).

![Dashboard Demo](images/demo.gif)

---

## 1. Project Workflow

```mermaid
flowchart LR
    A["Excel Dataset<br/>12 tables"] --> B["Power Query<br/>Data Cleaning"]
    B --> C["Data Model<br/>Relationships + Calendar"]
    C --> D["DAX Measures"]
    D --> E["Dashboard<br/>4 Pages"]
    E --> F["Insights &<br/>Recommendations"]
```

---

## 2. Data Model & Relationships

`Subscriptions` is the central fact table. Every other table connects to it either directly or through `Customers`.

### 2.1 Relationship Flow

```mermaid
flowchart LR
    REG["Regions"] -->|region_id| CUS["Customers"]

    CUS -->|customer_id| SUB["Subscriptions<br/>(churn_flag)"]
    PLN["Plans"] -->|plan_id| SUB
    CAL["Calendar"] -->|"date = start_date"| SUB

    SUB -->|subscription_id| PAY["Payments"]
    SUB -->|subscription_id| USG["Usage_Monthly"]
    SUB -->|subscription_id| CAN["Cancellation_Reasons"]

    CUS -->|customer_id| DEV["Devices"]
    CUS -->|customer_id| TKT["Support_Tickets"]
    CUS -->|customer_id| FDB["Feedback"]
    CUS -->|customer_id| RSP["Campaign_Responses"]
    MKT["Marketing_Campaigns"] -->|campaign_id| RSP

    classDef dim fill:#dbeafe,stroke:#2563eb,color:#111
    classDef fact fill:#fde68a,stroke:#d97706,color:#111,stroke-width:3px
    classDef det fill:#dcfce7,stroke:#16a34a,color:#111
    classDef act fill:#fce7f3,stroke:#db2777,color:#111
    class REG,PLN,CAL,CUS dim
    class SUB fact
    class PAY,USG,CAN det
    class DEV,TKT,FDB,RSP,MKT act
```

🟦 Dimension tables · 🟨 Central fact table · 🟩 Subscription details · 🟪 Customer activity

*All relationships are one-to-many (1 → \*), single direction, from the "one" side to the "many" side.*

### 2.2 Entity Relationship Diagram

```mermaid
erDiagram
    Regions ||--o{ Customers : "region_id"
    Customers ||--o{ Subscriptions : "customer_id"
    Customers ||--o{ Devices : "customer_id"
    Customers ||--o{ Support_Tickets : "customer_id"
    Customers ||--o{ Campaign_Responses : "customer_id"
    Customers ||--o{ Feedback : "customer_id"
    Plans ||--o{ Subscriptions : "plan_id"
    Subscriptions ||--o{ Payments : "subscription_id"
    Subscriptions ||--o{ Usage_Monthly : "subscription_id"
    Subscriptions ||--o{ Cancellation_Reasons : "subscription_id"
    Marketing_Campaigns ||--o{ Campaign_Responses : "campaign_id"
    Calendar ||--o{ Subscriptions : "date to start_date"

    Regions {
        int region_id PK
        string region_name
        string regional_manager
    }
    Customers {
        int customer_id PK
        int region_id FK
        string gender
        int age
        string marital_status
        date signup_date
    }
    Plans {
        int plan_id PK
        string plan_name
        int monthly_price
        string contract_type
        string category
    }
    Subscriptions {
        int subscription_id PK
        int customer_id FK
        int plan_id FK
        date start_date
        date end_date
        string status
        int churn_flag
    }
    Payments {
        int payment_id PK
        int subscription_id FK
        float amount_bdt
        string payment_method
        string payment_status
    }
    Usage_Monthly {
        int usage_id PK
        int subscription_id FK
        float data_used_gb
        int call_minutes
        int sms_count
    }
    Cancellation_Reasons {
        int cancellation_id PK
        int subscription_id FK
        string reason
        date cancellation_date
    }
    Devices {
        int device_id PK
        int customer_id FK
        string device_type
        string brand
    }
    Support_Tickets {
        int ticket_id PK
        int customer_id FK
        string issue_type
        string resolution_status
        int satisfaction_score
    }
    Feedback {
        int feedback_id PK
        int customer_id FK
        int rating
    }
    Marketing_Campaigns {
        int campaign_id PK
        string campaign_name
        string channel
        int budget_bdt
    }
    Campaign_Responses {
        int response_id PK
        int customer_id FK
        int campaign_id FK
        string converted
    }
```

### 2.3 Data Flow

```mermaid
flowchart LR
    XL[("Telecom_Churn_Dataset.xlsx")] --> PQ["Power Query<br/>trim, standardise, handle nulls"]
    PQ --> M["Data Model<br/>12 tables + Calendar"]
    M --> DX["DAX Measures"]
    DX --> P1["Overview"]
    DX --> P2["Demographics"]
    DX --> P3["Analytics"]
    DX --> P4["Subscriptions"]
```

---

## 3. Folder Structure

```
Telecom Churn Data Analysis/
│
├── Dataset/
│   └── Telecom_Churn_Dataset.xlsx     # Raw data — 12 sheets (tables)
│
├── Power Bi/
│   └── Telecom Churn.pbix             # Power BI report (model + DAX + 4 pages)
│
├── images/
│   ├── overview.png                   # Page 1 screenshot
│   ├── demographics.png               # Page 2 screenshot
│   ├── analytics.png                  # Page 3 screenshot
│   ├── subscriptions.png              # Page 4 screenshot
│   └── demo.gif                       # Dashboard walkthrough
│
└── README.md                          # Project documentation
```

| Folder | Purpose |
|---|---|
| `Dataset/` | Source data used by the report |
| `Power Bi/` | The Power BI file — open this to explore the dashboard |
| `images/` | Screenshots and demo used in this README |

---

## 4. Dataset

| Table | Rows | Table | Rows |
|---|---|---|---|
| Customers | 826 | Support_Tickets | 720 |
| Subscriptions | 880 | Marketing_Campaigns | 15 |
| Plans | 10 | Campaign_Responses | 750 |
| Regions | 12 | Feedback | 710 |
| Payments | 910 | Cancellation_Reasons | 323 |
| Usage_Monthly | 900 | Devices | 760 |

**Data cleaning (Power Query):** raw text columns had many spelling / casing variants, fixed for `status`, `gender`, `country`, `payment_status`, `payment_method`, `resolution_status` and `converted` (e.g. `Actve → Active`, `M → Male`, `Bngladesh → Bangladesh`, `Y / TRUE → Yes`). Missing cancellation reasons were set to `Unknown`.

---

## 5. Key DAX Measures

| Area | Measure | Formula |
|---|---|---|
| Subscriptions | Churn Rate % | `DIVIDE([Churned Subscriptions], [Total Subscriptions], 0)` |
| Subscriptions | Churned Subscriptions | `CALCULATE([Total Subscriptions], Subscriptions[churn_flag] = 1)` |
| Customers | Churned Customers | `CALCULATE(DISTINCTCOUNT(Subscriptions[customer_id]), Subscriptions[churn_flag] = 1)` |
| Revenue | Total Revenue | `SUM(Payments[amount_bdt])` |
| Revenue | Average Payment | `AVERAGE(Payments[amount_bdt])` |
| Usage | Average Data Usage | `AVERAGE(Usage_Monthly[data_used_gb])` |
| Support | Average Satisfaction Score | `AVERAGE(Support_Tickets[satisfaction_score])` |
| Marketing | Conversion Rate % | `DIVIDE([Converted Responses], [Total Responses], 0)` |

---

## 6. Dashboard Pages

### Overview
KPIs, churn trend, subscription status and top churned regions / plans.
![Overview](images/overview.png)

### Demographics
Churn by gender, age group, region, device, marital status and cancellation reason.
![Demographics](images/demographics.png)

### Analytics
Call minutes, data usage, payment method, support issues and ticket resolution.
![Analytics](images/analytics.png)

### Subscriptions
Subscription vs churn trend, plans, payment status and pricing.
![Subscriptions](images/subscriptions.png)

---

## 7. Key Insights

- **Churn rate is 36.7%** — 323 of 880 subscriptions cancelled (282 of 826 customers).
- **No single cause:** High Price (47), Moved Location (37), Poor Network (36), Bad Customer Service (36), Technical Issues (34).
- **Highest churn rate by plan:** Weekend Special (43%), Business Elite (42%), Night Owl Data (41%).
- **Highest churn rate by region:** Rangpur (43%), West Zone (42%), Khulna (41%).
- **Satisfaction is low** (2.9 / 5) but does not predict churn in this data.
- **Marketing converts ~26%** of responses (197 of 750); Email and SMS perform best.

## 8. Recommendations

- Offer retention discounts to price-sensitive customers.
- Check network and technical complaints in Rangpur, West Zone and Khulna.
- Review the three plans with above-average churn.

## 9. Tools Used

Excel · Power Query · Power BI Desktop · DAX

## 10. How to Use

1. Open `Power Bi/Telecom Churn.pbix` in Power BI Desktop.
2. Use the slicers on each page to filter by region, plan, gender, status or year.
3. Switch pages with the top navigation buttons.