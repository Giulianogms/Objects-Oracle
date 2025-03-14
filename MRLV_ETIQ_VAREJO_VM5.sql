CREATE OR REPLACE VIEW CONSINCO.MRLV_ETIQ_NAGUMO_VAREJO_VM5 AS
SELECT /*+OPTIMIZER_FEATURES_ENABLE('11.2.0.4')*/
        -- Novo modelo criado por Giuliano | 26/01/2024

       NULL MARCA, A."NROEMPRESA",A."SEQPRODUTO",A."DTABASEPRECO",A."CODACESSO",A."QTDETIQUETA",A."DTAPROMINICIO",
       A."DTAPROMFIM",A."CODACESSOPADRAO",A."EMBALAGEMPADRAO",A."PADRAOEMBVENDA",A."PRECOEMBPADRAO",A.PRECOVALIDNORMAL,A.PRECOVALIDPROMOC,A."MULTEQPEMBPADRAO",
       A."QTDUNIDEMBPADRAO",A."TIPOETIQUETA",A."TIPOPRECO",A."DESCCOMPLETA",A."DESCREDUZIDA",A."QTDEMBALAGEM1",A."MULTEQPEMB1",
       A."QTDUNIDEMB1",A."QTDEMBALAGEM2",A."MULTEQPEMB2",A."QTDUNIDEMB2",A."QTDEMBALAGEM3",A."MULTEQPEMB3",A."QTDUNIDEMB3",
       A."QTDEMBALAGEM4",A."MULTEQPEMB4",A."QTDUNIDEMB4",A."QTDEMBALAGEM5",A."MULTEQPEMB5",A."QTDUNIDEMB5",A."CODACESSO1",A."CODACESSO2",
       A."CODACESSO3",A."CODACESSO4",A."CODACESSO5",A."PRECO1",A."PRECO2",A."PRECO3",A."PRECO4",A."PRECO5",A."PRECOMIN",A."PRECOMAX",
       A."EMBALAGEM1",A."EMBALAGEM2",A."EMBALAGEM3",A."EMBALAGEM4",A."EMBALAGEM5",A."TIPOCODIGO", A.QTDEMBCODACESSO,


       '^XA' || '^PRA^FS' || '^LH00,00^FS'|| '^BY2^FS' || '^PQ' || NVL(A.QTDETIQUETA, 1) || '^FS'
       || CASE

--------- QUANDO ESTIVER NA OFERTA E QUANDO OFERTA FOI MENOR QUE PRECOO NORMAL
             WHEN (NVL(J.PRECOVALIDPROMOC,0) > 0) AND (NVL(J.PRECOVALIDPROMOC,0))  < TRUNC((A.PRECOVALIDNORMAL * A.PADRAOEMBVENDA),2)
               THEN
       -- ALTERADO POR GIULIANO | TRATAMENTO PRECO MEU NAGUMO
       CASE WHEN RPM.PRECOPPROMOCIONAL < NVL(J.PRECOVALIDPROMOC,0) AND PRECOPPROMOCIONAL > 0-- SE EXISTIR MEU NAGUMO, FORMA OFERTA + MEU NAGUMO E FOR MENOR QUE OFERTA NORMAL

       THEN                                   CHR(13) || CHR(10) ||
        '^FO90,115^GB150,4,4^FS'           || CHR(13) || CHR(10) || -- RISCO
        '^FO050,190^BY2.4^BEN,25,Y,N^FD'||A.CODACESSOPADRAO||'^FS' || CHR(13) || CHR(10) || -- EAN
        '^FO50,20^A0N,40,40^FD'||SUBSTR(A.DESCCOMPLETA,0,40) ||' '||CASE WHEN J.QTDEMBALAGEM > 1 THEN J.EMBALAGEM ELSE NULL END||'^FS' || CHR(13) || CHR(10) || -- DESC
        '^FO30,251^A0N,20,20^FD'||TO_CHAR(SYSDATE, 'DD/MM/YY HH24:MI')||'   Produto: '||A.SEQPRODUTO||'   Val. Prom.: '||
                                TO_CHAR(NAGF_INICIOPROMETIQUETA(A.NROEMPRESA, A.SEQPRODUTO, J.PRECOVALIDPROMOC), 'DD/MM/YY')||' a ' ||
                                TO_CHAR(NAGF_FIMPROMETIQUETA   (A.NROEMPRESA, A.SEQPRODUTO, J.PRECOVALIDPROMOC), 'DD/MM/YY')|| '   LJ: ' || G.NOMEREDUZIDO||'^FS' || CHR(13) || CHR(10) ||
        '^FO275,90^A0N,35,35^FDOFERTA^FS'  || CHR(13) || CHR(10) ||
        '^FO490,100^A0N,30,30^FD  R$  ^FS' || CHR(13) || CHR(10) ||
        '^FO495,76^A0N,20,20^FD  POR  ^FS' || CHR(13) || CHR(10) ||
        '^FO580,73^A0N,58,58^FD'||LPAD(TRUNC(J.PRECOVALIDPROMOC), 4, ' ' ) || ',' || LPAD((J.PRECOVALIDPROMOC - TRUNC(J.PRECOVALIDPROMOC)) * 100, 2, 0)||'^FS' || CHR(13) || CHR(10) || -- PROMOC
        (CASE WHEN J.MULTEQPEMB IS NOT NULL  OR J.MULTEQPEMBALAGEM IS NOT NULL THEN
        '^FO590,128^A0N,15,15^FDNesta Embalagem '||
                                CASE WHEN J.MULTEQPEMBALAGEM = 'LI' THEN 'LITRO' WHEN  J.MULTEQPEMBALAGEM = 'GR' THEN '100g' ELSE J.MULTEQPEMBALAGEM END ||' R$ ' ||
                                DECODE(SIGN(J.PRECOGERPROMOC),+1,
                                TRANSLATE(TO_CHAR(ROUND((J.PRECOGERPROMOC/(J.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','),
                                TRANSLATE(TO_CHAR(ROUND((J.PRECOGERNORMAL/(J.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','))  END )||'^FS' || CHR(13) || CHR(10) ||
        '^FO690,85^A0N,090,40^FD  ^FS'     || CHR(13) || CHR(10) ||
        '^FO50,95^A0N,25,25^FDR$^FS'       || CHR(13) || CHR(10) ||
        '^FO51,125^A0N,20,20^FDDE^FS'      || CHR(13) || CHR(10) ||
        '^FO70,92^A0N,60,60^^FD'||LPAD(TRUNC(J.PRECOVALIDNORMAL), 4, ' ' ) || ',' || LPAD((J.PRECOVALIDNORMAL - TRUNC(J.PRECOVALIDNORMAL)) * 100, 2, '0')|| '^FS' || CHR(13) || CHR(10) || -- PRECO NORMAL
        '^FO260,60^GB230,85,1^FS'          || CHR(13) || CHR(10) ||
        '^FO260,155^GB530,85,1^FS'         || CHR(13) || CHR(10) ||
        '^FO490,195^A0N,30,30^FD  R$  ^FS' || CHR(13) || CHR(10) ||
        '^FO495,175^A0N,20,20^FD  POR  ^FS'|| CHR(13) || CHR(10) ||
        (SELECT LT_IMG FROM CONSINCO.NAGT_LT_IMG) || CHR(13) || CHR(10) || -- Imagem
        '^FO400,204^A0N,20,20^FDExclusivo ^FS' || CHR(13) || CHR(10) ||
        '^FO580,167^A0N,58,58^FD'||LPAD(TRUNC(RPM.PRECOPPROMOCIONAL), 4, ' ' ) || ','||
                                   LPAD((RPM.PRECOPPROMOCIONAL -
                                   TRUNC(RPM.PRECOPPROMOCIONAL)) * 100, 2, 0)||'^FR^FS'|| CHR(13) || CHR(10) ||
        (CASE WHEN J.MULTEQPEMB IS NOT NULL  OR J.MULTEQPEMBALAGEM IS NOT NULL THEN
        '^FO590,221^A0N,15,15^FDNesta Embalagem '||
                                CASE WHEN J.MULTEQPEMBALAGEM = 'LI' THEN 'LITRO' WHEN  J.MULTEQPEMBALAGEM = 'GR' THEN '100g' ELSE J.MULTEQPEMBALAGEM END ||' R$ ' ||
                                DECODE(SIGN(RPM.PRECOPPROMOCIONAL),+1,
                                TRANSLATE(TO_CHAR(ROUND((RPM.PRECOPPROMOCIONAL/(J.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','),
                                TRANSLATE(TO_CHAR(ROUND((RPM.PRECOPPROMOCIONAL/(J.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ',')) END)||'^FS'|| CHR(13) || CHR(10) ||
        '^FO490,155^GB300,86,51^FR^FS'     || CHR(13) || CHR(10) ||
        '^FO490,60^GB300,85,50^FR^FS'

       -- FINAL PRECO MEU NAGUMO

       ELSE -- OFERTA NORMAL
                                             CHR(13) || CHR(10) ||
        '^FO90,115^GB150,4,4^FS'          || CHR(13) || CHR(10) ||-- RISCO
        '^FO050,170^BY2.4^BEN,25,Y,N^FD'||A.CODACESSOPADRAO||'^FS'|| CHR(13) || CHR(10) ||
        '^FO50,20^A0N,40,40^FD'||SUBSTR(A.DESCCOMPLETA,0,40) ||' '||CASE WHEN J.QTDEMBALAGEM > 1 THEN J.EMBALAGEM ELSE NULL END||'^FS' || CHR(13) || CHR(10) ||
        '^FO50,251^A0N,20,20^FD'||TO_CHAR(SYSDATE, 'DD/MM/YY HH24:MI')||'   Produto: '||A.SEQPRODUTO||'   Val. Prom.: '||
                                TO_CHAR(NAGF_INICIOPROMETIQUETA(A.NROEMPRESA, A.SEQPRODUTO, J.PRECOVALIDPROMOC), 'DD/MM/YY')||' a ' ||
                                TO_CHAR(NAGF_FIMPROMETIQUETA   (A.NROEMPRESA, A.SEQPRODUTO, J.PRECOVALIDPROMOC), 'DD/MM/YY')|| '   LJ: ' || G.NOMEREDUZIDO||'^FS' || CHR(13) || CHR(10) ||
        '^FO275,120^A0N,80,60^FDOFERTA^FS'|| CHR(13) || CHR(10) ||
        '^FO490,100^A0N,30,30^FD  R$  ^FS'|| CHR(13) || CHR(10) ||
        '^FO495,76^A0N,20,20^FD  POR  ^FS'|| CHR(13) || CHR(10) ||
        -- TRATATIVA LENGTH - TAMANHO PRECO PROMOC
        (CASE WHEN J.PRECOVALIDPROMOC > 99.99
        THEN
        '^FO515,90^A0N,130,90^FD'||LPAD(TRUNC(J.PRECOVALIDPROMOC), 4, ' ' ) || ',' || LPAD((J.PRECOVALIDPROMOC - TRUNC(J.PRECOVALIDPROMOC)) * 100, 2, 0)||'^FS'
        ELSE
        '^FO475,80^A0N,150,110^FD'||LPAD(TRUNC(J.PRECOVALIDPROMOC), 4, ' ' ) || ',' || LPAD((J.PRECOVALIDPROMOC - TRUNC(J.PRECOVALIDPROMOC)) * 100, 2, 0)||'^FS' END)|| CHR(13) || CHR(10) || -- PROMOC
        (CASE WHEN J.MULTEQPEMB IS NOT NULL  OR J.MULTEQPEMBALAGEM IS NOT NULL THEN
        '^FO590,215^A0N,15,15^FDNesta Embalagem '||
                                CASE WHEN J.MULTEQPEMBALAGEM = 'LI' THEN 'LITRO' WHEN  J.MULTEQPEMBALAGEM = 'GR' THEN '100g' ELSE J.MULTEQPEMBALAGEM END ||' R$ ' ||
                                DECODE(SIGN(J.PRECOGERPROMOC),+1,
                                TRANSLATE(TO_CHAR(ROUND((J.PRECOGERPROMOC/(J.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','),
                                TRANSLATE(TO_CHAR(ROUND((J.PRECOGERNORMAL/(J.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','))END )||'^FS' || CHR(13) || CHR(10) ||
        '^FO690,85^A0N,090,40^FD  ^FS'    || CHR(13) || CHR(10) ||
        '^FO50,95^A0N,25,25^FDR$^FS'      || CHR(13) || CHR(10) ||
        '^FO51,125^A0N,20,20^FDDE^FS'     || CHR(13) || CHR(10) ||
        '^FO70,92^A0N,60,60^FD'||LPAD(TRUNC(J.PRECOVALIDNORMAL), 4, ' ' ) || ',' || LPAD((J.PRECOVALIDNORMAL - TRUNC(J.PRECOVALIDNORMAL)) * 100, 2, '0')|| '^FS' || CHR(13) || CHR(10) || -- PRECO NORMAL
        '^FO260,60^GB230,180,1^FS'        || CHR(13) || CHR(10) ||
        '^FO490,60^GB300,180,100^FR^FS'

       END

--======== INICIO OFERTAS ATIVAVEIS (MEU NAGUMO) - 27/08/2024 - Giuliano ========--

        WHEN AT.PRECOPROMOCIONAL < TRUNC((A.PRECOVALIDNORMAL * A.PADRAOEMBVENDA),2) AND A.NROEMPRESA NOT IN (31,41,54) AND PRECOPPROMOCIONAL > 0
      THEN                                   CHR(13) || CHR(10) ||
        '^FO50,20^A0N,40,40^FD'||SUBSTR(A.DESCCOMPLETA,0,37) ||' '||CASE WHEN J.QTDEMBALAGEM > 1 THEN J.EMBALAGEM ELSE NULL END||'^FS' || CHR(13) || CHR(10) || -- DESC
        '^FO50,251^A0N,20,20^FD'||TO_CHAR(SYSDATE, 'DD/MM/YY HH24:MI')||'   Produto: '||A.SEQPRODUTO||'   Val. Prom.: '||
                                  TO_CHAR(AT.DTAINICIO, 'DD/MM/YY')||' a ' ||
                                  TO_CHAR(AT.DTAFIM,    'DD/MM/YY')|| '   LJ: ' || G.NOMEREDUZIDO||'^FS' || CHR(13) || CHR(10) ||
        '^FO370,90^A0N,18,18^FDATIVE ESTA^FS'|| CHR(13) || CHR(10) ||
        '^FO352,110^A0N,18,18^FDOFERTA NO APP^FS'|| CHR(13) || CHR(10) ||
        '^FO353,140^A0N,20,20^FDMEU NAGUMO^FS'  || CHR(13) || CHR(10) ||
        '^FO362,170^A0N,18,18^FDE INFORME O ^FS'|| CHR(13) || CHR(10) ||
        '^FO359,190^A0N,18,18^FDCPF NO CAIXA^FS'|| CHR(13) || CHR(10) ||
        '^FO490,100^A0N,30,30^FD  R$  ^FS'|| CHR(13) || CHR(10) ||
        '^FO495,76^A0N,20,20^FD  POR  ^FS'|| CHR(13) || CHR(10) ||
        -- TRATATIVA LENGTH - TAMANHO PRECO PROMOC ATIVAVEL
        (CASE WHEN J.PRECOVALIDPROMOC > 99.99
        THEN
        '^FO515,80^A0N,150,110^FD'||LPAD(TRUNC(AT.PRECOPROMOCIONAL), 4, ' ' ) || ',' || LPAD((AT.PRECOPROMOCIONAL - TRUNC(AT.PRECOPROMOCIONAL)) * 100, 2, '0')|| '^FS'
        ELSE
        '^FO475,80^A0N,150,110^FD'||LPAD(TRUNC(AT.PRECOPROMOCIONAL), 4, ' ' ) || ',' || LPAD((AT.PRECOPROMOCIONAL - TRUNC(AT.PRECOPROMOCIONAL)) * 100, 2, '0')|| '^FS' END)|| CHR(13) || CHR(10) || -- PROMOC
        (CASE WHEN J.MULTEQPEMB IS NOT NULL  OR J.MULTEQPEMBALAGEM IS NOT NULL THEN
        '^FO590,215^A0N,15,15^FDNesta Embalagem '||
                                CASE WHEN J.MULTEQPEMBALAGEM = 'LI' THEN 'LITRO' WHEN  J.MULTEQPEMBALAGEM = 'GR' THEN '100g' ELSE J.MULTEQPEMBALAGEM END ||' R$ ' ||
                                DECODE(SIGN(J.PRECOGERPROMOC),+1,
                                TRANSLATE(TO_CHAR(ROUND((AT.PRECOPROMOCIONAL/(J.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','),
                                TRANSLATE(TO_CHAR(ROUND((AT.PRECOPROMOCIONAL/(J.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','))END)||'^FS' || CHR(13) || CHR(10) ||
        '^FO690,85^A0N,090,40^FD  ^FS'|| CHR(13) || CHR(10) ||
        '^FO050,190^BY2.4^BEN,25,Y,N^FD'||A.CODACESSOPADRAO||'^FS'|| CHR(13) || CHR(10) ||
        '^FO50,95^A0N,25,25^FDR$^FS'|| CHR(13) || CHR(10) ||
        '^FO51,125^A0N,20,20^FD^FS'|| CHR(13) || CHR(10) ||
        (SELECT LT_IMG FROM CONSINCO.NAGT_LT_IMG3 WHERE TIPO = J.MP) || CHR(13) || CHR(10) || -- Imagem
        -- TRATATIVA LENGTH - TAMANHO PRECO NORMAL
        (CASE WHEN J.PRECOVALIDNORMAL > 99.99
        THEN
        '^FO40,75^A0N,62,62^FD'||LPAD(TRUNC(J.PRECOVALIDNORMAL), 4, ' ' ) || ',' || LPAD((J.PRECOVALIDNORMAL - TRUNC(J.PRECOVALIDNORMAL)) * 100, 2, '0')|| '^FS'
        ELSE
        '^FO40,70^A0N,72,72^FD'||LPAD(TRUNC(J.PRECOVALIDNORMAL), 4, ' ' ) || ',' || LPAD((J.PRECOVALIDNORMAL - TRUNC(J.PRECOVALIDNORMAL)) * 100, 2, '0')|| '^FS' END)|| CHR(13) || CHR(10) || -- PRECO NORMAL
        '^FO75,145^A0N,15,15^FDPRECO SEM ATIVACAO^FS'|| CHR(13) || CHR(10) ||
        '^FO75,165^A0N,15,15^FDNO APP MEU NAGUMO^FS'|| CHR(13) || CHR(10) ||
        '^FO260,60^GB230,180,1^FS'|| CHR(13) || CHR(10) ||
        '^FO490,60^GB300,180,100^FR^FS'

--======== INICIO OFERTAS EXCLUSIVAS - APENAS MEU NAGUMO SEM OFERTA C5 - 02/09/2024 - Giuliano ========--

        WHEN NVL(J.PRECOVALIDPROMOC,0) = 0 AND RPM.PRECOPPROMOCIONAL < TRUNC((A.PRECOVALIDNORMAL * A.PADRAOEMBVENDA),2) AND A.NROEMPRESA NOT IN (31,41,54) AND PRECOPPROMOCIONAL > 0
      THEN                                   CHR(13) || CHR(10) ||
        '^FO50,20^A0N,40,40^FD'||SUBSTR(A.DESCCOMPLETA,0,37) ||' '||CASE WHEN J.QTDEMBALAGEM > 1 THEN J.EMBALAGEM ELSE NULL END||'^FS' || CHR(13) || CHR(10) || -- DESC
        '^FO50,251^A0N,20,20^FD'||TO_CHAR(SYSDATE, 'DD/MM/YY HH24:MI')||'   Produto: '||A.SEQPRODUTO||'   Val. Prom.: '||
                                  TO_CHAR(RPM.DTINICIO, 'DD/MM/YY')||' a ' ||
                                  TO_CHAR(RPM.DTFIM,    'DD/MM/YY')|| '   LJ: ' || G.NOMEREDUZIDO||'^FS' || CHR(13) || CHR(10) ||
        '^FO285,80^A0N,18,18^FD- PRECO EXCLUSIVO -^FS'|| CHR(13) || CHR(10) ||
        '^FO330,100^A0N,15,15^FDPARA CLIENTE^FS'|| CHR(13) || CHR(10) ||
        '^FO310,185^A0N,18,18^FDCADASTRE-SE E^FS'|| CHR(13) || CHR(10) ||
        '^FO290,210^A0N,15,15^FDINFORME O CPF NO CAIXA^FS'|| CHR(13) || CHR(10) ||
        '^FO490,100^A0N,30,30^FD  R$  ^FS'|| CHR(13) || CHR(10) ||
        '^FO495,76^A0N,20,20^FD  POR  ^FS'|| CHR(13) || CHR(10) ||
        -- TRATATIVA LENGTH - TAMANHO PRECO PROMOC ATIVAVEL
        (CASE WHEN J.PRECOVALIDPROMOC > 99.99
        THEN
        '^FO515,80^A0N,150,110^FD'||LPAD(TRUNC(RPM.PRECOPPROMOCIONAL), 4, ' ' ) || ',' || LPAD((RPM.PRECOPPROMOCIONAL - TRUNC(RPM.PRECOPPROMOCIONAL)) * 100, 2, '0')|| '^FS'
        ELSE
        '^FO475,80^A0N,150,110^FD'||LPAD(TRUNC(RPM.PRECOPPROMOCIONAL), 4, ' ' ) || ',' || LPAD((RPM.PRECOPPROMOCIONAL - TRUNC(RPM.PRECOPPROMOCIONAL)) * 100, 2, '0')|| '^FS' END)|| CHR(13) || CHR(10) || -- PROMOC
        (CASE WHEN J.MULTEQPEMB IS NOT NULL  OR J.MULTEQPEMBALAGEM IS NOT NULL THEN
        '^FO590,215^A0N,15,15^FDNesta Embalagem '||
                                CASE WHEN J.MULTEQPEMBALAGEM = 'LI' THEN 'LITRO' WHEN  J.MULTEQPEMBALAGEM = 'GR' THEN '100g' ELSE J.MULTEQPEMBALAGEM END ||' R$ ' ||
                                DECODE(SIGN(J.PRECOGERPROMOC),+1,
                                TRANSLATE(TO_CHAR(ROUND((RPM.PRECOPPROMOCIONAL/(J.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','),
                                TRANSLATE(TO_CHAR(ROUND((RPM.PRECOPPROMOCIONAL/(J.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','))END)||'^FS' || CHR(13) || CHR(10) ||
        '^FO690,85^A0N,090,40^FD  ^FS'|| CHR(13) || CHR(10) ||
        '^FO050,190^BY2.4^BEN,25,Y,N^FD'||A.CODACESSOPADRAO||'^FS'|| CHR(13) || CHR(10) ||
        '^FO50,95^A0N,25,25^FDR$^FS'|| CHR(13) || CHR(10) ||
        '^FO51,125^A0N,20,20^FD^FS'|| CHR(13) || CHR(10) ||
        '^FO270,75,0^'||(SELECT LT_IMG FROM CONSINCO.NAGT_LT_IMG3 WHERE TIPO = 4) || CHR(13) || CHR(10) || -- Imagem MN
        -- TRATATIVA LENGTH - TAMANHO PRECO NORMAL
        (CASE WHEN J.PRECOVALIDNORMAL > 99.99
        THEN
        '^FO40,75^A0N,62,62^FD'||LPAD(TRUNC(J.PRECOVALIDNORMAL), 4, ' ' ) || ',' || LPAD((J.PRECOVALIDNORMAL - TRUNC(J.PRECOVALIDNORMAL)) * 100, 2, '0')|| '^FS'
        ELSE
        '^FO40,70^A0N,72,72^FD'||LPAD(TRUNC(J.PRECOVALIDNORMAL), 4, ' ' ) || ',' || LPAD((J.PRECOVALIDNORMAL - TRUNC(J.PRECOVALIDNORMAL)) * 100, 2, '0')|| '^FS' END)|| CHR(13) || CHR(10) || -- PRECO NORMAL
        '^FO85,145^A0N,15,15^FDPRECO PARA NAO^FS'|| CHR(13) || CHR(10) ||
        '^FO65,165^A0N,15,15^FDMEMBROS MEU NAGUMO^FS'|| CHR(13) || CHR(10) ||
        '^FO260,60^GB230,180,1^FS'|| CHR(13) || CHR(10) ||
        '^FO490,60^GB300,180,100^FR^FS'

----------- INICIO PRECO UNICO NORMAL OU PROMOCAO FOR MAIOR QUE NORMAL
         WHEN /*ROUND (A.PRECO1/A.QTDEMBALAGEM1,2) = TRUNC((A.PRECOEMBPADRAO/A.PADRAOEMBVENDA),2) OR*/
           (NVL(A.PRECOVALIDPROMOC,0) >= TRUNC((A.PRECOVALIDNORMAL/A.PADRAOEMBVENDA),2))
           THEN  CHR(13) || CHR(10) ||
        '^FO50,20^A0N,40,40^FD'||SUBSTR(A.DESCCOMPLETA,0,37) ||' '||CASE WHEN J.QTDEMBALAGEM > 1 THEN J.EMBALAGEM ELSE NULL END||'^FS' || CHR(13) || CHR(10) || -- DESC
        '^FO050,200^BY2.4^BEN,30,Y,N^FD' || A.CODACESSOPADRAO ||'^FS' --EAN COD BARRAS
      --- QR CODE ETIQUERA NORMAL
      || CHR(13) || CHR(10) || '^FO050,075^BQ,2,4^FDLA,:p:' || '1:vp:1' || '^FS'
      || CHR(13) || CHR(10) ||'^FO180,85^A0N,110,60^FDR$^FS' ||'^FS' -- R$
      || CHR(13) || CHR(10) ||'^FO350,90^A0N,170,130^FD'|| LPAD(TRUNC(A.PRECOEMBPADRAO), 4, ' ' ) || ',' || --PRECO NORMAL
                                                           LPAD((A.PRECOEMBPADRAO - TRUNC(A.PRECOEMBPADRAO)) * 100, 2, '0')|| '^FS'

----PRECO POR KG OU LI OU ETC...
||    (CASE WHEN
       J.MULTEQPEMB IS NOT NULL  OR J.MULTEQPEMBALAGEM IS NOT NULL
       THEN
CHR(13) || CHR(10) || '^FO550,255^A0N,20,19^FD' ||/* '*PRECO PAGO POR ' || J.MULTEQPEMBALAGEM ||' R$   '*/'Nesta Embalagem ' || CASE WHEN J.MULTEQPEMBALAGEM = 'LI' THEN 'LITRO'
                                                                                                                                                                                                                                                                    WHEN  J.MULTEQPEMBALAGEM = 'GR' THEN '100g'
                                                                                                                                                                                                                                                                     ELSE J.MULTEQPEMBALAGEM END ||' R$ '
      || DECODE(SIGN(J.PRECOGERPROMOC/*J.PRECOGERNORMAL*/),+1,
       TRANSLATE(TO_CHAR(ROUND((J.PRECOGERPROMOC/(J.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','),
       TRANSLATE(TO_CHAR(ROUND((J.PRECOGERNORMAL/(J.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','))
|| CHR(13) || CHR(10) || ''
END)||'^FR^FS'

      || CHR(13) || CHR(10) || '^FO50,265^A0N,13,16^FD'||'LOJA:'|| G.NOMEREDUZIDO || '^FS'
      || CHR(13) || CHR(10) || '^FO210,265^A0N,13,16^FD' ||  TO_CHAR(SYSDATE, 'dd/mm/yy hh24:mi') || '^FS'
      || CHR(13) || CHR(10) || '^FO320,265^A0N,13,16^FD'  || 'PROD:'|| A.SEQPRODUTO ||'^FS' -- COD INTERNO


 ------------INICIO PRECO UNICO CASO NAO ESTEJA EM OFERTA E TENHA PRECOS DIF POR EMBALAGENS
         WHEN TRUNC(A.PRECO1/A.QTDEMBALAGEM1,2) = TRUNC((A.PRECOEMBPADRAO/A.PADRAOEMBVENDA),2) AND (NVL(A.PRECOVALIDPROMOC,0) = 0)
           THEN  CHR(13) || CHR(10) ||
      '^FO50,20^A0N,40,40^FD'||SUBSTR(A.DESCCOMPLETA,0,37) ||' '||CASE WHEN J.QTDEMBALAGEM > 1 THEN J.EMBALAGEM ELSE NULL END||'^FS' || CHR(13) || CHR(10) || -- DESC
    --  || CHR(13) || CHR(10) || '^FO050,200^BY2.4^BEN,30,Y,N^FD' || A.CODACESSOPADRAO ||'^FS' --EAN COD BARRAS
       DECODE(LENGTH(A.CODACESSOPADRAO),13, '^FO050,200^BY2.4^BEN,30,Y,N^FD', '^FO050,200^BY2.4^BCN,30,Y,N^FD' ) || A.CODACESSOPADRAO ||'^FS' --EAN COD BARRAS BARRAS
        --- QR CODE ETIQUERA NORMAL
      || CHR(13) || CHR(10) ||'^FO050,075^BQ,2,4^FDLA,:p:' || '1:vp:1' ||'^FS'
      || CHR(13) || CHR(10) ||'^FO180,85^A0N,110,60^FDR$^FS' ||'^FS' -- R$
      || CHR(13) || CHR(10) ||'^FO350,90^A0N,170,130^FD'|| LPAD(TRUNC(A.PRECOEMBPADRAO), 4, ' ' ) || ',' || --PRECO NORMAL
                                                           LPAD((A.PRECOEMBPADRAO - TRUNC(A.PRECOEMBPADRAO)) * 100, 2, '0')|| '^FS'

----PRECO POR KG
||    (CASE WHEN
       J.MULTEQPEMB IS NOT NULL  OR J.MULTEQPEMBALAGEM IS NOT NULL
       THEN
CHR(13) || CHR(10) || '^FO550,255^A0N,20,19^FD' || /*'*PRECO PAGO POR ' || J.MULTEQPEMBALAGEM ||' R$   '*/ 'Nesta Embalagem ' || CASE WHEN J.MULTEQPEMBALAGEM = 'LI' THEN 'LITRO'
                                                                                                                                                                                                                                                                    WHEN  J.MULTEQPEMBALAGEM = 'GR' THEN '100g'
                                                                                                                                                                                                                                                                     ELSE J.MULTEQPEMBALAGEM END ||' R$ '
      || DECODE(SIGN(J.PRECOGERPROMOC/*J.PRECOGERNORMAL*/),+1,
       TRANSLATE(TO_CHAR(ROUND((J.PRECOGERPROMOC/(J.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','),
       TRANSLATE(TO_CHAR(ROUND((J.PRECOGERNORMAL/(J.MULTEQPEMB*1000))*1000 ,2),'FM9990.00'), '.', ','))
|| CHR(13) || CHR(10) || ''
END)||'^FR^FS'

      || CHR(13) || CHR(10) || '^FO50,265^A0N,13,16^FD'||'LOJA: '|| G.NOMEREDUZIDO || '^FS'
      || CHR(13) || CHR(10) || '^FO210,265^A0N,13,16^FD' ||  TO_CHAR(SYSDATE, 'dd/mm/yy hh24:mi') || '^FS'
      || CHR(13) || CHR(10) || '^FO320,265^A0N,13,16^FD'  || ' PROD: '|| A.SEQPRODUTO ||'^FS' -- COD INTERNO
      ---FO645,265^A0N,13,16^FD



END


--FIM DA ETIQUETA
|| CHR(13) || CHR(10) || '^XZ'
|| CHR(13) || CHR(10) LINHA

FROM CONSINCO.MRLX_BASEETIQUETAPROD A INNER JOIN CONSINCO.MRLV_BASEETIQUETAPROD_NAGV2 J ON J.NROEMPRESA  = A.NROEMPRESA AND J.SEQPRODUTO = A.SEQPRODUTO AND J.NROSEGMENTO = A.NROSEGMENTO AND J.QTDEMBALAGEM = A.QTDEMBCODACESSO
                                      INNER JOIN CONSINCO.MAX_EMPRESA G               ON G.NROEMPRESA  = A.NROEMPRESA
                                   -- Precos de Ofertas Ativaveis
                                       LEFT JOIN (SELECT SEQPRODUTO, PRECOPROMOCIONAL, DTAINICIO, DTAFIM
                                                    FROM CONSINCO.MRL_ENCARTE A INNER JOIN CONSINCO.MRL_ENCARTEPRODUTO B ON A.SEQENCARTE = B.SEQENCARTE
                                                   WHERE B.PRECOPROMOCIONAL > 0
                                                     AND B.QTDEMBALAGEM = 1
                                                     AND DESCRICAO LIKE 'MEU NAGUMO%'
                                                     AND TRUNC(SYSDATE) BETWEEN DTAINICIO AND DTAFIM) AT ON AT.SEQPRODUTO = A.SEQPRODUTO
                                    -- Precos Meu Nagumo - Identificados
                                       LEFT JOIN (SELECT PRECOPPROMOCIONAL, CODLOJA, CODIGOPRODUTO, RP.DTINICIO, RP.DTFIM
                                                    FROM CONSINCO.NAGT_REMARCAPROMOCOES RP
                                                   WHERE SYSDATE BETWEEN RP.DTHRINICIO AND RP.DTHRFIM -- Ajustado a view para tratativa de hora/min na DTFIM | 19/03/2024
                                                     AND RP.TIPODESCONTO  = 4
                                                     AND RP.PROMOCAOLIVRE = 0) RPM ON RPM.CODLOJA = A.NROEMPRESA
                                                                                 AND RPM.CODIGOPRODUTO = LPAD(A.CODACESSOPADRAO,14,0)

  ORDER BY LINHA
;
