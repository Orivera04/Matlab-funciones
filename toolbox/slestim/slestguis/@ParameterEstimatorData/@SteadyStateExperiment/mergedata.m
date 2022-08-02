function newdata = mergedata(olddata, newdata)
% MERGEDATA Merges two arrays of objects.
%
% OLDDATA and NEWDATA should be handles of length one.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2003/12/22 00:55:51 $

% Merge with old data
if ~isempty( olddata.InputData )
  newdata.InputData = mergedata( olddata.InputData, newdata.InputData );
end

if ~isempty( olddata.OutputData )
  newdata.OutputData = mergedata( olddata.OutputData, newdata.OutputData );
end

if ~isempty( olddata.StateData )
  newdata.StateData = mergedata( olddata.StateData, newdata.StateData );
end
