function ud_handles(cb,what)
%UD_HANDLES   Change order of axis/figure children
%   Up-Down HANDLES is used to change position of some axis/figure
%   children, ie, bring object forward, send object backward,
%   move it to top or bottom.
%   Without arguments a GUI is created where user can select the
%   available handles.
%   Without the GUI, ie, using the command line, UD_HANDLES is just
%   UISTACK.
%
%   Syntax:
%      UD_HANDLES(HANDLE,DIRECTION)
%
%   Inputs:
%      HANDLE      The handle to move
%      DIRECTION   The moving direction [ 'up' 'down' 'top' 'bottom' ]
%
%   GUI:
%      - up      :  send handle up
%      - down    :  send handle down
%      - top     :  send handle to top
%      - bottom  :  send handle to botom
%      - flip    :  flipud handle childrens
%      - delete  :  delete handle
%      - inspect :  inspect or propedit handle
%      - refresh :  refresh list of handles
%
%   Examples:
%     t = linspace(0,2*pi,30);
%     x = sin(t);
%     y = cos(t);
%     figure, hold on
%     red   = fill(x,y,'r','tag','red');
%     green = fill(x+0.8,y,'g','tag','green');
%     blue  = fill(x+1.6,y,'b','tag','blue');
%     axis image
%     ud_handles
%     %ud_handles(blue,'up');
%     %ud_handles(green,'top');
%
%   MMA 14-7-2004, martinho@fis.ua.pt

%   Department of physics
%   University of Aveiro

%   08-11-2005 - Added GUI

if nargin == 0
  cb = 'init';
end

if isequal(cb,'init')
  % check for previous:
  objs = findall(0,'tag','mma_inspect');
  if ~isempty(objs)
    return
  end
  
  su=get(0,'Units');
  set(0,'Units','centimeters');  
  ss=get(0,'ScreenSize');
  set(0,'Units',su);
  
  w = 5;
  h = 10;
  x = ss(3)-w;
  y = ss(4)-h-.8;
      
  fig = figure('MenuBar','none','NumberTitle','off','name','ud_handles',...
    'color',[00.7843    0.7922    0.8824],'tag','mma_inspect',...
    'units','centimeters','position',[x y w h]);
  
  x = 0;
  y = .1;
  w = 1;
  h = .9;
  main = uicontrol('style','listbox','units','normalized','position',[x y w h],...
    'FontSize',8,'callback','ud_handles(''sel'')','tag','objList',...
    'BackgroundColor',[.909804 0.909804 0.909804]);
  
  str={'root (0)'};
  str = strObjs(0,str,'');
  set(main,'string',str)
  
  x = 0;
  y = 0.05; y0=y;
  h = 0.05;
  w = .25;
  up = uicontrol('callback','ud_handles(''ud'',''up'')','string','up',...
    'units','normalized','position',[x y w h]);
  y=y-h;
  dow = uicontrol('callback','ud_handles(''ud'',''down'')','string','down',...
    'units','normalized','position',[x y w h]);
  x=x+w;
  y=y0;
  top = uicontrol('callback','ud_handles(''ud'',''top'')','string','top',...
    'units','normalized','position',[x y w h]);
  y=y-h;
  bot = uicontrol('callback','ud_handles(''ud'',''bottom'')','string','bottom',...
    'units','normalized','position',[x y w h]);
  x=x+w;
  y=y0;
  flp = uicontrol('callback','ud_handles(''flip'')','string','flip',...
    'units','normalized','position',[x y w h]);
  y=y-h;
  del = uicontrol('callback','ud_handles(''delete'')','string','delete',...
    'units','normalized','position',[x y w h],'ForegroundColor',[.55 0 0]);
  x=x+w;
  y=y0;   
  ins = uicontrol('callback','ud_handles(''inspect'')','string','inspect',...
    'units','normalized','position',[x y w h],'ForegroundColor',[0 0 .55]);
  y=y-h;
  ref = uicontrol('callback','ud_handles(''refresh'')','string','refresh',...
    'units','normalized','position',[x y w h],'ForegroundColor',[0 .55 0]);
  
  set(fig,'HandleVisibility','callback');
end

if isequal(cb,'sel')
  num = getObj;
  if isequal(get(num,'selected'),'on')
    selected = 'off';
  else
    selected = 'on';
  end
  set(findall(0),'selected','off')
  set(num,'selected',selected)
end

if isequal(cb,'refresh')
  main=findobj(0,'tag','objList');
  num = getObj;
    
  % new str:
  str={'root (0)'};
  str = strObjs(0,str,'');
  set(main,'string',str);
  
  % update value of listbox:
  s=get(main,'string');
  for i=1:length(s)
    if findstr(num2str(num),s{i})
      break;
    end
  end
  set(main,'value',i);  
end

if isequal(cb,'flip')
  num = getObj;
  handles=get(num,'children');
  set(num,'children',flipud(handles));
  ud_handles('refresh');
end

if isequal(cb,'inspect')
  num = getObj;
  try
    inspect(num);
  catch
    propedit(num);
  end
end

if isequal(cb,'delete')
  main=findobj(0,'tag','objList');
  val=get(main,'value');
  num = getObj;
  eval('delete(num);','');
  ud_handles('refresh'); 
  set(main,'value',max(1,val-1));
  % set new selected:
  ud_handles('sel');
end

if isequal(cb,'ud') | ishandle(cb)
  if ishandle(cb)
    num=cb;
  else
    num = getObj;
  end
  type = get(num,'type');
  
  parent = get(num,'parent');
  handles = get(parent,'children');
  n=length(handles);
  direction=what;
  
  if isempty(handles)
    return
  end
  is=ismember(handles,num);
  i=find(is==1);
  
  if isempty(i)
    return
  end

  if isequal(direction,'up') % bring object forward
    evalc('tmp=handles(i-1);','tmp=handles(i);');
    evalc('handles(i-1)=handles(i);','');
    handles(i)=tmp;
  end
  
  if isequal(direction,'down') % send object backward
    evalc('tmp=handles(i+1);','tmp=handles(i);');
    evalc('handles(i+1)=handles(i);','');
    handles(i)=tmp;
    handles=handles(1:n);
  end
  
  if isequal(direction,'top') % bring object to top
    tmp=handles(i);
    evalc('handles(2:i)=handles(1:i-1);','');
    handles(1)=tmp;
  end
  
  if isequal(direction,'bottom') % send object to bottom
    tmp=handles(i);
    evalc('handles(i:end-1)=handles(i+1:end);');
    handles(end)=tmp;
  end
  
  set(parent,'children',handles);
  ud_handles('refresh');
end

function num=getObj
theList = findobj(0,'tag','objList');
if isempty(theList)
  num=[];
  return
end
str = get(theList,'string');
val = get(theList,'value');
str = str{val};
i1=find(str=='('); i2=find(str==')');
num = str2num(str(i1:i2));  
b=findall(0);
d = abs(b-num);
i = find(d==min(d)); i = i(1);
num=b(i);

function str = strObjs(handle,str,strini)
handlec = get(handle,'children');
%handlec = flipud(handlec);
strini = [strini,'  '];
for i=1:length(handlec)
  handle = handlec(i);
  type   = get(handle,'type');
  tag    = get(handle,'tag');
  num    = num2str(handle);
  if ~isequal(tag,'mma_inspect')
    str(end+1) = {[strini,'',type,' ( ',num,' ) : ',tag]};
    str = strObjs(handle,str,strini);
  end
end