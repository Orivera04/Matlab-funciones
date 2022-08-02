function [typeFlag,object] = determine_object_type(object)
%DETERMINE_OBJECT_TYPE Determine the data object type for data object wizard 
%
%   [TYPEFLAG,OBJECT]=DETERMINE_OBJECT_TYPE(OBJECT)
%   This function determines the type of object to create and amends the 
%   object structure with the correct memory section element for code gen. 
%
%
%   Inputs:
%             object : data object that the object type is being determined
%
%   Output:
%             object : an updated object structure with new MemorySection field
%             typeFlag : inidcatore of signal or parameter ( 1 or 0 )
%               
%
% 

%

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.2.4.3 $  $Date: 2004/04/15 00:27:53 $
%


%
% default Mode is a Signal object.
%

typeFlag = 0;

if object.initFromWorkspace == 1,         % init from workspace indicator
    typeFlag = 0;             % Create a parameter object as a default
    switch (object.scope)
        case{'INPUT'}  
            object.MemorySection = 'RAM';
            object.dataScope = 'Global';
        case{'OUTPUT'}
            object.MemorySection = 'RAM'; 
            object.dataScope = 'Global';
        case{'MACHINE_CONSTANT'}
            object.MemorySection = 'ROM'; 
            object.dataScope = 'Global';
        case{'CONSTANT'}
            object.MemorySection = 'ROM'; 
            object.dataScope = 'Global';
        case{'MACHINE_LOCAL'}
            object.MemorySection = 'RAM'; 
            object.dataScope = 'File';
        case{'LOCAL'}
            object.MemorySection = 'RAM';
            object.dataScope = 'File';
        case{'MACHINE_IMPORTED'}
            object.MemorySection = 'RAM'; 
            object.dataScope = 'Global';
        case{'MACHINE_EXPORTED'}
            object.MemorySection = 'RAM'; 
            object.dataScope = 'Global';
        case{'TEMPORARY'}
            object.MemorySection = 'RAM';
            object.dataScope = 'Local';
        otherwise
            object.MemorySection ='ROM';
            object.dataScope = 'Global';
    end
else
    if mpt_static_config('ParamsOnly')==1,
      typeFlag = 0;               % Create parameters only
    else
      typeFlag = 1;               % Create a Signal object  as a default
    end
    
    switch (object.scope)
        case{'INPUT'}  
            object.MemorySection = 'RAM';
            object.dataScope = 'Global';
        case{'OUTPUT'}
            object.MemorySection = 'RAM'; 
            object.dataScope = 'Global';
        case{'MACHINE_CONSTANT'}
            typeFlag = 0; 
            object.MemorySection = 'ROM'; 
            object.dataScope = 'Global';
        case{'CONSTANT'}
            typeFlag = 0; 
            object.MemorySection = 'ROM'; 
            object.dataScope = 'Global';
        case{'MACHINE_LOCAL'}
            object.MemorySection = 'RAM';
            object.dataScope = 'Global';            
        case{'LOCAL'}
            object.MemorySection = 'RAM'; 
            object.dataScope = 'File';
        case{'MACHINE_IMPORTED'}
            object.MemorySection = 'RAM'; 
            object.dataScope = 'Global';
        case{'MACHINE_EXPORTED'}
            object.MemorySection = 'RAM'; 
            object.dataScope = 'Global';
        case {'TEMPORARY'}   
            object.MemorySection = 'RAM';
            object.dataScope = 'Local';
        otherwise
            object.MemorySection ='RAM';
            object.dataScope = 'Global';
    end    
end

return