function connect(obj, connectpoint, dir)
%CONNECT Connect the layout's UDD core to a UDD hierarchy
%
%  CONNECT(OBJ, CONNECTPOINT, DIR) where either OBJ and/or CONNECTPOINT are
%  layout classes will extract the UDD core data for these objects and pass
%  them on to the built-in UDD connect command.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $    $Date: 2004/02/09 07:35:13 $ 

if isa(obj, 'xregcontainer')
    obj = get(obj, 'containerdata');
end
if isa(connectpoint, 'xregcontainer')
    connectpoint = get(connectpoint, 'containerdata');
end
obj.connect(connectpoint, dir);
