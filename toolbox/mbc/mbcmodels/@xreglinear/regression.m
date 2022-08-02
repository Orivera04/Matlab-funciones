function [r,ok]=regression(m)
% r=REGRESSION(m) returns the regression matrix for the model m

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:50:03 $

if ~isfield(m.Store,'Q')
   error('Use initstore first to initialise data in the model');
end

r=m.Store.X;
if ~isempty(r)
   r=r(:,terms2(m));
end

if nargout>1
   % rank check on regression matrix
   ok=~(rank(r)<size(r,2));   
end
