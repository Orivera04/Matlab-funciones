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
%     BORDERS  :     [NORTH EAST SOUTH WEST] border in pixels
%     BACKGROUND :   {PROP,value} sets the background axes property PROP
%     BACKGROUNDCOLOR : Color for center of 3d pane
%     BUTTONDOWNFCN : String.  The identifier %OBJECT% is converted into a
%                     copy of the object before the string is evaluated.
%     SELECTED :     'on' or 'off'.  Turns the 3D border a shade of blue
%     UICONTEXTMENU : handle to uicontextmenu to set in background axes
%     TAGTEXT       : String.  Text to display in 'tag' at top-left corner
%     TAGCOLOR      : Color of tag item.  Default is current figure color.
%     

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.4 $  $Date: 2004/02/09 07:36:06 $


norepack = 1;
ud=get(obj.blackline,'userdata');

if ~isa(obj,'xregframe3dlayout')
   builtin('set',obj,parameter,value);
   reqnorepack=1;
else
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
         %position=position+[2 2 -4 -4];
         set(obj.xregcontainer,'position',position);
      case 'BORDERS'
         if isnumeric(value) & length(value)==4
            ud.borders=value;
         end
      case 'BACKGROUND'
         set(obj.background,value{:});
         reqnorepack=1;
      case 'BACKGROUNDCOLOR'
         set([obj.background;obj.cbobject],'facecolor',value);
      case 'BUTTONDOWNFCN'
         ud.buttondownfcn=value;
         if isempty(value)
            set(obj.cbobject,'buttondownfcn','')
         else
            set(obj.cbobject,'buttondownfcn',{@i_firebtndown,obj});
         end
         
         reqnorepack=1;
      case 'UICONTEXTMENU'
         set(obj.cbobject,'uicontextmenu',value);
         reqnorepack=1;
      case 'SELECTED'
         if strcmp(lower(value),'on')
            ud.sel=1;
         else
            ud.sel=0;
         end
         pr_sel(obj,ud.sel);
         reqnorepack=1;
      case 'VISIBLE'
         set([obj.background;obj.cbobject;obj.blackline;obj.darkline;obj.midline;obj.lightline],...
            'visible',value);
         if ud.tagtext
            set([obj.tagtext;obj.tagback],'visible',value);
         end
         % iterate over elements
         el=get(obj.xregcontainer,'elements');
         for k=1:length(el)
            set(el{k},'visible',value);
         end
         reqnorepack=1;
      case 'TAGTEXT'
         if ischar(value)
            set(obj.tagtext,'string',value);
            if isempty(value)
               ud.tagtext=0;
               ud.tagextent=[0 0];
               set([obj.tagtext;obj.tagback],'visible','off');
            else
               ud.tagtext=1;
               if strcmp(get(obj.background,'visible'),'on')
                  set([obj.tagtext;obj.tagback],'visible','on');
                  ud.tagextent=get(obj.tagtext,'extent');
               else
                  ttH=handle(obj.tagtext);
                  ttH.doMoveOffScreen(false);
                  ud.tagextent=ttH.extent;
                  ttH.doMoveOffScreen(true);
               end
            end
         else
            reqnorepack=1;
         end
      case 'TAGCOLOR'
         set(obj.tagback,'facecolor',value);
         reqnorepack=1;
      otherwise
         [obj.xregcontainer,reqnorepack]=set(obj.xregcontainer,parameter,value);
      end
      norepack=(norepack & reqnorepack);
   end
   set(obj.blackline,'userdata',ud);
   if ~norepack & get(obj,'boolpackstatus')
      repack(obj);
   end
end



function i_firebtndown(src,evt,obj)
firebtndn(obj);
return
