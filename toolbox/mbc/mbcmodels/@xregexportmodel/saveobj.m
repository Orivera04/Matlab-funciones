function obj=saveobj(obj)
% XREGEXPORTMODEL/SAVEOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:47:43 $

if iscell(obj.units)
   for n=1:length(obj.units)
      if ~ischar(obj.units{n}) & ~builtin('isempty',obj.units{n}) & ~isnumeric(obj.units{n})
         obj.units{n}=saveobj(obj.units{n});
      end
   end
elseif isa(obj.units,'junit')
   obj.units=saveobj(obj.units);
end