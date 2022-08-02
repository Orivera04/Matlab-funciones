% cap3_switch_exemplo ()
function R = cap3_switch_exemplo (a,b)
switch nargin
    case 0
    R='Nenhum parametro de entrada';
    case 1
    R='1 parametro de entrada';
    otherwise
    R='2 parametros de entrada';
end