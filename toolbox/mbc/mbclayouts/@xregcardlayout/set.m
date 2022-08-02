function  varargout=set(obj,varargin)
%  Synopsis
%     function  set(obj,parameter,value,setChildren)
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
%     CURRENTCARD :  current card visibility
%     NUMCARDS    :  number of cards
%     VISIBLE     : 'on' or 'off'
%     DRAWONSELECT :  'on'/'off' Always draws when card is selected
%     

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:00 $

if ~isa(obj,'xregcardlayout')
   builtin('set',obj,varargin{:});
else 
   norepack = 1;
   ud=obj.g.info;
   for arg=1:2:nargin-1
      parameter = varargin{arg};
      value = varargin{arg+1};
      reqnorepack=0;
      switch upper(parameter)
      case 'POSITION'
         position=value;
         position(3:4)=max(position(3:4),[1 1]);
         set(obj.xregcontainer,'position',position);
      case 'NUMCARDS'
         if value>0
            ud.numcards=value;
            % update drawn indicators
            cdrw=ud.carddraw;
            if value>length(cdrw)
               cdrw(end+1:value)=0;
            else
               cdrw=cdrw(1:value);
            end
            ud.carddraw=cdrw;
            
            if value<ud.currentcard
               % need to reselect 
               ud.currentcard=value;
               if ud.visible
                  % switch cards
                  if ~isempty(ud.cards)
                     onind=find(ud.cards==value);
                     el=get(obj.xregcontainer,'elements');
                     % if we need to, redraw the on cards
                     cdrw=ud.carddraw;
                     ps=get(obj.xregcontainer,'packstatus');
                     if (cdrw(value) | ud.alwaysdraw) & strcmpi(ps,'on')
                        pos=get(obj,'innerposition');
                        pos(3:4)=max(pos(3:4),[1 1]);
                        for i=onind
                           set(el{i},'position',pos);
                        end
                        cdrw(value)=0;
                        ud.carddraw=cdrw;
                     end
                     for i=onind
                        set(el{i},'visible','on');
                     end
                  end
               end
            end
         end
         reqnorepack=1;
      case 'CURRENTCARD'
         if value>0 & value<=ud.numcards & value~=ud.currentcard
            if ud.visible
               % switch cards
               if ~isempty(ud.cards)
                  onind=find(ud.cards==value);
                  offind=find(ud.cards==ud.currentcard);%setxor([1:length(ud.cards)],onind);
                  el=get(obj.xregcontainer,'elements');
                  for i=offind
                     set(el{i},'visible','off');
                  end
                  % if we need to, redraw the on cards
                  cdrw=ud.carddraw;
                  ps=get(obj.xregcontainer,'packstatus');
                  if (cdrw(value) | ud.alwaysdraw) & strcmpi(ps,'on')
                     pos=get(obj,'innerposition');
                     pos(3:4)=max(pos(3:4),[1 1]);
                     for i=onind
                        set(el{i},'position',pos);
                     end
                     cdrw(value)=0;
                     ud.carddraw=cdrw;
                  end
                  for i=onind
                     set(el{i},'visible','on');
                  end
               end
            end
            ud.currentcard=value;
         end
         reqnorepack=1;
      case 'VISIBLE'
         vis=strmatch(value,['off';'on '])-1;
         if ~isempty(vis) & vis~=ud.visible
            el=get(obj.xregcontainer,'elements');
            if ~isempty(ud.cards)
               cdrw=ud.carddraw;
               ps=get(obj.xregcontainer,'packstatus');
               crd=ud.currentcard;
               onind=find(ud.cards==crd);
               for i=onind
                  if vis & (cdrw(crd) | ud.alwaysdraw) & strcmpi(ps,'on')
                     pos=get(obj,'innerposition');
                     pos(3:4)=max(pos(3:4),[1 1]);
                     set(el{i},'position',pos);
                     cdrw(crd)=0;
                  end
                  set(el{i},'visible',value);
               end
               ud.carddraw=cdrw;
            end
            ud.visible=vis;
         end
         reqnorepack=1;
      case 'DRAWONSELECT'
         % set the always-draw flag
         ud.alwaysdraw=strmatch(value,['off';'on '])-1;
         reqnorepack=1;
      otherwise
         [obj.xregcontainer,reqnorepack]=set(obj.xregcontainer,parameter,value);
      end
      norepack=(norepack & reqnorepack);   
   end
   obj.g.info=ud;
   if nargout>1
      varargout{1}=obj;
      varargout{2}=norepack;   
   else
      varargout{1}=obj;
      if ~norepack & get(obj,'boolpackstatus')
            repack(obj);
      end
   end  
end

