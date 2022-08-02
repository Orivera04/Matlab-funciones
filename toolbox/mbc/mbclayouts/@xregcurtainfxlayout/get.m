function  res =get(obj,parameter)
%  Synopsis
%     function  res =get(obj,parameter)
%
%  Description
%     Peforms the same action as the handle graphics get function.
%     Some parameter types are overloaded however to take into account
%     object groupings.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:39 $


ud=obj.g.info;

switch upper(parameter)
case  'POSITION' 
   res = get(obj.xregcontainer,'position');
case 'VISIBLE'
   opts={'off','on'};
   res=opts{ud.visible+1};
case 'CURTAINFX'
   opts={'off','on'};
   res=opts{ud.slidefx+1};
case 'CURTAINDIRECTION'
   opts={'north','east','south','west'};
   res=opts{ud.slidedir};
case 'CENTER'
   el=get(obj.xregcontainer,'elements');
   res=el{1};
case 'EDGEITEM'
   opts={'off','on'};
   res=opts{ud.edgeitem+1};
case 'EDGEITEMTYPE'
   res='dividerline';
case 'OPENOFFSET'
   res=ud.offsets(1);
case 'CLOSEOFFSET'
   res=ud.offsets(2);
case 'STEPSIZE'
   res=ud.stepsize;
otherwise
   res = get(obj.xregcontainer,parameter);
end
