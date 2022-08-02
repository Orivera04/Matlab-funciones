function e= widlamcost(param,m,x,y,alg)
%WIDLAMCOST

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:57:34 $

% cost function to optimise the width  minimises GCV

% called from the GA
m.width= param(1);

% run the fit routine e.g. iterateridge
%[m,OK]= feval(alg,m,x,y);
 [m,cost,OK] = run(alg,m,[],x,y);

%e= sum((y - eval(m,x)).^2);%SSE error 
e = cost; %GCV score