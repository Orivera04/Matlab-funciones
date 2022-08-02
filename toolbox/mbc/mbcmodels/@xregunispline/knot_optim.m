function [sseJ,m,penalty] = knot_optim(knots,X,Y,k,m,alpha)
% This is the cost function used by LSQNONLIN

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:58:32 $

% First reconstruct the knot sequence.
knots=sort(knots);
h=diff([-1;knots(:);1])/2;
h(h<1e-6)=1e-6;
penalty= 1-alpha*sum(log((k+1)*h));
m3= set(m.mv3xspline,'knots',knots);
m3= leastsq(m3,X,Y);
m.mv3xspline=m3;
sseJ=penalty*(Y- eval(m3,X));



