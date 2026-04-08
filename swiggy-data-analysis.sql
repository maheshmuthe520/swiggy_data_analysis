-- =====================================================
-- SWIGGY DATA ANALYSIS PROJECT (COMPLETE)
-- =====================================================

create database if not exists swiggy;
use swiggy;

-- =====================================================
-- 1. VIEW FULL DATASET
-- =====================================================
select * from swiggy_rest;

-- =====================================================
-- 2. WHICH RESTAURANT IN PUNE HAS LEAST VISITS
-- =====================================================
select *
from swiggy_rest
where city = 'Pune'
and rating_count = (
    select min(rating_count)
    from swiggy_rest
    where city = 'Pune'
);

-- =====================================================
-- 3. WHICH RESTAURANT GENERATED MAX REVENUE IN INDIA
-- =====================================================
select *
from swiggy_rest
where (cost * rating_count) = (
    select max(cost * rating_count)
    from swiggy_rest
);

-- =====================================================
-- 4. RESTAURANTS ABOVE AVERAGE RATING
-- =====================================================
select *
from swiggy_rest
where rating > (select avg(rating) from swiggy_rest);

-- =====================================================
-- 5. COUNT RESTAURANTS ABOVE AVERAGE RATING
-- =====================================================
select count(*) as total_above_avg
from swiggy_rest
where rating > (select avg(rating) from swiggy_rest);

-- =====================================================
-- 6. RESTAURANTS BELOW AVERAGE RATING
-- =====================================================
select count(*) as total_below_avg
from swiggy_rest
where rating < (select avg(rating) from swiggy_rest);

-- =====================================================
-- 7. WHICH RESTAURANT GENERATED MAX REVENUE IN DELHI
-- =====================================================
select *
from swiggy_rest
where city = 'Delhi'
and (cost * rating_count) = (
    select max(cost * rating_count)
    from swiggy_rest
    where city = 'Delhi'
);

-- =====================================================
-- 8. RESTAURANT CHAINS WITH MAX BRANCHES
-- =====================================================
select name, count(*) as total_branches
from swiggy_rest
group by name
order by total_branches desc
limit 5;

-- =====================================================
-- 9. CITY WITH MAX NUMBER OF RESTAURANTS
-- =====================================================
select city, count(*) as total_restaurants
from swiggy_rest
group by city
order by total_restaurants desc
limit 5;

-- =====================================================
-- 10. MOST EXPENSIVE CUISINES
-- =====================================================
select cuisine, avg(cost) as avg_price
from swiggy_rest
group by cuisine
order by avg_price desc
limit 10;

-- =====================================================
-- 11. MOST POPULAR CUISINE (BASED ON RATING COUNT)
-- =====================================================
select cuisine, avg(rating_count) as avg_popularity
from swiggy_rest
group by cuisine
order by avg_popularity desc
limit 10;

-- =====================================================
-- 12. CREATE AVG RATING COLUMN USING WINDOW FUNCTION
-- =====================================================
select *,
       round(avg(rating) over(),2) as avg_rating
from swiggy_rest;

-- =====================================================
-- 13. CREATE AVG RATING COUNT COLUMN
-- =====================================================
select *,
       round(avg(rating_count) over(),2) as avg_rating_count
from swiggy_rest;

-- =====================================================
-- 14. CREATE AVG COST COLUMN
-- =====================================================
select *,
       round(avg(cost) over(),2) as avg_cost
from swiggy_rest;

-- =====================================================
-- 15. ADD MIN & MAX VALUES (ADVANCED)
-- =====================================================
select *,
       min(cost) over() as min_cost,
       max(cost) over() as max_cost,
       min(rating) over() as min_rating,
       max(rating) over() as max_rating
from swiggy_rest;

-- =====================================================
-- 16. AVERAGE COST BY CITY
-- =====================================================
select city,
       round(avg(cost),2) as avg_city_cost
from swiggy_rest
group by city
order by avg_city_cost desc;

-- =====================================================
-- 17. AVERAGE COST BY CUISINE
-- =====================================================
select cuisine,
       round(avg(cost),2) as avg_cuisine_cost
from swiggy_rest
group by cuisine
order by avg_cuisine_cost desc;

-- =====================================================
-- 18. RESTAURANTS COST > AVG COST
-- =====================================================
select *
from swiggy_rest
where cost > (select avg(cost) from swiggy_rest);

-- =====================================================
-- 19. CUISINE-WISE ABOVE AVG COST
-- =====================================================
select *
from (
    select *,
           avg(cost) over(partition by cuisine) as avg_cost
    from swiggy_rest
) as t
where cost > avg_cost;

-- =====================================================
-- 20. RANK RESTAURANTS BY COST
-- =====================================================
select *,
       rank() over(order by cost desc) as cost_rank
from swiggy_rest;

-- =====================================================
-- 21. RANK RESTAURANTS BY VISITS
-- =====================================================
select *,
       rank() over(order by rating_count desc) as visit_rank
from swiggy_rest;

-- =====================================================
-- 22. CITY-WISE COST RANK
-- =====================================================
select *,
       rank() over(partition by city order by cost desc) as city_rank
from swiggy_rest;

-- =====================================================
-- 23. DENSE RANK CITY-WISE
-- =====================================================
select *,
       dense_rank() over(partition by city order by cost desc) as dense_rank_no
from swiggy_rest;

-- =====================================================
-- 24. ROW NUMBER CITY-WISE
-- =====================================================
select *,
       row_number() over(partition by city order by cost desc) as row_num
from swiggy_rest;

-- =====================================================
-- 25. TOP 5 RESTAURANTS PER CITY (REVENUE)
-- =====================================================
select *
from (
    select *,
           (cost * rating_count) as revenue,
           row_number() over(partition by city order by (cost * rating_count) desc) as rnk
    from swiggy_rest
) t
where rnk <= 5;

-- =====================================================
-- 26. TOP 5 RESTAURANTS PER CUISINE
-- =====================================================
select *
from (
    select *,
           (cost * rating_count) as revenue,
           row_number() over(partition by cuisine order by (cost * rating_count) desc) as rnk
    from swiggy_rest
) t
where rnk <= 5;

-- =====================================================
-- 27. TOP 5 CUISINES BY REVENUE
-- =====================================================
select cuisine,
       sum(revenue) as total_revenue
from (
    select *,
           (cost * rating_count) as revenue,
           row_number() over(partition by cuisine order by (cost * rating_count) desc) as rnk
    from swiggy_rest
) t
where rnk <= 5
group by cuisine
order by total_revenue desc
limit 5;


