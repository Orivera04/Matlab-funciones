function f=slbt_f(y)
% Subroutine for e01_5_2; max velocity of a sailboat using FSOLVE;
%                                                    9/96, 6/24/02
%
y1=y([1:5]); la=y([6:8]); [L,f1,Ly,fy]=feval('slbt',y1);
f=[f1' Ly+la*fy];
	