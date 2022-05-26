create or replace procedure SP_comissao (Pcodvendedor number)
as
Vcodvendedor tb_vendedor.codvendedor%type;
VTotal number;

Begin
select codvendedor into Vcodvendedor from tb_vendedor where codvendedor = Pcodvendedor;
select sum(tb_item_do_pedido.qtde * tb_produto.Valor_unit) into VTotal from tb_pedido 
inner join tb_item_do_pedido on tb_pedido.numpedido = tb_item_do_pedido.numpedido
inner join tb_produto on tb_item_do_pedido.codproduto = tb_produto.codproduto
and tb_pedido.codvendedor = 15;

if VTotal is null then
	update tb_vendedor set faixa_com = 0.00 where codvendedor = Pcodvendedor;	
else
	if VTotal < 100.00 then
		update tb_vendedor set faixa_com = 10.00 where codvendedor = Pcodvendedor;	
	else if VTotal between 100.00 and 1000.00 then
		update tb_vendedor set faixa_com = 15.00 where codvendedor = Pcodvendedor;
	else 
			update tb_vendedor set faixa_com = 20.00 where codvendedor = Pcodvendedor;
	end if;
	end if;
end if;
Exception
	when no_data_found then
		insert into tab_erro values (sysdate, 'Codigo do vendedor inexistente - ' || Pcodvendedor);
end;


------------------------------------------------------------------------
create or replace procedure SP_verificaproduto2 (codprod number)
as
descricao TB_PRODUTO.DESCRICAO%type;
cont number;
Begin

select descricao into descricao from tb_produto
where codproduto = codprod;

select count(numpedido) into cont from tb_item_pedido
where codproduto = codprod;

  if cont = 0 then
    insert into tablog values(sysdate, codprod || ' - ' || descricao, user);
    delete from tb_produto where CODPRODUTO = codprod;
  end if;
Exception
  when no_data_found then
    insert into tab_erro values (sysdate,codprod || ' - Código do produto inexistente');
end;

----------------------------------------------------------------------
alter table tb_produto add qtdestoq number(5);
update tb_produto set QTDESTOQ = 120;

---------------------------------------------

Function ............ return varchar2
to_char(p_data, 'dd/mm/yyyy:HH24:mi:ss')
