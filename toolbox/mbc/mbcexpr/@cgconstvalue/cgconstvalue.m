function obj = cgconstvalue(s)
%CGCONSTVALUE Constructor for cgconstvalue objects
%
%  OBJ = CGCONSTVALUE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:09:30 $ 


if nargin
    e = s.cgvariable;
    s = mv_rmfield(s, 'cgvariable');
else
    s = struct('version', 1);
    e = cgvariable;
end

obj = class(s, 'cgconstvalue', e);