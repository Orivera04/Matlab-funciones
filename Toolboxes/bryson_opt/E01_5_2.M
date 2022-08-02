% Script e01_5_2.m; max velocity of a sailboat using FSOLVE;
%                                              9/96, 6/24/02
%
y1=[.6 1 .6 .6 1.3]; la=[0 0 0]; y=[y1 la]; 
optn=optimset('Display','Iter');
y=fsolve('slbt_f',y,optn)
	