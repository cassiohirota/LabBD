create or replace procedure SP_calcula_comissao (Pcodvendedor number)
as
Vcod TB_VENDEDOR.CODVENDEDOR%TYPE;
Vtotal number;
begin

select codvendedor into Vcod from TB_VENDEDOR where codvendedor = Pcodvendedor;

select sum(tb_item_pedido.QTDE * tb_produto.VALOR_UNIT) into Vtotal from tb_pedido 
inner join tb_item_pedido on TB_PEDIDO.NUMPEDIDO = TB_ITEM_PEDIDO.NUMPEDIDO
inner join tb_produto on tb_item_pedido.CODPRODUTO = tb_produto.CODPRODUTO
where tb_pedido.CODVENDEDOR = Pcodvendedor;

if Vtotal < 100.00 then
    update tb_vendedor set faixa_com = 0.0;
  else if Vtotal <=1000.00 then
    update tb_vendedor set faixa_com = 15.0;
  else
    update tb_vendedor set faixa_com = 20.0;
  end if;
  end if;
exception
  when no_data_found then
    insert into tab_erro values (sysdate, 'Código do vendedor inválido');
    
end;