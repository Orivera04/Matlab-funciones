function load
%LOAD Load image acquisition objects into the MATLAB workspace.
%
%    LOAD FILENAME returns all variables from the MAT-file, FILENAME,
%    into the MATLAB workspace.
%
%    LOAD FILENAME OBJ1 OBJ2 ... returns the specified image acquisition  
%    objects, OBJ1, OBJ2,... from the MAT-file, FILENAME, into the MATLAB 
%    workspace.
%
%    S = LOAD('FILENAME','OBJ1','OBJ2',...) returns the structure, S, with
%    the specified image acquisition objects, OBJ1, OBJ2,... from the MAT-file, 
%    FILENAME, instead of directly loading the image acquisition objects into the 
%    workspace. The fieldnames in S match the names of the image acquisition objects 
%    that were retrieved. If no objects are specified, then all variables 
%    existing in the MAT-file are loaded.
%
%    Values for read-only properties will be restored to their default values
%    upon loading. For example, the Running property will be restored to 
%    off. PROPINFO can be used to determine if a property is read-only.
%
%    Examples:
%       obj = videoinput('winvideo', 1);
%       set(obj, 'SelectedSourceName', 'input1')
%       save fname obj
%       load fname
%       load('fname', 's');
%
%    See also IMAQHELP, IMAQ/PRIVATE/SAVE, IMAQDEVICE/PROPINFO.
%    

%    CP 9-3-02
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:06:05 $
