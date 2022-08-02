function [om,OK]= centerexchange(m)
% [om,OK]= centerexchange(m) sets up the optimMgr for a center selection algorithm.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.2.3 $  $Date: 2004/02/09 07:54:26 $

om= contextimplementation(xregoptmgr,m,@i_centerexchange,[],'CenterExchange',@centerexchange);

% fit parameters
om= AddOption(om,'MaxNCenters','min(nObs/4,25)','evalstr', 'Number of centers',2);% percentage of data taken as centers - default 20 centers
om= AddOption(om,'NumLoops',20,{'int',[1, Inf]}, 'Number of augment/reduce cycles');
om= AddOption(om,'NumAugment',10,{'int',[1, Inf]}, 'Number of centers to augment by');
om= AddOption(om,'cost',0,{'numeric',[-Inf,Inf]},[],false);
OK = 1;

function [m,cost,OK]=i_centerexchange(m,om,x0,x,y,varargin)

%  Inputs:
%				m - rbf object with centers
%           om - optimMgr created above
%           x0 - unused
%				x - matrix of data points 
%				y - target values

% Outputs 
%			   m - new rbf object
%           cost - GCV value of fit
%           OK - flag to say if we encountered problems


set(m,'qr','ridge');

nObs = size(x,1);%number of data points
maxCStr= get(om,'MaxNCenters');
maxncenters = calcMaxNCenters(m,maxCStr,nObs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%% make a set of candidate centers 

centerdes = designobj(m);
nf = get(m,'nfactors');

bounds = cell(1,nf);
bounds(1,1:nf) = {[-1,1]};
ncand = 500;
% use a lattice design
centerdes = createcandset(centerdes,'lattice');
    
% Get the parameters stored in m
width = m.width;%width of the radial basis function
if any(width < eps) | size(width,1)> 1 % when each center has its own width 
   [m,OK] = defaultwidth(m,x);%set the default width
end 

lambda = get(m,'lambda') ;%regularization parameter 
if length(lambda)>1 % only use one lambda
	lambda= lambda(end);
   set(m,'lambda',lambda) ;
end    


numloops = get(om, 'NumLoops');
centerdes=augment(centerdes,maxncenters);
m.centers = factorsettings(centerdes);

m = update(m, zeros(size(m.centers,1),1)); % increase the size of the linearmod
% reinitialise the model with the new centers
[m, OK ]  = leastsq(m,x,y);

% get the stats
 S= stats(m,'summary',x,y);

press = S(4).^2.*nObs;
p = min(get(om, 'NumAugment'), nObs - maxncenters-1) ;% number of points to add in each loop

nObs = size(x,1);
% set the model in the design object
centerdes = model(centerdes, m);
for i = 1:numloops
   % take a copy of design object in case things get worse
   desobj=getdesign(centerdes);
   
   % add p new points
   centerdes=augment(centerdes,p);
   
    
   m.centers = factorsettings(centerdes);
   m = update(m, zeros(size(m.centers,1),1)); % increase the size of the linearmod

   % reinitialise the model with the new centers
   [m, OK ]  = leastsq(m,x,y);

   
   %delete p points
   [m, centerdes, newpress]=centerdelete(m, x, y, centerdes,press,p);
   
   if newpress > press
      centerdes = desobj;
   else
      press = newpress;
   end   
end

m = update(m, zeros(size(m.centers,1),1)); % increase the size of the linearmod
[m, OK] = leastsq(m,x,y);%get the unregularised weights

cost = log10(calcGCV(m,x,y));%
setFitOpt(m,'cost',cost);
OK=1;
