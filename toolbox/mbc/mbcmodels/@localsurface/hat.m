function h=hat(m)
%xreglinear/HAT   Hat matrix
%   h=hat(m) returns the hat matrix for the model m.  m must
%   have its store initialised with Q using initstore.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:42:12 $

h=hat(m.userdefined);