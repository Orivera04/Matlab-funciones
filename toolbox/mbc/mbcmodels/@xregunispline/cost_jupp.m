function sseJ= cost_jupp(sigma,m,X,Y,c0,alpha,Tgt)
%COST_JUPP Cost function for Jupp-coding
%
%  sseJ= COST_JUPP(sigma,m,X,Y,c0,alpha,Tgt)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:58:20 $

knots= invjupp(m.mv3xspline,sigma,Tgt);
nk= length(knots);
Tgt= gettarget(m);

% First reconstruct the knot sequence
h=diff([Tgt(1);knots(:);Tgt(1)]);
h(h<sqrt(eps))=sqrt(eps);
penalty= 1-alpha*sum(log((nk+1)/2*h));

% set knots and to nested least sqaures
m3= set(m.mv3xspline,'knots',knots);
[m3,OK]= leastsq(m3,X,Y);
if OK
    % nested least squares fit OK
    r= (Y-eval(m3,X))/sqrt(c0);
else
    % nested least squares fit didn't work
    r= zeros(size(Y));
    r(:)= 10/sqrt(length(Y));
end
sseJ=sqrt(abs(penalty))*r;
