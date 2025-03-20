# Teste Pedro Amarante

# Objetivos
- [x] Conseguir subir a stack do airflow e executar a dag smooth.py.
- [] Criar o postmortem explicando quais foram os problemas suas causas, soluções. E quais serão as ações para mitigar as chances disso acontecer novamente.
- [] Criar arquitetura do airflow atual.
- [] Sugerir uma nova arquitetura para o airflow.

# Topologia do repositório.
 ```
.
├── compose.yaml
├── dags
│   ├── __pycache__
│   │   └── smooth.cpython-37.pyc
│   └── smooth.py
├── docs
│   ├── notepad-da-simulação.md
│   └── postmortem.md
├── LICENSE
├── logs
│   ├── dag_id=smooth
│   │   └── run_id=manual__2025-03-20T16:39:49.819048+00:00
│   │       └── task_id=youtube_video
│   │           └── attempt=1.log
│   ├── dag_processor_manager
│   │   └── dag_processor_manager.log
│   └── scheduler
│       └── 2025-03-20
│           └── smooth.py.log
└── README.md
 ```

 # Topologia básica do airflow

 ## Airflow com Docker Compose

Este projeto utiliza o Apache Airflow com Docker Compose para facilitar a execução e gerenciamento de workflows de dados. A arquitetura inclui um banco de dados PostgreSQL, um broker Redis e múltiplos serviços do Airflow para orquestração de tarefas.

### Estrutura do Projeto

A topologia do projeto é composta pelos seguintes serviços:

- **PostgreSQL**: Banco de dados relacional usado pelo Airflow para armazenar metadados.
- **Redis**: Broker de mensagens utilizado pelo Celery Executor.
- **Airflow Webserver**: Interface web para monitoramento e gestão dos DAGs.
- **Airflow Scheduler**: Responsável por agendar e monitorar a execução das tarefas.
- **Airflow Worker**: Processos que executam as tarefas enviadas pelo scheduler.
- **Airflow Triggerer**: Gerencia disparos assíncronos para DAGs com tarefas deferráveis.
- **Airflow Init**: Serviço para inicializar o banco de dados e configurar usuários iniciais.
- **Airflow CLI**: Interface de linha de comando para interações manuais.
- **Flower**: Dashboard de monitoramento para Celery Workers.

### Requisitos

- Docker
- Docker Compose


### Onde este projeto foi executado?

- Este projeto foi feito utilizando uma ec2 com debian 12 t3.2xlarge.

### Como Iniciar o Projeto

1. Clone este repositório:
   ```bash
   git clone https://github.com/pppasantos/dre-3-test.git
   cd dre-3-test
   ```
2. Execute o compose.yaml:
   ```bash
   docker compose up
   ```
3. Login no Airflow:
   ```bash
   Acesse http://127.0.0.1:8080
   User: **airflow**
   Password: **airflow**
   ```
4. Inicie a Dag smooth