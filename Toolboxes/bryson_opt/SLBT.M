function [L,f,Ly,fy]=slbt(y)                 
% Subroutine for e01_3_1; max velocity of sailboat using POP; L=V;
% y=[V Wr al th ps]';                               12/94, 6/27/98
%
V=y(1); Wr=y(2); al=y(3); th=y(4); ps=y(5); mu=1; sa=sin(al);
ca=cos(al); st=sin(th); ct=cos(th); cp=cos(ps); sp=sin(ps);
sat=sin(al+th); cat=cos(al+th); 
L=V; f=[V^2-mu*Wr^2*sa*st; Wr^2-V^2-1+2*V*cp; Wr*sat-sp];
Ly=[1 0 0 0 0]; fy=[2*V -2*Wr*sa*st -Wr^2*ca*st -Wr^2*sa*ct 0; ...
    -2*(V-cp) 2*Wr 0 0 -2*V*sp; 0 sat Wr*cat Wr*cat -cp];


