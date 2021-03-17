## Урок 6. Создание ETL процесса. Часть 2
#### Задание
1) Развернуть окружение
2) Создать даг для дампа всех таблиц, используя операторы из урока

#### Решение
Скачиваем файлы с данными для базы-источкика и DDL-файл 
из  репозитория https://github.com/gregrahn/tpch-kit.git.

Создаем [Bash-скрипт](https://github.com/bostspb/etl/blob/main/lesson06/tables/init_01) 
для инициализации базы-источника и [скрипт](https://github.com/bostspb/etl/blob/main/lesson06/tables/init_01) для базы-приемника.

Создаем [файл](https://github.com/bostspb/etl/blob/main/lesson06/docker-compose.yml) 
под Docker Compose для развертывания двух контейнеров с Postgres 11 и Airflow.

Запускаем наши контейнеры

    docker-compose up -d

Заходим в консоль контейнера с первой базой и запускаем скрипт наполнения БД
    
    chmod ugo+x /root/tables/init_01
    bash /root/tables/init_01

Заходим в консоль контейнера со второй базой и запускаем скрипт создания схемы БД

    chmod ugo+x /root/tables/init_02
    bash /root/tables/init_02

Пишем [DAG](https://github.com/bostspb/etl/blob/main/lesson06/dags/lesson06_dag.py) 
для переброски данных из первой БД во втору. 
В нем задействованы [операторы из урока](https://github.com/bostspb/etl/blob/main/lesson06/operators)

Запускаем веб-интерфейс Airflow по адресу `http://localhost:8080/` и запускаем DAG. 
Таски [успешно отрабатывают](https://github.com/bostspb/etl/blob/main/lesson06/lesson06_ag_tree_view.png). 
Данные во второй таблице появляются.

