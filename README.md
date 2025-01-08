# Домашнее задание к занятию  "ELK" - "Засим Артем"


---

### Задание 1

Установите и запустите Elasticsearch, после чего поменяйте параметр cluster_name на случайный.

Приведите скриншот команды 'curl -X GET 'localhost:9200/_cluster/health?pretty', сделанной на сервере 
с установленным Elasticsearch. Где будет виден нестандартный cluster_name.

https://github.com/Artem35135/gitlab-hw/blob/main/img/elasticsearch.png

---

### Задание 2

Установите и запустите Kibana.

Приведите скриншот интерфейса Kibana на странице http://<ip вашего сервера>:5601/app/dev_tools#/console, 
где будет выполнен запрос GET /_cluster/health?pretty

https://github.com/Artem35135/gitlab-hw/blob/main/img/elasticsearch%2Bkibana.png

---

### Задание 3

Установите и запустите Logstash и Nginx. С помощью Logstash отправьте access-лог Nginx в Elasticsearch.
Приведите скриншот интерфейса Kibana, на котором видны логи Nginx.

https://github.com/Artem35135/gitlab-hw/blob/main/img/elk%2Bnginx.png

---

### Задание 4

Установите и запустите Filebeat. Переключите поставку логов Nginx с Logstash на Filebeat.
Приведите скриншот интерфейса Kibana, на котором видны логи Nginx, которые были отправлены через Filebeat.

С этим заданием у меня затык. Срок сдачи сегодня вечером, а времени разбираться больше нет. Позже, для себя, найду в чем была проблема,
но пока отправляю как есть.
