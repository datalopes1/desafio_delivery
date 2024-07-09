WITH tb_orders AS 
(SELECT
    t1.order_id,
    t1.store_id,
    t1.channel_id,
    t1.payment_order_id,
    t1.delivery_order_id
FROM orders AS t1
WHERE t1.order_status = 'FINISHED'),

tb_pay AS
(SELECT 
    t1.*,
    t2.payment_id,
    t2.payment_amount,
    t2.payment_fee,
    ((t2.payment_amount - t2.payment_fee) * 0.15) - 5 AS order_revenue
FROM tb_orders AS t1
LEFT JOIN payments AS t2
ON t1.payment_order_id = t2.payment_order_id
WHERE t2.payment_status = 'PAID'),

tb_deliveries AS 
(SELECT 
    t1.*,
    t2.driver_id,
    t2.delivery_distance_meters,
    t3.driver_modal
FROM tb_pay t1
LEFT JOIN deliveries AS t2
ON t1.delivery_order_id = t2.delivery_order_id
LEFT JOIN drivers AS t3
ON t2.driver_id = t3.driver_id
WHERE t2.delivery_status = 'DELIVERED'),

tb_stores AS
(SELECT 
    t1.*,
    t2.store_segment,
    t3.hub_state
FROM tb_deliveries AS t1
LEFT JOIN stores AS t2
ON t1.store_id = t2.store_id
LEFT JOIN hubs AS t3
ON t2.hub_id = t3.hub_id)

SELECT
    DATE('2024-07-08') AS dt_ref,
    order_id,
    store_id,
    payment_amount,
    payment_fee,
    order_revenue,
    driver_id,
    delivery_distance_meters,
    driver_modal,
    store_segment,
    hub_state
FROM tb_stores
