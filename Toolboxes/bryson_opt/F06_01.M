% Script f06_01.m;  SRL of SISO plant; ep put in to show 
% two repeated poles and zeros in plot;    9/96, 4/4/02
%
ep=.02; num=[1 0 -ep^2]; den=[1 0 2*(1-ep^2) 0 ...
   (1+ep^2)^2]; rlocus(-num,den); grid
axis([-2 2 -1.5 1.5])
%print -deps2 \book_do\figures\f06_01