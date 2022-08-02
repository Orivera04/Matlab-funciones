function out = getname(in)
%GETNAME

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:53:21 $

out = in.name;
if isempty(out)
    out = 'Optimisation';
end
