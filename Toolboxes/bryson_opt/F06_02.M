% Script f06_02.m; SRL of SIMO plant; ep put in to show
% repeated poles in plots;                 9/96, 4/4/02
%
ep=.02;num=[1 0 -1]; den=[1 0 2*(1-ep^2) 0 (1+ep^2)^2];
rlocus(-num,den); grid; axis([-2 2 -1.5 1.5])
%print -deps2 \book_do\figures\f06_02