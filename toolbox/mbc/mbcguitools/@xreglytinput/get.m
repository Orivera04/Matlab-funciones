function out = get(obj, property)
%% xreglytinput/SET
%%     get(xreglytinput, 'Property', Value)
%%     Property = {'numCells', 'Position', 'varName', 'Parent'}
%%
%%     Also at this time only one property per call
%%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:32:16 $

switch upper(property)
   
case 'VISIBLE'
   out = get(obj.lyt,'visible');   
   
case 'PARENT'
   out = get(obj.lyt,'parent');  
   
case 'VALUE'
   out = [];
   
case 'USERDATA'
   out = get(obj.lyt,'userdata');
   
otherwise 
    try
        out = get(obj.lyt, property);
    end
   
end %switch


