-- =====================================================================
--  VITRIX — Sistema de gestão para empresas de vidraçaria
--  Banco de dados PostgreSQL (hospedado no Supabase)
--
--  Ordem do script:
--    1. Tipos (ENUMs)        5. Views (consultas prontas para o dashboard)
--    2. Sequências           6. Funções e triggers
--    3. Tabelas              7. Segurança (Row Level Security)
--    4. Índices
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1. TIPOS ENUMERADOS
--    Restringem colunas de status/categoria a valores válidos,
--    evitando erros de digitação e dados inconsistentes.
-- ---------------------------------------------------------------------
create type user_role          as enum ('admin', 'gerente', 'vendedor', 'tecnico', 'financeiro');
create type cliente_tipo       as enum ('pessoa_fisica', 'empresa', 'condominio', 'arquiteto', 'construtora', 'parceiro');
create type origem_cliente     as enum ('instagram', 'google', 'indicacao', 'whatsapp', 'loja', 'anuncio', 'parceiro', 'outro');
create type compromisso_tipo   as enum ('visita_tecnica', 'reuniao', 'medicao', 'instalacao', 'manutencao', 'cobranca', 'retorno_cliente', 'entrega_orcamento');
create type compromisso_status as enum ('agendado', 'confirmado', 'em_andamento', 'concluido', 'cancelado', 'cliente_ausente', 'reagendado');
create type unidade_medida     as enum ('m2', 'metro_linear', 'unidade', 'kit', 'diaria', 'servico', 'valor_fixo');
create type orcamento_status   as enum ('rascunho', 'em_elaboracao', 'enviado', 'visualizado', 'aguardando_resposta', 'em_negociacao', 'aprovado', 'recusado', 'vencido', 'convertido_contrato');
create type contrato_status    as enum ('aguardando_assinatura', 'assinado', 'entrada_pendente', 'em_producao', 'instalacao_agendada', 'em_instalacao', 'concluido', 'cancelado');
create type pagamento_status   as enum ('pendente', 'recebido', 'parcialmente_recebido', 'vencido', 'cancelado', 'pago');
create type tipo_lancamento    as enum ('receita', 'despesa');


-- ---------------------------------------------------------------------
-- 2. SEQUÊNCIAS
--    Numeração amigável (Orçamento nº 1, 2, 3...) separada do UUID interno.
-- ---------------------------------------------------------------------
create sequence orcamentos_numero_seq;
create sequence contratos_numero_seq;


-- ---------------------------------------------------------------------
-- 3. TABELAS
--    Todas as tabelas têm empresa_id: o sistema é multiempresa
--    (cada vidraçaria vê apenas os próprios dados).
-- ---------------------------------------------------------------------

-- 3.1 Cadastro base ----------------------------------------------------

create table empresas (
  id uuid primary key default gen_random_uuid(),
  nome_fantasia text not null default 'Minha Vidraçaria',
  razao_social text,
  cnpj text,
  telefone text,
  whatsapp text,
  instagram text,
  email text,
  logo_url text,
  endereco text,
  numero text,
  complemento text,
  bairro text,
  cidade text default 'Recife',
  estado text default 'PE',
  cep text,
  chave_pix text,
  banco text,
  agencia text,
  conta text,
  validade_orcamento_dias integer default 7,
  prazo_padrao_execucao text,
  garantia_padrao text,
  termos_comerciais text,
  margem_lucro_padrao numeric(10,2) default 30,
  perda_padrao_percentual numeric(10,2) default 5,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- auth.users é a tabela de login do Supabase Auth.
create table usuarios (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid unique references auth.users(id) on delete cascade,
  empresa_id uuid references empresas(id) on delete cascade,
  nome text not null,
  email text unique,
  telefone text,
  role user_role not null default 'vendedor',
  ativo boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table clientes (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid references empresas(id) on delete cascade,
  responsavel_id uuid references usuarios(id) on delete set null,
  nome text not null,
  tipo cliente_tipo not null default 'pessoa_fisica',
  cpf_cnpj text,
  telefone text,
  whatsapp text,
  email text,
  data_nascimento date,
  origem origem_cliente default 'outro',
  observacoes text,
  ativo boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Um cliente pode ter vários endereços (casa, obra, escritório...).
create table enderecos (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid references empresas(id) on delete cascade,
  cliente_id uuid references clientes(id) on delete cascade,
  apelido text default 'Principal',
  endereco text not null,
  numero text,
  complemento text,
  bairro text,
  cidade text default 'Recife',
  estado text default 'PE',
  cep text,
  ponto_referencia text,
  latitude numeric(10,7),
  longitude numeric(10,7),
  principal boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 3.2 Agenda e atendimento técnico ------------------------------------

create table compromissos (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid references empresas(id) on delete cascade,
  cliente_id uuid references clientes(id) on delete set null,
  endereco_id uuid references enderecos(id) on delete set null,
  responsavel_id uuid references usuarios(id) on delete set null,
  titulo text not null,
  tipo compromisso_tipo not null default 'visita_tecnica',
  status compromisso_status not null default 'agendado',
  data_inicio timestamptz not null,
  data_fim timestamptz,
  endereco_texto text,
  observacoes text,
  google_maps_url text,
  lembrete_enviado boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table visitas (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid references empresas(id) on delete cascade,
  cliente_id uuid references clientes(id) on delete set null,
  compromisso_id uuid references compromissos(id) on delete set null,
  responsavel_id uuid references usuarios(id) on delete set null,
  data_visita timestamptz not null default now(),
  resumo text,
  observacoes_tecnicas text,
  dificuldade_instalacao text,
  andar text,
  necessidade_icamento boolean not null default false,
  acesso_local text,
  prazo_desejado text,
  assinatura_cliente_url text,
  status text default 'realizada',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- area_m2 é uma coluna GERADA: o banco calcula sozinho a partir das medidas.
create table medicoes (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid references empresas(id) on delete cascade,
  visita_id uuid references visitas(id) on delete cascade,
  cliente_id uuid references clientes(id) on delete set null,
  ambiente text not null,
  servico text,
  largura_m numeric(10,3) not null default 0,
  altura_m numeric(10,3) not null default 0,
  quantidade integer not null default 1,
  area_m2 numeric(10,3) generated always as (largura_m * altura_m * quantidade) stored,
  quantidade_folhas integer,
  perimetro_m numeric(10,3),
  tipo_vidro text,
  espessura_mm numeric(10,2),
  cor_vidro text,
  acabamento text,
  tipo_perfil text,
  cor_perfil text,
  ferragens text,
  acessorios text,
  observacoes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 3.3 Catálogo -----------------------------------------------------------

create table fornecedores (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid references empresas(id) on delete cascade,
  nome text not null,
  razao_social text,
  cnpj text,
  telefone text,
  whatsapp text,
  email text,
  endereco text,
  vendedor_responsavel text,
  produtos_fornecidos text,
  prazo_medio text,
  condicoes_pagamento text,
  observacoes text,
  ativo boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table produtos_servicos (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid references empresas(id) on delete cascade,
  fornecedor_id uuid references fornecedores(id) on delete set null,
  nome text not null,
  categoria text,
  descricao text,
  unidade unidade_medida not null default 'unidade',
  custo numeric(12,2) not null default 0,
  preco_venda numeric(12,2) not null default 0,
  margem_percentual numeric(10,2) default 0,
  comissao_percentual numeric(10,2) default 0,
  perda_percentual numeric(10,2) default 0,
  ativo boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 3.4 Vendas: orçamento → contrato --------------------------------------

create table orcamentos (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid references empresas(id) on delete cascade,
  cliente_id uuid references clientes(id) on delete set null,
  vendedor_id uuid references usuarios(id) on delete set null,
  endereco_id uuid references enderecos(id) on delete set null,
  visita_id uuid references visitas(id) on delete set null,
  numero integer not null default nextval('orcamentos_numero_seq'),
  status orcamento_status not null default 'rascunho',
  titulo text default 'Orçamento',
  data_emissao date not null default current_date,
  validade date,
  prazo_execucao text,
  garantia text,
  forma_pagamento text,
  quantidade_parcelas integer default 1,
  entrada_valor numeric(12,2) default 0,
  desconto_valor numeric(12,2) default 0,
  desconto_percentual numeric(10,2) default 0,
  -- Os totais abaixo são recalculados automaticamente por trigger (seção 6).
  subtotal numeric(12,2) not null default 0,
  custo_total numeric(12,2) not null default 0,
  margem_lucro_valor numeric(12,2) default 0,
  margem_lucro_percentual numeric(10,2) default 0,
  valor_total numeric(12,2) not null default 0,
  observacoes_cliente text,
  observacoes_internas text,
  pdf_url text,
  qr_code_url text,
  enviado_em timestamptz,
  visualizado_em timestamptz,
  aprovado_em timestamptz,
  recusado_em timestamptz,
  motivo_recusa text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Itens que o cliente vê no orçamento.
create table orcamento_itens (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid references empresas(id) on delete cascade,
  orcamento_id uuid references orcamentos(id) on delete cascade,
  produto_servico_id uuid references produtos_servicos(id) on delete set null,
  medicao_id uuid references medicoes(id) on delete set null,
  ambiente text,
  descricao text not null,
  largura_m numeric(10,3) default 0,
  altura_m numeric(10,3) default 0,
  quantidade numeric(10,3) not null default 1,
  area_m2 numeric(10,3) generated always as (coalesce(largura_m, 0) * coalesce(altura_m, 0) * quantidade) stored,
  unidade unidade_medida default 'unidade',
  preco_unitario numeric(12,2) not null default 0,
  custo_unitario numeric(12,2) not null default 0,
  desconto_valor numeric(12,2) default 0,
  total numeric(12,2) not null default 0,
  observacoes text,
  foto_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Custos internos do orçamento (material, mão de obra, frete...).
-- Usados para calcular a margem de lucro real de cada venda.
create table orcamento_custos (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid references empresas(id) on delete cascade,
  orcamento_id uuid references orcamentos(id) on delete cascade,
  descricao text not null,
  categoria text,
  fornecedor_id uuid references fornecedores(id) on delete set null,
  quantidade numeric(10,3) default 1,
  valor_unitario numeric(12,2) not null default 0,
  valor_total numeric(12,2) not null default 0,
  visivel_cliente boolean not null default false,
  observacoes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table contratos (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid references empresas(id) on delete cascade,
  orcamento_id uuid references orcamentos(id) on delete set null,
  cliente_id uuid references clientes(id) on delete set null,
  responsavel_id uuid references usuarios(id) on delete set null,
  numero integer not null default nextval('contratos_numero_seq'),
  status contrato_status not null default 'aguardando_assinatura',
  data_contrato date not null default current_date,
  data_assinatura date,
  data_inicio_prevista date,
  data_instalacao_prevista date,
  data_conclusao date,
  valor_total numeric(12,2) not null default 0,
  entrada_valor numeric(12,2) default 0,
  saldo_valor numeric(12,2) default 0,
  custo_previsto numeric(12,2) default 0,
  custo_real numeric(12,2) default 0,
  lucro_estimado numeric(12,2) default 0,
  lucro_real numeric(12,2) default 0,
  contrato_pdf_url text,
  contrato_assinado_url text,
  observacoes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 3.5 Financeiro ----------------------------------------------------------

create table parcelas (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid references empresas(id) on delete cascade,
  contrato_id uuid references contratos(id) on delete cascade,
  cliente_id uuid references clientes(id) on delete set null,
  numero_parcela integer not null default 1,
  descricao text,
  valor numeric(12,2) not null default 0,
  data_vencimento date not null,
  data_pagamento date,
  forma_pagamento text,
  status pagamento_status not null default 'pendente',
  comprovante_url text,
  observacoes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table contas_receber (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid references empresas(id) on delete cascade,
  cliente_id uuid references clientes(id) on delete set null,
  contrato_id uuid references contratos(id) on delete set null,
  parcela_id uuid references parcelas(id) on delete set null,
  descricao text not null,
  valor numeric(12,2) not null default 0,
  data_vencimento date not null,
  data_recebimento date,
  forma_pagamento text,
  numero_parcela integer,
  status pagamento_status not null default 'pendente',
  comprovante_url text,
  observacoes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table contas_pagar (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid references empresas(id) on delete cascade,
  fornecedor_id uuid references fornecedores(id) on delete set null,
  contrato_id uuid references contratos(id) on delete set null,
  descricao text not null,
  categoria text,
  valor numeric(12,2) not null default 0,
  data_compra date,
  data_vencimento date not null,
  data_pagamento date,
  forma_pagamento text,
  numero_parcela integer,
  quantidade_parcelas integer,
  codigo_barras text,
  boleto_url text,
  comprovante_url text,
  status pagamento_status not null default 'pendente',
  observacoes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table despesas (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid references empresas(id) on delete cascade,
  fornecedor_id uuid references fornecedores(id) on delete set null,
  contrato_id uuid references contratos(id) on delete set null,
  conta_pagar_id uuid references contas_pagar(id) on delete set null,
  categoria text not null,
  descricao text not null,
  valor numeric(12,2) not null default 0,
  data_despesa date not null default current_date,
  forma_pagamento text,
  fixa boolean not null default false,
  variavel boolean not null default true,
  recorrente boolean not null default false,
  relacionada_obra boolean not null default false,
  comprovante_url text,
  observacoes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Livro-caixa unificado: origem_tabela/origem_id apontam para o registro
-- que gerou o lançamento (ex.: uma conta a receber).
create table lancamentos_financeiros (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid references empresas(id) on delete cascade,
  tipo tipo_lancamento not null,
  descricao text not null,
  categoria text,
  valor numeric(12,2) not null default 0,
  data_lancamento date not null default current_date,
  data_vencimento date,
  data_pagamento date,
  status pagamento_status not null default 'pendente',
  origem_tabela text,
  origem_id uuid,
  observacoes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 3.6 Apoio ---------------------------------------------------------------

-- Anexos polimórficos: entidade_tipo + entidade_id permitem anexar
-- arquivos a qualquer registro (orçamento, contrato, visita...).
create table anexos (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid references empresas(id) on delete cascade,
  entidade_tipo text not null,
  entidade_id uuid not null,
  nome_arquivo text not null,
  tipo_arquivo text,
  url text not null,
  tamanho_bytes bigint,
  observacoes text,
  uploaded_by uuid references usuarios(id) on delete set null,
  created_at timestamptz not null default now()
);

create table notificacoes (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid references empresas(id) on delete cascade,
  usuario_id uuid references usuarios(id) on delete cascade,
  titulo text not null,
  mensagem text,
  tipo text,
  lida boolean not null default false,
  link text,
  created_at timestamptz not null default now()
);

-- Auditoria: quem fez o quê; "dados" guarda um snapshot em JSON.
create table logs_atividades (
  id uuid primary key default gen_random_uuid(),
  empresa_id uuid references empresas(id) on delete cascade,
  usuario_id uuid references usuarios(id) on delete set null,
  acao text not null,
  entidade_tipo text,
  entidade_id uuid,
  dados jsonb,
  created_at timestamptz not null default now()
);


-- ---------------------------------------------------------------------
-- 4. ÍNDICES
--    Criados para as buscas mais frequentes do dashboard:
--    listagens por empresa, filtros por status e por vencimento.
-- ---------------------------------------------------------------------
create index idx_clientes_empresa_nome       on clientes (empresa_id, nome);
create index idx_clientes_whatsapp           on clientes (whatsapp);
create index idx_compromissos_empresa_data   on compromissos (empresa_id, data_inicio);
create index idx_fornecedores_nome           on fornecedores (empresa_id, nome);
create index idx_produtos_nome               on produtos_servicos (empresa_id, nome);
create index idx_orcamentos_empresa_status   on orcamentos (empresa_id, status);
create index idx_orcamentos_cliente          on orcamentos (cliente_id);
create index idx_contratos_empresa_status    on contratos (empresa_id, status);
create index idx_contas_receber_vencimento   on contas_receber (empresa_id, data_vencimento, status);
create index idx_contas_pagar_vencimento     on contas_pagar (empresa_id, data_vencimento, status);
create index idx_despesas_data               on despesas (empresa_id, data_despesa);


-- ---------------------------------------------------------------------
-- 5. VIEWS
-- ---------------------------------------------------------------------

-- Quadro Kanban de orçamentos (uma coluna por status).
create view v_orcamentos_kanban as
select o.id, o.empresa_id, o.numero, o.status, o.titulo,
       o.data_emissao, o.validade, o.valor_total,
       cl.nome as cliente_nome,
       u.nome  as vendedor_nome
from orcamentos o
left join clientes cl on cl.id = o.cliente_id
left join usuarios u  on u.id  = o.vendedor_id
order by o.created_at desc;

-- Agenda: próximos compromissos com dados de contato do cliente.
create view v_proximos_compromissos as
select c.id, c.empresa_id, c.titulo, c.tipo, c.status,
       c.data_inicio, c.data_fim,
       cl.nome as cliente_nome, cl.whatsapp as cliente_whatsapp,
       c.endereco_texto,
       u.nome as responsavel_nome
from compromissos c
left join clientes cl on cl.id = c.cliente_id
left join usuarios u  on u.id  = c.responsavel_id
where c.data_inicio >= now()
order by c.data_inicio;

-- Indicadores do mês corrente, um registro por empresa (cards do dashboard).
create view v_dashboard_mensal as
select
  e.id as empresa_id,
  date_trunc('month', current_date)::date as mes_referencia,
  coalesce((select sum(c.valor_total) from contratos c
            where c.empresa_id = e.id and c.status <> 'cancelado'
              and date_trunc('month', c.data_contrato) = date_trunc('month', current_date)), 0) as faturamento_mes,
  coalesce((select sum(cr.valor) from contas_receber cr
            where cr.empresa_id = e.id and cr.status = 'recebido'
              and date_trunc('month', cr.data_recebimento) = date_trunc('month', current_date)), 0) as recebido_mes,
  coalesce((select sum(cp.valor) from contas_pagar cp
            where cp.empresa_id = e.id and cp.status = 'pago'
              and date_trunc('month', cp.data_pagamento) = date_trunc('month', current_date)), 0) as pago_mes,
  coalesce((select sum(d.valor) from despesas d
            where d.empresa_id = e.id
              and date_trunc('month', d.data_despesa) = date_trunc('month', current_date)), 0) as despesas_mes,
  (select count(*) from clientes cl
     where cl.empresa_id = e.id
       and date_trunc('month', cl.created_at) = date_trunc('month', current_date)) as novos_clientes_mes,
  (select count(*) from orcamentos o
     where o.empresa_id = e.id
       and date_trunc('month', o.data_emissao) = date_trunc('month', current_date)) as orcamentos_mes,
  (select count(*) from orcamentos o
     where o.empresa_id = e.id and o.status in ('aprovado', 'convertido_contrato')
       and date_trunc('month', o.data_emissao) = date_trunc('month', current_date)) as orcamentos_aprovados_mes,
  (select count(*) from contratos c
     where c.empresa_id = e.id and c.status <> 'cancelado'
       and date_trunc('month', c.data_contrato) = date_trunc('month', current_date)) as contratos_fechados_mes,
  (select count(*) from compromissos a
     where a.empresa_id = e.id
       and date_trunc('month', a.data_inicio) = date_trunc('month', current_date)) as compromissos_mes
from empresas e;


-- ---------------------------------------------------------------------
-- 6. FUNÇÕES E TRIGGERS
-- ---------------------------------------------------------------------

-- 6.1 Atualiza updated_at automaticamente em todo UPDATE.
create or replace function set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

do $$
declare
  t text;
begin
  foreach t in array array[
    'empresas', 'usuarios', 'clientes', 'enderecos', 'compromissos', 'visitas',
    'medicoes', 'fornecedores', 'produtos_servicos', 'orcamentos', 'orcamento_itens',
    'orcamento_custos', 'contratos', 'parcelas', 'contas_receber', 'contas_pagar',
    'despesas', 'lancamentos_financeiros'
  ] loop
    execute format(
      'create trigger set_updated_at_%1$s before update on %1$I
       for each row execute function set_updated_at()', t);
  end loop;
end;
$$;

-- 6.2 Recalcula subtotal, custo, valor final e margem de lucro do orçamento.
create or replace function recalcular_orcamento(p_orcamento_id uuid)
returns void
language plpgsql
as $$
declare
  v_subtotal    numeric(12,2);
  v_custo_total numeric(12,2);
  v_desconto    numeric(12,2);
  v_valor_total numeric(12,2);
begin
  select coalesce(sum(total), 0) into v_subtotal
  from orcamento_itens where orcamento_id = p_orcamento_id;

  select coalesce(sum(valor_total), 0) into v_custo_total
  from orcamento_custos where orcamento_id = p_orcamento_id;

  select coalesce(desconto_valor, 0) into v_desconto
  from orcamentos where id = p_orcamento_id;

  v_valor_total := greatest(v_subtotal - v_desconto, 0);

  update orcamentos set
    subtotal                = v_subtotal,
    custo_total             = v_custo_total,
    valor_total             = v_valor_total,
    margem_lucro_valor      = v_valor_total - v_custo_total,
    margem_lucro_percentual = case when v_valor_total > 0
                                   then round((v_valor_total - v_custo_total) / v_valor_total * 100, 2)
                                   else 0 end
  where id = p_orcamento_id;
end;
$$;

-- 6.3 Dispara o recálculo sempre que um item ou custo é inserido, alterado ou removido.
create or replace function trigger_recalcular_orcamento()
returns trigger
language plpgsql
as $$
begin
  if tg_op = 'DELETE' then
    perform recalcular_orcamento(old.orcamento_id);
    return old;
  else
    perform recalcular_orcamento(new.orcamento_id);
    return new;
  end if;
end;
$$;

create trigger recalcular_orcamento_itens
  after insert or update or delete on orcamento_itens
  for each row execute function trigger_recalcular_orcamento();

create trigger recalcular_orcamento_custos
  after insert or update or delete on orcamento_custos
  for each row execute function trigger_recalcular_orcamento();


-- ---------------------------------------------------------------------
-- 7. SEGURANÇA — ROW LEVEL SECURITY (RLS)
--    Com RLS ativo, o Supabase só devolve linhas permitidas por uma policy.
--    Aqui, qualquer usuário autenticado acessa os dados.
--    Melhoria planejada: filtrar por empresa_id do usuário logado
--    (ver README, "Próximos passos").
-- ---------------------------------------------------------------------
do $$
declare
  t text;
begin
  foreach t in array array[
    'empresas', 'usuarios', 'clientes', 'enderecos', 'compromissos', 'visitas',
    'medicoes', 'fornecedores', 'produtos_servicos', 'orcamentos', 'orcamento_itens',
    'orcamento_custos', 'contratos', 'parcelas', 'contas_receber', 'contas_pagar',
    'despesas', 'lancamentos_financeiros', 'anexos', 'notificacoes', 'logs_atividades'
  ] loop
    execute format('alter table %I enable row level security', t);
    execute format(
      'create policy acesso_autenticado on %I for all to authenticated
       using (true) with check (true)', t);
  end loop;
end;
$$;
