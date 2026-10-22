-- =====================================================================
--  VITRIX — Consultas analíticas
--  Perguntas de negócio respondidas em SQL. Rodar depois de schema.sql e seed.sql.
--  Técnicas usadas: JOINs, agregações, CTEs, FILTER, CASE,
--  funções de janela (SUM OVER, RANK) e datas (date_trunc, generate_series).
-- =====================================================================


-- 1. Faturamento mensal, quantidade de contratos e ticket médio
select to_char(date_trunc('month', data_contrato), 'YYYY-MM') as mes,
       count(*)                                               as contratos,
       sum(valor_total)                                       as faturamento,
       round(avg(valor_total), 2)                             as ticket_medio
from contratos
where status <> 'cancelado'
group by 1
order by 1;


-- 2. Desempenho por vendedor: taxa de conversão e valor vendido
select u.nome as vendedor,
       count(*)                                                        as orcamentos,
       count(*) filter (where o.status = 'convertido_contrato')        as convertidos,
       round(100.0 * count(*) filter (where o.status = 'convertido_contrato')
             / count(*), 1)                                            as taxa_conversao_pct,
       coalesce(sum(o.valor_total) filter (where o.status = 'convertido_contrato'), 0) as valor_vendido
from orcamentos o
join usuarios u on u.id = o.vendedor_id
group by u.nome
order by valor_vendido desc;


-- 3. Margem bruta por categoria de produto (itens de orçamentos convertidos,
--    antes de descontos e da mão de obra)
select p.categoria,
       sum(i.total)                                                        as receita,
       round(sum(i.custo_unitario * case when i.unidade = 'm2' then i.area_m2 else i.quantidade end), 2) as custo_material,
       round(100.0 * (sum(i.total)
             - sum(i.custo_unitario * case when i.unidade = 'm2' then i.area_m2 else i.quantidade end))
             / nullif(sum(i.total), 0), 1)                                 as margem_pct
from orcamento_itens i
join orcamentos o        on o.id = i.orcamento_id
join produtos_servicos p on p.id = i.produto_servico_id
where o.status = 'convertido_contrato'
group by p.categoria
order by receita desc;


-- 4. Qual canal de aquisição traz clientes que fecham negócio?
select cl.origem,
       count(distinct cl.id)                                                    as clientes,
       count(distinct cl.id) filter (where o.status = 'convertido_contrato')    as clientes_que_fecharam,
       coalesce(sum(o.valor_total) filter (where o.status = 'convertido_contrato'), 0) as receita
from clientes cl
left join orcamentos o on o.cliente_id = cl.id
group by cl.origem
order by receita desc;


-- 5. Fluxo de caixa mensal com saldo acumulado (função de janela)
with meses as (
  select generate_series(date '2026-05-01', date '2026-10-01', interval '1 month')::date as mes
),
entradas as (
  select date_trunc('month', data_recebimento)::date as mes, sum(valor) as total
  from contas_receber where status = 'recebido' group by 1
),
saidas as (
  select date_trunc('month', data_pagamento)::date as mes, sum(valor) as total
  from contas_pagar where status = 'pago' group by 1
)
select to_char(m.mes, 'YYYY-MM')                                   as mes,
       coalesce(e.total, 0)                                         as entradas,
       coalesce(s.total, 0)                                         as saidas,
       coalesce(e.total, 0) - coalesce(s.total, 0)                  as saldo_mes,
       sum(coalesce(e.total, 0) - coalesce(s.total, 0)) over (order by m.mes) as saldo_acumulado
from meses m
left join entradas e on e.mes = m.mes
left join saidas s   on s.mes = m.mes
order by m.mes;


-- 6. Contas a receber em aberto, agrupadas por prazo de vencimento (aging)
select case
         when data_vencimento < current_date                 then 'Vencida'
         when data_vencimento <= current_date + 30           then 'Vence em até 30 dias'
         else                                                     'Vence em mais de 30 dias'
       end                as faixa,
       count(*)           as titulos,
       sum(valor)         as valor_em_aberto
from contas_receber
where status = 'pendente'
group by 1
order by min(data_vencimento);


-- 7. Ranking de produtos por receita (RANK)
select rank() over (order by sum(i.total) desc) as posicao,
       p.nome,
       count(*)      as vezes_vendido,
       sum(i.total)  as receita
from orcamento_itens i
join orcamentos o        on o.id = i.orcamento_id and o.status = 'convertido_contrato'
join produtos_servicos p on p.id = i.produto_servico_id
group by p.nome
order by posicao;


-- 8. Funil de vendas: quantos orçamentos em cada etapa e quanto dinheiro está parado
select status,
       count(*)          as orcamentos,
       sum(valor_total)  as valor
from orcamentos
group by status
order by array_position(enum_range(null::orcamento_status), status);
