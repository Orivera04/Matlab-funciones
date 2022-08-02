function q=diff(s);
% QUADSPLINE/DIFF differentiate

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:41:04 $




q=s;
q.quadlow  = diff(s.quadlow);
q.quadhigh = diff(s.quadhigh);