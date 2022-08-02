function ModStr = tostring(con, factors)
% return a descriptive string

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.8.2 $    $Date: 2004/02/09 06:56:22 $

% Get the model pointer from the constraint
pMod = con.modptr;

% Get the oppoint pointer from the constraint
pOp = con.oppoint;

if ~isempty(pMod)
    ModStr = pMod.getname;
    ModBound = con.bound;
    BoundType = con.bound_type;
    
    % Tell us it's a sum over an operating point set
    ModStr = ['(Sum of ', ModStr, ' over ', pOp.getname, ')'];
    
    switch BoundType
    case 0
        ModStr = [ModStr ' <= ' num2str(ModBound)];        
    case 1
        ModStr = [ModStr ' >= ' num2str(ModBound)];
    end
else
    ModStr = '';
end
