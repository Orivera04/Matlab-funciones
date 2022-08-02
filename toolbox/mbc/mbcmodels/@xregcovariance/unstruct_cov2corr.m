function [w,s,c] = unstruct_cov2corr(c)
% COVMODEL/UNSTRUCT_CORR scale unstructured covariance

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 07:46:31 $



w= cov(c);
nc= size(w,1);
wc= triu( ones(nc) ) ;
U= (wc~=0);
wc(U)= c.cparam;

% scaling factor is the norm of the columns
sd=  sqrt(sum(wc.^2));
% make a lower bound on the scaling
sd(sd==0)=1;
sdmax= max(sd)*sqrt(eps*nc);
sd(sd<sdmax)=sdmax;

s= diag(1./sd);

wc= wc*s;
w= wc'*wc;
c.cparam= wc(U);

