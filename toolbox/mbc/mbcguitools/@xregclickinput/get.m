function out = get(obj, property)
%% xregconstinput/SET
%%     get(xregconstinput, 'Property', Value)
%%     Property = {'numCells', 'Position', 'varName', 'Parent'}
%%
%%     Also at this time only one property per call
%%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:31:30 $


ud = get(obj.text,'userdata');

switch upper(property)
   
case {'VARNAME','NAME'}
   out = get(obj.text,'string');
   
case 'CALLBACK'
   out = ud.callback;
   
case 'USERDATA'
    out = ud.UserData;
    
otherwise
    try
        out=get(obj.clickedit,property);
    catch
        warning('Not a valid XREGCLICKINPUT/GET property');
    end
    
end %switch


