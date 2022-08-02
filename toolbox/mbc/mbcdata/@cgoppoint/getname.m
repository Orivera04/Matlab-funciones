function out = getname(in)
%GETNAME

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:51 $

out = in.name;
if isempty(out)
    out = 'Dataset';
end