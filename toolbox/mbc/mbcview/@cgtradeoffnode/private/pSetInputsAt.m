function pSetInputsAt(obj, keys)
%PSETINPUTSAT Set inputs to data using specified keys
%
%  PSETINPUTSAT(OBJ, KEYS) sets all of the tradeoff inputs to the values
%  that are saved against the specified list of KEYS.  Table inputs are set
%  to the linked table cell input values for each key that is linked to a
%  table cell.  Invalid keys are not checked for, so missing keys may be
%  specifed using a value of 0, which will set inputs to their nominal
%  values for this key.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:34 $ 

pOtherInp = pGetOtherInputs(obj);
if ~isempty(pOtherInp)
    passign(pOtherInp, ...
        pveceval(pOtherInp, @copystoretovalue, obj.ObjectKey, keys, 'nominalvalue'));
end

pTableInp = pGetTableInputs(obj);
if ~isempty(pTableInp)
    % Check whether there are any table links that need to be set up
    [TableIndex, IsLinked] = getTableFromDatakey(obj.DataKeyTable, keys);
    if all(IsLinked)
        % All keys correspond to table cells
        obj.Tables(1).setinportsforcells(TableIndex{:});
    elseif any(IsLinked)
        % Some keys are cells and some are from store.  This requires that
        % we manually interleave the values from the different sources in
        % the correct order
        
        % Get table cell input values
        for n = 1:length(TableIndex)
            TableIndex{n} = TableIndex{n}(IsLinked);
        end
        obj.Tables(1).setinportsforcells(TableIndex{:});

        hTableInp = infoarray(pTableInp);
        for n = 1:length(hTableInp)
            % Vector of all values for this input
            AllValues = zeros(size(IsLinked));
            
            % Get table cell values
            AllValues(IsLinked) = getvalue(hTableInp{n});
            
            % Get store values
            hTableInp{n} = copystoretovalue(hTableInp{n}, obj.ObjectKey, ...
                keys(~IsLinked), 'nominalvalue');
            AllValues(~IsLinked) = getvalue(hTableInp{n});

            % Set all values into variable
            hTableInp{n} = setvalue(hTableInp{n}, AllValues);
        end
        passign(pTableInp, hTableInp);
    else
        % All keys are from store
        passign(pTableInp, ...
            pveceval(pTableInp, @copystoretovalue, obj.ObjectKey, keys, 'nominalvalue'));
    end
end
