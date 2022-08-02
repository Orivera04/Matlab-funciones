function out = get(obj, property)
%% xregaxesinput/GET calls to underlying gridlayout
%%     get(xregaxesinput, 'Property', Value)
%%
%%     Also at this time only one property per call
%%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:31:25 $

switch upper(property)
   
case {'HANDLES','AXES'}
    out = obj.axes;
    
case 'VALUE'
   out = [];
   
otherwise 
    try
        out = get(obj.grid, property);
    end
   
end %switch


