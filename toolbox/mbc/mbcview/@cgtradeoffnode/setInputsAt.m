function setInputsAt(obj, indextype, varargin)
%SETINPUTSAT Set input variables to specified saved presets
%
%  SETINPUTSAT sets the values of input to items in the tradeoff to the
%  values that were last stored for a particular data point, or their
%  nominal values if there is no stored value.
%
%  SETINPUTSAT(OBJ, 'list', index) sets the inputs to correspond to the
%  specified data point in the saved list.
%
%  SETINPUTSAT(OBJ, 'table', R, C) sets the inputs to correspond to the
%  specified table index.
%
%  SETINPUTSAT(OBJ, 'all') sets the inputs to correspond to all saved data
%  points.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:43 $

switch indextype
    case 'list'
        datakey = getDatakeyFromIndex(obj.DataKeyTable, varargin{1});
        pSetInputsAt(obj, datakey);

    case 'table'
        [datakey, EXISTS] = getDatakeyFromTable(obj.DataKeyTable, varargin{:});
        pSetInputsAt(obj, datakey);
        % Force the table inputs to the specified cell, even if the data
        % key did not exist
        if ~EXISTS && numTables(obj) > 0
            obj.Tables(1).setinportsforcells(varargin{:});
        end
        
    case 'all'
        pSetInputsAt(obj, getAllDatakeys(obj.DataKeyTable));
        
    otherwise
        error('mbc:cgtradeoffnode:InvalidArgument', 'Unrecognised index type.');
end
