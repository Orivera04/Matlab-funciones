% Script e02_4_2.m; min drag nose-shape pb. using MATLAB code FMINUNC;
% t-->x=distance; s=[d r]'; u=-tan(theta); lengths in a=r(0); drag in 
% q*pi*a^2 where q=dynamic pressure;                    11/94, 8/15/02
%
tf=4; optn=optimset('Display','Iter','MaxIter',500); 
u0=[.18 .18 .19 .19 .19 .20 .20 .20 .21 .21 .22 .22 .23 .24...
    .25 .26 .28 .29 .34 .38 .68];
%u=.5*ones(1,N+1);      	                    % Rough initial guess
u=fminunc('noshp_f',u0,optn,tf);        

