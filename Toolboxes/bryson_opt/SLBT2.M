function [L,f,Ly,fy,Lyy,fyy]=slbt2(y)               
% Subroutine for Example 1.5.1; sailboat max velocity using 
% POPN, L=V; y=[V Wr al th ps]'; 	          1/93, 8/14/02 
%
V=y(1); Wr=y(2); al=y(3); th=y(4); ps=y(5); sa=sin(al); 
ca=cos(al); st=sin(th); ct=cos(th); sp=sin(ps); cp=cos(ps);
sat=sin(al+th); cat=cos(al+th); L=V; Ly=[1 0 0 0 0];
f=[V^2-Wr^2*sa*st; Wr^2-V^2-1+2*V*cp; Wr*sat-sp];
fy=[2*V -2*Wr*sa*st -Wr^2*ca*st -Wr^2*sa*ct 0;...
   -2*(V-cp) 2*Wr 0 0 -2*V*sp; 0 sat Wr*cat Wr*cat -cp];
Lyy=zeros(5); fyy=zeros(15,5); z3=zeros(1,3); z4=[z3 0];
f1yy=[2 z4; 0 -2*st*sa -2*Wr*ca*st -2*Wr*sa*ct 0; 0 0 ...
     Wr^2*sa*st -Wr^2*ca*ct 0; z3 Wr^2*sa*st 0; 0 z4];
fyy(1:5,:)=f1yy+f1yy'-diag(diag(f1yy));
f2yy=[-2 z3 -2*sp; 0 2 z3; zeros(2,5); z4 -2*V*cp];
fyy(6:10,:)=f2yy+f2yy'-diag(diag(f2yy));
f3yy=[0 z4; 0 0 cat cat 0; 0 0 -Wr*sat -Wr*sat 0; ...
    z3 -Wr*sat 0; z4 sp]; 
fyy(11:15,:)=f3yy+f3yy'-diag(diag(f3yy));

