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
%          CENTER      :  returns the object contained in the frame
%          VISIBLE     :  Visible setting for frame
% 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:36:38 $


cdata=get(obj.xregcontainer,'containerdata');
ud=obj.ptr.info;
switch upper(parameter)
    case 'CENTER'
        els=cdata.elements;
        res=els{1};
    case 'VISIBLE'
        res=get(obj.outerpanel,'visible');
    case 'TITLE'
        res=get(obj.title,'string');
    case 'TITLEHEIGHT'
        res = ud.titleheight;
    case 'TOTALTITLEHEIGHT'
        res = ud.titleheight;
        if ud.divider
            res = res + 5;
        end
    case 'DIVIDER'
        res = ud.divider;
    case 'TITLEBORDER'
        res = ud.titleborder;
    case 'SELECTABLE'
        res={'off','on'};
        res=res{ud.selectmode+1};
    case 'SELECTED'
        res={'off','on'};
        res=res{ud.selected+1}; 
    case 'TITLEFONTSIZE'
        res = get(obj.title, 'fontsize');
    otherwise
        res = get(cdata,parameter);
end
