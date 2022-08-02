function ModStr = tostring(con, factors)
% return a descriptive string

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.8.2 $    $Date: 2004/02/09 06:55:55 $


% Get the model pointer from the constraint
pMod = con.modptr;

if ~isempty(pMod)
    % Get the input list
    pInps = getinputs(pMod.info);
    
    % Form input string 
    inpNames = [];
    for i = 1:length(pInps)
        inpNames = [inpNames, pInps(i).getname, ', '];
    end
    inpNames = inpNames(1:end-2);
    
    % Form equation string 
    ModStr = [pMod.getname, '(', inpNames, ')'];
    ModBound = con.bound;
    BoundType = con.bound_type;
    switch con.evaltype
        case {0,1}
            if con.evaltype==1
                ModStr = ['PEV of ' ModStr];
            end
            switch BoundType
                case 0
                    ModStr = [ModStr ' <= ' num2str(ModBound)];        
                case 1
                    ModStr = [ModStr ' >= ' num2str(ModBound)];
            end
        case 2
            ModStr = ['Boundary constraint of ' ModStr];
    end
    
else
    ModStr = '';
end
