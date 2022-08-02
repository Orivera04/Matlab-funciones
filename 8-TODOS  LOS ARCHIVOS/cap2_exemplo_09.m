echo on
% Arquivo: cap2_exemplo_09.m
% Exemplos: item 2.4.2
% Cadeia de Caracteres
txt1='Resultado'
% Transposicao
txt1'
% Concatenacao horizontal
txt2 = [txt1 ' da Prova1']
% Concatenacao vertical
txt3 = [ txt1 ; 'da Prova1']
% Concatenacao vertical nao executavel
txt4 = [ txt1 ; 'da Prova']
% Concatenacao vertical com funcao strvcat
txt4=strvcat(txt1,'da Prova')