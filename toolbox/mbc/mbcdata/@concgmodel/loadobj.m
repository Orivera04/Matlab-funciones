function c = loadobj(c)
%LOADOBJ  Loadobj for concgmodel
%
%  C = LOADOBJ(C)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $  $Date: 2004/02/09 06:55:49 $

if isstruct(c) && ~isfield(c, 'version')
    c.evaltype = 0;
    c.version = 2;
end

if isstruct(c)
    c = concgmodel(c);
end