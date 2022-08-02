function out = char(obj)
%% CHAR returns string 'varname: vals'

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:31:33 $


name = get(obj,'name');
value = get(obj,'value');
tol = get(obj.tolerance,'string');
%out = sprintf('%-10s',name);
out = [sprintf('%-10s = %.4g  Tol = %.4g',name, value, tol)];