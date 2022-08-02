%           Progetto Metodo di Simpson
%                 a schema fisso
%
%             Programma elaborato da
%
%      Giovanni DI CECCA & Virginia BELLINO
%           50 / 887           408 / 466
%
%             http://www.dicecca.net
%
% Funzione ausiliaria di simfix
%
% Questa routine calcola i valori della funzione 
% data in input secondo Matlab

function y=Fun( f, x )

% crea la funzione
Funzione = sprintf( 'y=%s;', f);

% calcola i valori
eval( Funzione );
