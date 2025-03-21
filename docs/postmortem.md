## Resumo
Durante a configuração do Apache Airflow, diversos problemas foram encontrados e solucionados. Este postmortem documenta os erros enfrentados, suas causas e as ações corretivas adotadas para evitar recorrências.

## Linha do Tempo

| Data            | Evento |
|-----------------|---------------------------------------------|
| 2025-03-19 22:12| Detecção de problemas durante o setup inicial |
| 2025-03-20 17:34| Investigação e diagnóstico dos erros encontrados |
| 2025-03-20 19:02| Aplicação de ações corretivas nos containers e configuração |
| 2025-03-20 22:37| Resolução final e validação da execução das DAGs |

## Causas Raiz e Soluções

### 1. Usuário do Banco de Dados Incorreto
- **Erro:**
  sqlalchemy.exc.OperationalError: (psycopg2.OperationalError) connection to server at "postgres" (172.21.0.2), port 5432 failed: FATAL:  password authentication failed for user "airflow"

- **Causa:** O usuário esperado era `airflow`, mas um usuário incorreto estava configurado.
- **Solução:** Ajustado o usuário e senha no ambiente e no container do Postgres. Agora o airflow tem seu proprio usuario e base de dados dentro do postgres. (.env)

### 2. Diretórios de Mapeamento Não Existentes no Host
- **Erro:** Diretórios necessários para `logs` e `plugins` não estavam presentes.
- **Solução:**
  mkdir -p ./logs ./plugins
  sudo chown -R 50000:0 ./dags ./logs ./plugins (ver makefile)

- **Causa:** O container `airflow-init` não estava montando corretamente os volumes.
- **Solução:** Nome do volume errado na âncora `&airflow-common` no `docker-compose.yml`.

## Ações Preventivas
- Definir corretamente `AIRFLOW_UID` e `AIRFLOW_GID` antes da inicialização.
- Criar e configurar os diretórios `dags`, `logs` e `plugins` previamente com permissões adequadas.
- Validar o ponto de montagem correto das DAGs antes da execução.
- Implementar uma pipeline de testes para verificar erros de sintaxe antes de subir novas DAGs.
- Implementar observabilidade e monitoramento.
- Criar Fernet_KEY.
- Criar um usuario no postgres especifico para o airflow.
- Resolver os warnings do airflow, (atualizar python e dependencias)
- Resolver os erros do postgres de migrations do airflow (Ele tem reclamado de algo na inicialização)
- A stack do airflow está consumindo muitos recursos, eu não quis limitar os containers para fazer a stack rodar. Em produção criar nodegroups com capacidade suficiente para a stack airflow e as dags.

## Conclusão
A configuração do Apache Airflow foi concluída com sucesso após a resolução dos problemas descritos.
