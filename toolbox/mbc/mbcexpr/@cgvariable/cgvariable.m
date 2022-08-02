function obj = cgvariable(s)
%CGVARIABLE Constructor for cgvariable class
%
%  OBJ = CGVARIABLE
%  OBJ = CGVARIABLE(S) where S is a structure
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.8.2 $    $Date: 2004/02/09 07:16:25 $ 


if nargin
    e = s.cgexpr;
    s = mv_rmfield(s, 'cgexpr');
else
    s = struct('version', 2, ...
        'Description','', ...
        'Alias', {{}}, ...
        'NominalValue', 0, ...
        'Value', 0, ...
        'BackupValue', {{}}, ...
        'BackupGUIDs', guidarray);
    e = cgexpr;
end

obj = class(s, 'cgvariable', e);