--1.How many pizzas were ordered?
SELECT COUNT(pizza_id) AS total_orders
FROM customer_orders;



--2.How many unique customer orders were made?
SELECT COUNT( DISTINCT order_id) AS orders
FROM customer_orders;



--3.How many successful orders were delivered by each runner?
SELECT runner_id,COUNT(order_id) AS successful_order_del
FROM runner_orders AS r
WHERE pickup_time != 'null'
GROUP BY runner_id
ORDER BY runner_id;



--4.How many of each type of pizza was delivered?
SELECT p.pizza_name,COUNT(c.pizza_id) AS total_pizza_del
FROM runner_orders AS r
INNER JOIN customer_orders AS c
ON r.order_id=c.order_id
INNER JOIN pizza_names AS p
ON c.pizza_id=p.pizza_id
WHERE pickup_time <> 'null'
GROUP BY pizza_name;



--5.How many Vegetarian and Meatlovers were ordered by each customer?
SELECT customer_id,p.pizza_name, COUNT(p.pizza_id) AS order_num
FROM customer_orders AS c
INNER JOIN pizza_names AS p
ON c.pizza_id=p.pizza_id
GROUP BY customer_id,p.pizza_name
ORDER BY customer_id;



--6.What was the maximum number of pizzas delivered in a single order?
SELECT order_id,COUNT(pizza_id) AS total_pizza_del
FROM customer_orders 
GROUP BY order_id
ORDER BY total_pizza_del DESC
LIMIT 1;



--7.For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

SELECT COUNT(pizza_id),customer_id,
 CASE WHEN (exclusions <> 'null' AND LENGTH(exclusions)>0 OR
extras <> 'null' AND LENGTH(extras)>0) THEN 1 ELSE 0
END AS changes
FROM customer_orders AS c
INNER JOIN runner_orders AS r
ON c.order_id=r.order_id
WHERE pickup_time <> 'null'
GROUP BY 2,3






--8.How many pizzas were delivered that had both exclusions and extras?
SELECT pizza_id,
order_id,
exclusions,extras
FROM customer_orders
WHERE exclusions <> 'null' AND 
extras<> 'null' AND LENGTH(exclusions)>1
AND LENGTH(extras)>1



--9.What was the total volume of pizzas ordered for each hour of the day?
SELECT EXTRACT(hour FROM order_time) AS time,
COUNT(pizza_id) AS total_pizza_order
FROM customer_orders
GROUP BY EXTRACT(hour FROM order_time)






--10.What was the volume of orders for each day of the week?
SELECT DATE_PART('dow',order_time) AS day,
DAY(order_time) AS day2,
COUNT(pizza_id) AS total_pizza_order
FROM customer_orders
GROUP BY DATE_PART('dow',order_time),
DAY(order_time)



