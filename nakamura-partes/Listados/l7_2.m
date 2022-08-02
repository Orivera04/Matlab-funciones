% L7_2:  see function wall_ht in Example 7.4
% Copyright S. Nakamura, 1995
function  f = wall_ht(T1)
k =1.2; e = 0.8; Tinf = 298;
Tf=298; h = 20; T0=625;
sig = 5.67E-8 ; wall_thick = 0.05;
f = k/wall_thick*(T1-T0) +e*sig*(T1.^4-Tinf^4)  ...
                         + h*(T1 - Tf);

