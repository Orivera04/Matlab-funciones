function out = pevcheck(m);
% MODEL/PEVCHECK default check to see if pev can be calculated
%
% default is not calculate

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:52:50 $


% quick check to see whether a model m has been PEVed or not.
% This will send a dummy set of numbers into the model and then check sizes.
% If there is a match then we assume that all is well.

out= ~isempty(m.Stats.Rinv);

