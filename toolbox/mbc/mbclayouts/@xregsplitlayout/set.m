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
%     SPLIT    :     [lfraction rfraction]
%     RESIZABLE :   'on', 'off' - dynamic resizing bar switch
%     ORIENTATION :  'lr', 'ud'  sets the split orientation
%     DIVIDERSTYLE : '3d' or 'flat'
%     DIVIDERWIDTH : width in pixels of dividing strip
%     CALLBACK :     Callback string executed after a resize
%     LEFT/TOP :     set object in left/top pane
%     RIGHT/BOTTOM : set object in right/top pane
%     OUTERBORDER :  [N E S W] outside border of layout
%                    Note this property is obsolete: use the container
%                    BORDER property instead.
%     LEFTINNERBORDER } [N E S W] inner border for left/top pane
%     TOPINNERBORDER  }
%     RIGHTINNERBORDER  } [N E S W] inner border for right/bottom pane
%     BOTTOMINNERBORDER }
%     MINWIDTH   :   [lmin rmin] set a minimum size for each pane in the
%                    splitlayout.
%     MINWIDTHUNITS : Units for minimum width settings: either 'pixels'
%                     or 'normalized'.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:37:12 $


norepack = 1;

if ~isa(obj,'xregsplitlayout')
   builtin('set',obj,parameter,value);
   reqnorepack=1;
else
   ud=obj.datastore.info;
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
         % check new position against minimum split positions
         minw=ud.minwidth;
         if any(minw)
            if ud.orientation
               sz=position(4);
            else
               sz=position(3);
            end
            % check to see if split needs changing
            if strcmp(ud.minwidthunits,'normalized')
               minw=minw.*sz;
            end
            newspl=ud.split.*sz;
            
            violation=newspl<minw;
            if any(violation) & ~all(violation)
               pane=find(violation);
               otherpane=find(~violation);
               ud.split(pane)=minw(pane)./sz;
               ud.split(otherpane)=1-ud.split(pane);
            end
         end
         set(obj.xregcontainer,'position',position);
      case 'SPLIT'
         % normalise values
         value=value./sum(value);
         % check against minwidth property
         minw=ud.minwidth;
         if any(minw)
            pos=get(obj.xregcontainer,'innerposition');
            if ud.orientation
               sz=pos(4);
            else
               sz=pos(3);
            end
            % check to see if split needs changing
            if strcmp(ud.minwidthunits,'pixels')
               minw=minw./sz;
            end
            
            violation=value<minw;
            if any(violation) & ~all(violation)
               pane=find(violation);
               otherpane=find(~violation);
               value(pane)=minw(pane);
               value(otherpane)=1-value(pane);
            end
         end
         ud.split=value;
      case 'RESIZABLE'
         rsnow=ud.resizable;
         ud.resizable=strmatch(lower(value),['off';'on '])-1;
         if (rsnow~=ud.resizable) & ud.resizable & ud.visible
            i_doResizerVis(obj,'on');
         else
            i_doResizerVis(obj,'off');
         end
      case 'ORIENTATION'
         if strcmp(lower(value),'lr')
            ud.orientation=0;
         elseif strcmp(lower(value),'ud')
            ud.orientation=1;
         end
      case 'DIVIDERSTYLE'
         if strcmp(lower(value),'flat')
            set(obj.rsbutton,'style','text');
            ud.divstyle=0;
         elseif strcmp(lower(value),'3d')
            set(obj.rsbutton,'style','pushbutton');
            ud.divstyle=1;
         end
      case 'DIVIDERWIDTH'
         ud.divwidth=value;
      case 'CALLBACK'
         ud.callbackstr=value;
         reqnorepack=1;
      case {'LEFT','TOP'}
         replace(obj.xregcontainer,value,1);
      case {'RIGHT','BOTTOM'}
         replace(obj.xregcontainer,value,2);
      case 'OUTERBORDER'
         % convert to 'border' type inputs
         value=value(end:-1:1);
         set(obj.xregcontainer,'border',value);
      case {'LEFTINNERBORDER','TOPINNERBORDER'}
         if isnumeric(value) & length(value(:))==4
            ud.innerborderl=value(:)';
         end
      case {'RIGHTINNERBORDER','BOTTOMINNERBORDER'}
         if isnumeric(value) & length(value(:))==4
            ud.innerborderr=value(:)';
         end
      case 'VISIBLE'
         if ~ud.resizable
            % keep button off
            vis='off';
         else
            vis=value;
         end
         ud.visible=strmatch(lower(value),['off';'on '])-1;
         i_doResizerVis(obj,vis);
         % iterate over elements
         el=get(obj.xregcontainer,'elements');
         for k=1:length(el)
            set(el{k},'visible',value);
         end
         reqnorepack=1;
      case 'MINWIDTH'
         ud.minwidth=value;
      case 'MINWIDTHUNITS'
         if any(strcmp(value,{'pixels','normalized'}))
            if ~strcmp(value,ud.minwidthunits)
               ud.minwidthunits=value;
               % convert minwidth values
               pos=get(obj,'position');
               if ud.orientation
                  pos=pos(4);
               else
                  pos=pos(3);
               end
               if strcmp(ud.minwidthunits,'pixels')
                  ud.minwidth=ud.minwidth.*pos;
               else
                  ud.minwidth=ud.minwidth./pos;
               end
            end
         end
      otherwise
         [obj.xregcontainer, reqnorepack] = set(obj.xregcontainer,parameter,value);
      end
      norepack=(norepack & reqnorepack);
   end
   obj.datastore.info=ud;
   
   if ~norepack & get(obj,'boolpackstatus')
      repack(obj);
   end
end





function i_doResizerVis(obj,vis)

if ~strcmp(vis,get(obj.rsbutton,'visible'))
   set(obj.rsbutton,'visible',vis);
   fig=get(obj,'Parent');
   MM=MotionManager(fig);
   if strcmp(vis,'on')
      MM.RegisterManager(obj.PointerRegion);    
   else
      MM.UnregisterManager(obj.PointerRegion);  
   end
end