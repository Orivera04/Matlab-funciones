function [B,OK,m,sumstats,OKmulti]= gls_fitB(L,B,DATA,Wc)
%LOCALMULTI/GLS_FITB least-squares estimation of localmulti
%
% [B,res,J,yhat]= gls_fitB(L,B,DATA,Wc)
%   L    localmulti object
%   B     initial parameter matrix (cols= sweeps)
%   DATA  sweepset of data to fit [X,Y]
%   Wc    optional weights Wc'*Wc= inv(covmatrix)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.6.2 $  $Date: 2004/02/09 07:39:59 $


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



mlist= get(L,'models');
for j= 1:length(mlist)
   mlist{j}= reset(mlist{j});
end

% initialise variables for results
select= zeros(length(mlist),1);
m= cell(length(mlist),1);
sumstats= m;
OK= logical(zeros(Ns,1));
allparams(1:Ns) = {zeros(0,1)};

res = cell(Ns,1);
yhat= res;
J   = res;

[s,StatsList]= childstats(L);

for i=1:Ns
   d= CDATA{i};
	% code X data
   Xs= d(:,1:end-1);
   Ys= d(:,end);
   select(:)=Inf;
   OK(i)=logical(0);
   for j= 1:length(mlist)
      % fit all models 
      [m{j},OKj]= fitmodel(mlist{j},Xs,Ys);
      sumstats{j}= summary(m{j},StatsList,Xs,Ys);
      OKmulti(j)= OKj;
      if OKj
         sind= strcmp(StatsList,L.Select);
         select(j)= sumstats{j}(sind);
      else
         select(j)= Inf;
      end
   end
   if any(isfinite(select))
      % choose best
      [dum,mind]= min(select);
      mbest= m{mind};
      params= allparameters(mbest);
      allparams{i}= [mind;length(params);params];
      OK(i)=logical(1);
      yhat{i}= eval(mbest,Xs);
      res{i}= Ys-yhat{i};
      J{i}= CalcJacob(mbest,Xs);   
      m= m(isfinite(select));
      sumstats= sumstats(isfinite(select));
  else
      res{i} = zeros(size(Ys));
   end
end

np= cellfun('length',allparams);

% make rectangular matrix of right size
B= zeros(max(np),Ns);
for i=1:Ns
   B(1:np(i),i)= allparams{i};
end

if isa(DATA,'sweepset')
   res= cell2sweeps(DATA(:,1),res);
else
   res= cat(1,res{:});
end
