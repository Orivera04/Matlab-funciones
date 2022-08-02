function obj=loadobj(obj)
% LOADOBJ   Load older object versions
%
%   OBJ=LOADOBJ(STRUCT)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 07:00:44 $

% Created 29/1/2001


if isa(obj,'cset_lhs')
   return
else
   if obj.version<2
      % add parameters for stratifying LHS
      obj.stratify=zeros(1,length(obj.delta));
      obj.symmetry=0;
   end
   
   if obj.version<3
      % add field for specifying stratified levels
      obj.stratify_levels = cell(1,length(obj.delta));
   end
   
   obj = rmfield(obj,'version');  % new version is always appended in constructor
   obj=cset_lhs(obj);
end



