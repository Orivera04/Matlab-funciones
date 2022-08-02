function set_data_mapping(objectTypeCat, storageClassCat, globalDeclareSymbol, ...
                                             globalRefSymbol, localDeclareSymbol, fileDeclareSymbol)
%SET_DATA_MAPPING Registers data mapping rule.
%
%  SET_DATA_MAPPING(OBJECTTYPECAT, STORAGECLASSCAT, ...
%        GLOBALDECLARESYMBOL, GLOBALREFSYMBOL, ...
%        LOCALDECLARESYMBOL, FILEDECLARESYMBOL) 
%        It is used to register a specific rule mapping for data objects, storage 
%        class category and placement withing the template file symbol space. 
%        It will either replace a given mapping, create a new mapping when it 
%        does not already  exist or add a new  storage class to a  given  object 
%        type.
%
%  INPUTS:
%        objectTypeCat:            object category name
%        storageClassCat:           storage class category name
%        globalDeclareSymbol:   symbol name assocaited with global declarations
%        globalRefSymbol:         symbol name associated with global references
%        localDeclareSymbol:    symbol name associated with local declarations
%        fileDeclareSymbol:      symbol name associated with file scope declarations
%
%  OUTPUT:
%        none
%
%  See Also GET_DATA_MAPPING, INIT_DATA_MAPPING.

%  Steve Toeppe
%  Copyright 2001-2002 The MathWorks, Inc.
%  $Revision: 1.9.4.1 $
%  $Date: 2004/04/15 00:28:50 $

global ecac;

%
% Search the entire mapping until either a match is found or a new entry is 
% inserted. A match requires that the object type and storage class are the same.
%
% File scope variables do not have a reference definition. Local scope objects 
% do not have a reference definition.
%
for i=1:length(ecac.mapping)
    if strcmp(ecac.mapping{i}.objectTypeCat,objectTypeCat) == 1
        for j=1:length(ecac.mapping{i}.storageClass)
            if strcmp(ecac.mapping{i}.storageClass{j}.storageClassCat, storageClassCat) == 1

                %Match has been found. Insert new mapping templage symbols.

                ecac.mapping{i}.storageClass{j}.globalDeclareSymbol = globalDeclareSymbol;
                ecac.mapping{i}.storageClass{j}.globalRefSymbol = globalRefSymbol;
                ecac.mapping{i}.storageClass{j}.localDeclareSymbol = localDeclareSymbol;
                ecac.mapping{i}.storageClass{j}.fileDeclareSymbol = fileDeclareSymbol;
                return
            end
        end
        
        %
        % Object type found, but storage class not found, create new one entry 
        % for the given object.
        %

        sci = length(ecac.mapping{i}.storageClass)+1;
        ecac.mapping{i}.storageClass{sci}.storageClassCat = storageClassCat;
        ecac.mapping{i}.storageClass{sci}.globalDeclareSymbol = globalDeclareSymbol;
        ecac.mapping{i}.storageClass{sci}.globalRefSymbol = globalRefSymbol;
        ecac.mapping{i}.storageClass{sci}.localDeclareSymbol = localDeclareSymbol;
        ecac.mapping{i}.storageClass{sci}.fileDeclareSymbol = fileDeclareSymbol;
        return
    end
end

%object type not found not found, create new one
mpi = length(ecac.mapping)+1;
ecac.mapping{mpi}.objectTypeCat = objectTypeCat;
ecac.mapping{mpi}.storageClass{1}.storageClassCat = storageClassCat;
ecac.mapping{mpi}.storageClass{1}.globalDeclareSymbol = globalDeclareSymbol;
ecac.mapping{mpi}.storageClass{1}.globalRefSymbol = globalRefSymbol;
ecac.mapping{mpi}.storageClass{1}.localDeclareSymbol = localDeclareSymbol;
ecac.mapping{mpi}.storageClass{1}.fileDeclareSymbol = fileDeclareSymbol;
