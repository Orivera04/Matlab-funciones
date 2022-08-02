% funcao cap3_inputname_exemplo
function [n1,n2,ne,ns] = cap3_inputname_exemplo( ent1,ent2 )
n1 = inputname(1);  % nome da primeira variavel de entrada
n2 = inputname(2);  % nome da segunda variavel de entrada
ne=nargin;  % numero de parametros de entrada
ns=nargout;   % numero de parametros de saída