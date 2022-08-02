function save
%SAVE Save image acquisition objects to a MAT-file.
%
%    SAVE FILENAME saves all variables in the MATLAB workspace to the 
%    specified MAT-file, FILENAME. If an extension is not specified for 
%    FILENAME, then a .MAT extension is used.
%
%    SAVE FILENAME OBJ1 OBJ2 ... saves image acquisition objects, OBJ1, OBJ2,...
%    to the specified MAT-file, FILENAME. If an extension is not specified 
%    for FILENAME, then a .MAT extension is used.
%
%    SAVE can be used in the functional form as well as the command form 
%    shown above. When using the functional form, you must specify the 
%    file name and image acquisition objects as strings.
%
%    Any data associated with the image acquisition object will not be stored
%    in the MAT-file. The data can be brought into the MATLAB workspace
%    with one of the synchronous read functions and then saved to the
%    MAT-file using a separate variable name. 
%
%    The LOAD command is used to return variables from the MAT-file to
%    the MATLAB workspace. Values for read-only properties will be restored 
%    to their default values upon loading. For example, the Running property
%    will be restored to off. PROPINFO can be used to determine if a
%    property is read-only.
%
%    Examples:
%       obj = videoinput('winvideo', 1);
%       set(obj, 'SelectedSourceName', 'input1')
%       save fname obj
%       set(obj, 'TriggerFcn', {'mycallback', 5});
%       save('fname1', 'obj')
%
%    See also IMAQHELP, IMAQ/PRIVATE/LOAD, IMAQDEVICE/PROPINFO,
%

%    CP 9-3-02
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:06:21 $
