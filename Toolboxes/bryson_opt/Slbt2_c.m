function [c,ceq,dc,dceq]=slbt2_c(y)               
% Subroutine for Example 1.5.1; sailboat max velocity using FMINCON;
% y=[V Wr al th ps]';                            1/93, 9/96, 4/16/98 
%
V=y(1); Wr=y(2); al=y(3); th=y(4); ps=y(5); sa=sin(al); ca=cos(al);
st=sin(th); ct=cos(th); sp=sin(ps); cp=cos(ps); sat=sin(al+th);
cat=cos(al+th); c=[]; dc=[]; 
ceq=[V^2-Wr^2*sa*st; Wr^2-V^2-1+2*V*cp; Wr*sat-sp];
dceq=[2*V -2*Wr*sa*st -Wr^2*ca*st -Wr^2*sa*ct 0;...
     -2*(V-cp) 2*Wr 0 0 -2*V*sp; 0 sat Wr*cat Wr*cat -cp]';

