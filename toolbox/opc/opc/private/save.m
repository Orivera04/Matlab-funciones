function save
%SAVE Save OPC Toolbox objects to a MAT-file.
%
%    SAVE FILENAME saves all variables in the MATLAB workspace to the 
%    specified MAT-file, FILENAME. If an extension is not specified for 
%    FILENAME, then a .MAT extension is used.
%
%    SAVE FILENAME OBJ1 OBJ2 ... saves OPC Toolbox objects, OBJ1, OBJ2,...
%    to the specified MAT-file, FILENAME. If an extension is not specified 
%    for FILENAME, then a .MAT extension is used.
%
%    SAVE can be used in the functional form as well as the command form 
%    shown above. When using the functional form, you must specify the 
%    file name and OPC Toolbox objects as strings.
%
%    Any data associated with the OPC Toolbox object will not be stored
%    in the MAT-file. The data can be brought into the MATLAB workspace
%    with GETDATA and then saved to the MAT-file using a separate variable
%    name. 
%
%    The LOAD command is used to return variables from the MAT-file to
%    the MATLAB workspace. Values for read-only properties will be restored 
%    to their default values upon loading. For example, the Status property
%    for an opcda object will be restored to 'disconnected'. You use
%    PROPINFO to determine if a property is read-only.
%
%
%    See also OPCHELP, OPC/PRIVATE/LOAD, OPCROOT/PROPINFO, DAGROUP/GETDATA
%

%    Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd 
%    $Revision: 1.1.6.1 $  $Date: 2004/03/24 20:43:51 $
