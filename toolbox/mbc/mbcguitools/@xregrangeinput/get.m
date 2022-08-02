function out = get(obj, property)
%% xregrangeinput/SET
%%     get(xregrangeinput, 'Property', Value)
%%     Property = {'numCells', 'Position', 'varName', 'Parent'}
%%
%%     Also at this time only one property per call
%%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:32:41 $


ud = get(obj.name,'userdata');

switch upper(property)
   
case {'VARNAME','NAME'}
   out = get(obj.name,'string');
   
case 'VISIBLE'
   out = get(obj.name,'visible');   
   
case 'PARENT'
   out = get(obj.name,'parent');
   
case 'POSITION'
   pos1 = get(obj.name,'position');
   bl = [pos1(1) pos1(2) 0 0];
   pos2 = get(obj.edit(3),'position');
   ur = [0 0 pos2(1)+pos2(3)-pos1(1) pos2(2)+pos2(4)-pos1(2)];
   out = bl+ur;
   
case 'MIN'
   out = ud.min;
   
case 'MAX'
   out = ud.max;
   
case 'CALLBACK'
   out = ud.callback;
   
case 'VALUE'
   out = linspace(ud.min,ud.max,ud.points);
   
case 'RANGE'
   out = [ud.min, ud.max];
   
case 'USERDATA'
   out = ud.UserData;
   
end %switch


