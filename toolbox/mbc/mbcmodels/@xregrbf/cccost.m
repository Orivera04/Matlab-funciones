function [e,res]= cccost(x_pop,training_quota,learning_rate,m,x,y)
%CCCOST

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:54:24 $

% cost function to optimise the width and centers using a cooperative/competetive GA
nf = get(m,'nfactors');
N = size(x,1);
m.width = x_pop(:,1);
m.centers = x_pop(:,2:nf+1);
npasses =0;
weights = zeros(size(m.centers,1),1);% start off with zero weights

FX= x2fx(m,x); % create the regression matrix
divisor = sqrt(sum(FX.^2,1));
divisor(divisor < eps) = Inf;
for j = 1:size(FX,2)
    normFX(:,j)= FX(:,j)/divisor(j); %normalise it
end
i =0;
while length(weights)*npasses < training_quota
   r = y - normFX*weights; % error vector
   weights = weights + 2*learning_rate*((normFX)'*r);   
   %ee(npasses+1) = sum(r.^2);
   npasses = npasses + 1;
end    

%res = ee(end);

res =sum(r.^2);
aveweights = mean(abs(weights).^(3/2));
e = ((abs(weights).^(3/2))/aveweights)';

