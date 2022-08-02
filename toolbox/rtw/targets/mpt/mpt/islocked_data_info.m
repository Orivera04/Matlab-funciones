function out = islocked_data_info(element,attribute)
%ISLOCKED_DATA_INFO - Checks if an attribute on an object attribute is locked.
%   
%   [OUT]=ISLOCKED_DATA_INFO(ELEMENT,ATTRIBUTE)
%   This returns a flag indicating if a parameter/signal attribute is locked
%   and should not be changed programatically.  This indicates a desire 
%   by the user to override the default rule base applied for that particular
%   attribute by setting it directly. 
%
%   INPUTS: 
%            element   : simulink data object name 
%            attribute : name of attribute to be checked
%   OUTPUTS:
%            out : flag value if data object attribute is locked or not
%                  0  is if attribute is not ocked, 1 if attribute is
%                  locked
%
%   Each of the attributes below can be locked.
%   ALIAS          - Another refernce name
%   DATATYPE       - Object DataType
%   DEFINITIONFILE - Definition file associated with this object 
%   FILEINCLUDE    - Include file for this object
%   INITIALVALUE   - Initialization value of the object
%   OWNER          - Owner of the data object
%   SCOPE          - Scope of the Variable
%   STORAGECLASS   - Storage Class of data object
%   SYMBOL         - Code Generation Template Symbol


%   Linghui Zhang
%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.9.4.5 $
%   $Date: 2004/04/15 00:27:14 $
%

try,
switch lower(attribute)
case{'scope'}
    cmd = [element,'.getAttributes(''DataScopeLocked'');'];
    out = evalin('base',cmd);
case{'owner'}
    cmd = [element,'.RTWInfo.CustomAttributes.getAttributes(''OwnerLocked'');'];
    out = evalin('base',cmd);
case{'alias'}
    cmd = [element,'.getAttributes(''AliasLocked'');'];
    out = evalin('base',cmd);
case{'datatype'}
    cmd = [element,'.RTWInfo.CustomAttributes.getAttributes(''UserDataTypeLocked'');'];
    out = evalin('base',cmd);
case{'initialvalue'}
    cmd = [element,'.RTWInfo.CustomAttributes.getAttributes(''InitialValueLocked'');'];
    out = evalin('base',cmd);
case{'storageclass'}
    cmd = [element,'.RTWInfo.CustomAttributes.getAttributes(''MemorySectionLocked'');'];
    out = evalin('base',cmd);
case{'fileinclude'}
    cmd = [element,'.RTWInfo.CustomAttributes.getAttributes(''IncludeFileLocked'');'];
    out = evalin('base',cmd);
case{'definitionfile'}
    cmd = [element,'.RTWInfo.CustomAttributes.getAttributes(''DefinitionFileLocked'');'];
    out = evalin('base',cmd);
case{'visibility'}
    cmd = [element,'.getAttributes(''VisibilityLocked'');'];
    out = evalin('base',cmd);    
otherwise
    out=0;
end
catch
%    disp(['Error in reading a locked attribute field: ',attribute])
    out=0;
end
return
