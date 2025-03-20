# Teste Pedro Amarante

# Objetivos
- [x] Conseguir subir a stack do airflow e executar a dag smooth.py.
- [ ] Criar o postmortem explicando quais foram os problemas suas causas, soluções. E quais serão as ações para mitigar as chances disso acontecer novamente.
- [ ] Criar arquitetura do airflow atual.
- [ ] Sugerir uma nova arquitetura para o airflow.

# Topologia do repositório.
 ```
.
├── compose.yaml ( Arquivo Principal para iniciar o projeto hospedado no docker)
├── dags
│   └── smooth.py (dag/tarefa que precisa rodar)
├── docs (documentação do projeto como um todo)
│   ├── notepad-da-simulação.md
│   └── postmortem.md
├── LICENSE
├── logs (Os logs do airflow ficam aqui)
└── README.md (Esta página)
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
- make


### Onde este projeto foi executado?

- Este projeto foi feito utilizando uma ec2 com debian 12 t3.2xlarge.

### Como Iniciar o Projeto

1. Clone este repositório:
   ```bash
   git clone https://github.com/pppasantos/dre-3-test.git
   cd dre-3-test
   ```
2. Dependencias:
   ```bash
   apt update
   curl -fssL https://get.docker.io | bash
   apt install docker-compose -y
   apt install make -y
   ```
3. Execute o Projeto:
   ```bash
   make up
   ```
4. Verifique se tudo está rodando:
   ```bash
    após o comando **make** ele irá mostrar os logs, porém é possivel ver o log de cada app individualmente;
    make logs-postgres
    make logs-scheduler
    make logs-worker
    make logs-webserver
   ```
3. Login no Airflow:
   ```bash
   Acesse http://127.0.0.1:8080
   User: **airflow**
   Password: **airflow**
   ```
4. Inicie a Dag smooth