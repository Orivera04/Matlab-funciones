function [s,g]= costknot(knots,m,X,Y,nk,c0,alpha); 
%COSTKNOT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:58:21 $

persistent FAC

% First reconstruct the knot sequence.
h=diff([-1;knots(:);1]);
h(h<sqrt(eps))=sqrt(eps);
penalty= 1-alpha*sum(log((nk+1)/2*h));
m3= set(m.mv3xspline,'knots',knots);
[m3,OK]= leastsq(m3,X,Y);
yhat= eval(m3,X);
if OK
   r= Y-yhat; 
else
   r= zeros(size(Y));
   r(:)= 10/sqrt(length(Y));
end
sseJ=penalty*r;


s= sum(sseJ.^2);

if ~isempty(c0)
   s= s/c0;
else
   FAC=[];
   c0=1;
end

if nargout>1
   m.mv3xspline=m3;
   % numerical jacobian
   thresh= max(abs(knots)*sqrt(eps),sqrt(eps));
   [Jy,FAC]= numjac('fbnleval',m,knots,yhat,thresh,FAC,0,[],[],X);
   % penalty jacobian
   dhdk= [diag(ones(nk,1));zeros(1,nk)] - [zeros(1,nk);diag(ones(nk,1))];
   dk=   -alpha* ((1./h)'*dhdk);
   
   % penalised jacobian J= del ( pen*yhat) /delk
   J= -penalty*Jy + r*dk;
   
   g= 2*sseJ'*J/c0;
end
   
