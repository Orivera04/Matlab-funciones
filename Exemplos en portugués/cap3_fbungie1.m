function yp = cap3_fbungie1 (t,y)
% y(1)' = y(2)
% y(2)' = g - (k/m) * y(1) - (b/m) * y(2)
g = 9.8;    % aceleracao da gravidade
k=0.1;      % fator de elasticidade
b=1.0;      % fator de tracao 
m=60;       % massa 
K = k/m;
B = b/m;
yp=[y(2) 
    g - K * y(1) - B*y(2)];