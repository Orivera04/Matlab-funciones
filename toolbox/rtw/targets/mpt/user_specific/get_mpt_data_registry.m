function data = get_mpt_data_registry(registryType,dataType)
%GET_MPT_DATA_REGISTRY Returns the initialization values.
%
%   [DATA]=GET_MPT_DATA_REGISTRY(REGISTRYTYPE,DATATYPE)
%   This function allows for a file based registration of default initial
%   values of parameters created from the data object wizard with Registry
%   type being "InitialValue" with registryType being "dataType" this provides
%   a default data type conversion in the initilization process.
%       
%   INPUTS:
%         registryType : type of registry initialization values.
%
%         dataType     : This is used only when registry type is dataType and 
%                        provides a method to convert data types during 
%                        creation of objects.
%   OUTPUTS:
%         data:        : The return value based upon the registry type
%         passed in.
%

%  Patrick W. Menter
%  Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.3.4.2 $  $Date: 2004/04/15 00:29:27 $
%  $ Revision:  $
%  $ Date:  $
%
%


data =[];

%
%  Check registry type
%



switch lower(registryType)
    
%
% for InitiaValue registry select the return initial value for data object creation  
%    
case{'initialvalue'}
    data = '0';
%    
% for the dataType registry the conversion of data types is handled here    
%
case{'datatype'}
    switch dataType
    case {'double'}
        data = dataType;
    otherwise
        data = dataType;
    end    
otherwise
   data = []; 
end

return
