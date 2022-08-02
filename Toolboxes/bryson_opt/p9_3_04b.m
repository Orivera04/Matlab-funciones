% Script p9_3_04b.m; min fuel path for DIP using FMINCON; 
%                                                    7/99, 3/29/02
%
v0=0; y0=.13; N=20;
%p0=-[.04 .08 .12 .16 .2*ones(1,11) .16 .12 .08 .04];
p0=-[.0500 .1000 .1500 .1555 .1555 .1555 .1555 .1555 .1555 .1555 ...
    .1555 .1555 .1555 .1555 .1555 .1555 .1500 .1000 .0500];      
optn=optimset('Display','Iter','MaxIter',5); 
un=ones(1,N-1); lb=-.25*un; ub=.01*un;
p=fmincon('mfuel_f',p0,[],[],[],[],lb,ub,'mfuel_c',optn,N,v0,y0);                          
