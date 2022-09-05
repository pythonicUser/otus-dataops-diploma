## Выпускной проект OTUS по курсу DataOps

## Тема: BI-Решение

- [Манифест terraform](terraform/main.tf) с созданием трёх виртуальных машин в `Яндекс.Облаке`.

- Плэйбуки Ansible по деплою инструментов:

- - [postgres](ansible/postgres-playbook.yml)

- - [airflow](ansible/airflow-playbook.yml)

- - [redash](ansible/redash-playbook.yml)

- - [metabase](ansible/metabase-playbook.yml)

- [Даги Airflow](ansible/airflow/dags/) по скачиванию данных из url и записи в БД