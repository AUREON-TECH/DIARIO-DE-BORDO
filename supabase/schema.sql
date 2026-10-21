-- Execute em um projeto Supabase DEDICADO ao Diário de Bordo.
create table if not exists public.diary_profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 display_name text not null check (char_length(display_name) between 2 and 120),
 role text not null default 'profissional' check (role in ('profissional','gestor','admin')),
 active boolean not null default false,
 created_at timestamptz not null default now()
);
create table if not exists public.diary_entries (
 id uuid primary key default gen_random_uuid(),
 author_id uuid not null references public.diary_profiles(id) constraint diary_entries_author_id_fkey,
 category text not null check(category in ('rotina','falta','atraso','conflito','operacao','elogio','decisao','outro')),
 team text not null check(team in ('GERAL','PARK','EXTERNA')),
 people text not null default '',
 severity text not null check(severity in ('informativo','atencao','critico')),
 description text not null check(char_length(description) between 1 and 10000),
 action_taken text not null default '',
 created_at timestamptz not null default now()
);
create index if not exists diary_entries_date_idx on public.diary_entries(created_at desc);
create index if not exists diary_entries_author_idx on public.diary_entries(author_id,created_at desc);
alter table public.diary_profiles enable row level security;
alter table public.diary_entries enable row level security;
-- Não existe cadastro automático. Administrador cria contas via Supabase Auth
-- e insere seus perfis pelo SQL Editor, ou por painel administrativo seguro.
create policy "Perfil individual" on public.diary_profiles for select to authenticated using (id=(select auth.uid()));
create policy "Gestao ve perfis ativos" on public.diary_profiles for select to authenticated
using ((select auth.jwt()->'app_metadata'->>'diary_role') in ('admin','gestor'));
create policy "Autor insere proprio relato" on public.diary_entries for insert to authenticated
with check (author_id=(select auth.uid()) and exists(
 select 1 from public.diary_profiles p where p.id=(select auth.uid()) and p.active
));
create policy "Autor ve proprios relatos ou gestor ve todos" on public.diary_entries for select to authenticated
using (
 (select auth.jwt()->'app_metadata'->>'diary_role') in ('admin','gestor')
 or (
 author_id=(select auth.uid())
 and exists(select 1 from public.diary_profiles p where p.id=(select auth.uid()) and p.active)
 )
);
-- Sem UPDATE/DELETE por usuários: histórico original é imutável.
grant select on public.diary_profiles to authenticated;
grant select,insert on public.diary_entries to authenticated;
-- Exemplo: após criar usuário em Auth, substituir UUID e nome:
-- insert into public.diary_profiles (id,display_name,role,active)
-- values ('UUID-DO-USUARIO','Gestor','admin',true);

-- Para autorizar acesso de gestor, defina raw_app_meta_data.diary_role='admin' ou 'gestor'
-- pelo painel administrativo ou por operação segura do lado servidor.
-- Nunca autorize papéis via user_metadata editável pelo cliente.
