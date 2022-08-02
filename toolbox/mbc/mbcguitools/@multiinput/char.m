function out = char(obj)
%% CHAR returns string 'varname: vals'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:19:10 $

out = 'MultiInput, elements: ';
for i = 1:length(obj.objects)
    out = [out char(obj.objects{i}) ', '];
end
out = [out '.'];
