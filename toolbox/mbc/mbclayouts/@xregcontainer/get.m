function  res =get(obj,parameter)
%  Synopsis
%     function  res =get(obj,parameter)
%
%  Description
%     Peforms the same action as the handle graphics get function.
%     Some parameter types are overloaded however to take into account
%     object groupings.
%
%  Overload get methods
%     POSITION : The position of the frame.
%     ELEMENTS : All the elements in the xregcontainer.
%     PARENT   : The parent of the frame.
%     TYPE     : Returns 'container'
%     PACKSTATUS: ['off'] | 'on'   
%     USERDATA
%     BORDER   : [WEST SOUTH EAST NORTH] border around object.
%
%  Example
%
%
%  See Also
%     methods xregcontainer

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:19 $


res=get(obj.g,parameter);





