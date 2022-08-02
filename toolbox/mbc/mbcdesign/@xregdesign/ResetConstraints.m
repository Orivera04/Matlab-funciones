function des=ResetConstraints(des)
% RESETCONSTRAINTS  delete design constraints indices
%
%   D=RESETCONSTRAINTS(D) empties the design constraints indices
%   in D.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:06:05 $

% Created 12/6/2000

if ~isempty(des.constraints)
   des.constraints = reset(des.constraints);
   % indicator to make sure they are recalced before doing anything
   des.candstate = des.candstate+1;
end