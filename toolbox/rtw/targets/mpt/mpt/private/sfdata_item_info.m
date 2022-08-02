function info = sfdata_item_info(info)
%SFDATA_ITEM_INFO extracts common components of all data items. 
%
%   INFO = GET_DATA_DETAIL( INFO)  will extract all common components of
%   interest including name, array size, data type, min/max, fixpoint, etc
%        
%   INPUT:
%       info:   
%   OUTPUT:
%       info: 

%   Steve Toeppe
%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.8.4.2 $  
%   $Date: 2004/04/15 00:28:55 $

info.name = fliplr(deblank(fliplr(deblank(sf('get',info.dataH,'.name')))));
info.arraySize = sf('get',info.dataH,'.parsedInfo.array.size');
if isempty(info.arraySize) == 1
    info.arraySize = 1;
end
info.sfDataType = sf('get',info.dataH,'.sfDataType');
temp = sf('get',info.dataH,'.dataType'); 

if strcmp(temp,'fixpt')
    temp = sf('get',info.dataH,'.fixptType.baseType');
end

if isempty(temp),
    info.rtwDataType = sf_type_to_rtw_type(info.sfDataType);
else
    info.rtwDataType = sf_type_to_rtw_type(temp);
end
initFromWorkspace = sf('get',info.dataH,'.initFromWorkspace');
info.description = sf('get',info.dataH,'.description');
info.min = sf('get',info.dataH,'.props.range.minimum');
info.max = sf('get',info.dataH,'.props.range.maximum');
info.units = sf('get',info.dataH,'.units');
info.initFromWorkspace = initFromWorkspace;

% if initFromWorkspace == 0,
if info.arraySize ==  1,   
    info.InitialValue = sf('get',info.dataH,'.props.initialValue');
else
    iValue = sf('get',info.dataH,'.props.initialValue');   
    arraySizeTot = 1;
    for ind=1:length(info.arraySize)
        arraySizeTot = arraySizeTot * info.arraySize(ind);
        index(ind) = info.arraySize(ind);
    end
    
    if length(info.arraySize) > 1,
        arrayStr = ['[ '];
        comma =' ';
        for index1=1:index(1),      
            for index2=1:index(2), 
                arrayStr = [arrayStr,comma,num2str(iValue)];
                comma =', ';
            end
            arrayStr = [arrayStr,';'];        
        end
    else
        arrayStr = ['[ '];
        comma =' ';
        for ixd=1:(arraySizeTot),
            arrayStr = [arrayStr,comma,num2str(iValue)];
            comma=', ';
        end    
    end
    arrayStr = [arrayStr,']'];
    info.InitialValue = arrayStr;        
end
% else
%     info.InitialValue = '0';  
% end

info.unique.id = sf('get',info.dataH,'.unique.id');
info.unique.name = sf('get',info.dataH,'.unique.name');
%info.unique.fullName = sf('get',info.dataH,'.unique.fullName');
info.unique.initValue = sf('get',info.dataH,'.unique.initValue');
info.parent = sf('get',info.dataH,'.linkNode.parent');
version = sf_get(bdroot,'Version');
if version > 5.0013e+007,
    info.fixPtBias = sf('get',info.dataH,'.fixptType.bias');
    info.fixPtSlope = sf('get',info.dataH,'.fixptType.slope');
    info.fixPtExponent = sf('get',info.dataH,'.fixptType.exponent');
    info.fixPtBaseType = sf('get',info.dataH,'.fixptType.baseType');
else
    info.fixPtBias = [];
    info.fixPtSlope = [];
    info.fixPtExponent = [];
    info.fixPtBaseType = [];
end