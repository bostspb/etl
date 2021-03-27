# GB: Построение хранилища данных и основы ETL
> **Geek University Data Engineering**

`DWH` `ETL` `Data Vault` `Anchor Modeling` `MPP` `Data Quality`
 `Apache Airflow` `Python` `Docker` `PostgreSQL` `Jupyter Notebook` 

### Урок 1. Введение
1. Понятие хранилища данных.
2. Виды представления моделей данных.
3. Реляционные модели данных.
4. Реляционная терминология.

### Урок 2. Архитектура хранилищ
1. Нормализация данных
2. Архитектура хранилища данных - слои

**Задание** <br>
Привести таблицы к 3НФ, НФБК, 4НФ, 5НФ, 6НФ

**Решение** <br>
[Приведение к 3НФ](https://github.com/bostspb/etl/blob/main/lesson02/3NF.png) <br>
[Приведение к НФБК](https://github.com/bostspb/etl/blob/main/lesson02/BCNF.png) <br>
[Приведение к 4НФ](https://github.com/bostspb/etl/blob/main/lesson02/4NF.png) <br>
[Приведение к 5НФ](https://github.com/bostspb/etl/blob/main/lesson02/5NF.png) <br>
[Приведение к 6НФ](https://github.com/bostspb/etl/blob/main/lesson02/6NF.png) <br>


### Урок 3. Проектирование хранилища. Часть 1
1. Хранилище по Кимбаллу
2. Хранилище по Инмону
3. Концепция Data Vault
4. Концепция Anchor modeling

### Урок 4. Проектирование хранилища. Часть 2
- MPP системы    
    - SE (Shared-Everything) - архитектура с разделяемыми памятью и дисками
    - SD (Shared-Disks) - архитектура с разделяемыми дисками
    - SN (Shared-Nothing) - архитектура без совместного использования ресурсов
    - Teradata – это параллельная реляционная СУБД.
    - Vertica - реляционная колончатая СУБД.
    - ClickHouse — колоночная аналитическая СУБД
- Проектирование хранилища
    - Data vault
    - Anchor modeling

**Задание** <br>
Спроектировать логические схемы `Data Vault` и `Anchor Modeling` на примере базы `Northwind`.

**Решение** <br>
- Исходная БД Northwind:
    - [SQL](https://github.com/bostspb/etl/blob/main/lesson04/Northwind.sql) 
- Northwind в Data Vault:
    - [Изображение схемы](https://github.com/bostspb/etl/blob/main/lesson04/northwind_data_vault.png), 
    - [SQL](https://github.com/bostspb/etl/blob/main/lesson04/Northwind%20Data%20vault.sql) 
- Northwind в Anchor Modeling:
    - [Изображение схемы](https://github.com/bostspb/etl/blob/main/lesson04/northwind_anchor_modeling.png)
    - [SQL](https://github.com/bostspb/etl/blob/main/lesson04/Northwind%20Anchor%20modeling.sql) 


### Урок 5. Создание ETL процесса. Часть 1
- познакомились с понятием ETL
- узнали основные свойства и требования к ETL процессам
- научились разворачивать СУБД в докере
- познакимились с python DB-API
- потренировались писать ETL процесс с помощью psycopg2

**Задание** <br>
1) Развернуть всю архитектуру у себя
2) Написать ETL процесс для загрузки всех таблиц из postgres-источника в postgres-приемник

**Решение** <br>
- [Ход выполнения задания](https://github.com/bostspb/etl/blob/main/lesson05/lesson05.md)
- [Скрипт с ETL-процессом](https://github.com/bostspb/etl/blob/main/lesson05/etl.py)
- [Файл для поднятия окружения под Docker Compose](https://github.com/bostspb/etl/blob/main/lesson05/docker-compose.yml)


### Урок 6. Создание ETL процесса. Часть 2
- познакомились с Airflow
- написали базовый оператор ответственный за загрузку данных в хранилище
- написали оператор извлечения данных из Postgres 
- написали даг ежедневного дампа таблицы в хранилище
- получили скелет ETL-системы

**Задание** <br>
1) Развернуть окружение
2) Создать даг для дампа всех таблиц, использую операторы из урока

**Решение** <br>
- [Ход выполнения задания](https://github.com/bostspb/etl/blob/main/lesson06/lesson06.md)
- [DAG](https://github.com/bostspb/etl/blob/main/lesson06/dags/lesson06_dag.py)
- [Файл для поднятия окружения под Docker Compose](https://github.com/bostspb/etl/blob/main/lesson06/docker-compose.yml)
- [Скриншот веб-интерфейса Airflow с успешно отработавшими тасками](https://github.com/bostspb/etl/blob/main/lesson06/lesson06_ag_tree_view.png)


### Урок 7. Управление качеством данных
- познакомились с понятием Data quality и метаданных
- узнали какие есть метрики и методы для оценки качества данных
- реализовали оператор для записи логов, сбора статистики и проверки загрузки данных
- модифицировали код базового оператора, теперь он пишет лог и делает проверку были ли загружены данные

**Задание** <br>
1) Написать оператор для сбора статистики в таблицу `statistic`. Метод записи из `utils.py`: `write_etl_statistic()`.
2) Создать отдельный даг с этим оператором. Перед сбором статистики должен быть `external_task_sensor` на успешное выполнение переливки данных. 
Документация по сенсору: https://airflow.apache.org/docs/apache-airflow/1.10.4/_api/airflow/sensors/external_task_sensor/index.html

**Решение** <br>
- [Файлы DAG](https://github.com/bostspb/etl/tree/main/lesson07/dags)
- [Операторы](https://github.com/bostspb/etl/tree/main/lesson07/operators)
- [DDL таблиц для статистики](https://github.com/bostspb/etl/blob/main/lesson07/create_tables.py)
- [Файл для поднятия окружения под Docker Compose](https://github.com/bostspb/etl/blob/main/lesson07/docker-compose.yml)


### Урок 8. Курсовой проект
- спроектировали схему хранилища
- реализовали операторы для разложения данных по слоям
- определили вид конфигурационного файла для описания модели данных
- написали даг с полным ETL-пайплайном 

**Задание** <br>
Реализовать ETL-систему для загрузки Data Vault

**Решение** <br>
- [DAG](https://github.com/bostspb/etl/blob/main/lesson08/dags/data_vault_dag.py)
- [Конфигурационный YAML-файл с описанием модели данных](https://github.com/bostspb/etl/blob/main/lesson08/dags/schema.yaml)
- [Операторы](https://github.com/bostspb/etl/tree/main/lesson08/operators)
- [DDL таблиц (скрипты генерации и сами SQL)](https://github.com/bostspb/etl/tree/main/lesson08/ddl)
- [Файл для поднятия окружения под Docker Compose](https://github.com/bostspb/etl/blob/main/lesson08/docker-compose.yml)
- [Скриншот зависимостей Tasks](https://github.com/bostspb/etl/blob/main/lesson08/task_links.png)
- [Скриншот с успешно отработавшими тасками](https://github.com/bostspb/etl/blob/main/lesson08/task_tree.png)