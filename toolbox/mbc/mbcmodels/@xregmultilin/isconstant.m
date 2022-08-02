function ic= IsConstant(m)
%ISCONSTANT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:55:33 $

ic= isconstant(get(m,'currentmodel'));
