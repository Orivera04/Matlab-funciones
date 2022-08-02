function blk=SLConstraints(d,sys)
% SLConstraints  Create a simulink model of design constraints
%
%  BLK=SLCONSTRAINTS(D,SYS) creates a simulink model of the constraints
%  for the design D, in the system SYS.  The constraints block is returned
%  as BLK.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:47 $

% Created 3/8/2000

if builtin('isempty',d.constraints);
   % create a dummy empty constraints object
   c=des_constraints(factors(d));
else
   c=d.constraints;
end
lims=designlimits(d);
lims=cat(1,lims{:});
lb=lims(:,1);
ub=lims(:,2);
blk=slconstraints(c,sys,lb,ub);
return