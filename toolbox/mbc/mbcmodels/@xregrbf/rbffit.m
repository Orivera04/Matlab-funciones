function  [m,OK] = rbffit(m,x,y);
%RBFFIT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:57:12 $

% temporary funnel for rbf routines
% created 30/11/2000

width = m.width;%width of the radial basis function
if any(width) < eps 
   [m,OK] = defaultwidth(m,x);%set the default width
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
[mjunk,OK] = InitModel(m,x,y); 

if OK
    [m,cost,OK] = run(getFitOpt(m),m,[],x,y);
    [m,OK] = InitModel(m,x,y); % store the matrices for computing the stats
    if ~isempty(cost)
        setFitOpt(m,'cost',cost);
    end
    set(m,'fitalg','leastsq');
else
     m=mjunk;
end  

