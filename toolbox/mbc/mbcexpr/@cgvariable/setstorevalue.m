function obj = setstorevalue(obj, storekey, datakey, value)
%SETSTOREVALUE Set a value into a specified store in the variable
%
%  OBJ = SETSTOREVALUE(OBJ, STOREKEY, DATAKEY, VALUE) puts the value VALUE
%  in a store defined by STOREKEY.  Within this store the value is
%  referenced by DATAKEY.  VALUE should be a valid setting for OBJ.
%
%  STOREKEY must be a (1-by-1) guidarray.  DATAKEY can be any item that
%  conforms to the key requirements imposed by the MBCSTORE object.  Note
%  that all DATAKEYs for a given STOREKEY must always be of the same type.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/02/09 07:17:03 $ 

idx = getIndices(obj.BackupGUIDs, storekey);
if idx == 0
    % Create a new store for the value to go in
    if isscalar(value)
        newstore = mbcstore;
    elseif isvector(value)
        newstore = mbccellstore;
    else
        error('mbc:cgvariable:InvalidArgument', 'Value of a variable must be a scalar or vector.');
    end
    newstore = setvalue(newstore, datakey, value);
    obj.BackupGUIDs = [obj.BackupGUIDs, storekey];
    obj.BackupValue = [obj.BackupValue, {newstore}];
else
    if ~isscalar(value) && ~isa(obj.BackupValue{idx}, 'mbccellstore')
        % Convert the scalar-only store into one capable of saving vectors too
        obj.BackupValue{idx} = mbccellstore(obj.BackupValue{idx});
    end
    obj.BackupValue{idx} = setvalue(obj.BackupValue{idx}, datakey, value);
end