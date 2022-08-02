function [obj, datakey] = addDatakeys(obj, N)
%ADDDATAKEYS Create new datakeys
%
%  [OBJ, DATAKEY] = ADDDATAKEYS(OBJ, N) creates N new datakeys and returns
%  them.  The new datakeys are not linked to a table cell.  If N is not
%  specifed it is assumed to be 1.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:13 $ 

if nargin<2
    N = 1;
end

datakey = (obj.NextDataKeyNumber:(obj.NextDataKeyNumber + N - 1))';
obj.DataKeyTable = [obj.DataKeyTable; ...
    uint32(zeros(N,1)), datakey, uint32(zeros(N,1))];
obj.NextDataKeyNumber = obj.NextDataKeyNumber + N;
