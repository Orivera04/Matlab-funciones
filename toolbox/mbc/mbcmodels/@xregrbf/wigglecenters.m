function [om,OK]=wigglecenters(m)
%WIGGLECENTERS Place centers where model is wiggly
%
%  WIGGLECENTERS is a novel algorithm to move the centers to where y is
%  wiggly.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.2.4 $  $Date: 2004/04/04 03:30:33 $

om= contextimplementation(xregoptmgr,m,@i_wigglecenters,[],'WiggleCenters',@wigglecenters);
om = setAltMgrs(om,{@wigglecenters,@rols,@rederr}); % give a choice of center selection algorithms
% fit parameters
om= AddOption(om,'MaxNCenters','min(nObs/4,25)','evalstr', 'Number of centers');% percentage of data taken as centers
om= AddOption(om,'PercentCandidates','(min(nObs,200)/nObs)*100','evalstr', 'Percentage of data to be candidate centers');% number of candidate centers,take min(nObs,200)
om= AddOption(om,'Tolerance',0.0001,{'numeric',[eps 1]}, [],false);% stopping criterion
om= AddOption(om,'cost',0,{'numeric',[-Inf,Inf]},[],false);
OK = 1;



function [m,cost,OK]=i_wigglecenters(m,om,x0,x,y,varargin)
set(m,'qr','rols');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set maxncenters
nObs = size(x,1);
maxCStr= get(om,'MaxNCenters');
maxncenters = calcMaxNCenters(m,maxCStr,nObs);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nf = get(m,'nfactors');

%%%%%%%%%%%adjust the number of candidate centers in pool
PcCandStr = get(om,'PercentCandidates');
PercentCandidates = calcPercentCand(m,PcCandStr,nObs);
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
m.centers = candcenters;
ncand = size(candcenters,1);
%%%%%%%%%%%

% Get the parameters stored in m
width = m.width;%width of the radial basis function
if width < eps |size(width,1)> 1 %covers when on entry we have a width per center
    [m,OK] = defaultwidth(m,x);%set the default width
end
lambda=get(m,'lambda');
if length(lambda)>1 % only use one lambda
    lambda = lambda(end);
    set(m,'lambda',lambda);
end


%  Set up the 'full' regression matrix, Phik with all the candidate centers
% At the kth step Phik will store columns corresponding to the centers that
% have yet to be selected.
% The columns will be orthogonal to the (k-1) columns corresponding centers
% already chosen
Phik = x2fx(m,x);

k=1;
radius = sqrt(nf)/maxncenters;
distances = xregdistancepoints(candcenters,x);
neighbors = (distances<radius);
numneigh = sum((neighbors),1);% number of neighbors within radius
centorder = 1:ncand;
d = y; % will store the residual
y2 = y'*y;
B = zeros(maxncenters,ncand); %initialise the upper triangular matrix B

while k<= min(ncand,maxncenters), %loop on k
    B(k,:)= 0;
    B(k,k)= 1;
    drep = repmat(d,1,ncand-k+1);%
    yneigh = zeros(nObs,ncand-k+1);
    yvarneigh = zeros(nObs,ncand-k+1);

    %step 1
    %compute the regularised weight (gk)
    tmp = sum(Phik.*Phik,1) + lambda;
    gk = (d'*Phik)./tmp;

    % yvalues at the neighbors of the candidate centers
    yneigh(neighbors) = drep(neighbors);

    ave = sum(yneigh,1)./numneigh;% average of the y values of neighbours
    ave = repmat(ave,nObs,1);
    yvar = yneigh-ave;
    yvarneigh(neighbors) = yvar(neighbors);
    wiggle = sum(yvarneigh.^2,1)';
    [mxwiggle,kindex] = max(wiggle); % choose the candidate with the largest wiggle
    index = kindex + k-1;

    % interchanging the selected column of Phik with the 1st column of Phik
    Phik(:,[1 kindex]) = Phik(:,[kindex 1]);
    neighbors(:,[1 kindex]) = neighbors(:,[kindex 1]);
    numneigh([1 kindex]) = numneigh([kindex 1]);

    % interchange (up to the (k-1)th row) the selected column of B with the kth column of B
    B(1:k-1,[k index]) =  B(1:k-1,[index k]);

    % interchange the order of the centers
    centorder([k index])= centorder([index k]);

    % get the kth regularised weight
    g(k) = gk(kindex);

    % name the first column of Phik (corresponds to the kth center)
    wk = Phik(:,1);


    %kill the first column to remove this center from consideration
    Phik(:,1) = [];
    neighbors(:,1) = [];
    numneigh(1) = [];

    %Step 3
    %Gram-Schmidt orthogonalisatiom to make the
    %remaining columns of Phi orthogonal to wk

    ww = wk'*wk;
    B(k,k+1:ncand) = wk'*Phik/ww;
    Phik = Phik - (wk/ww)*(wk'*Phik); % (this formula appears in regularisation in the selection...)


    % Step 4
    % compute the remaining residual
    d = d - g(k)*wk;

    k = k+1;
end

nchosen = k-1;%number of centers selected

%save the centers chosen.
%note centers are in the order that they were chosen
m.centers = candcenters((centorder(1:nchosen)),:);
B = B(1:nchosen,1:nchosen);% the final upper triangular matrix
weights = B\g(1:nchosen)';%get the unregularised weights
m = update(m,weights);%load the weights into the xreglinear parent

cost = log10(calcGCV(m,x,y));%
setFitOpt(m,'cost',cost);

OK=1;
