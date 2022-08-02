function obj = initTableInputsForValidCells(obj, pT)
%INITTABLEINPUTSFORVALIDCELLS A short description of the function
%
%  OBJ = INITTABLEINPUTSFORVALIDCELLS(OBJ, PT) adds saved values for the
%  table inputs that correspond to the valid filling item evaluation cells
%  in table PT.  Any saved values that already exist for these table cells
%  will not be over-written.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/04/04 03:36:33 $ 

% Get mask expression and check it isn't null
[pFill, pMask] = getFillExpression(obj, pT);
if isnull(pMask)
    return
end

setInputsAt(obj, 'table', 1, 1);
OK = pT.setinportsforcells;
if OK
    pInp = pGetTableInputs(obj);
    G = pMask.getSwitchGrid(pInp);
    [R, C] = find(G);
    new = ~containsTable(obj.DataKeyTable, R, C);
    
    % Add data keys for new input settings
    R = R(new);
    C = C(new);
    [obj.DataKeyTable, datakeys] = addTableDatakeys(obj.DataKeyTable, R, C);
    
    % Add saved values for table inputs at the new input settings
    hInputs = infoarray(pInp);
    InputVals = pveceval(pInp, @getvalue);
    for n = 1:length(R)
        hInputs{1} = setstorevalue(hInputs{1}, obj.ObjectKey, ...
            datakeys(n), InputVals{1}(R(n)));
        hInputs{2} = setstorevalue(hInputs{2}, obj.ObjectKey, ...
            datakeys(n), InputVals{2}(C(n)));
    end
    passign(pInp, hInputs);
       
    % Update object's heap copy with datakey changes
    xregpointer(obj);
end
