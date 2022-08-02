function e= widcost(param,m,x,y,alg)
%WIDCOST

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:57:33 $

% cost function to optimise the width and regularisation parameters
% called from the GA
% uses algorithm 'alg' e.g. ridge or rols
m.width= param(1);
set(m,'lambda',param(2));

N=size(x,1); % number of data points

%if rols or rederr the centers will change each time
[m,cost,OK] = run(alg,m,[],x,y);

e= cost;%log10(GCV)
