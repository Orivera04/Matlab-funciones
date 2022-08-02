function [B,yhat,res,J,OKall]= gls_fitB(poly,B,DATA,Wc)
% POLYNOM/GLS_FITB least-squares estimation of localpspline
%
% [B,res,J,yhat]= gls_fitB(ps,B,DATA,Wc)
%   ps    localpspline object
%   B     initial parameter matrix (cols= sweeps)
%   DATA  sweepset of data to fit [X,Y]
%   Wc    optional weights Wc'*Wc= inv(covmatrix)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:40:25 $

Ns= size(DATA,3);

if isa(DATA,'sweepset')
   CDATA= cell(DATA);
elseif ~isa(DATA,'cell') 
   CDATA= {DATA};
else
   CDATA= DATA;
end
if nargin < 4 | isempty(Wc)
   Wc=cell(Ns,1);
end

% setup Jacobian pattern
Jcell= cell(1,Ns);
ts= cellfun('size',CDATA,1);
for i=1:Ns;
   Jcell{i}= ones(ts(i),1);
end
JPattern= spblkdiag(Jcell{:});

p0 = datum(poly,0);
OKall= zeros(1,Ns);

for i=1:Ns
   d= CDATA{i};
   Xs= d(:,1:end-1);
   Ys= d(:,end);
   
   tp=0;
   [poly,OK]= leastsq(p0,Xs,Ys,Wc{i});
   
   
   p= double(poly);
   p= [zeros(size(B,1)-length(p),1); p];
   B(:,i)= p;
   if nargout>1
      % this makes sure that the polynomial is the right size
      % and sets the datum
      poly= update(poly,p);
      [res{i},J{i},yhat{i}]= lsqcost(poly,Xs-datum(poly),Ys,Wc{i});
   end
   OKall(i)= OK;
end
% not sure if I want to do this in here or whether this is best post GLS 

if isa(DATA,'sweepset')
   res= cell2sweeps(DATA(:,1),res);
else
   res= cat(1,res{:});
end

