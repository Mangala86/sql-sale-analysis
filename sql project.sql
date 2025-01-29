SELECT * FROM pizzahub.pizzas;
-- Q1. retrive the number of order placed.
select count(order_id)as total_orders from orders; -- 21350


-- Q2.Revaenue genrates from pizza sales.
SELECT 
    ROUND(SUM(orders_detail.quantity * pizzas.price),
            2) AS total_sales
FROM
    orders_detail
        JOIN
    pizzas ON pizzas.pizza_id = orders_detail.pizza_id; -- 769729.5
    
    -- Q3.Identify  the highest-priced pizza.
    
    select pizza_types.name,pizzas.price
    from pizza_types join pizzas 
    on pizza_types.pizza_type_id = pizzas .pizza_type_id 
    order by pizzas.price desc 
    limit 1; -- The Greek Pizza	35.95
    
    use pizzahub;
    -- Q4. identify the most common pizza size ordered.
    
 select  pizzas.size, count(orders_detail.order_details_id) as order_count
 from pizzas join orders_detail
 on pizzas.pizza_id = orders_detail.pizza_id
 group by pizzas .size order by order_count desc;
 -- L	17433
-- M	14490
-- S	13294
-- XL	514
-- XXL	27


-- Q5. list top 5 pizza ordered
-- Along with their quantity.
	
  SELECT pizza_types.name,sum( orders_detail.quantity) as quantity
FROM pizza_types
JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN orders_detail
ON orders_detail.pizza_id = pizzas.pizza_id
group by pizza_types .name order by quantity desc limit 5;
-- The Classic Deluxe Pizza	2302
-- The Barbecue Chicken Pizza	2295
-- The Pepperoni Pizza	2283
-- The Hawaiian Pizza	2270
-- The Thai Chicken Pizza	2216

use pizzahub;

-- Q6. join the nessasary table to find the 
-- total quantity of each pizza category ordered.
select pizza_types.category,
sum(orders_detail.quantity)as quantity
from pizza_types 
join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join orders_detail
on orders_detail.pizza_id = pizzas.pizza_id
group by pizza_types.category order by quantity desc;
-- Classic	13999
-- Supreme	11300
-- Veggie	10969
-- Chicken	10386


-- Q7 Determine the distribution of orders by per hour  of the day.
select hour(order_time) as hour ,count(order_id) as order_count
from orders
 group by hour (order_time)
 limit 10;
-- 11	1231
-- 12	2520
-- 13	2455
-- 14	1472
-- 15	1468
-- 16	1920
-- 17	2336
-- 18	2399
-- 19	2009
-- 20	1642



-- Q8.Determine the distribution of  orderby hours of the day.
Select hour (order_time),count(order_id)from orders 
group by hour (order_time);
-- 11	1231
-- 12	2520
-- 13	2455
-- 14	1472
-- 15	1468
-- 16	1920
-- 17	2336
-- 18	2399
-- 19	2009
-- 20	1642
-- 21	1198
-- 22	663
-- 23	28
-- 10	8
-- 9	1 

-- Q9. join relavent tables to find the 
-- category-wise distrubtion of pizzas.

select category, count(name)from pizza_types
group by category ;

-- Chicken	6
-- Classic	8
-- Supreme	9
-- Veggie	9


-- Q10. Determine the distribution of orders of the hour of the day.
select hour (order_time)as hour ,count(order_id) as order_count from orders
group by  	hour (order_time);
11	1231
12	2520
13	2455
14	1472
15	1468
16	1920
17	2336
18	2399
19	2009
20	1642
21	1198
22	663
23	28
10	8
9	1


-- Q11. join the relevent tables to find the 
-- category-wise  distribution of pizzas.
select category, count(name) from pizza_types
group by category;
Chicken	6
Classic	8
Supreme	9
Veggie	9

--Q12. groups the order by date calculate the average 
-- number of pizzas orderd by per day.

SELECT ROUND(AVG(quantity), 0) AS avg_quantity
FROM (
    SELECT orders.order_date, 
           SUM(orders_detail.quantity) AS quantity
    FROM orders
    JOIN orders_detail
    ON orders.order_id = orders_detail.oreder_id
    GROUP BY orders.order_date
) AS order_quantity;

139


-- Q 13. Determine the top 3 most ordred pizza type based on revenue.
  

SELECT pizza_types.name AS pizza_name,
       SUM(orders_detail.quantity * pizzas.price) AS revenue
FROM pizza_types
JOIN pizzas
ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN orders_detail
ON orders_detail.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;

 The Thai Chicken Pizza	40526
The Barbecue Chicken Pizza	40329.25
The California Chicken Pizza	38730

-- Q14. Calculate the pertange contribution of each pizza type to total revenue.
    SELECT order_date,
       SUM(revenue) OVER (ORDER BY order_date) AS cum_revenue
FROM (
    SELECT orders.order_date,
           SUM(orders_detail.quantity * pizzas.price) AS revenue
    FROM orders_detail
    JOIN pizzas
    ON orders_detail.pizza_id = pizzas.pizza_id
    JOIN orders
    ON orders.order_id = orders_detail.oreder_id
    GROUP BY orders.order_date
) AS sales limit 10;
2015-01-01	2713.8500000000004
2015-01-02	5445.75
2015-01-03	8108.15
2015-01-04	9863.6
2015-01-05	11929.55
2015-01-06	14358.5
2015-01-07	16560.7
2015-01-08	19399.05
2015-01-09	21526.4
2015-01-10	23990.350000000002


-- Q15.Determine the top 3 most ordered pizza types
-- based on revenue for each pizza category.
SELECT name, revenue 
FROM (
    SELECT category, 
           name, 
           revenue, 
           RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rn
    FROM (
        SELECT pizza_types.category, 
               pizza_types.name, 
               SUM(orders_detail.quantity * pizzas.price) AS revenue
        FROM pizza_types
        JOIN pizzas
        ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN orders_detail
        ON orders_detail.pizza_id = pizzas.pizza_id
        GROUP BY pizza_types.category, pizza_types.name
    ) AS a
) AS b
WHERE rn <= 3;

Chicken	The Thai Chicken Pizza	40526
Chicken	The Barbecue Chicken Pizza	40329.25
Chicken	The California Chicken Pizza	38730
Classic	The Classic Deluxe Pizza	35804.5
Supreme	The Spicy Italian Pizza	32943.75
Chicken	The Southwest Chicken Pizza	32755
Supreme	The Italian Supreme Pizza	31625.75
Veggie	The Four Cheese Pizza	30396.800000000592
Classic	The Hawaiian Pizza	30246.75
Supreme	The Sicilian Pizza	29047.75
Classic	The Pepperoni Pizza	28488
Classic	The Greek Pizza	26841.650000000012
Veggie	The Mexicana Pizza	25426.25
Veggie	The Five Cheese Pizza	24882.5
Supreme	The Pepper Salami Pizza	23915.75
Classic	The Italian Capocollo Pizza	23468.5
Classic	The Napolitana Pizza	22855.5
Supreme	The Prosciutto and Arugula Pizza	22821.75
Veggie	The Vegetables + Vegetables Pizza	22647.25
Veggie	The Spinach and Feta Pizza	21953
Classic	The Big Meat Pizza	21516
Classic	The Pepperoni, Mushroom, and Peppers Pizza	17781
Chicken	The Chicken Alfredo Pizza	15983.75
Chicken	The Chicken Pesto Pizza	15721.5
Supreme	The Soppressata Pizza	15542
Supreme	The Calabrese Pizza	14993
Veggie	The Italian Vegetables Pizza	14938.5
Veggie	The Spinach Pesto Pizza	14688
Supreme	The Spinach Supreme Pizza	14432.75
Veggie	The Mediterranean Pizza	14303
Veggie	The Green Garden Pizza	13198
Supreme	The Brie Carre Pizza	10926.29999999991

 WITH ranked_pizzas AS (
    SELECT pizza_types.category AS pizza_category,
           pizza_types.name AS pizza_name,
           SUM(orders_detail.quantity * pizzas.price) AS revenue,
           ROW_NUMBER() OVER (PARTITION BY pizza_types.category ORDER BY SUM(orders_detail.quantity * pizzas.price) DESC) AS rn
    FROM pizza_types
    JOIN pizzas
    ON pizza_types.pizza_type_id = pizzas.pizza_type_id
    JOIN orders_detail
    ON orders_detail.pizza_id = pizzas.pizza_id
    GROUP BY pizza_types.category, pizza_types.name
)
SELECT pizza_category, pizza_name, revenue
FROM ranked_pizzas
WHERE rn <= 3;




-- Q 16 Analyse the cumulative revenue genrated over time.

SELECT 
    sales.order_date,
    SUM(sales.revenue) OVER (ORDER BY sales.order_date) AS cum_revenue
FROM (
    SELECT 
        orders.order_date,
        SUM(orders_detail.quantity * pizzas.price) AS revenue
    FROM 
        orders_detail
    JOIN pizzas
        ON orders_detail.pizza_id = pizzas.pizza_id
    JOIN orders
        ON orders.order_id = orders_detail.oreder_id
    GROUP BY 
        orders.order_date
) AS sales;
