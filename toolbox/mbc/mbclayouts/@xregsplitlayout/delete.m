function delete(obj)
%DELETE Delete splitlayout object
%
% DELETE(L) deletes the layout object L.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:37:05 $

MM = MotionManager(get(obj.xregcontainer,'parent'));
MM.UnregisterManager(obj.PointerRegion);

% call container/delete
delete(obj.xregcontainer);
