function firebtndn(obj)
% FIREBTNDN   Activate Buttondownfcn for frame3dlayout
%
%   FIREBTNDN(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:35 $


ud=get(obj.blackline,'userdata');
xregcallback(ud.buttondownfcn);