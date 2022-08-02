function out= supportTBS(m);
% xreglinear/supportTBS indicates that model supports Transform Both Sides
%
% xreglinear doesn't support TBS as TBS makes function nonlinear

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:56:02 $

out= supportTBS(get(m,'currentmodel'));