function  list =findobj(obj,varargin)
%  Synopsis
%     function  obj = findobj(obj,parameter,value,parameter,...)
%
%  Description
%     Finds sub objects in the xregcontainer tree  by matching properties.
%     It works similarly to the handle graphics findobj command. Note
%     That the only property match supported at the moment is the 'tag'
%     property because it is a property that all containers have.
%
%
%  Example
%     >> list = findobj(obj,'tag','mytag')
%     list =
%        { uicontrol gridObject }
%
%  See Also
%     methods xregcontainer
%     xregcontainer/replaceObj

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/04/04 03:29:35 $


k = find(ismember(varargin,'tag'));
list = {};
if mod(k,2) & (nargin > k)
   tag = get(obj,'tag');
   switch class(varargin{k+1})
   case 'double'
      if prod(tag==varargin{k+1})
         list = {obj};
      end
   case 'char'
      if strcmp(upper(tag),upper(varargin(k+1)))
         list = {obj};
      end
   end
end

h = get(obj,'elements');
for k = 1:length(h)
   r = findobj(h{k},varargin{:});
   if iscell(r)
      list = { list{:} r{:} };
   else
      if ~isempty(r)
         list = { list{:} r };
      end
   end
end


