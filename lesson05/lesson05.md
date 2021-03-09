## Урок 5. Создание ETL процесса. Часть 1
#### Задание
1) Развернуть всю архитектуру у себя
2) Написать ETL процесс для загрузки ВСЕХ таблиц из postgres-источника в postgres-приемник

#### Решение
Создаем [файл](https://github.com/bostspb/etl/blob/main/docker-compose.yml) под Docker Compose для развертывания двух контейнеров с Postgres 11.

Запускаем наши контейнеры из директории с файлом

    docker-compose up -d

Создаем базу в каждом контейнере

    docker exec -it etl_postgres_01 psql -U root -c "create database benchmark_db;"
    docker exec -it etl_postgres_02 psql -U root -c "create database benchmark_db;"
    
Клонируем репозиторий с данными из теста TPC-H

    git clone https://github.com/gregrahn/tpch-kit.git
    
Перекидываем DDL-файл в контейнеры и разворачиваем таблицы

    docker cp ./tpch-kit/dbgen/dss.ddl etl_postgres_01:/
    docker exec -it etl_postgres_01 psql benchmark_db -f dss.ddl
        
    docker cp ./tpch-kit/dbgen/dss.ddl etl_postgres_02:/
    docker exec -it etl_postgres_02 psql benchmark_db -f dss.ddl

    
Перекидываем файлы с данными для таблиц в контейнер с первоб БД
    
    docker cp ./tables/customer.tbl etl_postgres_01:/
    docker cp ./tables/lineitem.tbl etl_postgres_01:/
    docker cp ./tables/nation.tbl etl_postgres_01:/
    docker cp ./tables/orders.tbl etl_postgres_01:/
    docker cp ./tables/part.tbl etl_postgres_01:/
    docker cp ./tables/partsupp.tbl etl_postgres_01:/
    docker cp ./tables/region.tbl etl_postgres_01:/
    docker cp ./tables/supplier.tbl etl_postgres_01:/

Заливаем данные в первую БД

    docker exec -it etl_postgres_01 psql benchmark_db -c "\copy customer FROM '/customer.tbl' CSV DELIMITER '|'"
    docker exec -it etl_postgres_01 psql benchmark_db -c "\copy lineitem FROM '/lineitem.tbl' CSV DELIMITER '|'"
    docker exec -it etl_postgres_01 psql benchmark_db -c "\copy nation FROM '/nation.tbl' CSV DELIMITER '|'"
    docker exec -it etl_postgres_01 psql benchmark_db -c "\copy orders FROM '/orders.tbl' CSV DELIMITER '|'"
    docker exec -it etl_postgres_01 psql benchmark_db -c "\copy part FROM '/part.tbl' CSV DELIMITER '|'"
    docker exec -it etl_postgres_01 psql benchmark_db -c "\copy partsupp FROM '/partsupp.tbl' CSV DELIMITER '|'"
    docker exec -it etl_postgres_01 psql benchmark_db -c "\copy region FROM '/region.tbl' CSV DELIMITER '|'"
    docker exec -it etl_postgres_01 psql benchmark_db -c "\copy supplier FROM '/supplier.tbl' CSV DELIMITER '|'"  

Пишем [скрипт](https://github.com/bostspb/etl/blob/main/etl.py) переброски данных из первой БД во вторую через промежуточное создание CSV-файлов с данными 

Скрипт отрабатывает успешно - сначала формируются файлы с данными из первой БД под каждую таблицу, 
потом они загружаются во вторую БД.