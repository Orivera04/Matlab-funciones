function varargout = mxltool(varargin)
%MXLTOOL MATLAB Builder for Excel graphical user interface.
%    MXLTOOL launch Builder GUI.

%   Copyright 2001-2003 The MathWorks, Inc.
%   $Revision: 1.70.4.5 $   $Date: 2004/01/19 02:56:27 $

%Call cmptool
cmptool;

%Set file extension list
f = getappdata(0,'CMPToolHandle');
setappdata(f,'fileextlist',{'*.mxl','Builder for Excel 1.0, 1.1 (*.mxl)';...
                           '*.cbl','Builder for COM 1.0 (*.cbl)'});
