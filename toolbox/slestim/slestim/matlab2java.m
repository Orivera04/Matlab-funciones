function javaData = matlab2java(matlabData)
% Convert two dimensional cell arrays to Java arrays

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.4.2 $ $Date: 2004/04/11 00:43:59 $

if ~iscell(matlabData) || isempty(matlabData)
  javaData = javaArray('java.lang.Object', 1, 1);
  return
end

% Initialize java objects
sizes    = size(matlabData);
javaData = javaArray('java.lang.Object',  sizes);

for i = 1:sizes(1)
  for j = 1:sizes(2)
    current = matlabData{i,j};
    
    if ischar(current)
      javaData(i,j) = java.lang.String(current);
    elseif islogical(current)
      javaData(i,j) = java.lang.Boolean(current);
    elseif isa(current, 'double')
      javaData(i,j) = java.lang.Double(current);
    elseif ishandle(current)
      javaData(i,j) = java(current);
    else
      error('No such class for Java conversion.');
    end
  end
end
