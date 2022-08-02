% cap3_elseif_exemplo ()
function R = cap3_elseif_exemplo (a,b)
if nargin == 0
    R='Nenhum parametro de entrada';
elseif nargin == 1
    R='1 parametro de entrada';
else
    R='2 parametros de entrada';
end