function f=dgeo(be1,be0,th1,dph)
% Subroutine for p2_1_3a.m & p3_1_03a; discrete-step min distance to a
% meridian on a sphere;                                  10/96, 2/3/98
%
f=sin(be0)-sin(be1)-cos(be1)*sin(th1)*dph;
	
	
