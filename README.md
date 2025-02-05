# Домашнее задание к занятию  «Репликация и масштабирование. Часть 2» - "Засим Артем"


---

### Задание 1

Опишите основные преимущества использования масштабирования методами:

активный master-сервер и пассивный репликационный slave-сервер;
master-сервер и несколько slave-серверов;
Дайте ответ в свободной форме.


Активный master-сервер и пассивный репликационный slave-сервер
Этот метод предполагает, что master-сервер выполняет все операции записи и чтения, 
а slave-сервер служит резервной копией, которая синхронизируется с основным сервером и может быть активирована в случае сбоя.

Преимущества:

Надежность и отказоустойчивость – в случае сбоя основного сервера можно быстро переключиться на реплику.
Простота настройки и администрирования – репликация обычно не требует сложных изменений в коде приложения.
Минимальная задержка репликации – поскольку slave-сервер не обслуживает пользовательские запросы, репликация выполняется без значительных накладных расходов.
Ограничения:

Slave-сервер не разгружает основной сервер, так как он не обрабатывает запросы чтения.
При сбое master-сервера требуется ручное или автоматическое переключение (failover).


Master-сервер и несколько slave-серверов
Этот метод расширяет концепцию репликации, позволяя нескольким slave-серверам обрабатывать запросы на чтение, 
в то время как master-сервер остается единственным узлом для записи.

Преимущества:

Разгрузка master-сервера – операции чтения можно распределить между несколькими slave-серверами, снижая нагрузку на основной узел.
Горизонтальное масштабирование – можно добавлять новые slave-серверы по мере роста нагрузки.
Более высокая отказоустойчивость – при выходе из строя одного slave-сервера нагрузка перераспределяется на другие реплики.
Ограничения:

Задержка репликации – из-за асинхронной природы репликации некоторые данные на slave-серверах могут быть устаревшими.
Сложность балансировки нагрузки – требуется механизм распределения запросов на чтение между репликами.
Ограничение на запись – все записи все равно проходят через один master-сервер, что может стать узким местом.

---

### Задание 2

Разработайте план для выполнения горизонтального и вертикального шаринга базы данных. База данных состоит из трёх таблиц:
пользователи,
книги,
магазины (столбцы произвольно).
Опишите принципы построения системы и их разграничение или разбивку между базами данных.

Пришлите блоксхему, где и что будет располагаться. Опишите, в каких режимах будут работать сервера.



Мы будем использовать смешанный подход – горизонтальный шардинг для таблицы пользователей и книг, а вертикальный шардинг для разделения различных типов данных между серверами.

Горизонтальный шардинг
Горизонтальный шардинг используется, когда таблицы становятся слишком большими и создают узкое место для производительности.

Таблица "пользователи" будет разделена по user_id, например, пользователи с user_id 1-1000000 на одном сервере, 1000001-2000000 на другом и т. д.
Таблица "книги" будет разделена по book_id, аналогично пользователям.
Этот метод распределяет нагрузку и позволяет масштабировать систему добавлением новых серверов.

Вертикальный шардинг
Вертикальный шардинг применяется для разграничения логически различных частей базы данных.

Таблица "магазины" будет вынесена в отдельную базу, так как она содержит информацию, связанную с инвентарем, а не напрямую с пользователями или книгами.

Разбивка между базами данных
Сервер	Тип шардинга	Таблицы	Ключ шардинга
DB1	Горизонтальный	пользователи_1	user_id (1-1000000)
DB2	Горизонтальный	пользователи_2	user_id (1000001-2000000)
DB3	Горизонтальный	книги_1	book_id (1-500000)
DB4	Горизонтальный	книги_2	book_id (500001-1000000)
DB5	Вертикальный	магазины	-


Режимы работы серверов
Master-Slave репликация – на каждом сервере будет один master для записи и несколько slave-серверов для чтения, что позволит масштабировать нагрузки на SELECT-запросы.
Load Balancer (Балансировщик нагрузки) – распределяет запросы между серверами для равномерного распределения нагрузки.
Кэширующий слой (Redis, Memcached) – ускоряет доступ к часто запрашиваемым данным.

Блок схема

                                +----------------------+
                                |   Балансировщик      |
                                |       нагрузки       |
                                +----------+-----------+
                                           |
              +----------------------------+------------------------------+
              |                                                           |
    +---------v--------+                                         +--------v--------+
    | Мастер-сервер DB1|                                         | Мастер-сервер DB3|
    | (Пользователи)    |                                        | (Книги)          |
    +--------+----------+                                        +--------+---------+
             |                                                            |
    +--------+--------+                                           +-------+--------+
    |                 |                                           |                |
+---v---+         +---v---+                                     +---v---+      +---v---+
| Slave |         | Slave |                                     | Slave |      | Slave |
| DB1   |         | DB2   |                                     | DB3   |      | DB4   |
|       |         |       |                                     |       |      |       |
+-------+         +-------+                                     +-------+      +-------+

                |                                                          |
        +-------v--------+                                        +--------v---------+
        |    Кэш (Redis) |                                        |    Кэш (Redis)   |
        +----------------+                                        +------------------+


Объяснение схемы:
Балансировщик нагрузки (первый элемент) принимает запросы и направляет их либо на мастер-серверы для записи, либо на реплики (слейвы) для чтения.
Мастер-серверы:
DB1 (пользователи) и DB3 (книги) обрабатывают записи (INSERT, UPDATE, DELETE).
Каждому мастеру сопоставлены реплики Slave DB1, Slave DB2, Slave DB3, Slave DB4, которые отвечают за чтение.
Кэш (Redis) используется для быстрого доступа к часто запрашиваемым данным, таким как популярные книги или активные пользователи. 
Запросы на такие данные могут быть направлены сразу в кэш.
Система распределяет нагрузку между мастерами и слейвами, увеличивая производительность и отказоустойчивость.
