# ÁUREON — Diário de Bordo

PWA responsivo para registrar acontecimentos da operação em tempo real.

## Modelo
- **Individual:** autor registra relatos e consulta o próprio histórico.
- **Coletivo:** gestores aprovados veem todos os relatos.
- **Dados:** registros persistidos em Supabase exclusivo; GitHub só guarda código.
- **Segurança:** Supabase Auth + RLS, sem formulário público de cadastro, relatos imutáveis.
- **Grupos iniciais:** Geral, PARK, EXTERNA.

## Instalação
1. Crie um projeto Supabase **exclusivo** para o Diário de Bordo.
2. Execute `supabase/schema.sql` no SQL Editor (num banco novo).
3. Crie usuários em Authentication > Users e insira seus UUIDs e papéis em `diary_profiles`. Somente perfis `active=true` podem registrar.
4. Em `index.html`, configure `SUPABASE_URL` e `SUPABASE_PUBLISHABLE_KEY`; somente chave publicável, **nunca service_role**.
5. Habilite GitHub Pages em Settings > Pages > Deploy from a branch > main / root. URL prevista: https://raphaelbuenocaptacao-creator.github.io/DIARIO-DE-BORDO/
6. Configure a URL de redirecionamento do site no Supabase Auth.

**Privacidade:** repositório pode ser público somente porque não contém registros ou segredos. Para ocorrências delicadas, prefira repositório privado com hospedagem apropriada e restrinja acessos ao banco. Revise necessidades da LGPD e a política de retenção.

**Limitações do MVP:** online para salvar; PWA instala e guarda apenas shell offline. Não há edição/exclusão de relatos, nem IA ativa. Indicadores contam registros, não faltas oficialmente confirmadas. O fechamento e relatórios inteligentes devem ser adicionados após validação do fluxo de gestão.