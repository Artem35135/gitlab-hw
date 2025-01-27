# Домашнее задание к занятию  «Индексы» - "Засим Артем"


---

### Задание 1

Напишите запрос к учебной базе данных, который вернёт процентное отношение 
общего размера всех индексов к общему размеру всех таблиц.

SELECT ROUND(SUM(INDEX_LENGTH) / SUM(DATA_LENGTH + INDEX_LENGTH) * 100, 2) AS index_to_table_ratio_percentage
FROM information_schema.tables
WHERE TABLE_SCHEMA = 'sakila';

---

### Задание 2

Выполните explain analyze следующего запроса:

select distinct 
  concat(c.last_name, ' ', c.first_name), 
  sum(p.amount) over (partition by c.customer_id, f.title)
from payment p, rental r, customer c, inventory i, film f
where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id

перечислите узкие места;
оптимизируйте запрос: внесите корректировки по использованию операторов, при необходимости добавьте индексы.

Узкие места запроса:
- DISTINCT заставляет базу данных выполнять сортировку или хеширование для удаления дубликатов, 
что может быть ресурсоёмким на больших наборах данных.

- Использование SUM() OVER (PARTITION BY ...). Аналитические функции, такие как SUM() OVER, 
могут приводить к дополнительным накладным расходам, особенно в сочетании с большим количеством строк.

- Фильтрация по DATE(p.payment_date). Использование функции DATE() на столбце p.payment_date 
делает невозможным использование индекса по payment_date. Это приводит к полному сканированию таблицы.

- Использование соединения нескольких таблиц (payment, rental, customer, inventory, film).
При большом количестве записей соединение таблиц через INNER JOIN или кортежный синтаксис 
(FROM table1, table2) без соответствующих индексов может быть медленным.

Оптимизированный вариант

SELECT DISTINCT
    CONCAT(c.last_name, ' ', c.first_name) AS customer_name,
    SUM(p.amount) OVER (PARTITION BY c.customer_id, f.title) AS total_payment
FROM sakila.payment p
INNER JOIN sakila.rental r ON p.payment_date = r.rental_date
INNER JOIN sakila.customer c ON r.customer_id = c.customer_id
INNER JOIN sakila.inventory i ON r.inventory_id = i.inventory_id
INNER JOIN sakila.film f ON i.film_id = f.film_id
WHERE p.payment_date >= '2005-07-30 00:00:00' AND p.payment_date < '2005-07-31 00:00:00';

- Снижение использования DISTINCT и избыточных данных позволяет уменьшить накладные расходы.
- Явные INNER JOIN улучшают читаемость и дают оптимизатору больше информации.
- Использование диапазона вместо DATE() позволяет задействовать индексы на payment_date.
