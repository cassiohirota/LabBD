create or replace procedure SPatualizar_preco (unidade CHAR)
as
 Vtotal number;
begin
  select count(*) into Vtotal from tb_produto where UNID = unidade; 

  if Vtotal >= 1 then
      update tb_produto set VALOR_UNIT = VALOR_UNIT * 1.1 where UNID = unidade;
      insert into tablog values (sysdate, 'Produto com preço modificado=' || descricao, Vtotal);
  end if;

Exception
    when no_data_found then
    insert into tab_erro values (sysdate, 'unidade não existente - ' || unidade);
end;