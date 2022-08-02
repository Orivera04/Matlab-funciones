function sp=conjpt(t,s)				            
% Subroutine for Pb. 8.7.5; Fermat pb. with a conjugate point;
% s=[be x y]'; 		                           2/94, 12/96, 7/25/98
% 
be=s(1); x=s(2); y=s(3); z=sqrt(1+y^2); 
sp=[-y*cos(be)/z; z*cos(be); z*sin(be)];