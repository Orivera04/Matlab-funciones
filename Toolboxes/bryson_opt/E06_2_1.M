% Script e06_2_1.m; SRL of SISO plant; 9/96, 6/24/02
%
figure(1); clf; num=[1 0 0]; den=[1 0 2 0 1];
rlocus(-num,den); axis([-2 2 -1.5 1.5]); grid 
