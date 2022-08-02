function out = concheck(m);
% ExportModel \ concheck
% Check to see whether constraint can be calculated on this model class
% Unless this function is overloaded by a child it will return 0

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:47:16 $

out = ~isempty(m.constraints);