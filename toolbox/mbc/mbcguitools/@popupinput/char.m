function out = char(obj)
%% CHAR returns string 'varname: vals'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:20:17 $


name = get(obj,'name');
string = get(obj,'string');
out = [sprintf('%-10s = %-10s',name, string)];