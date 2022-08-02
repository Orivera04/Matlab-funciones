function obj=set(obj,param,data)
% SET Set candidate set parameters
%
%   OBJ=SET(OBJ,PARAM,DATA)
%
%   PARAM may be one of:
%
%       Levels: Cell array of levels for each factor
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:51 $

% Created 1/11/2000


switch lower(param)
case 'levels'
   obj.levels=data;
   mm=zeros(length(data),2);
   for n=1:length(data)
      mm(n,:)=[min(data{n}) max(data{n})];
   end
   obj.candidateset=limits(obj.candidateset,mm);
end
return
