function  obj =set(obj,varargin)
%  Synopsis
%     function  obj = set(obj,parameter,value)
%
%  Description
%     Set the parameter of the handles. This works very similar
%     to the set methods for handles. The only difference is that
%     some methods have been overloaded to peform differently
%     on the package. Non overload methods just peform the set
%     recursively on all submembers.
%
%
%
%  Overloaded set methods
%     CENTER   :     object/layout to place in centre of frametitle
%     USERDATA    :  User-definable data store
%     VISIBLE  :   on/off
%     TOOLBARDRAW : on/off  - suppresses toolbar redrawing for faster creation.
%     SPACERWIDTH : height in pixels of gap between toolbar and central object
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:37:26 $

dorepack = 0;
if ~isa(obj,'xregtoolbarlayout')
   builtin('set',obj,varargin{:});
else
   cdata=get(obj.xregcontainer,'containerdata');
   for arg=1:2:nargin-1
      parameter = varargin{arg};
      value = varargin{arg+1};
      
      reqrepack=1;
      switch upper(parameter)
      case 'CENTER'
         cdata.elements={value};
      case 'VISIBLE'
         set([obj.panel;obj.tb],'visible',value);
         % iterate over elements
         el=cdata.elements;
         for k=1:length(el)
            set(el{k},'visible',value);
         end
         reqrepack=0;
      case 'TOOLBARDRAW'
         flg=((strmatch(lower(value),['off';'on '])-1)~=0);
         obj.tb.setRedraw(flg);
         if flg
            obj.tb.drawToolBar;
         end
      case 'SPACERWIDTH'
         ud=obj.rtP.info;
         ud.SpacerW=value;
         obj.rtP.info=ud;
      case 'RESOURCELOCATION'
         obj.tb.ResourceLocation=value;
      otherwise
         [obj.xregcontainer,reqrepack]=set(obj.xregcontainer,parameter,value);
         reqrepack=~reqrepack;
      end
      dorepack = (dorepack || reqrepack);
   end
end

if dorepack & getBoolPackstatus(obj.xregcontainer) 
   obj = repack(obj);
end
