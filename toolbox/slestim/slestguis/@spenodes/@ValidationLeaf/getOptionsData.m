function table = getOptionsData(this)
% GETOPTIONSDATA 

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:40:17 $

data = this.Fields.Options;

if ~isempty(data)
  table = matlab2java(data);
else
  table = {};
end
