CREATE OR REPLACE FUNCTION CONSINCO.NAGF_BUSCATRIB_BKS (psCodAcesso  IN CONSINCO.MAP_PRODCODIGO.CODACESSO%TYPE,
                                                        psNroEmpresa IN NUMBER)

RETURN VARCHAR2 IS
   vsTipoTributacao VARCHAR2(1);

BEGIN
  SELECT TIPOTRIBUTACAO 
  INTO vsTipoTributacao
  FROM CONSINCO.MRL_TRIBUTACAOPDV X
 WHERE X.NROTRIBUTACAO = 
         (SELECT NROTRIBUTACAO FROM CONSINCO.MAP_FAMDIVISAO WHERE SEQFAMILIA = 
                 (SELECT SEQFAMILIA FROM CONSINCO.MAP_PRODUTO WHERE SEQPRODUTO =
                        (SELECT SEQPRODUTO FROM CONSINCO.MAP_PRODCODIGO C WHERE CODACESSO = psCodAcesso AND C.TIPCODIGO IN ('E','B'))))
   AND X.NROEMPRESA = psNroEmpresa;
    
RETURN vsTipoTributacao;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    vsTipoTributacao := NULL;

END;
