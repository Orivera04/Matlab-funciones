function out = get(obj, property)
%% xregtextinput/SET
%%     get(xregtextinput, 'Property', Value)
%%     Property = {'numCells', 'Position', 'varName', 'Parent'}
%%
%%     Also at this time only one property per call
%%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:33:59 $

switch upper(property)
   
case {'VARNAME','NAME'}
   out = get(obj.hnd,'string');
   
case 'VISIBLE'
   out = get(obj.hnd,'visible');   
   
case 'PARENT'
   out = get(obj.hnd,'parent');  
   
case 'VALUE'
   out = [];
   
case 'USERDATA'
   out = [];
   
end %switch


