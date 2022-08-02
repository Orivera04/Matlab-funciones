% Arquivo: cap2_varglobal_exemplo
% Retorna Var_Global * (matriz identidade nxn)
function m=cap2_varglobal_exemplo (n)
global Var_Global
m=eye(n)*Var_Global;
