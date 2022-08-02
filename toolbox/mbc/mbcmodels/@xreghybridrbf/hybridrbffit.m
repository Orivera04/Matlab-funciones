function [m,OK] = hybridrbffit(m,x,y);
%HYBRIDRBFFIT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:48:11 $

% temporary funnel for xreghybridrbf routines
% created 28/2/2001


width = get(m.rbfpart,'width');%width of the radial basis function
if any(width) < eps 
   [m.rbfpart,OK] = defaultwidth(m.rbfpart,x);%set the default width
end 

% If last model run had a different number of terms then the length of 
% lambda is different from the number of terms.  Increase the size of lambda
% to match
lambda = get(m,'lambda');
termsin = Terms(m);
if (length(lambda) > 1) & ~isequal(length(lambda), length(termsin))
    set(m, 'lambda', lambda(1)*ones(size(termsin)));
end

%initial test to see if all is OK, but don't use the result
[mjunk,OK] = InitModel(m,x,y,[]); 
if OK
    [m,cost,OK] = run(getFitOpt(m),m,[],x,y);
    [m,OK] = InitModel(m,x,y); % store the matrices for computing the stats
    m = setFitOpt(m,'cost',cost);
    set(m,'fitalg','leastsq');
else
    m=mjunk;
end  

