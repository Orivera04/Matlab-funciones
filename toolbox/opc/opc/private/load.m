function load
%LOAD Load OPC Toolbox objects into the MATLAB workspace.
%
%    LOAD FILENAME returns all variables from the MAT-file, FILENAME,
%    into the MATLAB workspace.
%
%    LOAD FILENAME OBJ1 OBJ2 ... returns the specified OPC Toolbox  
%    objects, OBJ1, OBJ2,... from the MAT-file, FILENAME, into the MATLAB 
%    workspace.
%
%    S = LOAD('FILENAME','OBJ1','OBJ2',...) returns the structure, S, with
%    the specified OPC Toolbox objects, OBJ1, OBJ2,... from the MAT-file, 
%    FILENAME, instead of directly loading the OPC Toolbox objects into the 
%    workspace. The fieldnames in S match the names of the OPC Toolbox objects 
%    that were retrieved. If no objects are specified, then all variables 
%    existing in the MAT-file are loaded.
%
%    Values for read-only properties will be restored to their default
%    values upon loading. For example, the Status property of an OPCDA
%    object will be restored to  'disconnected'. PROPINFO can be used to
%    determine if a property is read-only.
%
%    See also OPCHELP, OPC/PRIVATE/SAVE, OPCROOT/PROPINFO.
%    

%    Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd 
%    $Revision: 1.1.6.1 $  $Date: 2004/03/24 20:43:48 $
