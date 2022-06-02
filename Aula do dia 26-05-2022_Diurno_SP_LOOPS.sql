-- aula dia 26-05 Diurno
-- PROCEDURES 03

SELECT * FROM MEDICO

ALTER TABLE TB_PRODUTO ADD qtdestoq number(5);

SELECT * FROM TB_PRODUTO;

UPDATE TB_PRODUTO 
SET QTDESTOQ = 120;

Create or replace procedure P_verificaEstoque ( Pcodprod number, Pqtde_retirada number) 
as
E_estoque exception;
vqtde TB_produto.qtdestoq%type;
begin

 insert into tab_erro values (sysdate,'testar se a excecao dá rollback');

 select qtdestoq into vqtde from TB_produto 
 where codproduto = pcodprod;

if vqtde < Pqtde_retirada then 
      raise E_estoque;
else
   update TB_produto
      set qtdestoq = qtdestoq - Pqtde_retirada
    where codproduto = pcodprod;

end if;
commit;
exception
  when no_data_found then
     insert into tab_erro values( sysdate, 'não existe o produto'||pcodprod);

    when E_estoque then 
      -- insert into tab_erro values (sysdate,' estoque insuficiente '|| pcodprod);
      -- rollback;
      raise_application_error (-20999,' estoque insuficiente '|| pcodprod);
end;

EXEC P_verificaEstoque(11,20); -- TESTANDO COM PRODUTO QUE EXISTE

EXEC P_verificaEstoque(99,15); -- TESTANDO COM PRODUTO INEXISTENTE

EXEC P_verificaEstoque(11,150);  -- TESTANDO COM QTDE SUPERIOR A EXISTENTE

SELECT * FROM TB_PRODUTO

SELECT * FROM TAB_ERRO

delete tab_erro

TAREFA: UPLOAD NOS TEAMS DOS EXERCÍCIOS 2 E 3 DA LISTA DE PROCEDURES 4B

--- Funções definidas pelo usuario

Create or replace Function CalcDobro (p1 in number) return number 
  as
    p2 number;
 BEGIN
    p2 := p1* 2;
    Return p2;
 END;
 
 Exemplo2: Função que devolve a descrição de um produto


Create or replace Function  
          Fn_devolve_descricao(pcodprod  TB_produto.codproduto%type)
return varchar2
as
Vdesc TB_produto.descricao%type;
Begin
    Select descricao into vdesc
    From TB_produto
    Where TB_produto.codproduto = pcodprod;
    Return (vdesc);
End Fn_devolve_descricao;


Para evocar uma função:

1a. Forma:

Select numpedido, codproduto, Fn_devolve_descricao(codproduto)
From Tb_item_pedido;

Select numpedido, tb_produto.codproduto descricao
from tb_produto inner join tb_item_pedido
on tb_produto.codproduto = tb_item_pedido.codproduto;
2a. Forma

variable resultado varchar2(20)

execute :resultado := fn_devolve_descricao (11);
print :resultado

3ª forma:   formatando a saída:

select numpedido, codproduto,  substr(Fn_devolve_descricao(codproduto),1,15) as Descricao, pco_unit from Tb_item_pedido;


select Calcdobro(5) from Dual;


select valor_unit,calcdobro(valor_unit) from tb_produto;

Create or replace Function FN_verHora (Pdata date)
return varchar2
as
hora varchar2(22);
Begin
select to_char(Pdata, 'dd/mm/yy:hh24:mi:ss') into hora from dual;
return(hora);
End FN_verHora;

select FN_verHora(sysdate) from dual;