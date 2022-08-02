function out = get(obj, property)
%% xregconstinput/SET
%%     get(xregconstinput, 'Property', Value)
%%     Property = {'numCells', 'Position', 'varName', 'Parent'}
%%
%%     Also at this time only one property per call
%%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:31:52 $


ud = get(obj.text,'userdata');

switch upper(property)
   
case {'VARNAME','NAME'}
   out = get(obj.text,'string');
   
case 'VISIBLE'
   out = get([obj.edit obj.text],'visible');   
   
case 'PARENT'
   out = get([obj.edit obj.text],'parent');   
   
case 'MIN'
   out = ud.min;
   
case 'MAX'
   out = ud.max;
   
case 'CALLBACK'
   out = ud.callback;
   
case 'VALUE'
   tmp = get(obj.edit,'string');
   tmpN = str2num(tmp);
   if ~isempty(tmpN)
      out = tmpN;   
  elseif ~isempty(tmp)
      out = tmp;
  else
	  out = [];
   end   
case 'RANGE'
   out = [ud.min ud.max];
   
case 'USERDATA'
   out = ud.UserData;
   
case 'CHARSTATUS'
   if ud.CharStatus
      out = 'on';
   else
      out = 'off';
   end
   
end %switch


