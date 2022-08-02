function [om,OK]=interlace(m)
% XREGHYBRIDRBF/INTERLACE selection of polynomial and centers
%
%  Selection of centers and polynomial terms is carried out simultaneously
%  using rols. Implemented as an xregoptmgr.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.7.4.3 $  $Date: 2004/02/09 07:48:12 $

om= contextimplementation(xregoptmgr,m,@i_interlace,[],'Interlace',@interlace);

% fit parameters
om= AddOption(om,'MaxNParams','min(nObs/4,25)','evalstr','Maximum number of terms');% percentage of data taken as centers - default 20 centers
om= AddOption(om,'MaxNCenters','min(nObs/4,25)','evalstr','Maximum number of centers');% percentage of data taken as centers - default 20 centers
om= AddOption(om,'PercentCandidates','(min(nObs,200)/nObs)*100','evalstr','Percentage of data to be candidate centers');% number of candidate centers,take min(nObs,200)
om= AddOption(om,'StartLamUpdate',5,{'int',[1 Inf]},'Number of terms to add before updating');% when to start updating lambda (after how many centers have been added)
om= AddOption(om,'Tolerance',0.0001,{'numeric',[eps 1]},'Minimum change in log10(GCV)');% stopping criterion
om= AddOption(om,'MaxRep',10,{'int',[1 100]},'Maximum no. times log10(GCV) change is minimal');% number of times no large change in GCV is seen 
om= AddOption(om,'PlotFlag',0,'boolean','Display',logical(0));%plot flag
om= AddOption(om,'cheapmode',0,'boolean',[],logical(0));% no cheaper version available, not gui-settable
om= AddOption(om,'cost',0,{'numeric',[-Inf,Inf]},[],logical(0));
OK = 1;

function [m,cost,OK]=i_interlace(m,om,x0,x,y,varargin)


% new algorithm that is an adaptation of rols to add polynomial terms
%  created by Tanya Morton 19/9/2000 major rewrite 21/2/2001
%  MathWorks Ltd

%  Inputs:
%				m - rbf object with centers
%				x - matrix of data points 
%				y - target values

% Outputs 
%			   m - new rbf object

m = set(m,'qr','rols');
oldtermsin = Terms(m); % save the termsin on entry
oldstatus = get(m,'status');%save the status on entry


nObs = size(x,1);%number of data points
maxCStr= get(om,'MaxNCenters');
maxncenters = calcMaxNCenters(m.rbfpart,maxCStr,nObs);

maxPStr= get(om,'MaxNParams');
maxnparams = calcMaxNParams(m,maxPStr,nObs);

%%%%%%%%%%%adjust the number of candidate centers in pool
PcCandStr = get(om,'PercentCandidates');
PercentCandidates = calcPercentCand(m.rbfpart,PcCandStr,nObs);
approxncand = max(1,round((PercentCandidates/100)*nObs)); %approximate number of candidate points to try
if nObs >  approxncand
    state = rand('state');
    rand('state',0);
    randint = randperm(nObs);
    candcenters = x(randint(1:approxncand), :);
    rand('state',state);
else
   %  take all data points as candidate centers
    candcenters = x;
end   

m.rbfpart = set(m.rbfpart,'centers',candcenters); 
nrbfcand = size(candcenters,1);
%%%%%%%%%%%

startlamupdate = get(om,'StartLamUpdate');
maxrep = get(om,'MaxRep'); % maximum number of repeated GCV values before stopping
plotflag = get(om,'PlotFlag'); % whether to plot or not - set to 0 if using uOptRols or OptRols with this routine
tol = get(om,'tolerance');%stopping criteria for adding more centers 0<tol<1
   
width = get(m.rbfpart,'width');%width of the radial basis function
if width < eps | (length(width) >1)
   [m.rbfpart,OK] = defaultwidth(m.rbfpart,x);%set the default width
end 


t = size(m.linearmodpart,1);

%set up regression matrix 
FX = x2fx(m,x);

% compress Phik to just use the terms available to be chosen from xreglinear, plus all the
% candidate centers
linstatus= get(m.linearmodpart,'status');
FX(:,linstatus==2)= [];

lmtermsin = linstatus~=2;
termsin = [lmtermsin; logical(ones(nrbfcand,1))];
Phik = FX;
ncand = size(Phik,2);% total number of candidate terms
nlm = ncand-nrbfcand;% number of xreglinear terms considered

% start with lambda at default, zero for the polynomial terms and 1e-4 for the rbfs
lambdak = [zeros(1,nlm) 1e-4*ones(1,nrbfcand)];
lambda = [];



updateLamba= 1;
[rstats,termorder]= mx_rols(Phik,y,1e-4,[maxnparams,0,updateLamba,startlamupdate,maxrep,10^tol,0,nlm]);
nchosen= rstats(1);
termorder= termorder(1:nchosen);
bestlambda= rstats(4);
bestGCV= rstats(2);
set(m,'lambda',bestlambda);

[compressedpolyorder,polyperm] = intersect(termorder,[1:nlm]); % polynomial terms selected (from compressed list)
% work out the index of the polynomial in the uncompressed list
if ~isempty(compressedpolyorder)
    for i = 1:length(compressedpolyorder)
        [places,junk] = find(cumsum(termsin) == compressedpolyorder(i));
        polyorder(i) = min(places); 
    end
else
    polyorder = [];
end    
npoly = length(polyorder);
[centlist,perm] = setdiff(termorder,compressedpolyorder);% center numbers in increasing order
centorder = termorder(sort(perm))-nlm;
centers = candcenters(centorder,:);% centers in the order in which they were chosen
ncenters = size(centers,1);% number of centers chosen
reorderlambda = [zeros(1,t ) (1e-4)*ones(1,ncenters)];
reorderlambda(t+1:end) = bestlambda;

set(m,'lambda',reorderlambda);
m.rbfpart = set(m.rbfpart,'lambda',reorderlambda(end));

m.rbfpart = set(m.rbfpart,'centers',centers);

% sets the correct number of terms in the hybrid rbf (may destroy term/status info at top level)
m = update(m,zeros(t + ncenters,1));

% set the status in the hybrid rbf (xreglinear status stays as on entry)
m = set(m,'status',[linstatus;3*ones(ncenters,1)]);

% set up the Store for stepwise
% [m.linearmodpart,OK] = InitModel(m.linearmodpart,x,y);
lmtermstotakeout = logical(ones(t,1));
lmtermstotakeout(polyorder) = logical(zeros(size(polyorder)));% put in the chosen polyterms


% % set up the Store for stepwise
[m,OK] = InitModel(m,x,y);
% %make the terms at the xreghybridrbf level match the submodels and get the fit
termsout =  [lmtermstotakeout; ~Terms(m.rbfpart)];
[m,OK] = stepwise(m,termsout); 
% 
cost = log10(calcGCV(m,x,y)); % initialise the model and get the coefficients
setFitOpt(m,'cost',cost);

% reset the status/terms in the linearmodpart to 3/1 
m.rbfpart = setstatus(m.rbfpart,':',3);

