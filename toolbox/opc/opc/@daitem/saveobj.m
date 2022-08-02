function obj = saveobj(obj)
%SAVEOBJ Save filter for OPC Toolbox objects.
%
%    B = SAVEOBJ(OBJ) is called by SAVE when an object is
%    saved to a .MAT file. The return value B is subsequently used by
%    SAVE to populate the .MAT file.  
%
%    SAVEOBJ will be separately invoked for each object to be saved.
% 
%    See also OPC/PRIVATE/SAVE.
%

%    Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd 
%    $Revision: 1.1.6.1 $  $Date: 2004/03/24 20:43:30 $

obj.opcroot = saveobj(obj.opcroot);