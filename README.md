
A comprehensive data analytics pipeline for Netflix movie ratings analysis using **dbt (data build tool)** and **modern data stack technologies**. This project transforms raw Netflix dataset into actionable insights with interactive visualizations and quality validation.

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                      Netflix Dataset (Raw)                       │
│              (8,532 movies, 19.7M user ratings)                 │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
        ┌──────────────────────────────────────┐
        │   Data Ingestion Layer                │
        │  (Raw Data Seeds/CSV Import)          │
        └──────────────────┬───────────────────┘
                           │
                           ▼
        ┌──────────────────────────────────────┐
        │    dbt Transformation Layer           │
        │  ├─ Staging Models (Raw → Cleaned)   │
        │  ├─ Intermediate Models (Aggregations)
        │  └─ Mart Models (Business Logic)     │
        └──────────────────┬───────────────────┘
                           │
        ┌──────────────────┴───────────────────┐
        │                                       │
        ▼                                       ▼
   ┌──────────────────┐          ┌──────────────────────┐
   │  Validated Data  │          │  Quality Tests       │
   │  (dbt Models)    │          │  (dbt Tests)         │
   └─────────┬────────┘          └──────────────────────┘
             │
             ▼
   ┌──────────────────────────────────────┐
   │  Analytics & Visualization Layer      │
   │  ├─ KPI Dashboard                    │
   │  ├─ Rating Distribution Charts       │
   │  ├─ Top Movies Rankings              │
   │  └─ Performance Metrics              │
   └──────────────────────────────────────┘
             │
             ▼
   ┌──────────────────────────────────────┐
   │  Interactive HTML Dashboard          │
   │  (Netflix-themed UI)                 │
   └──────────────────────────────────────┘
```

---

## 🛠️ Tech Stack

| Category | Technology | Purpose |
|----------|-----------|---------|
| **Orchestration** | dbt Core 1.3+ | Data transformation & SQL-based modeling |
| **Data Processing** | SQL | Transformation logic and aggregations |
| **Utilities** | dbt_utils 1.3.0 | Helper macros and functions |
| **Visualization** | HTML5 + Chart.js | Interactive dashboards |
| **Frontend** | CSS3, JavaScript | Netflix-themed UI components |
| **Database** | SQL-based (connectable) | Data warehouse/mart storage |
| **Version Control** | Git | Source code management |

### Dependencies
```yaml
dbt-labs/dbt_utils: 1.3.0
```

---

## Pipeline Flow

### Data Processing Flow

```
1. DATA INGESTION
   ├─ Raw Netflix CSV dataset loaded
   ├─ Schema validation
   └─ Initial data quality checks

2. STAGING MODELS (dbt Staging)
   ├─ Remove duplicates
   ├─ Standardize column names
   ├─ Cast data types correctly
   └─ Handle null values

3. INTERMEDIATE MODELS
   ├─ Movie ratings aggregation
   ├─ Rating distribution calculations
   ├─ Ranking computations
   └─ Performance metrics

4. MART MODELS (Business Layer)
   ├─ Top rated movies (min 1K reviews)
   ├─ Most popular movies (by review count)
   ├─ Rating distribution bands
   └─ Overall KPIs

5. VALIDATION TESTS
   ├─ Data uniqueness checks
   ├─ NOT NULL constraints
   ├─ Referential integrity
   └─ Business rule validations

6. VISUALIZATION
   └─ HTML Dashboard with insights
```

### dbt Model Materialization

All models are materialized as **Views** for performance optimization:
```yaml
models:
  netflixdataset:
    +materialized: view
```

---

## DBT Models

### Project Structure
```
netflixdataset/
├── models/                    # SQL transformation models
│   ├── staging/              # Raw data cleaning layer
│   ├── intermediate/         # Aggregation layer
│   └── marts/                # Final business models
├── tests/                    # Data quality & validation tests
├── macros/                   # Reusable dbt macros
├── seeds/                    # Static reference data
├── analyses/                 # Ad-hoc analyses
├── snapshots/                # SCD Type 2 tracking
└── dbt_project.yml          # dbt configuration
```

### Key Models

**1. Movie Ratings Mart**
- Contains: Movie title, average rating, total ratings count
- Used for: Ranking and filtering analysis

**2. Rating Distribution Mart**
- Groups movies into rating bands
- Distribution: 4.5+, 4.0-4.5, 3.5-4.0, 3.0-3.5, Below 3.0

**3. Top Rated Movies View**
- Filters: Minimum 1,000 reviews threshold
- Ranking: By average rating (descending)
- Top performers: Shawshank Redemption (4.54), Godfather (4.46), Lives of Others (4.44)

**4. Most Popular Movies View**
- Ranking: By total review count (descending)
- Top movies: Pulp Fiction (67.3K), Forrest Gump (66.1K), Shawshank Redemption (63.4K)

---

## Validation Logic

### Quality Checks Implemented

| Check Type | Purpose | Method |
|-----------|---------|--------|
| **Uniqueness** | Ensure no duplicate movies | dbt unique test on movie_id |
| **NOT NULL** | Validate required fields | dbt not_null test on critical columns |
| **Range Validation** | Rating scale compliance | Average rating between 0.5-5.0 |
| **Minimum Records** | Data completeness | Threshold checks for review counts |
| **Referential** | Data consistency | Cross-model integrity checks |

### Data Quality Metrics

- **Total Movies**: 8,532 titles
- **Total Ratings**: 19.7M user interactions
- **Average Rating**: 3.45 out of 5.0
- **Rating Range**: 0.5 - 5.0 scale
- **Minimum Reviews (Top Rated)**: 1,000 threshold

### Custom Macros

Located in `netflixdataset/macros/`:
- Reusable validation functions
- Custom SQL transformations
- Data quality assertions

---

## Dashboard Screenshots

### Overview
The Netflix Analytics dashboard provides comprehensive insights into movie ratings and viewer preferences with a Netflix-themed dark UI.

### Key Visualizations

#### 1. **KPI Cards**
```
┌─────────────┬─────────────┬─────────────┬─────────────┐
│   MOVIES    │  RATINGS    │  AVG RATE   │  TOP RATED  │
│   8,532     │   19.7M     │    3.45     │    4.54     │
│  Titles     │ User Inter. │   Out 5.0   │  Shawshank  │
└─────────────┴─────────────┴─────────────┴─────────────┘
```

#### 2. **Rating Distribution (Donut Chart)**
- 4.5+: 1 movie (Exceptional)
- 4.0-4.5: 1,159 movies (Excellent)
- 3.5-4.0: 3,382 movies (Good)
- 3.0-3.5: 2,387 movies (Average)
- Below 3.0: 1,603 movies (Below Average)

#### 3. **Most Rated Movies (Horizontal Bar Chart)**
Top 8 by review count:
1. Pulp Fiction - 67.3K ratings
2. Forrest Gump - 66.1K ratings
3. Shawshank Redemption - 63.4K ratings
4. Silence of the Lambs - 63.3K ratings
5. Jurassic Park - 59.7K ratings
6. Star Wars: Ep. IV - 54.5K ratings
7. Braveheart - 53.8K ratings
8. Terminator 2 - 52.2K ratings

#### 4. **Top 10 Highest Rated Movies (Bar Chart)**
Minimum 1,000 ratings required, sorted by average rating:
1. Shawshank Redemption (1994) - ★ 4.54
2. Godfather, The (1972) - ★ 4.46
3. Lives Of Others (2006) - ★ 4.44
4. Usual Suspects (1995) - ★ 4.44
5. Band Of Brothers (2001) - ★ 4.44
6. City Of God (2002) - ★ 4.43
7. Dark Knight, The (2008) - ★ 4.41
8. Schindler's List (1993) - ★ 4.40
9. Spirited Away (2001) - ★ 4.39
10. Seven Samurai (1954) - ★ 4.38

#### 5. **Data Field Guide**
Interactive guide explaining:
- **MOVIE_TITLE**: Full movie name with release year
- **AVERAGE_RATING**: Mean score from user reviews (0.5-5.0 scale)
- **TOTAL_RATINGS**: Count of individual user ratings
- **What the Data Tells Us**: Quality vs. Reach analysis

#### 6. **Rankings Tables**

** Top Rated** (Highest average ratings, min. 1K reviews)
** Most Popular** (Most reviewed movies of all time)

---

## Getting Started

### Prerequisites
- dbt Core v1.3+
- Python 3.8+
- SQL database connection (Snowflake, BigQuery, PostgreSQL, etc.)
- Git

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/sarath497/netflix-data-analytics-platform.git
cd netflix-data-analytics-platform
```

2. **Install dbt**
```bash
pip install dbt-core
```

3. **Install dependencies**
```bash
dbt deps
```

4. **Configure database connection**
```bash
dbt init netflixdataset
```

5. **Run transformations**
```bash
dbt run
```

6. **Execute tests**
```bash
dbt test
```

7. **Generate documentation**
```bash
dbt docs generate
dbt docs serve
```

### View Dashboard
Open the HTML dashboard: file:///E:/Netflixdataset_DBT%20project/Final%20Data%20analytics%20Dashboard/netflix_analytics_by%20claudeai.html
```
<img width="1360" height="2288" alt="_E__Netflixdataset_DBT%20project_Final%20Data%20analytics%20Dashboard_netflix_analytics_by%20claudeai html (1)" src="https://github.com/user-attachments/assets/6f369f94-8b07-4fdc-8bfb-78f5f438b85d" />


```

---

## Project Structure

```
netflix-data-analytics-platform/
├── README.md                                    # This file
├── dbt_project.yml                             # Root dbt configuration
├── netflixdataset/
│   ├── dbt_project.yml                         # Project configuration
│   ├── packages.yml                            # dbt packages
│   ├── models/
│   │   ├── staging/                            # Staging models (ELT)
│   │   ├── intermediate/                       # Intermediate transforms
│   │   └── marts/                              # Final business models
│   ├── tests/                                  # dbt tests (YAML & SQL)
│   ├── macros/                                 # Reusable SQL macros
│   ├── seeds/                                  # CSV reference data
│   ├── analyses/                               # Ad-hoc SQL analyses
│   └── snapshots/                              # SCD Type 2 snapshots
├── Final Data analytics Dashboard/
│   └── netflix_analytics_by claudeai.html      # Interactive dashboard
└── .gitignore                                  # Git ignore rules
```

---

## Key Insights

### Data Summary
- **Dataset Size**: 8,532 unique movies
- **Total Reviews**: 19.7 million user ratings
- **Rating Distribution**: Skewed towards 3.5-4.0 range (good movies)
- **Quality Threshold**: 40% of movies rated 3.5 or above

### Top Performers
- **Highest Rated**: Shawshank Redemption (4.54/5.0)
- **Most Popular**: Pulp Fiction (67.3K ratings)
- **Best Quality-Popularity Balance**: Pulp Fiction (4.19 rating, 67.3K reviews)

### Audience Preferences
- Movies trending in 3.5-4.0 range indicate high-quality Netflix catalog
- "Lives of Others", "Usual Suspects", and "Band of Brothers" show quality over quantity
- Classic films maintain consistent high ratings despite release year

---

## Data Quality Standards

✅ **No NULL values** in critical fields
✅ **Duplicate detection** on movie identifiers
✅ **Rating scale validation** (0.5-5.0)
✅ **Minimum review threshold** enforced (1K for top rankings)
✅ **Referential integrity** checks across models
✅ **Automated tests** run with every dbt run

---

## Usage Examples

### Generate dbt documentation
```bash
dbt docs generate
dbt docs serve
```

### Run specific model
```bash
dbt run --select model_name
```

### Run only tests
```bash
dbt test
```

### Generate lineage diagram
```bash
dbt docs generate
# Open http://localhost:8000 and navigate to Lineage
```

---

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.


---

## Acknowledgments

- Netflix Dataset for comprehensive movie ratings
- dbt Labs for the amazing data transformation framework
- Chart.js for interactive visualizations

---

**Last Updated**: March 2026  
**Version**: 1.0.0  
**Status**: Active Development
