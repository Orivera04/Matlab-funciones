%% Ejemplo 7.3
% Ajuste interactivo de parámetros
clear, clc
a = 28.90;
b = 0.1967e-2;
c = 0.4802e-5;
d = -1.966e-9;
T1 = 300
%% suponga T2 y ajuste
T2 = 591
format bank
delta_h = a*(T2-T1) + b*(T2.^2 - T1.^2)/2 + c*(T2.^3-T1^3)/3 + d*(T2.^4-T1.^4)/4
