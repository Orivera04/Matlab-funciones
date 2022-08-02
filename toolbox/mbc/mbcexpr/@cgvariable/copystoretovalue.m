function obj = copystoretovalue(obj, storekey, datakey, nodataaction)
%COPYSTORETOVALUE Set the value of a variable to a stored value
%
%  OBJ = COPYSTORETOVALUE(OBJ, STOREKEY, DATAKEY, NODATAACTION) sets the
%  value of OBJ to be the value stored in the store specified by STOREKEY,
%  and the key within that store specified by DATAKEY.  NODATAACTION
%  specifies what should be done if there is no stored value at that
%  (STOREKEY, DATAKEY) combination and may be set to one of 'nominalvalue',
%  'noaction', or 'error'.  If NODATAACTION is not specified, the default
%  setting is 'nominalvalue'.  The settings of NODATAACTION cause the
%  following behaviour:
%
%    nominalvalue  :  The object's value is replaced with it's nominal
%                     value.
%    noaction      :  The object's value is left unchanged.
%    error         :  An error is thrown if there is no value to use.
%
%  Multiple datakeys may be specified, in which case the value of OBJ will
%  be set to a vector of corresponding values.  If more than one datakey is
%  specified, NODATAACTION cannot be 'error'.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.4 $    $Date: 2004/02/09 07:16:31 $ 

if nargin<4
    nodataaction = 'nominalvalue';
end
newvalue = [];
idx = getIndices(obj.BackupGUIDs, storekey);
if length(datakey)==1
    if idx > 0
        newvalue = getvalue(obj.BackupValue{idx}, datakey);
    end
    if isempty(newvalue)
        if strcmp(nodataaction, 'nominalvalue')
            obj = setpoint(obj);
        elseif ~strcmp(nodataaction, 'noaction')
            error('mbc:cgvariable:InvalidArgument', 'No stored value exists for specified keys.');
        end
    else
        obj = setvalue(obj, newvalue);
    end
else
    if strcmp(nodataaction, 'nominalvalue')
        defvalue = getnomvalue(obj);
    elseif strcmp(nodataaction, 'noaction')
        defvalue = getvalue(obj);
    else
        error('mbc:cgvariable:InvalidArgument', 'Invalid option for no data action.');
    end    
    if idx > 0
        if isa(obj.BackupValue{idx}, 'mbccellstore')
            storevals = getvalues(obj.BackupValue{idx}, datakey, {defvalue});
            newvalue = cat(1, storevals{:});
        else
            newvalue = getvalues(obj.BackupValue{idx}, datakey, defvalue);
        end
    else
        newvalue = repmat(defvalue, size(datakey));
    end
    obj = setvalue(obj, newvalue);
end
