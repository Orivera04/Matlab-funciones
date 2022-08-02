function delete(AxW)
% DELETE
%
%   Overloaded delete call for the axiswrapper.  Deletes contained axes.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:17:58 $

ud=AxW.g.info;
delete(ud.axes);