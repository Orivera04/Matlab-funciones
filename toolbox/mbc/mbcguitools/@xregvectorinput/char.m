function out = char(obj)
%% CHAR returns string 'varname: vals'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:34:02 $


name = get(obj,'name');
value = get(obj,'value');
value = [value(1),value(end)];
out = [sprintf('%-10s = [%.4g, ... ,%.4g]',name, value)];