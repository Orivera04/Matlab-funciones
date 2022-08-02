function  res =get(obj,parameter)
%  Synopsis
%     function  res =get(obj,parameter)
%
%  Description
%     Peforms the same action as the handle graphics get function.
%     Some parameter types are overloaded however to take into account
%     object groupings.
%
%  Example
%          INNERBORDER :  [NORTH EAST SOUTH WEST] inner border in pixels
%          OUTERBORDER :  [NORTH EAST SOUTH WEST] outer border in pixels
%                         Note this property is obsolete: use the container
%                         BORDER property instead.
%          CENTER      :  returns the object contained in the frame
%          USERDATA    :  User-definable data store
%          VISIBLE     :  Visible setting for frame

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:36:33 $

ud=obj.rtP.info;
cdata=get(obj.xregcontainer,'containerdata');

switch upper(parameter)
    case  'POSITION' 
        res = cdata.position;
    case 'INNERBORDER'
        res=ud.borders;
        res=[-res(2)-res(4) -res(1)-res(4) res(2) res(1)];
    case 'OUTERBORDER'
        res=cdata.border;
        res=res(end:-1:1);
    case 'PARENT'
        res=cdata.parent;
    case 'CENTER'
        res=cdata.elements{1};
    case 'USERDATA'
        res=ud.userdata;
    case 'VISIBLE'
        res=get(obj.whiteline,'visible');
    otherwise
        res = get(cdata,parameter);
end
