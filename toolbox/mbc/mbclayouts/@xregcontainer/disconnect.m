function disconnect(obj)
%DISCONNECT Disconnect the layout's UDD core from a UDD hierarchy
%
%  DISCONNECT(OBJ, ) will extract the UDD core data for tOBJ and pass
%  them on to the built-in UDD disconnect command.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $    $Date: 2004/02/09 07:35:17 $ 

obj = get(obj, 'containerdata');
obj.disconnect;
