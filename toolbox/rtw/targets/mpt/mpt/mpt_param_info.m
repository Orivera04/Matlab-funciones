function param = mpt_param_info(paramName)

%   Steve Toeppe
%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $
%   $Date: 2003/06/14 03:36:26 $
param=[];
param.name = paramName;
param.fileName = [];
param.functionName = [];
param.ref=[];
dSize = [];
dataType = [];
try
    obj = evalin('base',paramName);
    data = obj;
    objClass = evalin('base',['class(',paramName,')']);
    dataClass = objClass;
    
    % if isa(obj,'mpt.Parameter') == 1
    %     dSize = prod(size(obj.Value));
    %     data = obj.Value;
    %     dataClass = class(obj.Value(1));
    % end
    
    dataType = get_data_obj_type(dataClass);
    
    if isempty(dataType) == 0
        dSize = prod(size(data));
        baseMO = 1;
    else
        try
            baseMO = 0;
            dSize = prod(size(obj.Value));
            data = obj.Value;
            dataClass = class(obj.Value(1));
            dataType = get_data_obj_type(dataClass);
        catch
            param = [];
            return           
        end
    end
    param.dataType=dataType;
    param.class = objClass;
    param.width = dSize;
    param.baseMO = baseMO;
catch
    param = [];
    return
end
function dataType  = get_data_obj_type(dataClass)

switch(dataClass)
    case {'double','single','uint8','uint16','uint32','int8','int16','int32','boolean','logical'}
        if strcmp(dataClass,'logical') == 1
            dataType = 'boolean';
        else
            dataType = dataClass;
        end
%         data=evalin('base',paramName);
    otherwise

        dataType = [];
end