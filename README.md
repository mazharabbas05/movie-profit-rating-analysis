# Movie Profit vs Rating Analysis (SQL Practice)

Practice project on the `movies` and `financials` datasets — exploring the relationship between a movie's **profit margin** and its **IMDB rating**.

## 📌 Problem Statements

1. **High Profit Movies**
   Find all movies where profit percentage `((revenue - budget) * 100 / budget)` is **≥ 500%**.

2. **High Profit but Below-Average Rating**
   Find movies that made **500%+ profit** but had an **IMDB rating below the average rating of all movies** — i.e., did the movie make money despite not being well-received?

3. **Below-Average Rated Movies (Supporting Query)**
   List all movies with an IMDB rating **below the average rating** of all movies — used as an intermediate/reference query.

## 🛠️ Approach

- Used a derived column `pct_profit` to calculate profit percentage from `financials`.
- Used a **correlated subquery** (`SELECT AVG(imdb_rating) FROM movies`) to compare each movie's rating against the overall average.
- Joined `financials` and `movies` on `movie_id` to combine profit and rating data.
- Combined both conditions (`pct_profit >= 500` **and** `imdb_rating < avg_rating`) using a `JOIN` + `WHERE` to get the final answer.

## 📂 Queries

### 1. Movies with 500%+ profit
```sql
select *, (revenue - budget) * 100 / budget as pct_profit
from financials
where (revenue - budget) * 100 / budget >= 500;
```

### 2. Movies with 500%+ profit AND below-average rating
```sql
select
  x.movie_id, x.pct_profit,
  y.title, y.imdb_rating
from (
    select *, (revenue - budget) * 100 / budget as pct_profit
    from financials
) x
join (
    select * from movies
    where imdb_rating < (select avg(imdb_rating) from movies)
) y
using (movie_id)
where pct_profit >= 500;
```

### 3. Movies with below-average rating (supporting query)
```sql
select * from movies
where imdb_rating < (select avg(imdb_rating) from movies);
```

## 💡 Key Insight

This project highlights movies that were **commercially successful (500%+ profit) despite being rated below average** — useful for spotting cases where marketing/budget efficiency outperformed audience reception.

## 🧰 Tech Used

- SQL (subqueries, correlated subqueries, joins, derived columns)

---

*Part of my SQL practice series — feedback welcome!*
