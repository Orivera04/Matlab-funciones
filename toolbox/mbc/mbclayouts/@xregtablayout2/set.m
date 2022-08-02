function  set(obj,varargin)
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
%  Overloaded set methods
%     POSITION :     [xmin xmax width height] of the whole package.
%     CURRENTCARD :  current card visibility
%     NUMCARDS    :  number of cards
%     VISIBLE     : 'on' or 'off'
%     BACKGROUNDCOLOR : Sets the background color of the tab layout
%     FOREGROUNDCOLOR : Sets the color of the text on the tabs
%     TABLABELS : Cell array.  Set of strings for the tabs
%     MINTABSIZE : Minimum tab size to use.  The sizes may go below
%                  this if the tab layout isn't big enough to fit all
%                  the text into the tabs
%     CALLBACK  :  Callback string to activate when a tab is clicked.
%                  The tokens %CARD% and %OBJECT% will be converted to
%                  the current tab index and a copy of the object.
%     INNERBORDER : [N E S W] border in pixels between tab layout edges
%                   and it's contained objects.
%     ENABLE      : 'on'/'off', or a cell array of 'on'/'off' values, one
%                   for each tab.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:37:19 $


norepack = 1;
if ~isa(obj,'xregtablayout2')
   builtin('set',obj,parameter,value);
   reqnorepack=1;
else
   ud = get(obj.whiteline,'userdata');
   for arg=1:2:nargin-1
      parameter = varargin{arg};
      value = varargin{arg+1};
      reqnorepack=0;
      switch upper(parameter)
      case 'POSITION'
         % redraw tabs, reset position on parent xregcardlayout
         if ud.buttonloc==0
            set(obj.xregcardlayout,'position',value+[2 2 -4 -24]+ud.innerborder);
         elseif ud.buttonloc==1
            set(obj.xregcardlayout,'position',value+[2 22 -4 -24]+ud.innerborder);
         end
         ud.tabsdrawn=0;
         reqnorepack=0;
         
      case 'VISIBLE'
         vis=find(strcmp({'off','on'},lower(value)))-1;
         if ~isempty(vis) & vis~=ud.visible
            set(obj.xregcardlayout,'visible',value);
            set([obj.bgpatch;obj.whiteline;obj.lightline;obj.darkline;obj.blackline;ud.tablabels(:)],...
               'visible',value);
            ud.visible=vis;
         end
         reqnorepack=1;
         
      case 'BACKGROUNDCOLOR'
         set(obj.bgpatch,'facecolor',value);
         set(ud.tablabels(:),'backgroundcolor',value);
         ud.bgcol=value;
         reqnorepack=1;
         
      case 'FOREGROUNDCOLOR'
         set(ud.tablabels(:),'foregroundcolor',value);
         reqnorepack=1;
         
      case 'NUMCARDS'
         % change number of tab labels, redraw
         set(obj.xregcardlayout,'numcards',value);
         % get number of cards in parent now
         nc=get(obj.xregcardlayout,'numcards');
         ntabs=length(ud.tablabels);
         if nc<ntabs
            delete(ud.tablabels(nc+1:end));
            ud.tablabels=ud.tablabels(1:nc);
            ud.tabextents=ud.tabextents(1:nc);
            ud.tabsdrawn=0;
            reqnorepack=0;
            ud.enabled=ud.enabled(1:nc);
         elseif nc>ntabs
            cbstr={@i_tabsel,obj};
            figh=get(obj.axes,'parent');
            for n=(ntabs+1):nc
               ud.tablabels(n) = xreguicontrol('parent',figh,'style','text',...
                  'position',[0 0 40 15],...
                  'horizontalalignment','left',...
                  'visible','off',...
                  'interruptible','off',...
                  'buttondownfcn',[cbstr, {n}],...
                  'string',['Tab' sprintf('%d',n)],...
                  'backgroundcolor',ud.bgcol,...
                  'enable','inactive'); 
               ud.tabextents(n) = 40;
            end
            connectdata(obj, ud.tablabels((ntabs+1):end));
            ud.enabled(ntabs+1:nc)=1;
            ud.tabsdrawn=0;
            reqnorepack=0;
         end
         
      case 'CURRENTCARD'
         % redraw tabs
         cc=get(obj.xregcardlayout,'currentcard');
         set(obj.xregcardlayout,'currentcard',value);
         if cc~=get(obj.xregcardlayout,'currentcard');
            % need to redraw tabs
            ud.tabsdrawn=0;
            reqnorepack=0;
         end
         
      case {'TABLABELS','LABELS'}
         % need to set strings and then check extents needed for tabs
         if ischar(value)
            value={value};
         end
         if length(value)==length(ud.tablabels)
            set(ud.tablabels(:),{'string'},value(:));
            if ~ud.visible
               set(ud.tablabels(:),'visible','on');
               ext=get(ud.tablabels(:),{'extent'});
               set(ud.tablabels(:),'visible','off');
            else
               ext=get(ud.tablabels(:),{'extent'});
            end   
            ext=cat(1,ext{:});
            ext=ext(:,3)+13;   % 13 pixels for lines and spaces
            ext=max(ext,ud.mintabsize);
            ud.tabextents = ext';
            ud.tabsdrawn=0;            
         end
         
      case 'MINTABSIZE'
         ud.mintabsize=value;
         ud.tabsdrawn=0;
         ud.tabextents=max(ud.tabextents,value);
         reqnorepack=0;
      case 'CALLBACK'
         ud.callback=value;
         reqnorepack=1;
      case 'BEFORETABSELCALLBACK'
         ud.beforecallback=value;
         reqnorepack=1;         
      case 'BORDER'
         set(obj.xregcardlayout,'border',value);
         ud.tabsdrawn=0;
      case 'INNERBORDER'
         ud.innerborder = [value(4) value(3) -(value(4)+value(2)) -(value(3)+value(1))];
         set(obj.xregcardlayout,'position',get(obj,'position')+[1 2 -3 -23]+ud.innerborder);
      case 'BUTTONPOSITION'
         loc=find(strcmp(lower(value),{'top','bottom'}))-1;
         if ~isempty(loc)
            if loc~=ud.buttonloc
               ud.buttonloc=loc;
               % shift xregcardlayout
               if loc==1
                  set(obj.xregcardlayout,'position',get(obj.xregcardlayout,'position')+[0 20 0 0]);
               elseif loc==0
                  set(obj.xregcardlayout,'position',get(obj.xregcardlayout,'position')-[0 20 0 0]);
               end
               ud.tabsdrawn=0;
            end
         end
      case 'ENABLE'
         % make sure any 'on' settings are 'inactive'
         if ischar(value)==1
            if strcmp(value,'on')
               value='inactive';
               chng=1:length(ud.tablabels);
            else
               chng=[];
            end
            set(ud.tablabels,'enable',value);
         elseif iscell(value) & length(value)==length(ud.tablabels)
            chng=strcmpi('on',value);
            value(chng)={'inactive'};
            set(ud.tablabels,{'enable'},value(:));
         else
            error('Enable setting must be length 1 or of the same length as there are tabs.')
         end
         ud.enabled=zeros(1,length(ud.tablabels));
         ud.enabled(chng)=1;
      otherwise
         [obj.xregcardlayout,reqnorepack]=set(obj.xregcardlayout,parameter,value);
         if ~reqnorepack
            ud.tabsdrawn=0;
         end
      end
      norepack=(norepack & reqnorepack);
   end
end
set(obj.whiteline,'userdata',ud);

if ~norepack & get(obj,'boolpackstatus')
   repack(obj);
end


function i_tabsel(src,evt,obj,n)
cb_tabsel(obj,n);
return
