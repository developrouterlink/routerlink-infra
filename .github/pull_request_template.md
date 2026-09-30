# 🏗️ PR de Infraestrutura: [Título Resumido da Mudança]

## 📋 Resumo das Alterações
Descreva de forma clara e concisa quais alterações foram realizadas na infraestrutura Docker/serviços:
- [ ] Alteração de imagem / versão de container
- [ ] Adição/modificação de variáveis de ambiente (`.env.example`)
- [ ] Alteração de portas, redes ou volumes
- [ ] Modificação de filas, exchanges ou vhosts (RabbitMQ)
- [ ] Scripts de inicialização de banco (DDL / migrations / init scripts)
- [ ] Atualização de dependências ou profiles do Docker Compose

---

## 🔍 Contexto & Motivação
*Por que essa mudança na infraestrutura é necessária? Qual problema ela resolve ou qual funcionalidade ela viabiliza?*

---

## ⚙️ Checklist de Validação de Infra
Marque todos os testes executados localmente antes de solicitar o review:

- [ ] Arquivo `docker-compose.yml` validado com sintaxe íntegra (`docker compose config`).
- [ ] Testado boot completo com `docker compose up -d --build` (sem erros).
- [ ] Testado boot com o perfil SEFAZ: `docker compose --profile sefaz up -d`.
- [ ] Healthchecks verificados via `docker compose ps` (todos os serviços com status `healthy`).
- [ ] O arquivo `.env.example` foi atualizado caso novas variáveis tenham sido introduzidas.
- [ ] Não há senhas de produção expostas no código ou histórico.
- [ ] Persistência de volumes testada após restart (`docker compose down && docker compose up -d`).

---

## 🧪 Como Testar as Mudanças
Instruções passo a passo para o revisor rodar e testar este PR:
```bash
# 1. Obter a branch
git checkout <branch-name>

# 2. Configurar variáveis
cp .env.example .env

# 3. Subir e validar
docker compose up -d --build
docker compose ps
```

---

## ⚠️ Impacto em Produção / Breaking Changes
- [ ] **Sim, exige migração de banco / alteração manual em produção.** (Descreva abaixo)
- [ ] **Não, totalmente retrocompatível.**

*Detalhes de migração ou cuidados extras (se aplicável):*
