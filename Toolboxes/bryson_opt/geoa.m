function f=geoa(p)
% Subroutine for Pb. 2.3.7;  1/31/98
%
c=pi/180; ph0=139.7*c; th0=35.7*c; thf=40.7*c; phf=-73.8*c;
tf=pi+phf+pi-ph0; thm=p(1); al=p(2);
f=[tan(th0)+tan(thm)*sin(al)  tan(thf)-tan(thm)*sin(tf-al)];
