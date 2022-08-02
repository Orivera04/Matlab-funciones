function result = get_data_mapping(objectTypeCat, storageClassCat)
%GET_DATA_MAPPING Provides a mapping of an object and storage class. 
%
%   [RESULT]=GET_DATA_MAPPING(OBJECTTYPECAT,STORAGECLASSCAT)
%   This function is used to get the mapping rules of a particular object
%   and storage class category. The mapping rules control placement of
%   declarations and references within template files. The function will 
%   get a data mapping rule for an object (objectTypeCat) and storage 
%   class (storageClassCat).
%
%   INPUTS:
%         objectTypeCat    :  name of object type
%         storagteClassCat :  name of storage class
%   OUTPUTS:
%         result           :  mapping rules structure
%
%   See Also set_data_mapping, init_data_mapping


%   Steve Toeppe
%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.9.4.1 $
%   $Date: 2004/04/15 00:28:06 $

global ecac;

% Search the mapping rules for a object and storage class match. If found, return the mapping
% information. Otherwise, return an empty result.
result = [];
if (isempty(objectTypeCat) == 0) & (isempty(storageClassCat) == 0)
    for i=1:length(ecac.mapping)
        if strcmp(ecac.mapping{i}.objectTypeCat,objectTypeCat) == 1
            for j=1:length(ecac.mapping{i}.storageClass)
                if strcmp(ecac.mapping{i}.storageClass{j}.storageClassCat, storageClassCat) == 1
                    result = ecac.mapping{i}.storageClass{j};
                    return
                end
            end

        end
    end
end

 