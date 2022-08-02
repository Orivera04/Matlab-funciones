function ind=convunique(ind,lst)
% CONVUNIQUE  make a set of numbers unique
%   I=CONVUNIQUE(I,X) converts the set of numbers I so
%   that they are unique from each other and also from the numbers
%   in X.  This is done by 'removing' each number from the
%   total list as it appears so that [1 1 2] will pick the 1st, 2nd,
%   and 4th numbers available.  The indices in X are assumed to be
%   unavailable from the start.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:29 $

% Created 4/11/99

if nargin>1
   % remove any duplicates from lst
   lst=unique(lst(lst>0));
else
   lst=[];
end

% call mex function
ind=convunique_loop(lst,ind);
return



