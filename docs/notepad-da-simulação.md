# Problemas Detectados no Setup do Airflow

Listarei aqui os problemas detectados na ordem que eu os encontrei, durante a configuração do Apache Airflow junto com suas correções.

## 1. Usuário do Banco de Dados Não Era o Esperado Pelo Airflow

- **Erro:**
  ```
  sqlalchemy.exc.OperationalError: (psycopg2.OperationalError) connection to server at "postgres" (172.21.0.2), port 5432 failed: FATAL:  password authentication failed for user "airflow"
  ```
- No container do Postgres, o usuário **admin** foi substituído pelo **airflow**, que era esperado pela aplicação.

### 1.1. Variável `AIRFLOW_UID` não estava definida

- Foi necessário defini-la globalmente.

## 2. Diretórios de Mapeamento Não Encontrados no Host

- Apenas o diretório `dags` existia, foi necessário criar `plugins` e `logs`:
  ```bash
  mkdir -p ./logs ./plugins
  ```
- Foi necessário dar permissão nesses diretórios ao usuário do Airflow, visto que estavam subindo para os containers com permissões erradas:
  ```bash
  sudo chown -R 5000:0 ./dags ./logs ./plugins
  ```

### 2.1. Volumes do `airflow-init`

## 3. Container `airflow-webserver` Não Estava Passando no Healthcheck Interno do Docker

- **Status:** `Up 57 seconds (unhealthy) dre-3-test_airflow-webserver_1`
- Identifiquei que a porta de checagem estava errada. Alterei para **8080**.
- Logs mostraram que surtiu efeito:
  ```
  airflow-webserver_1  | 127.0.0.1 - - [20/Mar/2025:14:39:17 +0000] "GET /health HTTP/1.1" 200 141 "-" "curl/7.74.0"
  ```
- A partir de agora já temos o frontend web disponível no navegador.

## 3. Interface Web Disponível, Mas Sem Apresentar Nenhuma DAG

- Após logar com as credenciais padrão do Airflow, percebi que a DAG `smooth` não tinha sido carregada pelo scheduler.
- Entendi que o ponto de montagem estava errado. Alterei na âncora de `./dag` para **`./dags`**.

## 4. Erro na DAG

- Agora a DAG estava sendo reconhecida na interface web do Airflow, porém apresentava erro de sintaxe:
  ```
  Broken DAG: [/opt/airflow/dags/smooth.py] Traceback (most recent call last):
    File "<frozen importlib._bootstrap_external>", line 791, in source_to_code
  ```
- Entendi que faltava um `:` no final da declaração da função.

### DAG Executada Com Sucesso

```log
*** Reading local file: /opt/airflow/logs/dag_id=smooth/run_id=manual__2025-03-20T14:50:10.831513+00:00/task_id=youtube_video/attempt=1.log
[2025-03-20, 14:50:12 UTC] {taskinstance.py:1083} INFO - Dependencies all met for <TaskInstance: smooth.youtube_video manual__2025-03-20T14:50:10.831513+00:00 [queued]>
[2025-03-20, 14:50:12 UTC] {taskinstance.py:1083} INFO - Dependencies all met for <TaskInstance: smooth.youtube_video manual__2025-03-20T14:50:10.831513+00:00 [queued]>
[2025-03-20, 14:50:12 UTC] {taskinstance.py:1279} INFO - 
--------------------------------------------------------------------------------
[2025-03-20, 14:50:12 UTC] {taskinstance.py:1280} INFO - Starting attempt 1 of 1
[2025-03-20, 14:50:12 UTC] {taskinstance.py:1281} INFO - 
--------------------------------------------------------------------------------
[2025-03-20, 14:50:12 UTC] {taskinstance.py:1300} INFO - Executing <Task(SmoothOperator): youtube_video> on 2025-03-20 14:50:10.831513+00:00
[2025-03-20, 14:50:12 UTC] {smooth.py:37} INFO - Enjoy Sade - Smooth Operator: https://www.youtube.com/watch?v=4TYv2PhG89A
[2025-03-20, 14:50:12 UTC] {taskinstance.py:1323} INFO - Marking task as SUCCESS.
```

## Vídeo da Solução

[Assista ao vídeo](https://drive.google.com/file/d/1rCEdJ59CETfEyiXT5HFs17PLwb867lEk/view?usp=sharing)
