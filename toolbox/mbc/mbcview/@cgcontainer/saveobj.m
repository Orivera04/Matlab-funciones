function obj=saveobj(obj)
%SAVEOBJ  Save-time actions
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:22:01 $

% containers execute on data if not a pointer
if ~isa(obj.data,'xregpointer') & isobject(obj.data)
   obj.data=saveobj(obj.data);
end
obj.cgnode=saveobj(obj.cgnode);