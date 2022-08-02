function sp=minfuela(t,s,flag,p)     
% Subroutine for Pb. 3.3.19, min fuel holding path, s=[th thdot x y]'; 
% u=tan(sg); sg=bank angle; (x,y) in V^2/g, time in V/g; 2/98, 6/20/98
%	
th=s(1); sp=[s(2) p(1)*sin(th) cos(th) sin(th)]';
