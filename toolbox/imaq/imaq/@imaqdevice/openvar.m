function openvar(name, obj)
%OPENVAR Open an image acquisition object for graphical editing.
%
%    OPENVAR(NAME, OBJ) open an image acquisition object, OBJ, for graphical 
%    editing. NAME is the MATLAB variable name of OBJ.
%
%    See also IMAQDEVICE/SET, IMAQDEVICE/GET, IMAQDEVICE/PROPINFO,
%             IMAQHELP.
%

%    CP 04-17-02
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:27 $

if ~isa(obj, 'imaqdevice')
    errordlg('OBJ must be an image acquisition object.', 'Invalid object', 'modal');
    return;
end

if ~isvalid(obj)
    errordlg('The image acquisition object is invalid.', 'Invalid object', 'modal');
    return;
end

try
    inspect(obj);
catch
    imaqgate('privateFixError');
    errordlg(lasterr, 'Inspection error', 'modal');
end
