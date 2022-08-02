function obj = captureInputsAt(obj, indextype, varargin)
%CAPTUREINPUTSAT Save current value of input variables
%
%  CAPTUREINPUTSAT saves the current value of each input to the tradeoff.
%  This can then be restored at a later point using the SETINPUTSAT method.
%
%  OBJ = CAPTUREINPUTSAT(OBJ, 'new') creates a new datakey that is not
%  linked to a table cell and stores the input variable values there.
%
%  OBJ = CAPTUREINPUTSAT(OBJ, 'list', index) saves the inputs using the
%  datakey that is listed at the index-th position in the saved list.
%
%  OBJ = CAPTUREINPUTSAT(OBJ, 'table', R, C) saves input values at the
%  datakey associated with the table cell (R, C).  If there is no existing
%  data for that cell, a save location is added that is linked to this
%  table cell.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:37:15 $ 

switch indextype
    case 'new'
        [obj.DataKeyTable, datakey] = addDatakeys(obj.DataKeyTable);
        
    case 'list'
        datakey = getDatakeyFromIndex(obj.DataKeyTable, varargin{1});

    case 'table'
        [datakey, EXISTS] = getDatakeyFromTable(obj.DataKeyTable, varargin{:});
        if ~EXISTS
            % Create a new datakey for this table cell
            [obj.DataKeyTable, datakey] = addTableDatakeys(obj.DataKeyTable, varargin{:});
        end
        
    otherwise
        error('mbc:cgtradeoffnode:InvalidArgument', 'Unrecognised index type.');
end

pAll = [pGetTableInputs(obj), pGetOtherInputs(obj)];
if ~isempty(pAll) && pCheckScalarInputs(obj)
    passign(pAll, pveceval(pAll, @copyvaluetostore, obj.ObjectKey, datakey));
end

% Take note of saving action by incrementing the counter associated with
% this datakey
obj.DataKeyTable = incrementSaveCounter(obj.DataKeyTable, datakey);

xregpointer(obj);
