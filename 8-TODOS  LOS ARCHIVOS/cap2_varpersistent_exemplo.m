% Arquivo: cap2_varpersistent_exemplo
% Retorna Var_Persistent * (matriz identidade nxn)
function m=cap2_varpersistent_exemplo (n)
persistent Var_Persistent
if isempty(Var_Persistent)  % se vazia, recebe 1
    Var_Persistent = 1;
else
    Var_Persistent = Var_Persistent+n; % soma n
end
m=Var_Persistent*eye(n);

