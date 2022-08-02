function out = openmxl(filename)
%OPENMXL Open MXL project file in MXLTOOL.
%   OPENMXL(FILENAME) opens the Builder for Excel project 
%   file, FILENAME, in the Builder GUI.
%   Helper function for OPEN.
%
%   See OPEN.

%   Copyright (c) 2001-2003 The MathWorks, Inc. 
%   $Revision: 1.3.4.2 $  $Date: 2004/01/13 16:42:28 $

if nargout, out = []; end

%Open Builder GUI
cmptool     

%Open project file
cmptool('openproject',filename)
