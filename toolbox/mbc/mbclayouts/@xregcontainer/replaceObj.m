function  findobj(obj,obj2,varargin)
%  Synopsis
%     function replaceObj(obj,obj2,parameter,value,parameter,...)
%
%  Description
%     Replace the element that matches the properties with obj2
%
%
%  Example
%     b = replaceObj(b,uicontrol,'tag','axes');
%     b = repack(b);
%
%  Notes
%     Ensure to execute a repack after running this method.
%     The only match possible for the moment is the 'tag' property.
%     Support for all others will be added later.
%
%  See Also
%     methods xregcontainer

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:35:28 $


k = find(ismember(varargin,'tag'));
if mod(k,2) & (nargin > k)
   h = get(obj,'elements');
   for m = 1:length(h)
      tag = get(h{m},'tag');
      if strcmp(upper(tag),upper(varargin(k+1)))
         delete(h{m});
         h{m} = obj2;
      elseif ~ishandle(h{m})
         h{m} = replaceObj(h{m},obj2,varargin{:});
      end
   end
   obj = set(obj,'elements',h);
end


