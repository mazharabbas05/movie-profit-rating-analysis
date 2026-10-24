# Movie Profit vs Rating Analysis (SQL)

SQL practice project on the `movies` and `financials` tables: do movies that make a lot of profit always have good ratings?

## Questions

1. Which movies made a profit of **500% or more**? Profit % = `(revenue - budget) * 100 / budget`.
2. Which of those movies had an IMDB rating **below the average rating** of all movies?
3. Supporting query: list all movies rated below the average rating.

## Approach

- Calculated profit percentage as a derived column from the `financials` table.
- Used a **scalar subquery** (`SELECT AVG(imdb_rating) FROM movies`) to get the overall average rating, and compared every movie against it.
- Joined `financials` and `movies` on `movie_id` to bring profit and rating together.
- Filtered with `pct_profit >= 500` on top of the below-average-rating result.

## Queries

The queries are in [`movie_profit_rating_queries.sql`](movie_profit_rating_queries.sql).

### 1. Movies with 500%+ profit

```sql
SELECT *, (revenue - budget) * 100 / budget AS pct_profit
FROM financials
WHERE (revenue - budget) * 100 / budget >= 500;
```

### 2. Movies with 500%+ profit and a below-average rating

```sql
SELECT x.movie_id, x.pct_profit, y.title, y.imdb_rating
FROM (
    SELECT *, (revenue - budget) * 100 / budget AS pct_profit
    FROM financials
) x
JOIN (
    SELECT * FROM movies
    WHERE imdb_rating < (SELECT AVG(imdb_rating) FROM movies)
) y USING (movie_id)
WHERE pct_profit >= 500;
```

### 3. Movies rated below average

```sql
SELECT * FROM movies
WHERE imdb_rating < (SELECT AVG(imdb_rating) FROM movies);
```

## Takeaway

Query 2 finds movies that earned very high returns even though audiences rated them below average. This is a useful check for cases where marketing or a low budget mattered more than reviews.

## SQL concepts used

Derived columns, subqueries in `WHERE` and `FROM`, scalar subquery, joins with `USING`.
