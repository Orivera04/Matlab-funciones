function em = setname(em , str)
% ExportModel/setname
%	E = setname(E,'namestr')

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:47:47 $
if ~isa(str , 'char')
   error('ExportModel\setname: Expects a character array argument')
else
   em.name = str;
end
