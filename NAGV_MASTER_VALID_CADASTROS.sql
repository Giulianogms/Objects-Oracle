CREATE OR REPLACE VIEW CONSINCO.NAGV_MASTER_VALID_CADASTROS AS 
-- Criado por Giuliano - 05/01/2024 | Tkt 340887
-- Master Cadastros | Reune validação de outras views em uma única query

SELECT SEQPRODUTO PLU, SEQFAMILIA COD_FAMILIA, DESCCOMPLETA DESC_PRODUTO,
       'Inconsistência(s): '||INC1||
       CASE WHEN INC2 IS NOT NULL THEN ' | '||INC2 ELSE NULL END||
       CASE WHEN INC3 IS NOT NULL THEN ' | '||INC3 ELSE NULL END||
       CASE WHEN INC4 IS NOT NULL THEN ' | '||INC4 ELSE NULL END||
       CASE WHEN INC5 IS NOT NULL THEN ' | '||INC5 ELSE NULL END||
       CASE WHEN INC6 IS NOT NULL THEN ' | '||INC6 ELSE NULL END||
       CASE WHEN INC7 IS NOT NULL THEN ' | '||INC7 ELSE NULL END||
       CASE WHEN INC8 IS NOT NULL THEN ' | '||INC8 ELSE NULL END
       INCONSISTENCIAS
  FROM (

SELECT /*+OPTIMIZER_FEATURES_ENABLE('11.2.0.4')*/
       SEQPRODUTO, SEQFAMILIA, DESCCOMPLETA,
       -- Comeca Case de Tratativas
       -- Familias sem fleg Participa Controle Estoque ST
       CASE WHEN EXISTS (
       SELECT 1 FROM CONSINCO.MAP_FAMDIVISAO X
        WHERE NVL(X.INDMERCENQUADST, 'X') != 'S'
          AND X.SEQFAMILIA =  MP.SEQFAMILIA)
       THEN 'Sem fleg Participa Controle Estoque ST' END INC1,
       -- Famílias sem NCM e CST PIS e COFINS
       CASE WHEN EXISTS (
       SELECT 1 FROM MAP_FAMILIA F
        WHERE F.SEQFAMILIA = MP.SEQFAMILIA
          AND (F.CODNBMSH IS NULL
           OR F.SITUACAONFPIS IS NULL
           OR F.SITUACAONFCOFINS IS NULL
           OR F.SITUACAONFIPISAI IS NULL
           OR F.SITUACAONFCOFINSSAI IS NULL)
          )
       THEN 'Sem NCM e CST PIS/COFINS'               END INC2,
       -- Prod sem EAN com fleg 'EAN TRIB DANFE'
       CASE WHEN EXISTS (
         SELECT 1 FROM MAP_PRODCODIGO X
          WHERE X.SEQPRODUTO NOT IN (SELECT DISTINCT SEQPRODUTO FROM MAP_PRODCODIGO Z WHERE Z.TIPCODIGO = 'E' AND Z.INDEANTRIBNFE = 'S' AND Z.SEQPRODUTO = X.SEQPRODUTO)
            AND X.TIPCODIGO = 'E'
            AND X.SEQPRODUTO = MP.SEQPRODUTO)
       THEN 'Sem EAN com fleg "EAN TRIB DANFE"'      END INC3,
       -- Saída CST IPI diferente de 50/53
       CASE WHEN EXISTS (
         SELECT 1 FROM CONSINCO.MAP_FAMILIA X
          WHERE NVL(X.SITUACAONFIPISAI, 0) NOT IN (50, 53) AND X.SEQFAMILIA =  MP.SEQFAMILIA)
       THEN 'CST IPI Saida diferente de 50/53'       END INC4,
       -- Tributação/Origem IMP x NAC
       CASE WHEN EXISTS (
         SELECT 1 FROM CONSINCO.MAP_FAMDIVISAO A LEFT JOIN CONSINCO.MAP_TRIBUTACAO B ON A.NROTRIBUTACAO = B.NROTRIBUTACAO
          WHERE A.SEQFAMILIA = MP.SEQFAMILIA
            AND ((UPPER(TRIBUTACAO) LIKE '%IMP%' OR UPPER(TRIBUTACAO) LIKE 'IM%')    AND CODORIGEMTRIB NOT IN (1,2,3,8) AND UPPER(TRIBUTACAO) NOT LIKE '%LIMP%'
             OR  UPPER(TRIBUTACAO) LIKE '%IMP.LIMP%'                                AND CODORIGEMTRIB NOT IN (1,2,3,8)))
       THEN 'IMP/IM.D com origem NAC'                END INC5,
       -- Tributação/Origem NAC x IMP
       CASE WHEN EXISTS (
         SELECT 1 FROM CONSINCO.MAP_FAMDIVISAO A LEFT JOIN CONSINCO.MAP_TRIBUTACAO B ON A.NROTRIBUTACAO = B.NROTRIBUTACAO
          WHERE A.SEQFAMILIA = MP.SEQFAMILIA
           AND (TRIBUTACAO NOT LIKE '%IMP%'   AND CODORIGEMTRIB NOT IN (0,4,5,6,7) AND TRIBUTACAO NOT LIKE 'IM%'
             OR TRIBUTACAO NOT LIKE 'IM%'     AND CODORIGEMTRIB NOT IN (0,4,5,6,7) AND TRIBUTACAO NOT LIKE 'IMP%'
             OR TRIBUTACAO     LIKE '%LIMP%'  AND CODORIGEMTRIB NOT IN (0,4,5,6,7) AND TRIBUTACAO NOT LIKE 'IMP%'))

       THEN 'NAC com origem IMP'                     END INC6,
       -- Aliquota = 0 e CST IPI Diferente de 03
       CASE WHEN EXISTS (
          SELECT 1 FROM CONSINCO.MAP_PRODUTO X INNER JOIN CONSINCO.MAP_FAMILIA    Z ON X.SEQFAMILIA = Z.SEQFAMILIA
                                               INNER JOIN CONSINCO.MAP_FAMFORNEC  F ON F.SEQFAMILIA = Z.SEQFAMILIA
                                               INNER JOIN CONSINCO.GE_PESSOA      G ON G.SEQPESSOA  = F.SEQFORNECEDOR
           WHERE NVL(Z.ALIQUOTAIPI,0) = 0 
             AND NVL(Z.SITUACAONFIPI, '123') != '03'
             AND F.PRINCIPAL = 'S'
             AND G.UF = 'EX'
             AND X.SEQPRODUTO = MP.SEQPRODUTO)
       THEN '(EX) Aliquota = 0 e CST IPI Diferente de 03' END INC7,
      -- Aliquota != 0 e CST IPI Diferente de 00
       CASE WHEN EXISTS (
          SELECT 1 FROM CONSINCO.MAP_PRODUTO X INNER JOIN CONSINCO.MAP_FAMILIA    Z ON X.SEQFAMILIA = Z.SEQFAMILIA
                                               INNER JOIN CONSINCO.MAP_FAMFORNEC  F ON F.SEQFAMILIA = Z.SEQFAMILIA
                                               INNER JOIN CONSINCO.GE_PESSOA      G ON G.SEQPESSOA  = F.SEQFORNECEDOR
           WHERE NVL(Z.ALIQUOTAIPI,0) > 0 
             AND NVL(Z.SITUACAONFIPI, '123') != '00'
             AND F.PRINCIPAL = 'S'
             AND G.UF = 'EX'
             AND X.SEQPRODUTO = MP.SEQPRODUTO)
       THEN '(EX) Aliquota MAIOR que 0 e CST IPI Diferente de 00' END INC8

  FROM MAP_PRODUTO MP) vMaster WHERE COALESCE(INC1, INC2, INC3, INC4, INC5, INC6, INC7, INC8) IS NOT NULL
;

  
