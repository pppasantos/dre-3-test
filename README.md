# Problemas Detectados no Setup do Airflow

Listarei aqui os problemas detectados na ordem que eu os encontrei, durante a configuração do Apache Airflow junto com suas correções.


## 1 Usuário do Banco de Dados Não Era o Esperado Pelo Airflow

- sqlalchemy.exc.OperationalError: (psycopg2.OperationalError) connection to server at "postgres" (172.21.0.2), port 5432 failed: FATAL:  password authentication failed for user "airflow"
- No container do Postgres, usuario admin foi substituido pelo **airflow** que era esperando pela app.

# 1.1. Variável AIRFLOW_UID não estava definida.
- foi necessário defini-la globalmente.


## 2 Diretórios de mapeamento não encontrados no host.

- Apenas o diretório 'dags' existia, foi necessário criar 'plugins' e 'logs'
- mkdir -p ./logs ./plugins
- Foi necessário dar permissão nesses diretórios ao usuario do airflow, visto que elas estavam subindo para os containers com permissões erradas.
- sudo chown -R 5000:5000 ./dags ./logs ./plugins

# 2.1 Volumes do airflow-init

## 3. Container airflow webserver não estava passando no healthcheck interno do docker.
- Up 57 seconds (unhealthy) dre-3-test_airflow-webserver_1
- Identifiquei que a porta de checagem estava errada, Alterei para **8080**.
- Logs mostraram que surtiu efeito,
    airflow-webserver_1  | 127.0.0.1 - - [20/Mar/2025:14:39:17 +0000] "GET /health HTTP/1.1" 200 141 "-" "curl/7.74.0"
- A Partir de agora já temos o frontend web disponivel no navegador.

## 3. Interface web disponivel, mas sem apresentar nenhuma dag.
- Após logar com as credenciais padrão do airflow, percebi que a dag smooth não tinha sido carregada pelo scheduler.
- Entendi que o ponto de montagem estava errado alterei na ancora de ./dag para **./dags**.

## 4. Erro na DAG.
- Agora a dag estava sendo reconhecida na web do airflow porém, apresentava erro de syntax. (Broken DAG: [/opt/airflow/dags/smooth.py] Traceback (most recent call last):
  File "<frozen importlib._bootstrap_external>", line 791, in source_to_code)

- Entendi que faltava um ':' no final da declaração da função.


Agora a dag foi executada com sucesso.

´´´
*** Reading local file: /opt/airflow/logs/dag_id=smooth/run_id=manual__2025-03-20T14:50:10.831513+00:00/task_id=youtube_video/attempt=1.log
[2025-03-20, 14:50:12 UTC] {taskinstance.py:1083} INFO - Dependencies all met for <TaskInstance: smooth.youtube_video manual__2025-03-20T14:50:10.831513+00:00 [queued]>
[2025-03-20, 14:50:12 UTC] {taskinstance.py:1083} INFO - Dependencies all met for <TaskInstance: smooth.youtube_video manual__2025-03-20T14:50:10.831513+00:00 [queued]>
[2025-03-20, 14:50:12 UTC] {taskinstance.py:1279} INFO - 
--------------------------------------------------------------------------------
[2025-03-20, 14:50:12 UTC] {taskinstance.py:1280} INFO - Starting attempt 1 of 1
[2025-03-20, 14:50:12 UTC] {taskinstance.py:1281} INFO - 
--------------------------------------------------------------------------------
[2025-03-20, 14:50:12 UTC] {taskinstance.py:1300} INFO - Executing <Task(SmoothOperator): youtube_video> on 2025-03-20 14:50:10.831513+00:00
[2025-03-20, 14:50:12 UTC] {standard_task_runner.py:55} INFO - Started process 153 to run task
[2025-03-20, 14:50:12 UTC] {standard_task_runner.py:82} INFO - Running: ['***', 'tasks', 'run', 'smooth', 'youtube_video', 'manual__2025-03-20T14:50:10.831513+00:00', '--job-id', '3', '--raw', '--subdir', 'DAGS_FOLDER/smooth.py', '--cfg-path', '/tmp/tmpjy327i5e']
[2025-03-20, 14:50:12 UTC] {standard_task_runner.py:83} INFO - Job 3: Subtask youtube_video
[2025-03-20, 14:50:12 UTC] {task_command.py:388} INFO - Running <TaskInstance: smooth.youtube_video manual__2025-03-20T14:50:10.831513+00:00 [running]> on host 01e3bdaaa8d5
[2025-03-20, 14:50:12 UTC] {taskinstance.py:1509} INFO - Exporting the following env vars:
AIRFLOW_CTX_DAG_OWNER=***
AIRFLOW_CTX_DAG_ID=smooth
AIRFLOW_CTX_TASK_ID=youtube_video
AIRFLOW_CTX_EXECUTION_DATE=2025-03-20T14:50:10.831513+00:00
AIRFLOW_CTX_TRY_NUMBER=1
AIRFLOW_CTX_DAG_RUN_ID=manual__2025-03-20T14:50:10.831513+00:00
[2025-03-20, 14:50:12 UTC] {smooth.py:37} INFO - Enjoy Sade - Smooth Operator: https://www.youtube.com/watch?v=4TYv2PhG89A
[2025-03-20, 14:50:12 UTC] {taskinstance.py:1323} INFO - Marking task as SUCCESS. dag_id=smooth, task_id=youtube_video, execution_date=20250320T145010, start_date=20250320T145012, end_date=20250320T145012
[2025-03-20, 14:50:12 UTC] {local_task_job.py:208} INFO - Task exited with return code 0
[2025-03-20, 14:50:13 UTC] {taskinstance.py:2578} INFO - 0 downstream tasks scheduled from follow-on schedule check
´´´

