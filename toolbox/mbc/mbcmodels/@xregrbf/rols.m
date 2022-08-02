function [om,OK]=rols(m)
% XREGRBF/ROLS regularized orthogonal least squares (rols) 
%
%  Center selection algorithm for rols. Implemented as an xregoptmgr. This
%  is normally a sub xregoptmgr (of e.g iteraterols or iterateridge)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.7.4.3 $  $Date: 2004/02/09 07:57:16 $

om= contextimplementation(xregoptmgr,m,@i_rols,[],'Rols',@rols);
om = setAltMgrs(om,{@rols,@rederr,@wigglecenters, @centerexchange}); % give a choice of center selection algorithms 
% fit parameters
om= AddOption(om,'MaxNCenters','min(nObs/4,25)','evalstr', 'Maximum number of centers', 2);% percentage of data taken as centers - default 20 centers
om= AddOption(om,'PercentCandidates','(min(nObs,200)/nObs)*100','evalstr','Percentage of data to be candidate centers');% number of candidate centers,take min(nObs,200)
om= AddOption(om,'Tolerance',0.0001,{'numeric',[eps 1]},'Regularized error tolerance');% stopping criterion
om= AddOption(om,'cost',0,{'numeric',[-Inf,Inf]},[],false);
OK = 1;

function [m,cost,OK,newlam]=i_rols(m,om,x0,x,y,Phik,candcenters,width)
% implementation of the Regularized Orthogonal Least Squares algorithm (ROLS)
% reference: S. Chen, E. S. Chng, and K. Alkadhim, "Regularized Orthogonal Least Squares Algorithm for Constructing Radial
% Basis Function Networks", Int. J. Control, 1996, vol. 64, No. 5, 829--837
% Uses a forward selection algorithm to choose centers from the set 
% of data points  

%  created by Tanya Morton 19/9/2000
%  MathWorks Ltd

%  Inputs:
%    m - rbf object with centers
%    om - optimmgr == user options
%    x0 - (ignored)
%    x - matrix of data points 
%    y - target values
%    Phik - (optional) regression matrix for RBF. If candcenters is given, then 
%        Phik must be the regression matrix for the RBF with these centers.
%    candcenters - (optional) set to choose centers from. If not given then the 
%        data points x are used as the candidate center set.
%    width - (optional) width to use. Allows a width per center or width per 
%       center per dimension to be associated with the candidate centers. If 
%       not specified, a global width or width per dim is taken from given RBF 
%       model
%
% Outputs:
%    m - new rbf object


if nargin<6
   Phik=[];
end
if nargin < 7 | isempty( candcenters ),
    candcenters = x;
end
if nargin < 8 | isempty( width ),
    width = get( m, 'width' );
    if size( width, 2 ) ~= 1,
        width = width(1,:);
    end
end
set(m,'qr','rols');

nObs = size(x,1);%number of data points
maxCStr= get(om,'MaxNCenters');
maxncenters = calcMaxNCenters(m,maxCStr,nObs);

% adjust the number of candidate centers in pool
PcCandStr = get(om,'PercentCandidates');
PercentCandidates = calcPercentCand(m,PcCandStr,nObs);
approxncand = max(1,round((PercentCandidates/100)*nObs)); %approximate number of candidate points to try
ncand = size(candcenters,1);
if ncand > approxncand,
    state = rand('state');
    rand('state',0);
    randint = randperm(ncand);
    candcenters = candcenters(randint(1:approxncand),:);
    ncand = size(candcenters,1);
    if size( width, 1 ) > 1,
        width = width(randint(1:approxncand),:);
    end
    if ~isempty(Phik)
       Phik= Phik(:,randint(1:approxncand));
    end
    rand('state',state);
end   
m.centers = candcenters; 
m.width   = width; 
maxncenters = min( maxncenters, ncand );

%%%%%%%%%%%
    
% Get the parameters stored in m
width = m.width;%width of the radial basis function
if any(width < 0.0), % was < eps
   [m,OK] = defaultwidth(m,x);%set the default width
   Phik=[];
end 

lambda = get(m,'lambda') ;%regularization parameter 
if length(lambda)>1 % only use one lambda
	lambda= lambda(end);
   set(m,'lambda',lambda) ;
end    

tol = get(om,'tolerance');%stopping criteria for adding more centers 0<tol<1

%  Set up the 'full' regression matrix, Phik with all the candidate centers
% At the kth step Phik will store columns corresponding to the centers that 
% have yet to be selected. 
% The columns will be orthogonal to the (k-1) columns corresponding centers 
% already chosen 
if isempty(Phik)
   Phik = x2fx(m,x);
end

% calculation done by private mex functions
[gcv,centorder,weights]= mx_rols(Phik,y,lambda,[maxncenters,tol]);

nchosen= gcv(1);
if nchosen
   %save the centers chosen. 
   %note centers are in the order that they were chosen
   m.centers = candcenters((centorder(1:nchosen)),:);
   if size( m.width, 1 ) > 1,
       m.width = width((centorder(1:nchosen)),:);
   end
   %B = B(1:nchosen,1:nchosen);% the final upper triangular matrix 
   %weights = B\g(1:nchosen)';%get the unregularised weights
else
   % no centers
   m.centers= zeros(0,size(candcenters,2));
   weights= zeros(0,1);
end

m = update(m,weights);%load the weights into the xreglinear parent

% cost = log10(calcGCV(m,x,y));%
cost = log10(gcv(2));
newlam= gcv(3);
setFitOpt(m,'cost',cost(1));
OK=1;
