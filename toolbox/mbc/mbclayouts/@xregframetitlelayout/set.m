function  obj =set(obj,varargin)
%  Synopsis
%     function  obj = set(obj,parameter,value,setChildren)
%
%  Description
%     Set the parameter of the handles. This works very similar
%     to the set methods for handles. The only difference is that
%     some methods have been overloaded to peform differently
%     on the package. Non overload methods just peform the set
%     recursively on all submembers.
%
%
%  Overloaded set methods
%     POSITION :     [xmin xmax width height] of the whole package.
%     INNERBORDER  : [NORTH EAST SOUTH WEST] inner border in pixels
%     CENTER   :     object/layout to place in centre of frametitle
%     TITLE    :     (string) Text to place in title area
%     TITLECOLOR   : Background colour for title text.
%     OUTERBORDER  : [NORTH EAST SOUTH WEST] outer border in pixels
%                    Note this property is obsolete: use the container
%                    BORDER property instead.
%     USERDATA    :  User-definable data store

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:36:14 $


norepack = 1;
if ~isa(obj,'xregframetitlelayout')
   builtin('set',obj,varargin{:});
   reqnorepack=1;
else
   cdata=get(obj.xregcontainer,'containerdata');
   for arg=1:2:nargin-1
      parameter = varargin{arg};
      value = varargin{arg+1};
      reqnorepack=0;
      switch upper(parameter)
      case 'POSITION'
         position=value;
         if position(3) <= 0
            position(3) = 1;
         end
         if position(4) <= 0
            position(4) = 1;
         end
         cdata.position= position;
      case 'INNERBORDER'
         if isnumeric(value) & length(value)==4
            ud=get(obj.title,'userdata');
            ud.borders=value;
            set(obj.title,'userdata',ud);
         end
      case 'OUTERBORDER'
         value=value(end:-1:1);
         cdata.border=value;
      case 'CENTER'
         cdata.elements={value};
      case 'TITLE'
         if ischar(value)
            ud=get(obj.title,'userdata');
            set(obj.title,'string',value);
            if isempty(value)
               if ud.title==0
                  reqnorepack=1;
               else
                  ud.title=0;
                  set(obj.title,'visible','off');
               end
            else
               if ud.title==1
                  reqnorepack=1;
               else
                  ud.title=1;
               end
               % set correct x-size for title object
               vis=strcmp(get(obj.title,'visible'),'on');
               if ~vis
                  set(obj.title,'visible','on');
                  ext=get(obj.title,'extent');
                  set(obj.title,'visible','off')
               else
                  ext=get(obj.title,'extent');
               end
               pos=get(obj.title,'position'); 
               set(obj.title,'position',[pos(1) pos(2) ext(3)+4 pos(4)]);
               set(obj.title,'visible',get(obj.grayline,'visible'));
            end
            set(obj.title,'userdata',ud);
         end
      case 'TITLECOLOR'
         set(obj.title,'backgroundcolor',value);
      case 'VISIBLE'
         ud=get(obj.title,'userdata');
         if ~ud.title
            vis='off';
         else
            vis=value;
         end
         set([obj.grayline;obj.whiteline;obj.title],{'visible'},{value;value;vis});
         % iterate over elements
         el=cdata.elements;
         for k=1:length(el)
            set(el{k},'visible',value);
         end
         reqnorepack=1;
      case 'ENABLE'
         if ~any(strcmp(lower(value),{'off','on','inactive'}))
            error('Bad value for frametitlelayout property: Enable');
         end
         set(obj.title,'enable',value);
         % iterate over elements
         el=cdata.elements;
         for k=1:length(el)
            set(el{k},'enable',value);
         end
         reqnorepack=1;
      case 'USERDATA'
         % overloaded: can use a frame object as store
         set(obj.whiteline,'userdata',value);
         reqnorepack=1;
      case 'BACKGROUND'
         % no longer supported
      otherwise
         [obj.xregcontainer,reqnorepack]=set(obj.xregcontainer,parameter,value);
      end
   end
   norepack=(norepack & reqnorepack);
end

if ~norepack & getBoolPackstatus(obj.xregcontainer)
   obj = repack(obj);
end
