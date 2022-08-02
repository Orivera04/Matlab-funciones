function obj = loadobj(B)
%LOADOBJ Load filter for OPC Toolbox objects.
%
%    OBJ = LOADOBJ(B) is called by LOAD when an OPC Toolbox object is 
%    loaded from a .MAT file. The return value, OBJ, is subsequently 
%    used by LOAD to populate the workspace.  
%
%    LOADOBJ will be separately invoked for each object in the .MAT file.
%
%    See also OPC/PRIVATE/LOAD.
%

%    Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd 
%    $Revision: 1.1.6.1 $  $Date: 2004/03/24 20:42:56 $

%DEBUG: disp('Called DAGROUP loadobj');
% Return the original object. All work is done in OPCROOT.
obj = B;