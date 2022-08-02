% Script e06_2_2.m; SRL of SIMO plant;    9/96, 6/24/02
%
num=[1 0 -1]; den=[1 0 2 0 1]; sys=tf(-num,den);
rlocus(sys); axis([-2 2 -1.5 1.5]); grid 