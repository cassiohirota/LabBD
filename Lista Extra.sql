create view custoCli as 
select IDCLIENTE, min(custo_chamada) as minimo_custo, max(custo_chamada) as maximo_custo from chamadas
group by IDCLIENTE;

select * from custoCli;

select distinct chamadas.idcliente, data, cidade from chamadas 
inner join CLIENTECALL on chamadas.IDCLIENTE=CLIENTECALL.IDCLIENTE
where cidade = 'Sorocaba' and data  in (select data from chamadas
where EXTRACT(YEAR FROM TO_DATE(data, 'DD-MM-YY')) = 2021);

select chamadas.idcliente, data, cidade from chamadas 
inner join CLIENTECALL on chamadas.IDCLIENTE=CLIENTECALL.IDCLIENTE
where cidade = 'Sorocaba'
intersect
select chamadas.idcliente, data, cidade from chamadas
inner join CLIENTECALL on chamadas.IDCLIENTE=CLIENTECALL.IDCLIENTE
where EXTRACT(YEAR FROM TO_DATE(data, 'DD-MM-YY')) = 2021;

delete from setor where idsetor = (select setor.idsetor from setor
where setor.idsetor not in (select idsetor from chamadas));