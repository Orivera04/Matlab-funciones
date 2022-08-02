function scaledValue = fixpt_scaled_num(value,objName)
%FIXPT_SCALED_NUM scales real number for fixed point scaled number
%  SCALEDVALUE = FIXPT_SCALED_NUM(VALUE) 
%        It will scale a decimal number to get a quantized fixed point 
%        value. 
%  INPUT:
%        value:   real-world value 
%        objName: name of the object 
%  OUTPUT:
%        scaledValue: quantized fixed point value. 
%
% Use the the following formula to calcutate:
%   value = slope * newValue + bias
% so 
%   newValue = (value-bias)/slope
%   scaledValue = round(newValue)

%  Linghui Zhang
%  Copyright 2002-2004 The MathWorks, Inc.
%  $Revision: 1.1.6.6 $
%  $Date: 2004/04/15 00:28:03 $

mpmResult = rtwprivate('rtwattic', 'AtticData', 'mpmResult');
ecac = rtwprivate('rtwattic', 'AtticData', 'ecac');

if isempty(mpmResult) | isfield(mpmResult,'warning')==0
    mpmResult.warning = {};
end
lf=sprintf('\n');
scaledValue = value;
modelName = ecac.modelName;
if get_data_info(objName,'ISFIXPT',modelName) == 1
    lens= str2num(get_param(ecac.modelName,'ProdHWWordLengths'));
    charLen = lens(1);         % 8
    shortLen = lens(2);        % 16
    intLen = lens(3);          % 32
    longLen = lens(4);         % 32
    
    dataType = get_data_info(objName,'DATATYPE',modelName);
    scaling = get_data_info(objName,'SLSCALING',modelName);
    if length(scaling) > 1
        slope = scaling(1);
        bias = scaling(2);
    else
        slope = scaling;
        bias = 0;
    end
    switch (dataType)
        case 'uint8'
            max = 2^charLen-1;
            min = 0;
        case 'int8'
            max = 2^(charLen-1)-1;
            min = -2^(charLen-1);
        case 'uint32'
            max = 2^intLen-1;
            min = 0;
        case 'int32'
            max = 2^(intLen-1)-1;
            min = -2^(intLen-1);
        case 'uint16'
            max = 2^shortLen-1;
            min = 0;
        case 'int16'
            max = 2^(shortLen-1)-1;
            min = -2^(shortLen-1);
        otherwise
            disp('Unsupported Fixed-Point Data Type');
    end
    err = 0;
    fixNumOutOfRang = '';
    detailMsg = '';
    if slope == 0
        err = 1; 
        fixNumOutOfRang = objName;
        detailMsg = ['   Fixed-point data out of range due to its scope set to zero:',lf,...
                     '                  ',objName];
    else
        newValue = (value-bias)/slope;
        scaledValue = round(newValue);
        [r,c]=size(scaledValue);
        for i = 1:r
            for j = 1:c        
                if scaledValue(i,j) > max
                    scaledValue(i,j) = max;
                    fixNumOutOfRang = objName;
                    err = 2;
                    break;
                elseif scaledValue(i,j) < min
                    scaledValue(i,j) = min;
                    fixNumOutOfRang = objName;                   
                    err = 2;
                    break;                    
                end
            end
            if err == 2
                break;
            end
        end
    end
    if isempty(fixNumOutOfRang) == 0
        if err == 2
            detailMsg = ['   Fixed-point data out of range:',lf,...
                         '                 ',objName];
        end
        msg = 'Fixed-Point Number out of Range';
        if isempty(mpmResult.warning) == 1 | isequal(mpmResult.warning{end}.detailMsg,detailMsg) == 0
            disp(['*** Warning: ',detailMsg]);
            mpmResult.warning{end+1}.detailMsg = detailMsg;
            mpmResult.warning{end}.msg = msg;
            mpmResult.warning{end}.type = 'Warning';
        end
    end
end
rtwprivate('rtwattic', 'AtticData', 'mpmResult',mpmResult);
