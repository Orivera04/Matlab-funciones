function h=testline(action,tag,direction,movecall,upcall)
%TESTLINE places a mouse-movable line on the current axis for current data
%
%  Format: h=testline(action,tag,direction,movecall,upcall)
%
%    -action:
%       (handle) = handle of data line or axis to associate testline with
%           This creates the line, and requires tag and direction.
%
%       'mousedown' sets a flag in userdata of line and figure window
%				properties
%       'mouseup'   resets flag and figure properties to null states
%       'mousego'   moves testline
%       'delete'  erases testline
%       'recenter'   recenters testline
%             (all above actions require tag as well)
%
%    -tag: tag of line (if [], default='testline')
%
%	  -direction: 'v' vertical or 'h' horizontal (if [], default='h')
%       For a horiz line, testline is placed at mean of data or ylim
%       For a vert line, testline is placed at the current minimum xlim
%
%    -movecall (optional): additional callback that can be used 
%        with 'mousego' (default='')
%
%    -upcall (optional): additional callback that can be used 
%        with 'mouseup' (default='')
%
% Bill Miller
% Updated April 10, 2001

if nargin<1
   disp(' TESTLINE: need a line or axis handle');
   return
end

if isnumeric(action)
   if ~exist('movecall'),movecall='';,end
   if ~exist('upcall'),upcall='';,end
   if ~exist('tag')
      tag='testline';
   elseif isempty(tag)
      tag='testline';
   end
   if ~exist('direction')
      direction='h';
   elseif isempty(direction)
      direction='h';
   end
      
   h=CreateLine(action,tag,direction,movecall,upcall);
   return
end
   
switch(action)
	case 'mousedown'
      li=findobj('parent',gca,'tag',tag);
      userdata=get(li,'userdata');
      userdata{1}=1;
      set(li,'userdata',userdata);
      cmd1=['testline(''mousego'',''' tag ''');'];
      cmd2=['testline(''mouseup'',''' tag ''');'];
      set(gcf,'WindowButtonMotionFcn',cmd1);
      set(gcf,'WindowButtonUpFcn',cmd2);
      drawnow
      
   case 'mousego'
      MoveLine(tag,action)
      
   case 'mouseup'
      DoMouseUp(tag)
      
   case 'delete'
      li=findobj('parent',gca,'tag',tag);
      set(li,'erasemode','normal')
      delete(li)
      set(gcf,'WindowButtonMotionFcn','');
      set(gcf,'WindowButtonUpFcn','');
      
   case 'recenter'
      MoveLine(tag,action)
end
   
  
%--------------
function li=CreateLine(handle,tag,direction,movecall,upcall)
		hold on
      
      tp=get(handle,'type');
      switch tp
      	case 'axes'
            axhnd=handle;
            xlim=get(axhnd,'xlim');
            ylim=get(axhnd,'ylim');
            ypos=mean(ylim);
            xpos=mean(xlim);
         case 'line'
            axhnd=get(handle,'parent');
            xlim=get(axhnd,'xlim');
            ylim=get(axhnd,'ylim');
            xpos=mean(xlim);
         	y=get(handle,'ydata');
         	ypos=mean(y);

         otherwise
            disp('  TESTLINE: action must be handle to axes or line')
            return
      end
               
      cmd1=['testline(''mousedown'',''' tag ''');'];
      
      switch direction
         case 'h'
         	xdata=xlim;
         	ydata=[ypos ypos];
      	case 'v'
         	xdata=[xpos xpos];
         	ydata=ylim;
         otherwise
            disp('  TESTLINE: direction must be ''h'' or ''v'' ')
				return
         end
      
   	li=line(xdata,ydata, ...
         'color','r', ...
         'linewidth', 1.5, ...
         'tag',tag, ...
         'erasemode','xor', ...
         'userdata',{0, direction, movecall, upcall},...
         'ButtonDownFcn',cmd1);
            
%--------------
function MoveLine(tag,action)

	li=findobj('parent',gca,'tag',tag);
   
   userdata=get(li,'userdata');
   state=userdata{1};
   
   xlim=get(gca,'xlim');
   ylim=get(gca,'ylim');

   switch action
   	case 'recenter'
         xpos=mean(xlim);
         ypos=mean(ylim);
      case 'mousego'
         if state==0,return,end
      	pt=get(gca,'currentpoint');
   		xpos=pt(1,1);
   		ypos=pt(1,2);
   end
   
   
   switch userdata{2}
   	case 'h'
         if ypos > ylim(2)
            ypos=ylim(2);
         elseif ypos<ylim(1)
            ypos=ylim(1);
         end
         set(li,'ydata',[ypos ypos])
         drawnow
      case 'v'
         if xpos > xlim(2)
            xpos=xlim(2);
         elseif xpos<xlim(1)
            xpos=xlim(1);
         end
         set(li,'xdata',[xpos xpos])
         drawnow
      otherwise
   end
   
   movecall=userdata{3};
   eval(movecall)

%--------------
function DoMouseUp(tag)

	li=findobj('parent',gca,'tag',tag);
   userdata=get(li,'userdata');
   state=userdata{1};
   if state==0,return,end
   
   userdata{1}=0;
   set(li,'userdata',userdata)
   set(gcf,'WindowButtonMotionFcn','');
   set(gcf,'WindowButtonUpFcn','');
   drawnow
   
   upcall=userdata{4};
   eval(upcall)


