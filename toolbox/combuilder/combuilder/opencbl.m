function out = opencbl(filename)
%OPENCBL Open CBL project file in COMTOOL.
%   OPENCBL(FILENAME) opens the Builder for COM project 
%   file, FILENAME, in the Builder GUI.
%   Helper function for OPEN.
%
%   See OPEN.

%   Copyright 2001-2003 The MathWorks, Inc. 
%   $Revision: 1.1.2.2 $  $Date: 2004/01/13 16:41:59 $

if nargout, out = []; end

%Open Builder for COM GUI
cmptool     

%Open project file
cmptool('openproject',filename)
