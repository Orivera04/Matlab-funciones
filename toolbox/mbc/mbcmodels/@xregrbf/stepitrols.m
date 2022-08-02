function [om,OK]=stepitrols(m)
% XREGRBF/STETITROLS updates lambda while selecting centers 
%
%  Lambda selection is performed at the same time as center selection using rols.
%  Implemented as an xregoptmgr. This is normally a sub xregoptmgr (of e.g 
%  trialwidths). This routine is faster than iteraterols.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.9.4.3 $  $Date: 2004/02/09 07:57:24 $

om= contextimplementation(xregoptmgr,m,@i_stepitrols,[],'StepItRols',@stepitrols);
% fit parameters
om= AddOption(om,'MaxNCenters','min(nObs/4,25)','evalstr', 'Maximum number of centers',2);% percentage of data taken as centers - default 20 centers
om= AddOption(om,'PercentCandidates','(min(nObs,200)/nObs)*100','evalstr','Percentage of data to be candidate centers');% number of candidate centers,take min(nObs,200)
om= AddOption(om,'StartLamUpdate',5,{'int',[1 Inf]},'Number of centers to add before updating');% when to start updating lambda (after how many centers have been added)
om= AddOption(om,'Tolerance',0.005,{'numeric',[eps 1]},'Minimum change in log10(GCV)');% stopping criterion
om= AddOption(om,'MaxRep',10,{'int',[1 100]}, 'Maximum no. times log10(GCV) change is minimal');% number of times no large change in GCV is seen 
om= AddOption(om,'PlotFlag',0,'boolean','Display',logical(0));%plot flag
om= AddOption(om,'cheapmode',0,'boolean',[],logical(0));% no cheaper version available, not gui-settable
om= AddOption(om,'cost',Inf,{'numeric',[-Inf,Inf]},[],logical(0));
OK = 1;

function [m,cost,OK,varargout]=i_stepitrols(m,om,x0,x,y,varargin)
% adaptation of the rols algorithm to iterate lambda to reduce GCV after each center selection
% see 'Regularisation in the Selection of Rbf centers', Mark Orr

% it seems that iteraterols performs better than this one

%  created by Tanya Morton 1/11/2000
%  MathWorks Ltd

%  Inputs:
%				m - rbf object with centers
%				x - matrix of data points 
%				y - target values

% Outputs 
%			   m - new rbf object

set(m,'qr','rols');

nObs = size(x,1);

maxCStr= get(om,'MaxNCenters');
maxncenters = calcMaxNCenters(m,maxCStr,nObs);


startlamupdate = get(om,'StartLamUpdate');
maxrep = get(om,'MaxRep'); % maximum number of repeated GCV values before stopping

% Get the parameters stored in m
width = m.width;%width of the radial basis function
nObs = size(x,1);%number of data points
if any(width <0) | size(width,1)> 1
   [m,OK] = defaultwidth(m,x);%set the default width
end 
lam= get(m,'lambda');
if length(lam)>1
    set(m,'lambda',lam(1));
end 

plotflag = get(om,'PlotFlag'); % whether to plot or not - set to 0 if using uOptRols or OptRols with this routine
tol = get(om,'Tolerance');%stopping criteria for adding more centers 0<tol<1
%  Set up the 'full' regression matrix, Phi
centers = x;%take the initial centers to be the data points
m.centers = centers;
Phi = x2fx(m,x);%



%%%%%%%%%%%adjust the number of candidate centers in pool
PcCandStr = get(om,'PercentCandidates');
PercentCandidates = calcPercentCand(m,PcCandStr,nObs);
ncand = max(1,round((PercentCandidates/100)*nObs)); % approximate number of candidate points to try
if nObs >  ncand
   state = rand('state');
   rand('state',0);
   randint = randperm(nObs);
   candx = x(randint(1:ncand), :);
   Phik= Phi(:,randint(1:ncand));
   rand('state',state);

   
%     incr = round(nObs/ncand);
%     candx = x(1:incr:nObs, :);%
%     Phik = Phi(:,1:incr:nObs); %k:nObs rows of Phi
else
   %  take all data points as candidate centers
    candx = x;
    Phik = Phi;
end    
ncand = size(candx,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55

lambda = 1e-4;% start with lambda at default

% choose centers with mx_rols and updateLamba algorithm
updateLamba= 1;
[rstats,centorder]= mx_rols(Phik,y,lambda,[maxncenters,0,updateLamba,startlamupdate,maxrep,10^tol,0,0]);
nchosen= rstats(1);
bestlambda= rstats(4);
bestGCV= rstats(2);

set(m,'lambda',bestlambda);
centers = candx((centorder(1:nchosen)),:);%note, centers are in the order that they were chosen
m.centers = centers;
% solve for weights using mx_rols and force center selection for all nchosen terms
[rstats,centorder,WEIGHTS]= mx_rols(Phik(:,centorder(1:nchosen)),y,bestlambda,[nchosen,0,0,startlamupdate,maxrep,10^tol,nchosen,0]);

m = update(m,WEIGHTS);
cost = log10(rstats(2));

setFitOpt(m,'cost',cost);
OK =1;
