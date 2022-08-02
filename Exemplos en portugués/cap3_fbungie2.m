function yp = cap3_fbungie2(t,y,flag,m,k,b)
% y(1)' = y(2)
% y(2)' = g - (k/m) * y(1) - (b/m) * y(2)
g = 9.8;    % aceleracao da gravidade
% k = fator de elasticidade
% b = fator de tracao 
% m = massa 
K = k/m;
B = b/m;
yp=[y(2) 
    g - K * y(1) - B*y(2)];