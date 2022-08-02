function u=username(mp)
%USERNAME  return username from Project
%
%  u=username(mp);
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 08:06:53 $


% Warning: this function should not be used.  Instead directly call the
% preferences as in the command below.
u=getusername(initfromprefs(mbcuser));