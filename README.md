# Danny-MA-s-SQL-Challenge

**1.What is the total amount each customer spent at the restaurant?
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

 

--2.How many days has each customer visited the restaurant?
SELECT customer_id,COUNT(DISTINCT order_date) AS total_visited_days
FROM sales
GROUP BY customer_id
ORDER BY customer_id;



--3.What was the first item from the menu purchased by each customer?
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



--4/5.What is the most purchased item on the menu and how many times was it purchased by all customers?
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



--6.Which item was first purchased by the customer after they became a member?
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



--7.Which item was purchased just before the customer became a member?
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



--8.What is the total items & amount spent for each member before they became a member?
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



--9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
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



--10.In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January? 
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
