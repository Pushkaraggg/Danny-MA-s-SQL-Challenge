# Danny-MA-s-SQL-Challenge

### WEEK 1 CHALLENGE

**1.What is the total amount each customer spent at the restaurant?**
```sql
CREATE VIEW details AS (SELECT m.product_id,customer_id AS total_cust,m.price,m.product_name
 FROM sales AS s
 INNER JOIN menu AS m
 ON s.product_id= m.product_id
 ORDER BY product_id)
 
 SELECT total_cust,
 SUM(price) 
 FROM details
 GROUP BY total_cust
 ORDER BY total_cust;
 ```

 

**2.How many days has each customer visited the restaurant?**
```sql
SELECT customer_id,COUNT(DISTINCT order_date) AS total_visited_days
FROM sales
GROUP BY customer_id
ORDER BY customer_id;
```



**3.What was the first item from the menu purchased by each customer?**
```sql
 WITH my_cte AS (SELECT customer_id,
 order_date,
 product_name,
 RANK() OVER(PARTITION BY customer_id ORDER by order_date) AS rank
FROM sales AS s
INNER JOIN menu AS m
ON s.product_id=m.product_id
ORDER by customer_id)

SELECT customer_id,product_name
FROM my_cte
WHERE rank='1';
```



**4/5.What is the most purchased item on the menu and how many times was it purchased by all customers?**
```sql
WITH my_cte AS (SELECT s.customer_id,COUNT(m.product_id) AS count,m.product_name
FROM sales AS s
INNER JOIN menu AS m
ON s.product_id= m.product_id
GROUP BY s.customer_id,m.product_name
ORDER BY customer_id),

my_ct AS (SELECT customer_id, count,product_name,
RANK() OVER(PARTITION BY customer_id ORDER BY count DESC)
FROM my_cte)

SELECT customer_id,product_name,count,rank
FROM my_ct 
WHERE rank='1';
```



**6.Which item was first purchased by the customer after they became a member?**
```sql
WITH my_cte AS (SELECT m.product_id,s.customer_id,mb.join_date,s.order_date,m.product_name,
RANK() OVER(PARTITION BY s.customer_id ORDER BY order_date) AS rank
FROM sales AS s
INNER JOIN menu AS m
ON s.product_id=m.product_id
INNER JOIN members AS mb
ON s.customer_id=mb.customer_id
WHERE order_date>=join_date)

SELECT product_id,product_name,customer_id,order_date
FROM my_cte
WHERE rank='1';
```



**7.Which item was purchased just before the customer became a member?**
```sql
WITH my_cte AS(SELECT m.product_id,
s.customer_id,
s.order_date,
m.product_name,
mb.join_date,
RANK() OVER(PARTITION BY mb.customer_id ORDER BY s.order_date DESC) AS Rnk
FROM Sales AS s
INNER JOIN menu AS m
ON s.product_id= m.product_id
INNER JOIN members AS mb
ON s.customer_id= mb.customer_id 
WHERE order_date< join_date)

SELECT customer_id,product_name,order_date,join_date
FROM my_cte
WHERE Rnk='1';
```



**8.What is the total items & amount spent for each member before they became a member?**
```sql
WITH my_cte AS(SELECT m.product_id,
s.customer_id,
s.order_date,
m.product_name,
mb.join_date,
m.price,
RANK() OVER(PARTITION BY mb.customer_id ORDER BY s.order_date DESC) AS Rnk
FROM Sales AS s
INNER JOIN menu AS m
ON s.product_id= m.product_id
INNER JOIN members AS mb
ON s.customer_id= mb.customer_id 
WHERE order_date< join_date)

SELECT customer_id,SUM(price) AS amount_spent,COUNT(product_name) AS total_items
FROM my_cte
GROUP BY customer_id
ORDER BY customer_id;
```



**9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?**
```sql
WITH my_cte AS(SELECT m.product_id,
s.customer_id,
m.product_name,
m.price
FROM Sales AS s
INNER JOIN menu AS m
ON s.product_id= m.product_id),

my_cte1 AS (SELECT customer_id,product_name,price,
CASE WHEN product_name='sushi' THEN price * 10 * 2
ELSE price * 10
END AS points
FROM my_cte)

SELECT customer_id,SUM(points) AS total_points
FROM my_cte1
GROUP BY customer_id
ORDER BY customer_id;
```



**10.In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?**
```sql
CREATE VIEW points AS(SELECT s.customer_id,
m.product_name,
mb.join_date,
m.price,
CASE WHEN product_name IN ('sushi','curry') THEN price * 10 * 2
END AS points
FROM Sales AS s
INNER JOIN menu AS m
ON s.product_id= m.product_id
INNER JOIN members AS mb
ON s.customer_id= mb.customer_id 
WHERE order_date< join_date),

CREATE VIEW points1 AS (SELECT customer_id,product_name,price,
CASE WHEN product_name='sushi' THEN price * 10 * 2
ELSE price * 10
END AS points
FROM points)
```

### WEEK 2 CHALLENGE

**1.How many pizzas were ordered?**
```sql
SELECT COUNT(pizza_id) AS total_orders
FROM customer_orders;
```


**2.How many unique customer orders were made?**
```sql
SELECT COUNT( DISTINCT order_id) AS orders
FROM customer_orders;
```



**3.How many successful orders were delivered by each runner?**
```sql
SELECT runner_id,COUNT(order_id) AS successful_order_del
FROM runner_orders AS r
WHERE pickup_time != 'null'
GROUP BY runner_id
ORDER BY runner_id;
```



**4.How many of each type of pizza was delivered?**
```sql
SELECT p.pizza_name,COUNT(c.pizza_id) AS total_pizza_del
FROM runner_orders AS r
INNER JOIN customer_orders AS c
ON r.order_id=c.order_id
INNER JOIN pizza_names AS p
ON c.pizza_id=p.pizza_id
WHERE pickup_time <> 'null'
GROUP BY pizza_name;
```



**5.How many Vegetarian and Meatlovers were ordered by each customer?**
```sql
SELECT customer_id,p.pizza_name, COUNT(p.pizza_id) AS order_num
FROM customer_orders AS c
INNER JOIN pizza_names AS p
ON c.pizza_id=p.pizza_id
GROUP BY customer_id,p.pizza_name
ORDER BY customer_id;
```



**6.What was the maximum number of pizzas delivered in a single order?**
```sql
SELECT order_id,COUNT(pizza_id) AS total_pizza_del
FROM customer_orders 
GROUP BY order_id
ORDER BY total_pizza_del DESC
LIMIT 1;
```



**7.For each customer, how many delivered pizzas had at least 1 change and how many had no changes?**
```sql
SELECT COUNT(pizza_id),customer_id,
 CASE WHEN (exclusions <> 'null' AND LENGTH(exclusions)>0 OR
extras <> 'null' AND LENGTH(extras)>0) THEN 1 ELSE 0
END AS changes
FROM customer_orders AS c
INNER JOIN runner_orders AS r
ON c.order_id=r.order_id
WHERE pickup_time <> 'null'
GROUP BY 2,3
```






**8.How many pizzas were delivered that had both exclusions and extras?**
```sql
SELECT pizza_id,
order_id,
exclusions,extras
FROM customer_orders
WHERE exclusions <> 'null' AND 
extras<> 'null' AND LENGTH(exclusions)>1
AND LENGTH(extras)>1
```



**9.What was the total volume of pizzas ordered for each hour of the day?**
```sql
SELECT EXTRACT(hour FROM order_time) AS time,
COUNT(pizza_id) AS total_pizza_order
FROM customer_orders
GROUP BY EXTRACT(hour FROM order_time)
```






**10.What was the volume of orders for each day of the week?**
```sql
SELECT DATE_PART('dow',order_time) AS day,
DAY(order_time) AS day2,
COUNT(pizza_id) AS total_pizza_order
FROM customer_orders
GROUP BY DATE_PART('dow',order_time),
DAY(order_time)
```
