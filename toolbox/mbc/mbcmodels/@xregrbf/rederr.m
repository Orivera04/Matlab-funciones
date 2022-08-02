function [om,OK]=rederr(m)
%REDERR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.3 $  $Date: 2004/02/09 07:57:14 $

om= contextimplementation(xregoptmgr,m,@i_rederr,[],'RedErr',@rederr);
% fit parameters
om= AddOption(om,'MaxNCenters','min(nObs/4,25)','evalstr','Number of centers',2);% percentage of data taken as centers 
om= AddOption(om,'cost',Inf,{'numeric',[-Inf,Inf]},[],false);% field to store cost (GCV), not gui-settable
om= AddOption(om,'PercentCandidates',100,{'numeric',[100 100]},[],false);%non-gui settable -  number of candidate centers - always 100
OK = 1;

function [m,cost,OK]=i_rederr(m,om,x0,x,y,varargin)

 % subfunction to iteratively choose centers where error is maximum
 % uses ridge regression
 % call with set(m,'lambda',0) for ordinary least squares 

set(m,'qr','ridge');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set maxncenters
nObs = size(x,1); 
maxCStr= get(om,'MaxNCenters');
maxncenters = calcMaxNCenters(m,maxCStr,nObs);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Get the parameters stored in m
width = m.width;%width of the radial basis function
if any(width < 0) | size(width,1)> 1 %covers when on entry we have a width per center
   [m,OK] = defaultwidth(m,x);%set the default width
end 

if length(get(m,'lambda'))>1 
    % use the default lambda
    set(m,'lambda',1e-4);
end    
% calculate PHI for all centers so we can select terms during the loop
m.centers= x;
FX= x2fx(m,x);

res = y;
centers = [];
ind =[];
for i =1: maxncenters
    [mxres,ind(i)] = max(abs(res)); % find where the residual is maximum 
    centers = [centers; x(ind(i),:)];% add the basis function at that data point
    Phi = FX(:,ind); 
	 [Q,R]= qrdecomp(m,Phi);
    %pad y
    ya = [y; zeros(size(Q,1) - nObs,1)];
    res = ya - Q*(Q'*ya);% compute the new residual
    % truncate res
    res = res(1:nObs, 1);
    res(ind) = 0;% remove the chosen centers so they can't be chosen again
end

m.centers= centers;
Beta = R\(Q'*ya);
m = update(m,Beta);%load the weights

cost = log10(calcGCV(m,x,y));%
setFitOpt(m,'cost',cost);
OK  =1;
