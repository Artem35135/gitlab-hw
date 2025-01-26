# Домашнее задание к занятию  «SQL. Часть 2» - "Засим Артем"


---

### Задание 1

Одним запросом получите информацию о магазине, в котором обслуживается более 300 покупателей, и выведите в результат следующую информацию:

фамилия и имя сотрудника из этого магазина;
город нахождения магазина;
количество пользователей, закреплённых в этом магазине.

SELECT COUNT(*) AS Count, s2.first_name, c2.city 
FROM sakila.customer c
JOIN sakila.store s ON c.store_id = s.store_id
JOIN sakila.staff s2 ON s.manager_staff_id = s2.staff_id 
JOIN sakila.address a ON s.address_id = a.address_id
JOIN sakila.city c2 ON a.city_id = c2.city_id
GROUP BY c.store_id
HAVING COUNT(*) > 300;

---

### Задание 2

Получите количество фильмов, продолжительность которых больше средней продолжительности всех фильмов.

SELECT COUNT(*) AS Count 
FROM sakila.film f 
WHERE f.length > (SELECT AVG(f2.length) FROM sakila.film f2);


---

### Задание 3

Получите информацию, за какой месяц была получена наибольшая сумма платежей, и добавьте информацию по количеству аренд за этот месяц.

SELECT
    DATE_FORMAT(p.payment_date, '%Y-%m') AS payment_month,
    SUM(p.amount) AS total_amount,
    COUNT(DISTINCT r.rental_id) AS total_rentals
FROM sakila.payment p
LEFT JOIN sakila.rental r
ON p.rental_id = r.rental_id
GROUP BY DATE_FORMAT(p.payment_date, '%Y-%m')
ORDER BY total_amount DESC
LIMIT 1;
