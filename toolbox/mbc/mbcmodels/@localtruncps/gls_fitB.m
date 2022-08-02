function [B,yhat,res,J]= gls_fitB(ts,B,DATA,Wc)
% TRUNC/GLS_FITB least-squares estimation of localtruncps
%
% [B,res,J,yhat]= gls_fitB(ps,B,DATA,Wc)
%   ts    localtruncps object
%   B     initial parameter matrix (cols= sweeps)
%   DATA  sweepset of data to fit [X,Y]
%   Wc    optional weights Wc'*Wc= inv(covmatrix)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:43:02 $



Ns= size(DATA,3);

if nargin < 4 | isempty(Wc)
   Wc=cell(1,Ns);
end

% setup Jacobian pattern
Jcell= cell(1,Ns);
tst= tsizes(DATA);
nk= length(ts.knots);
for i=1:Ns;
   Jcell{i}= ones(tst(i),nk);
end
% sparse block diagonal
JPattern= spblkdiag(Jcell{:});


minb= zeros(nk,Ns);
maxb= minb;
for i=1:Ns
   d= DATA{i};
   [b,minb(:,i),maxb(:,i),OK]= initial(ts,d(:,1),d(:,2));
end

knots= B(1:length(ts.knots),:);

r= costknot(knots,ts,DATA,Wc);
c0 = sqrt(sum(r.^2));

options= optimset('display','off',...
   'JacobPattern ',JPattern,...
   'Jacobian','off',...
   'TolFun',1e-6,...
   'Tolx',1e-3/Ns^2,...
   'LargeScale','on');
   [k,resnorm,r,exitflag,output,lam,J] = lsqnonlin('costknot',knots,minb,maxb,options,ts,DATA,Wc,c0);
   
[res,B,J,yhat,PS]= costknot(k,ts,DATA,Wc);


drawnow

