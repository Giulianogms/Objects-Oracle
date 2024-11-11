BEGIN
  NAGP_INSERETITISS(nroTituloBase => 9957,
                    nroTituloServ => 9965,
                    vlrSERV       => 29.00,
                    nroTituloIss  => 9958,
                    vlrISS        => 1.45,
                    vEmissao      => DATE '2024-09-10',
                    vVencimento   => DATE '2024-11-20');
END;

E depois rodar a CONSINCO.CAFD_INTEG_TIT_FINANCEIRO

--=======================================================--

CREATE OR REPLACE PROCEDURE CONSINCO.NAGP_INSERETITISS (nroTituloBase IN NUMBER,
                                                        nroTituloServ IN NUMBER,
                                                        vlrSERV       IN NUMBER,
                                                        nroTituloIss  IN NUMBER,
                                                        vlrISS        IN NUMBER,
                                                        vEmissao      IN DATE,
                                                        vVencimento   IN DATE)
                                               
                                               AS
      -- Por Giuliano em 11/11/24
      -- Inserir titulos ISSQN e SERVRC quando os memos não forem gerados            
      -- Utilizando um anterior como base                             
 BEGIN

INSERT INTO CONSINCO.MRL_TITULOFIN X  (X.SEQTITULO,
       X.NROEMPRESA,
       X.CODESPECIE,
       X.SEQPESSOA,
       X.VERSAOPESSOA,
       X.OBRIGDIREITO,
       X.SEQAGENCIA,
       X.NROTITULO,
       X.NROPARCELA,
       X.QTDPARCELA,
       X.NRODOCUMENTO,
       X.SERIEDOC,
       X.ORIGEMDOC,
       X.VLRORIGINAL,
       X.VLRCOMISSAO,
       X.VLRJUROMORA,
       X.DTAVENCIMENTO,
       X.DTAVENCTOBOLETO,
       X.DTAEMISSAO,
       X.OBSERVACAO,
       X.SEQCTACORRENTE,
       X.NOSSONUMERO,
       X.CODBARRADOCTO,
       X.TITULOEMITIDO,
       X.LINHADIGITAVEL,
       X.VLRDSCFINANC,
       X.DTALIMDSCFINANC,
       X.DTAENTRADA,
       X.INDREPLICACAO,
       X.INDGEROUREPLICACAO,
       X.INDEXPORTACAO,
       X.CODOUTRAOPERACAO,
       X.VLROUTRAOPERACAO,
       X.NROCARGA,
       X.NROFORMAPAGTO,
       X.VLRVENDOR,
       X.VLRDESCCOMERC,
       X.VLRINDENIZACAO,
       X.VLRISSRETIDO,
       X.VLRDESCFUNRURAL,
       X.TIPLANCTOFIN,
       X.TIPOGERFINANC,
       X.NROREPRESENTANTE,
       X.NROEMPRESAFINANC,
       X.NROBANCO,
       X.NROCARTEIRACOBR,
       X.NROEMPRESACOBR,
       X.NROAGENCIA,
       X.NROCTACORRENTE,
       X.DIGCTACORRENTE,
       X.DIGAGENCIA,
       X.STATUSTITULOFIN,
       X.DTACANCELAMENTO,
       X.USUCANCELAMENTO,
       X.SEQINTEGRACAOCANCEL,
       X.TIPOCARTCOBRANCA,
       X.USUINTEGRACAO,
       X.DTAINTEGRACAO,
       X.SEQINTEGRACAO,
       X.TIPOVLRFINANCE,
       X.DTALANCAMENTO,
       X.NROSERIEECF,
       X.SEQPAGADOR,
       X.CODOPERALTERACAO,
       X.DTACARGA,
       X.SEQAUXNOTAFISCAL,
       X.LINKERP,
       X.VLRCOMISSAOREC,
       X.SEQBOLETO,
       X.VLRDESCICMS,
       X.VLRDESCPIS,
       X.VLRDESCCOFINS,
       X.VLRDESCCSLL,
       X.VLRDESCIR,
       X.SEQMOTORISTA,
       X.VLRDESCINSS,
       X.VLRDESCISS,
       X.SEQENTREGADOR,
       X.CMC7,
       X.NROCUPOM,
       X.PERCDESCFINANC,
       X.SEQPESSOAEMITENTE,
       X.PERCOMPROR,
       X.PRAZOPAGTOCOMPROR,
       X.DTABASECOBRANCA,
       X.VLRICMSSTPARC1,
       X.VLRIPIPARC1,
       X.VLRDESCCONTRATO,
       X.DIASPRAZO,
       X.VLRDSCABATIMENTO,
       X.INDINTEGRAFINANC,
       X.VLRLIMITEBOLETO,
       X.SERIETITULO,
       X.VLROPCONTRATODESC,
       X.VLROPCONTRATORET,
       X.PERCDESCCONTRATO,
       X.DTAVENCTOANT,
       X.INDEMAILVENCTOENV,
       X.ORIGEMTITULO,
       X.VLRDESCCONTRATOGC,
       X.APPORIGEM,
       X.INDDADOSBOLETO,
       X.INDPAGAMENTO,
       X.INDGERAQUITACAOTIT,
       X.NROGIFTCARD,
       X.PERCADMINISTRACAO,
       X.APPORIGEMTITULO,
       X.SEQFINANCEIRO,
       X.INDGERACOBRELETRONICA,
       X.SEQDOCTO,
       X.SEQPAGTO,
       X.NUMERONFSE,
       X.INDCONTROLASALDO,
       X.NRONSU,
       X.VLRJUROSMOTIVOCOBRANCA,
       X.SEQDEPOSITARIO,
       X.PROPRIOTERCEIRO,
       X.INDVLRORIGINALCALCSISTEMA,
       X.VLRDESCFINANCAJUSTESISTEMA,
       X.SEQPEDVENDAFORMAPAGTO,
       X.VLRDSCCONTRATOOPERABATIMENTO,
       X.VLRDESCFUNSENAR,
       X.VLRDESCFUNRAT,
       X.VLRDESCFUNPREVSOCIAL)

SELECT (SELECT MAX(SEQTITULO) FROM CONSINCO.MRL_TITULOFIN) + ROWNUM,
       X.NROEMPRESA,
       X.CODESPECIE,
       X.SEQPESSOA,
       X.VERSAOPESSOA,
       X.OBRIGDIREITO,
       X.SEQAGENCIA,
       nroTituloIss,
       X.NROPARCELA,
       X.QTDPARCELA,
       nroTituloIss,
       X.SERIEDOC,
       X.ORIGEMDOC,
       DECODE(CODESPECIE, 'ISSQN', vlrISS, 'SERVRC', vlrSERV),
       X.VLRCOMISSAO,
       X.VLRJUROMORA,
       vVencimento,
       X.DTAVENCTOBOLETO,
       vEmissao,
       X.OBSERVACAO,
       X.SEQCTACORRENTE,
       X.NOSSONUMERO,
       X.CODBARRADOCTO,
       X.TITULOEMITIDO,
       X.LINHADIGITAVEL,
       X.VLRDSCFINANC,
       X.DTALIMDSCFINANC,
       X.DTAENTRADA,
       X.INDREPLICACAO,
       X.INDGEROUREPLICACAO,
       'I',
       X.CODOUTRAOPERACAO,
       X.VLROUTRAOPERACAO,
       X.NROCARGA,
       X.NROFORMAPAGTO,
       X.VLRVENDOR,
       X.VLRDESCCOMERC,
       X.VLRINDENIZACAO,
       X.VLRISSRETIDO,
       X.VLRDESCFUNRURAL,
       X.TIPLANCTOFIN,
       X.TIPOGERFINANC,
       X.NROREPRESENTANTE,
       X.NROEMPRESAFINANC,
       X.NROBANCO,
       X.NROCARTEIRACOBR,
       X.NROEMPRESACOBR,
       X.NROAGENCIA,
       X.NROCTACORRENTE,
       X.DIGCTACORRENTE,
       X.DIGAGENCIA,
       X.STATUSTITULOFIN,
       X.DTACANCELAMENTO,
       X.USUCANCELAMENTO,
       X.SEQINTEGRACAOCANCEL,
       X.TIPOCARTCOBRANCA,
       X.USUINTEGRACAO,
       X.DTAINTEGRACAO,
       NULL,
       X.TIPOVLRFINANCE,
       X.DTALANCAMENTO,
       X.NROSERIEECF,
       X.SEQPAGADOR,
       X.CODOPERALTERACAO,
       X.DTACARGA,
       X.SEQAUXNOTAFISCAL,
       X.LINKERP,
       X.VLRCOMISSAOREC,
       X.SEQBOLETO,
       X.VLRDESCICMS,
       X.VLRDESCPIS,
       X.VLRDESCCOFINS,
       X.VLRDESCCSLL,
       X.VLRDESCIR,
       X.SEQMOTORISTA,
       X.VLRDESCINSS,
       X.VLRDESCISS,
       X.SEQENTREGADOR,
       X.CMC7,
       X.NROCUPOM,
       X.PERCDESCFINANC,
       X.SEQPESSOAEMITENTE,
       X.PERCOMPROR,
       X.PRAZOPAGTOCOMPROR,
       X.DTABASECOBRANCA,
       X.VLRICMSSTPARC1,
       X.VLRIPIPARC1,
       X.VLRDESCCONTRATO,
       X.DIASPRAZO,
       X.VLRDSCABATIMENTO,
       X.INDINTEGRAFINANC,
       X.VLRLIMITEBOLETO,
       X.SERIETITULO,
       X.VLROPCONTRATODESC,
       X.VLROPCONTRATORET,
       X.PERCDESCCONTRATO,
       X.DTAVENCTOANT,
       X.INDEMAILVENCTOENV,
       X.ORIGEMTITULO,
       X.VLRDESCCONTRATOGC,
       X.APPORIGEM,
       X.INDDADOSBOLETO,
       X.INDPAGAMENTO,
       X.INDGERAQUITACAOTIT,
       X.NROGIFTCARD,
       X.PERCADMINISTRACAO,
       X.APPORIGEMTITULO,
       X.SEQFINANCEIRO,
       X.INDGERACOBRELETRONICA,
       X.SEQDOCTO,
       X.SEQPAGTO,
       nroTituloServ,
       X.INDCONTROLASALDO,
       X.NRONSU,
       X.VLRJUROSMOTIVOCOBRANCA,
       X.SEQDEPOSITARIO,
       X.PROPRIOTERCEIRO,
       X.INDVLRORIGINALCALCSISTEMA,
       X.VLRDESCFINANCAJUSTESISTEMA,
       X.SEQPEDVENDAFORMAPAGTO,
       X.VLRDSCCONTRATOOPERABATIMENTO,
       X.VLRDESCFUNSENAR,
       X.VLRDESCFUNRAT,
       X.VLRDESCFUNPREVSOCIAL FROM CONSINCO.MRL_TITULOFIN X WHERE NROTITULO = nroTituloBase AND CODESPECIE IN ('SERVRC','ISSQN')
       
       AND NOT EXISTS (SELECT 1 FROM CONSINCO.MRL_TITULOFIN A WHERE A.NROTITULO = nroTituloIss AND A.CODESPECIE = X.CODESPECIE);
       
END;
