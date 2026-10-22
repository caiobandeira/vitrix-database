-- =====================================================================
--  VITRIX — Dados FICTÍCIOS de demonstração
--  Nenhum nome, telefone ou documento abaixo pertence a pessoas reais.
--  Período simulado: maio a outubro de 2026.
--  Rodar depois do schema.sql.
-- =====================================================================

-- ---------------------------------------------------------------------
-- Empresa e equipe
-- ---------------------------------------------------------------------
insert into empresas (id, nome_fantasia, cidade, estado, validade_orcamento_dias, garantia_padrao)
values ('e0000000-0000-0000-0000-000000000001', 'Vitrix Demo Vidraçaria', 'Recife', 'PE', 10, '1 ano');

insert into usuarios (id, empresa_id, nome, email, role) values
  ('a0000000-0000-0000-0000-000000000001', 'e0000000-0000-0000-0000-000000000001', 'Ana Souza',    'ana@vitrix.demo',    'admin'),
  ('a0000000-0000-0000-0000-000000000002', 'e0000000-0000-0000-0000-000000000001', 'Bruno Lima',   'bruno@vitrix.demo',  'vendedor'),
  ('a0000000-0000-0000-0000-000000000003', 'e0000000-0000-0000-0000-000000000001', 'Carla Melo',   'carla@vitrix.demo',  'vendedor'),
  ('a0000000-0000-0000-0000-000000000004', 'e0000000-0000-0000-0000-000000000001', 'Diego Rocha',  'diego@vitrix.demo',  'tecnico');

-- ---------------------------------------------------------------------
-- Clientes (created_at espalhado no período para análises mensais)
-- ---------------------------------------------------------------------
insert into clientes (id, empresa_id, responsavel_id, nome, tipo, whatsapp, origem, created_at) values
  ('c0000000-0000-0000-0000-000000000001', 'e0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000002', 'Marcos Andrade',         'pessoa_fisica', '81900000001', 'instagram', '2026-05-04'),
  ('c0000000-0000-0000-0000-000000000002', 'e0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000003', 'Condomínio Mar Azul',    'condominio',    '81900000002', 'indicacao', '2026-05-12'),
  ('c0000000-0000-0000-0000-000000000003', 'e0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000002', 'Juliana Freitas',        'pessoa_fisica', '81900000003', 'google',    '2026-06-02'),
  ('c0000000-0000-0000-0000-000000000004', 'e0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000003', 'Studio Linha Arquitetura','arquiteto',    '81900000004', 'parceiro',  '2026-06-18'),
  ('c0000000-0000-0000-0000-000000000005', 'e0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000002', 'Ricardo Teixeira',       'pessoa_fisica', '81900000005', 'whatsapp',  '2026-07-07'),
  ('c0000000-0000-0000-0000-000000000006', 'e0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000003', 'Construtora Horizonte',  'construtora',   '81900000006', 'anuncio',   '2026-07-21'),
  ('c0000000-0000-0000-0000-000000000007', 'e0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000002', 'Patrícia Nunes',         'pessoa_fisica', '81900000007', 'instagram', '2026-08-05'),
  ('c0000000-0000-0000-0000-000000000008', 'e0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000003', 'Fernando Costa',         'pessoa_fisica', '81900000008', 'indicacao', '2026-08-26'),
  ('c0000000-0000-0000-0000-000000000009', 'e0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000002', 'Clínica Bem Viver',      'empresa',       '81900000009', 'google',    '2026-09-10'),
  ('c0000000-0000-0000-0000-000000000010', 'e0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000003', 'Larissa Barros',         'pessoa_fisica', '81900000010', 'instagram', '2026-10-03');

-- ---------------------------------------------------------------------
-- Fornecedores e catálogo
-- ---------------------------------------------------------------------
insert into fornecedores (id, empresa_id, nome, produtos_fornecidos) values
  ('f0000000-0000-0000-0000-000000000001', 'e0000000-0000-0000-0000-000000000001', 'Têmpera Nordeste (fictício)', 'Vidro temperado e laminado'),
  ('f0000000-0000-0000-0000-000000000002', 'e0000000-0000-0000-0000-000000000001', 'AluPerfil PE (fictício)',      'Perfis de alumínio'),
  ('f0000000-0000-0000-0000-000000000003', 'e0000000-0000-0000-0000-000000000001', 'Ferragens Recife (fictício)',  'Ferragens e acessórios');

insert into produtos_servicos (id, empresa_id, fornecedor_id, nome, categoria, unidade, custo, preco_venda) values
  ('b0000000-0000-0000-0000-000000000001', 'e0000000-0000-0000-0000-000000000001', 'f0000000-0000-0000-0000-000000000001', 'Box de banheiro temperado 8mm', 'Box',          'm2',           260, 480),
  ('b0000000-0000-0000-0000-000000000002', 'e0000000-0000-0000-0000-000000000001', 'f0000000-0000-0000-0000-000000000001', 'Envidraçamento de varanda',     'Varanda',      'm2',           420, 780),
  ('b0000000-0000-0000-0000-000000000003', 'e0000000-0000-0000-0000-000000000001', 'f0000000-0000-0000-0000-000000000002', 'Janela de correr alumínio',     'Esquadria',    'm2',           380, 690),
  ('b0000000-0000-0000-0000-000000000004', 'e0000000-0000-0000-0000-000000000001', 'f0000000-0000-0000-0000-000000000001', 'Espelho bisotado 4mm',          'Espelho',      'm2',           150, 320),
  ('b0000000-0000-0000-0000-000000000005', 'e0000000-0000-0000-0000-000000000001', 'f0000000-0000-0000-0000-000000000002', 'Guarda-corpo em vidro',         'Guarda-corpo', 'metro_linear', 520, 950),
  ('b0000000-0000-0000-0000-000000000006', 'e0000000-0000-0000-0000-000000000001', 'f0000000-0000-0000-0000-000000000001', 'Porta pivotante temperada',     'Porta',        'm2',           480, 890),
  ('b0000000-0000-0000-0000-000000000007', 'e0000000-0000-0000-0000-000000000001', null,                                   'Manutenção preventiva',         'Serviço',      'servico',      80,  250);

-- ---------------------------------------------------------------------
-- Orçamentos
-- Os totais (subtotal, custo, margem) ficam zerados aqui de propósito:
-- o trigger recalcular_orcamento preenche tudo quando itens e custos entram.
-- ---------------------------------------------------------------------
insert into orcamentos (id, empresa_id, cliente_id, vendedor_id, numero, status, titulo, data_emissao, validade, desconto_valor, motivo_recusa) values
  ('d0000000-0000-0000-0000-000000000001', 'e0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000002', 1,  'convertido_contrato', 'Box banheiro suíte',          '2026-05-06', '2026-05-16', 0,   null),
  ('d0000000-0000-0000-0000-000000000002', 'e0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000003', 2,  'convertido_contrato', 'Guarda-corpo área da piscina', '2026-05-15', '2026-05-25', 500, null),
  ('d0000000-0000-0000-0000-000000000003', 'e0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000002', 3,  'recusado',            'Varanda gourmet',              '2026-06-04', '2026-06-14', 0,   'Preço acima do esperado'),
  ('d0000000-0000-0000-0000-000000000004', 'e0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000004', 'a0000000-0000-0000-0000-000000000003', 4,  'convertido_contrato', 'Espelhos e porta pivotante',   '2026-06-20', '2026-06-30', 0,   null),
  ('d0000000-0000-0000-0000-000000000005', 'e0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000005', 'a0000000-0000-0000-0000-000000000002', 5,  'convertido_contrato', 'Envidraçamento de varanda',    '2026-07-09', '2026-07-19', 300, null),
  ('d0000000-0000-0000-0000-000000000006', 'e0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000006', 'a0000000-0000-0000-0000-000000000003', 6,  'recusado',            'Janelas bloco B',              '2026-07-23', '2026-08-02', 0,   'Fechou com concorrente'),
  ('d0000000-0000-0000-0000-000000000007', 'e0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000006', 'a0000000-0000-0000-0000-000000000003', 7,  'convertido_contrato', 'Janelas bloco A',              '2026-08-01', '2026-08-11', 1500,null),
  ('d0000000-0000-0000-0000-000000000008', 'e0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000007', 'a0000000-0000-0000-0000-000000000002', 8,  'convertido_contrato', 'Box + espelho banheiro social','2026-08-07', '2026-08-17', 0,   null),
  ('d0000000-0000-0000-0000-000000000009', 'e0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000008', 'a0000000-0000-0000-0000-000000000003', 9,  'vencido',             'Porta pivotante entrada',      '2026-08-28', '2026-09-07', 0,   null),
  ('d0000000-0000-0000-0000-000000000010', 'e0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000009', 'a0000000-0000-0000-0000-000000000002', 10, 'convertido_contrato', 'Divisórias e manutenção',      '2026-09-12', '2026-09-22', 0,   null),
  ('d0000000-0000-0000-0000-000000000011', 'e0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000002', 11, 'convertido_contrato', 'Varanda gourmet (revisado)',   '2026-09-20', '2026-09-30', 800, null),
  ('d0000000-0000-0000-0000-000000000012', 'e0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000010', 'a0000000-0000-0000-0000-000000000003', 12, 'em_negociacao',       'Box e janela quarto',          '2026-10-05', '2026-10-15', 0,   null),
  ('d0000000-0000-0000-0000-000000000013', 'e0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000002', 13, 'enviado',             'Espelho sala',                 '2026-10-14', '2026-10-24', 0,   null),
  ('d0000000-0000-0000-0000-000000000014', 'e0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000008', 'a0000000-0000-0000-0000-000000000003', 14, 'rascunho',            'Janela cozinha',               '2026-10-19', '2026-10-29', 0,   null);

select setval('orcamentos_numero_seq', 14);

-- Itens: o total é calculado aqui a partir das medidas e do preço do catálogo.
insert into orcamento_itens (empresa_id, orcamento_id, produto_servico_id, ambiente, descricao,
                             largura_m, altura_m, quantidade, unidade, preco_unitario, custo_unitario, total)
select 'e0000000-0000-0000-0000-000000000001', v.orcamento_id::uuid, p.id, v.ambiente, p.nome,
       v.largura, v.altura, v.qtd, p.unidade, p.preco_venda, p.custo,
       round(p.preco_venda * case when p.unidade = 'm2' then v.largura * v.altura * v.qtd else v.qtd end, 2)
from (values
  ('d0000000-0000-0000-0000-000000000001', 'Box de banheiro temperado 8mm', 'Suíte',          1.20, 1.90, 1),
  ('d0000000-0000-0000-0000-000000000002', 'Guarda-corpo em vidro',         'Piscina',        0,    0,    18),
  ('d0000000-0000-0000-0000-000000000003', 'Envidraçamento de varanda',     'Varanda',        4.50, 2.40, 1),
  ('d0000000-0000-0000-0000-000000000004', 'Espelho bisotado 4mm',          'Recepção',       2.00, 1.50, 2),
  ('d0000000-0000-0000-0000-000000000004', 'Porta pivotante temperada',     'Entrada',        1.20, 2.40, 1),
  ('d0000000-0000-0000-0000-000000000005', 'Envidraçamento de varanda',     'Varanda',        5.20, 2.40, 1),
  ('d0000000-0000-0000-0000-000000000006', 'Janela de correr alumínio',     'Apartamentos',   1.50, 1.20, 16),
  ('d0000000-0000-0000-0000-000000000007', 'Janela de correr alumínio',     'Apartamentos',   1.50, 1.20, 16),
  ('d0000000-0000-0000-0000-000000000008', 'Box de banheiro temperado 8mm', 'Banheiro social',1.00, 1.90, 1),
  ('d0000000-0000-0000-0000-000000000008', 'Espelho bisotado 4mm',          'Banheiro social',0.80, 1.00, 1),
  ('d0000000-0000-0000-0000-000000000009', 'Porta pivotante temperada',     'Entrada',        1.40, 2.60, 1),
  ('d0000000-0000-0000-0000-000000000010', 'Porta pivotante temperada',     'Consultórios',   0.90, 2.20, 4),
  ('d0000000-0000-0000-0000-000000000010', 'Manutenção preventiva',         'Geral',          0,    0,    2),
  ('d0000000-0000-0000-0000-000000000011', 'Envidraçamento de varanda',     'Varanda',        4.50, 2.40, 1),
  ('d0000000-0000-0000-0000-000000000012', 'Box de banheiro temperado 8mm', 'Suíte',          1.10, 1.90, 1),
  ('d0000000-0000-0000-0000-000000000012', 'Janela de correr alumínio',     'Quarto',         1.50, 1.20, 1),
  ('d0000000-0000-0000-0000-000000000013', 'Espelho bisotado 4mm',          'Sala',           2.50, 1.80, 1),
  ('d0000000-0000-0000-0000-000000000014', 'Janela de correr alumínio',     'Cozinha',        1.20, 1.00, 1)
) as v(orcamento_id, produto, ambiente, largura, altura, qtd)
join produtos_servicos p on p.nome = v.produto;

-- Custos internos: material (custo de catálogo) + instalação (12% do material).
insert into orcamento_custos (empresa_id, orcamento_id, descricao, categoria, quantidade, valor_unitario, valor_total)
select empresa_id, orcamento_id, 'Material', 'material', 1, sum(t), sum(t)
from (select empresa_id, orcamento_id,
             custo_unitario * case when unidade = 'm2' then area_m2 else quantidade end as t
      from orcamento_itens) x
group by empresa_id, orcamento_id;

insert into orcamento_custos (empresa_id, orcamento_id, descricao, categoria, quantidade, valor_unitario, valor_total)
select empresa_id, orcamento_id, 'Instalação', 'mao_de_obra', 1, round(valor_total * 0.12, 2), round(valor_total * 0.12, 2)
from orcamento_custos where categoria = 'material';

-- ---------------------------------------------------------------------
-- Contratos (um por orçamento convertido)
-- ---------------------------------------------------------------------
insert into contratos (empresa_id, orcamento_id, cliente_id, responsavel_id, status,
                       data_contrato, data_conclusao, valor_total, entrada_valor, saldo_valor,
                       custo_previsto, lucro_estimado)
select o.empresa_id, o.id, o.cliente_id, o.vendedor_id,
       case when o.data_emissao < '2026-09-01' then 'concluido'::contrato_status else 'em_producao' end,
       o.data_emissao + 4,
       case when o.data_emissao < '2026-09-01' then o.data_emissao + 30 end,
       o.valor_total, round(o.valor_total * 0.4, 2), o.valor_total - round(o.valor_total * 0.4, 2),
       o.custo_total, o.margem_lucro_valor
from orcamentos o
where o.status = 'convertido_contrato'
order by o.numero;

update orcamentos o
set aprovado_em = c.data_contrato
from contratos c
where c.orcamento_id = o.id;

-- Parcelas: entrada (40%) + saldo em 2 vezes, vencimentos mensais.
insert into parcelas (empresa_id, contrato_id, cliente_id, numero_parcela, descricao, valor, data_vencimento, data_pagamento, forma_pagamento, status)
select c.empresa_id, c.id, c.cliente_id, n,
       case n when 1 then 'Entrada' else 'Parcela ' || n end,
       case n when 1 then c.entrada_valor else round(c.saldo_valor / 2, 2) end,
       c.data_contrato + (n - 1) * 30,
       case when c.data_contrato + (n - 1) * 30 <= date '2026-10-21' then c.data_contrato + (n - 1) * 30 + 2 end,
       case n when 1 then 'pix' else 'cartao' end,
       case when c.data_contrato + (n - 1) * 30 <= date '2026-10-21' then 'recebido'::pagamento_status else 'pendente' end
from contratos c
cross join generate_series(1, 3) as n;

insert into contas_receber (empresa_id, cliente_id, contrato_id, parcela_id, descricao, valor,
                            data_vencimento, data_recebimento, forma_pagamento, numero_parcela, status)
select p.empresa_id, p.cliente_id, p.contrato_id, p.id, 'Contrato nº ' || c.numero || ' — ' || p.descricao,
       p.valor, p.data_vencimento, p.data_pagamento, p.forma_pagamento, p.numero_parcela, p.status
from parcelas p join contratos c on c.id = p.contrato_id;

-- ---------------------------------------------------------------------
-- Contas a pagar e despesas (fixas mensais + compras de material)
-- ---------------------------------------------------------------------
insert into contas_pagar (empresa_id, fornecedor_id, descricao, categoria, valor, data_vencimento, data_pagamento, status)
select 'e0000000-0000-0000-0000-000000000001', null, d.descricao, d.categoria, d.valor,
       (m + interval '9 days')::date,
       case when (m + interval '9 days')::date <= date '2026-10-21' then (m + interval '8 days')::date end,
       case when (m + interval '9 days')::date <= date '2026-10-21' then 'pago'::pagamento_status else 'pendente' end
from generate_series(date '2026-05-01', date '2026-10-01', interval '1 month') as m
cross join (values ('Aluguel do galpão', 'aluguel', 2200.00),
                   ('Energia elétrica',  'utilidades', 480.00),
                   ('Combustível',       'transporte', 650.00)) as d(descricao, categoria, valor);

insert into contas_pagar (empresa_id, fornecedor_id, contrato_id, descricao, categoria, valor, data_compra, data_vencimento, data_pagamento, status)
select c.empresa_id, 'f0000000-0000-0000-0000-000000000001', c.id,
       'Material do contrato nº ' || c.numero, 'material',
       oc.valor_total, c.data_contrato, c.data_contrato + 15,
       case when c.data_contrato + 15 <= date '2026-10-21' then c.data_contrato + 14 end,
       case when c.data_contrato + 15 <= date '2026-10-21' then 'pago'::pagamento_status else 'pendente' end
from contratos c
join orcamento_custos oc on oc.orcamento_id = c.orcamento_id and oc.categoria = 'material';

insert into despesas (empresa_id, fornecedor_id, contrato_id, conta_pagar_id, categoria, descricao, valor,
                      data_despesa, fixa, variavel, recorrente, relacionada_obra)
select empresa_id, fornecedor_id, contrato_id, id, categoria, descricao, valor,
       data_pagamento, categoria <> 'material', categoria = 'material', categoria <> 'material', contrato_id is not null
from contas_pagar
where status = 'pago';

-- ---------------------------------------------------------------------
-- Agenda (inclui compromissos futuros para a view v_proximos_compromissos)
-- ---------------------------------------------------------------------
insert into compromissos (empresa_id, cliente_id, responsavel_id, titulo, tipo, status, data_inicio, data_fim, endereco_texto) values
  ('e0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000004', 'Instalação varanda gourmet',   'instalacao',        'concluido', '2026-10-08 09:00-03', '2026-10-08 15:00-03', 'Boa Viagem, Recife'),
  ('e0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000010', 'a0000000-0000-0000-0000-000000000003', 'Retorno sobre orçamento nº 12', 'retorno_cliente',   'agendado',  '2026-10-23 10:00-03', null,                  'WhatsApp'),
  ('e0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000009', 'a0000000-0000-0000-0000-000000000004', 'Instalação divisórias',        'instalacao',        'confirmado','2026-10-27 08:00-03', '2026-10-27 17:00-03', 'Graças, Recife'),
  ('e0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000008', 'a0000000-0000-0000-0000-000000000004', 'Medição janela cozinha',       'medicao',           'agendado',  '2026-10-29 14:00-03', null,                  'Casa Amarela, Recife');
