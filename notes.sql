-- conver sql table to json formate
SELECT 
	customer_id,
    JSON_ARRAYAGG(
		JSON_OBJECT(
			'orderId', order_id,
            'orderDate', order_date,
            'status', status,
            'shippingDate', order_date
        )
    ) AS orders
FROM customers
JOIN orders USING (customer_id)
GROUP BY customer_id;

SELECT 
	customer_id,
    GROUP_CONCAT(
		JSON_OBJECT(
			'orderId', order_id
        )
    ) as orders
FROM customers
JOIN orders USING (customer_id)
GROUP BY customer_id;

