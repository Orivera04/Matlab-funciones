function comtool(varargin)
%COMTOOL MATLAB Builder for COM graphical user interface.
%    COMTOOL launch Builder GUI.

%   Author(s): C.F.Garvin, 02-01-01
%   Copyright 2000-2002 The MathWorks, Inc.
%   $Revision: 1.24.4.5 $   $Date: 2004/01/19 02:56:22 $

%Call cmptool
cmptool

%Set file extension list
f = getappdata(0,'CMPToolHandle');
setappdata(f,'fileextlist',{'*.cbl','Builder for COM 1.0 (*.cbl)';...
                           '*.mxl','Builder for Excel 1.0, 1.1 (*.mxl)'});
