function QuantityTypeList = listquantitytypes
%LISTQUANTITYTYPES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:48:32 $

%LISTQUANTITYTYPES  List all registered quantity types.
%
%   QuantityTypeList = LISTQUANTITYTYPES lists all registered quantity types.

% ---------------------------------------------------------------------------
% Description : Method to list all registered quantity types.
% Outputs     : QuantityTypeList - list of registered quantity types ({str})
% ---------------------------------------------------------------------------

persistent QUANTITYTYPELIST

% Import the ucar.unit package (must be on the MATLAB classpath)
import ucar.units.*;

if isempty(QUANTITYTYPELIST)

    % Retrieve all registered quantity types
    QuantityTypeListVector = QuantityType.getQuantityTypes;
    
    % Load vector elements into a cell array
    QuantityTypeList = cell(1, QuantityTypeListVector.size); % preallocate size
    for qtcount = 1:(QuantityTypeListVector.size)
        QuantityTypeList{qtcount} = QuantityTypeListVector.elementAt(qtcount-1);
    end
    
    % Sort, then assign persistent variable
    QuantityTypeList = sort(QuantityTypeList);
    QUANTITYTYPELIST = QuantityTypeList;
    
else
    
    % Use cached copy
    QuantityTypeList = QUANTITYTYPELIST;
    
end