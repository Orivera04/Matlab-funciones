function [m,OK]=initcenters(m,X,v)
%INITCENTERS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:54:49 $

% routine for initialising center locations

m.centers=[];% centers will be chosen by this algorithm

ncenters = get(m,'maxncenters'); % number of centers to add
N = size(X,1);%number of data points

nf = get(m,'nfactors');
nperms = 500;
vars=0;
randst=zeros(35,1);
inds=zeros(ncenters,nf);

% reset random generator
rnd=sum(100*clock);
rand('state',rnd);
minrandst=zeros(35,1);

minvar=0;
for n=1:nperms
   % initialise random state
   [inds,randst]=i_geninds(N);
   inds= inds(1:ncenters);
   candset = X(inds,:);
   vars= mx_distance(candset,1);             % computes the minimum distance between the points
   if vars>minvar
      minvar=vars;
      minrandst=randst;
   end
end
clear inds;
% reconstruct best indices
rand('state',minrandst); % go back to the best random state
inds=randperm(N)';

inds= inds(1:ncenters);

centers = X(inds,:);
m.centers = centers;
m.ncenters = ncenters;
m.xreglinear = update(m.xreglinear,zeros(ncenters,1));
OK =1;


%try initialising using DoE and the Latin hypercube - didn't work
%d = design;
%d = nfactors(d,nf);
%d = model(d,m);%set the model in the design
%conditiong was terrible
%bounds = cell(1,nf);
%bounds(1,1:nf) = {[-1,1]};
%d = candspace(d,'lhs',bounds,ncenters,'minimax');
%codecenters = candidates(d);

%first try randomly initialising from within data points
%permind =  randperm(ndatapoints);
%centers = X(permind(1:ncenters),:);


function [inds,rnd]=i_geninds(N)

rnd=rand('state');
% initialise random state
   inds=randperm(N)';
return
