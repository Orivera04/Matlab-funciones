function yp = fbungie02(t, y, flag, m, k, b)
% y(1)' = y(2)
% y(2)' = g - (k/m) * y(1) - (b/m) * y(2)
% m = massa
% k= fator de elasticidade
% b = fator de tracao
g = 9.8;     % aceleracao da gravidade
K = k/m;
B = b/m;
yp=[y(2) 
    g - K * y(1) - B * y(2)];

