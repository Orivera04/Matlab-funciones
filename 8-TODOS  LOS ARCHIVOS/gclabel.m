function gclabel(what,filename)
%GCLABEL   Guided contour labels
%   GCLABEL allows the automatic placement of contour labels in
%   the intersection points between a guide and the contour lines.
%   The guide is created by the user and can be a curve (spline) or a
%   broken line.
%   A tutorial follows:
%
%   Syntax:
%      GCLABEL(H)
%      GCLABEL(H,FILENAME)
%      GCLABEL(H,'load')
%      GCLABEL('delete_guides')
%      (follow the tutorial for explanation)
%
%   Tutorial:
%      [C,H] = CONTOUR(...)
%      GCLABEL(H)
%
%      1- Click with the left mouse buttom at least twice on the axes
%         to create the guide and auxiliary points (aux). To stop
%         click with other buttom.
%
%      2- Use the left mouse buttom to drag guide or aux as desired
%
%      3- Click on the guide with right buttom and select <done> on
%         the uicontextmenu. This will delete the guide and aux
%
%      Options are available on the guide uicontextmenu:
%      - <angle=m>, <angle=0>, <angle=0+>: texts are drawn with
%        rotation = line slope, without rotation or with a + mark
%
%      - <bgColor>, <fgColor>, <fontSize>: text labels properties
%
%      - <spline>, <broken line>: the guide can be a curve (spline) or
%        a broken line
%
%      - <delete guides>, <delete this>, <delete all>: delete all
%        guides and aux in gca, delete current guide, aux and labels
%        or delete all
%
%      There is also a uicontextmenu for the aux (right click at the
%      square markers):
%      - <snap to nearest>: will move current aux point to the nearest
%        contour line. This can be useful to put one vertice of the
%        guide on a line
%
%      You have the possibility to add or remove aux points:
%      - add: click on the guide with extend mouse buttom (third one
%        or mouse weel...)
%      - remove: click with the extend mouse buttom on an aux point
%
%      You can add more guides, GCLABEL(H), again and again..., and
%      then save them all with <save> at the guide uicontextmenu.
%      This will create a text file with all the settings of the
%      current guides.
%      Then, after create another contour figure you can reuse the
%      guides saved:
%      GCLABEL(H,FILENAME), or
%      GCLABEL(H,'load'), which calls uigetfile to select filename
%      If this is done in a loop, better delete the guides and aux
%      after:
%      GCLABEL(''delete_guides'')
%
%   Comment:
%      There are three ways to put the labels:
%      1- Inline, but using BackgroundColor instead of cutting the
%      lines. Notice that The BackgroundColor property of text is not
%      present in Matlab prior to R13.
%      2- Inline, but without rotation.
%      3- Not inline but at the left of a marker placed over the
%      contour lines.
%
%   Example:
%      figure
%      x=-10:10; y=0:10;;
%      [x,y]=meshgrid(x,y);
%      z=x.^2-y.^2;
%      [c,h] = contour(x,y,z);
%      gclabel(h);
%      % Now, click with right mouse buttom to create the auxiliary
%      % points (aux). To stop click with other buttom. After  this,
%      % a guide is created.
%      % Click on aux or guide and drag to desired locations.
%      % Add extra points with the third buttom over the guide, or
%      % remove points with the third buttom on any aux point
%      % Both aux points (square markers) and guide have a
%      % uicontextmenu. Right click over aux and guide and explore it.
%      %
%      % Now, you can save the guide created as a text file, in the
%      % guide uicontextmenu, menu <save>, for future use, example:
%      [cs,ch] = contour(peaks);
%      gclabel(h), % then create the guide, drag it, ..., etc
%      % now, save it in file.txt
%      for i=1:n
%        [c,h] = contour(whatever)
%        gclabel(h,'file.txt')
%        gclabel('delete_guides') % to delete the guide and aux, only
%        % leaving the labels)
%      end
%
%   MMA 14-11-2005, martinho@fis.ua.pt
%
%   See also MEETPOINT

if nargin == 0
  return 
elseif ishandle(what)
  chandles  = what;
  % for R14 contours:
  if isequal(get(chandles,'type'),'hggroup')
    chandles = get(chandles,'children');
  end
  setappdata(gcf,'contours',chandles);
  what = 'init';
end

if nargin == 2
  if isequal(filename,'load')
    [filename, pathname] = uigetfile({'*.txt';'*.m';'*.*'},'Select the gclabel file');
    if isequal(filename,0)|isequal(pathname,0)
      return
    else
      filename=[pathname,filename];
    end
  end
  load_gclabel(filename);
  return
end

guide_tag     = 'gclabel_guide';
guide_tag_aux = 'gclabel_guide_aux';

theGuide    = [];
theGuideAux = [];
if isequal(get(gco,'tag'),guide_tag)
  theGuide = gco;
  theGuideAux = getappdata(theGuide,'guide_aux');
elseif isequal(get(gco,'tag'),guide_tag_aux)
  theGuideAux = gco;
  theGuide = getappdata(theGuideAux,'guide');
end

chandles  = getappdata(gcf,'contours');

% load some data:
cp=get(gca,'currentpoint');
xi=cp(1,1);
yi=cp(1,2);
if ishandle(theGuideAux)
  X = get(theGuideAux,'xdata');
  Y = get(theGuideAux,'ydata');
end
if ishandle(theGuide)
  x=get(theGuide,'xdata');
  y=get(theGuide,'ydata');
end

if isequal(what,'init')
  [theGuide,theGuideAux] = drawGuide('tags',guide_tag,guide_tag_aux);
  [labels,markers]=meetpoint_clab(chandles,theGuide);
  setappdata(theGuide,'labels',labels);
  setappdata(theGuide,'markers',markers);
  set(gcf,'WindowButtonDownFcn','gclabel(''get'')');
elseif ishandle(theGuide)
  GuideType = getappdata(theGuide,'guide_type');
  Angle     = getappdata(theGuide,'Angle');
  bgColor   = getappdata(theGuide,'bgColor');
  fgColor   = getappdata(theGuide,'fgColor');
  fontSize  = getappdata(theGuide,'fontSize');
end

if isequal(what,'get') & (isequal(gco,theGuide) | isequal(gco,theGuideAux))

  %---------------------------------------- select to move
  %
  if isequal(get(gcf,'SelectionType'),'normal')
    dist = (X-xi).^2 +(Y-yi).^2;
    i=find(dist==min(dist)); i=i(1);
    setappdata(theGuide,'ref_indice',i);
    deleteLabels(theGuide);
    set(gcf,'WindowButtonMotionFcn','gclabel(''move'')');

    %---------------------------------------- add new point
    %
  elseif isequal(get(gcf,'SelectionType'),'extend') & isequal(gco,theGuide)
    % find where to place the point:
    dist=(x-xi).^2 + (y-yi).^2 ;
    i=find(dist == min(dist));
    for  n=i:length(x)
      dist = sqrt( (X-x(n)).^2 + (Y-y(n)).^2 );
      if any(dist< (max(X)-min(X))/100 + (max(Y)-min(Y))/100)
        break
      end
    end
    i=find(dist == min(dist));
    i_=i-1;
    % rebuilt aux
    X=[X(1:i_) xi X(i:end)];
    Y=[Y(1:i_) yi Y(i:end)];
    drawGuide('guide',theGuide,'aux_data',X,Y);

    %---------------------------------------- remove point:
    %
  elseif isequal(get(gcf,'SelectionType'),'extend') & isequal(gco,theGuideAux)
    % find aux point selected:
    dist=(X-xi).^2 + (Y-yi).^2 ;
    i=find(dist == min(dist)); i=i(1);
    if i==1
      X=X(2:end);
      Y=Y(2:end);
    elseif i==length(x)
      X=X(1:end-1);
      Y=Y(1:end-1);
    else
      X=[X(1:i-1) X(i+1:end)];
      Y=[Y(1:i-1) Y(i+1:end)];
    end
    % rebuild or delete guide, guide_aux and labels:
    if length(X)<=1
      deleteLabels(theGuide);
      delete(theGuide);
      delete(theGuideAux);
    else
      drawGuide('guide',theGuide,'aux_data',X,Y);
    end

  end
end

% ------------------------------------------------ mouse motion event
%
if isequal(what,'move')
  drawGuide('guide',theGuide);
  set(gcf,'WindowButtonUpFcn','gclabel(''stop'')');
end

% ------------------------------------------------ stop mouse motion event
%
if isequal(what,'stop')
  if ishandle(theGuide)
    deleteLabels(theGuide);
    [labels,markers] = meetpoint_clab(chandles,theGuide,Angle,bgColor,fgColor,fontSize);
    setappdata(theGuide,'labels',labels);
    setappdata(theGuide,'markers',markers);
  end
  set(gcf,'WindowButtonMotionFcn','');
end

% ------------------------------------------------ done, delete current guide and aux
%
if isequal(what,'done')
  set(gcf,'WindowButtonDownFcn','');
  set(gcf,'WindowButtonUpFcn','');
  delete(theGuide);
  delete(theGuideAux);
end

% ------------------------------------------------ done for all, delete all guides and aux
%
if isequal(what,'delete_guides')
  AllGuides = findobj(gca,'tag',guide_tag);
  for i=1:length(AllGuides)
    thisGuide = AllGuides(i);
    thisAux = getappdata(thisGuide,'guide_aux');
    delete(thisGuide);
    delete(thisAux);
  end
  set(gcf,'WindowButtonDownFcn','');
  set(gcf,'WindowButtonMotionFcn','');
  set(gcf,'WindowButtonUpFcn','');
end

% ------------------------------------------------ delete current guide, aux and labels
%
if isequal(what,'delete_curr')
  deleteLabels(theGuide);
  delete(theGuide);
  delete(theGuideAux);
end

% ------------------------------------------------ delete all guides, aux and labels
%
if isequal(what,'delete_all')
  AllGuides = findobj(gca,'tag',guide_tag);
  for i=1:length(AllGuides)
    thisGuide = AllGuides(i);
    thisAux = getappdata(thisGuide,'guide_aux');
    deleteLabels(thisGuide);
    delete(thisGuide);
    delete(thisAux);
  end
  set(gcf,'WindowButtonDownFcn','');
  set(gcf,'WindowButtonMotionFcn','');
  set(gcf,'WindowButtonUpFcn','');
end

% ------------------------------------------------ angle, colors, fontsize
%
if isequal(what,'angle_0') | isequal(what,'angle_0+') | isequal(what,'angle_m')...
    | isequal(what,'bgColor') | isequal(what,'fgColor') | isequal(what(1:2),'fs')
  if isequal(what,'angle_0')
    Angle=0;
  elseif isequal(what,'angle_0+')
    Angle=2;
  elseif isequal(what,'angle_m')
    Angle=1;
  elseif isequal(what,'bgColor')
    tmp = uisetcolor(bgColor);
    if ~isequal(tmp,0), bgColor = tmp; end
  elseif  isequal(what,'fgColor')
    tmp = uisetcolor(fgColor);
    if ~isequal(tmp,0), fgColor = tmp; end
  elseif isequal(what(1:2),'fs')
    fontSize = str2num(what(3:end));
  end

  deleteLabels(theGuide);
  [labels,markers]=meetpoint_clab(chandles,theGuide,Angle,bgColor,fgColor,fontSize);
  setappdata(theGuide,'labels',   labels);
  setappdata(theGuide,'markers',  markers);
  setappdata(theGuide,'Angle',    Angle);
  setappdata(theGuide,'bgColor',  bgColor);
  setappdata(theGuide,'fgColor',  fgColor);
  setappdata(theGuide,'fontSize', fontSize);

  cmenu = getappdata(theGuide,'cmenu');
  menu_anglem  = findobj(cmenu,'label','angle=m');
  menu_angle0  = findobj(cmenu,'label','angle=0');
  menu_angle00 = findobj(cmenu,'label','angle=0+');
  menu_fs6     = findobj(cmenu,'label','6');
  menu_fs8     = findobj(cmenu,'label','8');
  menu_fs10    = findobj(cmenu,'label','10');
  menu_fs12    = findobj(cmenu,'label','12');
  if isequal(what,'angle_0') | isequal(what,'angle_0+') | isequal(what,'angle_m')
    set(menu_anglem, 'checked','off');
    set(menu_angle0, 'checked','off');
    set(menu_angle00,'checked','off');
    if isequal(what,'angle_m'),  set(menu_anglem, 'checked','on'); end
    if isequal(what,'angle_0'),  set(menu_angle0, 'checked','on'); end
    if isequal(what,'angle_0+'), set(menu_angle00,'checked','on'); end
  end
  if isequal(what(1:2),'fs')
    set(menu_fs6, 'checked','off');
    set(menu_fs8, 'checked','off');
    set(menu_fs10,'checked','off');
    set(menu_fs12,'checked','off');
    evalc(['set(menu_fs',what(3:end),',''checked'',''on'');'],'');
  end
end

% ------------------------------------------------ spline <-> bline
%
if isequal(what,'spline') | isequal(what,'bline')
  GuideType = getappdata(theGuide,'guide_type');
  if ~isequal(what,GuideType)
    setappdata(theGuide,'guide_type',what);
    deleteLabels(theGuide);
    drawGuide('guide',theGuide,'aux_data',X,Y);
    [labels,markers]=meetpoint_clab(chandles,theGuide,Angle,bgColor,fgColor,fontSize);
    setappdata(theGuide,'labels',labels);
    setappdata(theGuide,'markers',markers);
  end

  cmenu = getappdata(theGuide,'cmenu');
  menu_spline = findobj(cmenu,'label','spline');
  menu_bline  = findobj(cmenu,'label','broken line');
  set(menu_spline,'checked','off');
  set(menu_bline, 'checked','off');
  if isequal(what,'spline'), set(menu_spline,'checked','on'); end
  if isequal(what,'bline'),  set(menu_bline, 'checked','on'); end
end

% ------------------------------------------------ snap to nearest contour
%
if isequal(what,'snap')
  % find nearest contour point:
  xc=cell_2_v(get(chandles,'xdata'));
  yc=cell_2_v(get(chandles,'ydata'));
  dist=(xc-xi).^2 + (yc-yi).^2 ;
  i=find(dist == min(dist)); i=i(1);
  xp = xc(i);
  yp = yc(i);

  % find aux point selected:
  dist=(X-xi).^2 + (Y-yi).^2 ;
  i=find(dist == min(dist));

  X(i) = xp;
  Y(i) = yp;
  deleteLabels(theGuide);
  drawGuide('guide',theGuide,'aux_data',X,Y);
  [labels,markers]=meetpoint_clab(chandles,theGuide,Angle,bgColor,fgColor,fontSize);
  setappdata(theGuide,'labels',labels);
  setappdata(theGuide,'markers',markers);
end

% ------------------------------------------------ save
%
if isequal(what,'save')
  [filename, pathname] = uiputfile('gclabel.txt', 'Save current gclabels');
  if ~(isequal(filename,0) | isequal(pathname,0))
    AllGuides = findobj(gca,'tag',guide_tag);
    fid=fopen([pathname,filename],'w');
    fprintf(fid,'*** gclabel data *** %s ***\n',datestr(now));
    for i=1:length(AllGuides)
      thisGuide = AllGuides(i);
      GuideType = getappdata(thisGuide,'guide_type');
      Angle     = getappdata(thisGuide,'Angle');
      bgColor   = getappdata(thisGuide,'bgColor');
      fgColor   = getappdata(thisGuide,'fgColor');
      fontSize  = getappdata(thisGuide,'fontSize');
      thisAux   = getappdata(thisGuide,'guide_aux');
      X = get(thisAux,'xdata');
      Y = get(thisAux,'ydata');

      fprintf(fid,'\n');
      fprintf(fid,'#%d\n',i);
      fprintf(fid,'= GuideType %s\n',GuideType);
      fprintf(fid,'= Angle %d\n',    Angle);
      fprintf(fid,'= bgColor %s\n', num2str(bgColor));
      fprintf(fid,'= fgColor %s\n', num2str(fgColor));
      fprintf(fid,'= fontSize %d\n', fontSize);

      for i=1:length(X)
        fprintf(fid,'data %f %f\n',X(i),Y(i));
      end
      fprintf(fid,'#\n');
    end
    fclose(fid);
  end
end

% ------------------------------------------------ help
%
if isequal(what,'help')
 Message={
  'GCLABEL -  Guided Contour Labels',
  ''
  '>> [c,h] = contour(...)',
  'Start gclabel:'
  '>> gclabel(h)',
  '1 - Click with the left mouse buttom at least twice on the axes to create the guide and auxiliary points (aux). To stop, click with other buttom',
  '2 - Use the left mouse buttom to drag guide or aux as desired.',
  '3 - Click on the guide with right buttom and select <done> on the uicontextmenu. This will delete the guide and aux.',
  '',
  'Other options are available on the guide uicontextmenu:',
  '- <angle=m>, <angle=0>, <angle=0+>: texts are drawn with rotation = line slope, without rotation or with a + mark.',
  '- <bgColor>, <fgColor>, <fontSize>: text labels properties',
  '- <spline>, <broken line>: the guide can be a curve (spline) or a broken line',
  '- <delete guides>, <delete this>, <delete all>: delete all guides and aux in gca, delete current guide, aux and labels or delete all',
  '',
  'There is also a uicontextmenu for the aux (right click at the square markers):',
  '- <snap to nearest>: will move current aux point to the nearest contour line. This can be useful to put one vertice of the guide on a line'
  '',
  'You have the possibility to add or remove aux points:',
  '- add: click on the guide with extend mouse buttom (third one or mouse weel...)',
  '- remove: click with the extend mouse buttom on an aux point',
  '',
  'You can add more guides, gclabel(h), again and again...',
  'And then save them all with <save> at the guide uicontextmenu.',
  'This will create a text file with all the settings of the current guides.',
  'Then, after create another contour figure you can reuse the guides saved:',
  '>> gclabel(h,filename)',
  'If this is done in a loop, better delete the guides and aux after this: gclabel(''delete_guides'')',
  '',
  'For questions/comments, use my email: martinho@fis.ua.pt'
  };
  Title='gclabel, help';
  mb=msgbox(Message,Title,'help','modal');
end

% ------------------------------------------------ about
%
if isequal(what,'about')
  Message={
  'GCLABEL -  Guided Contour Labels',
  ''
  'Martinho Marta Almeida',
  'Physics Department',
  'Aveiro University'
  'Portugal',
  '',
  'Nov-2005',
  '',
  'martinho@fis.ua.pt'
  };
  Title='gclabel, about';
  mb=msgbox(Message,Title,'help','modal');
end

function deleteLabels(guide)
labels  = getappdata(guide,'labels');
markers = getappdata(guide,'markers');
if ishandle(labels)
  delete(labels)
end
if ishandle(markers)
  delete(markers)
end

function [theGuide,theGuideAux] = drawGuide(varargin)
theGuide=[];
X=[];
for i=1:length(varargin)
  if isequal(varargin{i},'tags')
    guide_tag = varargin{i+1};
    guide_tag_aux = varargin{i+2};
  end
  if isequal(varargin{i},'guide')
    theGuide = varargin{i+1};
  end
  if isequal(varargin{i},'aux_data')
    X = varargin{i+1};
    Y = varargin{i+2};
  end
end

if ~isempty(theGuide)
  theGuideAux = getappdata(theGuide,'guide_aux');
end

if isempty(theGuide)
  hold on
  c=0;
  while 1
    [x_,y_] = ginput(1);
    if isequal(get(gcf,'SelectionType'),'normal')
      c=c+1;
      X(c)=x_;
      Y(c)=y_;
      p(c)=plot(x_,y_,'rs');
    elseif c > 1
      break
    end
  end
  delete(p);
  [x,y] = genGuide(X,Y,'spline');
  theGuide    = plot(x,y,'r:','tag',guide_tag,    'erasemode','xor');
  theGuideAux = plot(X,Y,'ks','tag',guide_tag_aux,'erasemode','xor');

  setappdata(theGuide,'guide_aux',theGuideAux);
  setappdata(theGuideAux,'guide',theGuide);

  genMenu(theGuide)
  genMenuAux(theGuideAux)

  setappdata(theGuide,'guide_type','spline');
  setappdata(theGuide,'Angle',     1       );
  setappdata(theGuide,'bgColor',   [1 1 1] );
  setappdata(theGuide,'fgColor',   [0 0 0] );
  setappdata(theGuide,'fontSize',  10      );

elseif ~isempty(X)
  guideType = getappdata(theGuide,'guide_type');
  [x,y] = genGuide(X,Y,guideType);
  set(theGuide,   'xdata',x,'ydata',y);
  set(theGuideAux,'xdata',X,'ydata',Y);
else % move event:
  i = getappdata(theGuide,'ref_indice');
  guideType = getappdata(theGuide,'guide_type');
  cp = get(gca,'CurrentPoint');
  X = get(theGuideAux,'xdata');
  Y = get(theGuideAux,'ydata');
  X(i) = cp(1,1);
  Y(i) = cp(1,2);
  [x,y] = genGuide(X,Y,guideType);
  set(theGuide,   'xdata',x,'ydata',y);
  set(theGuideAux,'xdata',X,'ydata',Y);
end

function [x,y] = genGuide(xaux,yaux,GuideType)
if isequal(GuideType,'spline')
  xy=[xaux;yaux];
  dt=.25;
  n=size(xy,2);
  t=1:n;
  ts=1:dt:n;
  xys=spline(t,xy,ts);
  x=xys(1,:);
  y=xys(2,:);
elseif isequal(GuideType,'bline')
  x=xaux;
  y=yaux;
end

function genMenu(theHandle)
% uicontextmenus for the guide:
cmenu = uicontextmenu;
set(theHandle, 'UIContextMenu', cmenu);
uimenu(cmenu,   'Label', 'done',          'Callback', 'gclabel(''done'')'                           );
uimenu(cmenu,   'Label', 'delete guides', 'Callback', 'gclabel(''delete_guides'')', 'separator','on');
uimenu(cmenu,   'Label', 'delete this',   'Callback', 'gclabel(''delete_curr'')'                    );
uimenu(cmenu,   'Label', 'delete all',    'Callback', 'gclabel(''delete_all'')'                     );
uimenu(cmenu,   'Label', 'angle=m',       'Callback', 'gclabel(''angle_m'')',       'separator','on','checked','on');
uimenu(cmenu,   'Label', 'angle=0',       'Callback', 'gclabel(''angle_0'')'                        );
uimenu(cmenu,   'Label', 'angle=0+',      'Callback', 'gclabel(''angle_0+'')'                       );
uimenu(cmenu,   'Label', 'bgColor',       'Callback', 'gclabel(''bgColor'')',       'separator','on');
uimenu(cmenu,   'Label', 'fgColor',       'Callback', 'gclabel(''fgColor'')'                        );
fs=uimenu(cmenu,'Label', 'FontSize',      'Callback', ''                                            );
uimenu(fs,      'Label', '6',             'Callback', 'gclabel(''fs6'')'                            );
uimenu(fs,      'Label', '8',             'Callback', 'gclabel(''fs8'')'                            );
uimenu(fs,      'Label', '10',            'Callback', 'gclabel(''fs10'')'                           ,'checked','on');
uimenu(fs,      'Label', '12',            'Callback', 'gclabel(''fs12'')'                           );
uimenu(cmenu,   'Label', 'spline',        'Callback', 'gclabel(''spline'')',        'separator','on','checked','on');
uimenu(cmenu,   'Label', 'broken line',   'Callback', 'gclabel(''bline'')'                          );
uimenu(cmenu,   'Label', 'save',          'Callback', 'gclabel(''save'')',          'separator','on');
uimenu(cmenu,   'Label', 'help',          'Callback', 'gclabel(''help'')'                           );
uimenu(cmenu,   'Label', 'about',         'Callback', 'gclabel(''about'')'                          );
setappdata(theHandle,'cmenu',cmenu);

function genMenuAux(theHandle)
% uicontextmenus for the guide aux (markers)
cmenu = uicontextmenu;
set(theHandle,'UIContextMenu', cmenu);
uimenu(cmenu,'Label', 'snap to nearest','Callback', 'gclabel(''snap'')');

function load_gclabel(filename)
chandles  = getappdata(gcf,'contours');
guide_tag = 'gclabel_guide';
guide_tag_aux = 'gclabel_guide_aux';

% some default settings:
GuideType = 'spline';
Angle     = 1;
bgColor   = [1 1 1];
fgColor   = [0 0 0];
fontSize  = 10;

fid=fopen(filename);
while 1
  tline = fgetl(fid);
  if ~ischar(tline), break, end
  if length(tline) > 1
    if isequal(tline(1),'#')
      cont=0;
      X = [];
      Y = [];
    end
    if strmatch('= GuideType',tline), GuideType = tline(13:end);          end
    if strmatch('= Angle',tline),     Angle     = str2num(tline(8:end));  end
    if strmatch('= bgColor',tline),   bgColor   = str2num(tline(10:end)); end
    if strmatch('= fgColor',tline),   fgColor   = str2num(tline(10:end)); end
    if strmatch('= fontSize',tline),  fontSize  = str2num(tline(11:end)); end
    if strmatch('data',tline)
      cont=cont+1;
      data = str2num(tline(5:end));
      X(cont)=data(1);
      Y(cont)=data(2);
    end
  elseif isequal(tline,'#') & length(X) > 1
    [x,y] = genGuide(X,Y,GuideType);
    hold on
    theGuide    = plot(x,y,'r:','tag',guide_tag,    'erasemode','xor');
    theGuideAux = plot(X,Y,'ks','tag',guide_tag_aux,'erasemode','xor');

    setappdata(theGuide,'guide_aux',theGuideAux);
    setappdata(theGuideAux,'guide',theGuide);

    genMenu(theGuide)
    genMenuAux(theGuideAux)

    setappdata(theGuide,'guide_type',GuideType);
    setappdata(theGuide,'Angle',     Angle    );
    setappdata(theGuide,'bgColor',   bgColor  );
    setappdata(theGuide,'fgColor',   fgColor  );
    setappdata(theGuide,'fontSize',  fontSize );

    [labels,markers]=meetpoint_clab(chandles,theGuide,Angle,bgColor,fgColor,fontSize);
    setappdata(theGuide,'labels',    labels);
    setappdata(theGuide,'markers',   markers);
  end
end
fclose(fid);
set(gcf,'WindowButtonDownFcn','gclabel(''get'')');

function v = cell_2_v(c)
v=[];
for i=1:length(c)
  v = [v; c{i}];
end

function [TextHandles,MarkerHandles] = meetpoint_clab(handle0,handle1,Angle,bgColor,fgColor,fontSize)
%MEETPOINT_CLAB   Meet points and slopes of curves
%   Computes the intesection points of curves and the slopes at the
%   meet points, adding labels and markers.
%   This is a modified version of MEETPOINT (MMA 10-11-2005)

TextHandles   = nan;
MarkerHandles = nan;

if nargin < 5
  fontSize = 10;
end
if nargin < 5
  fgColor = 'k';
end
if nargin < 4
  bgColor = 'w';
end
if nargin < 3
  Angle = 1;
end

% for R14 contours:
if isequal(get(handle0,'type'),'hggroup')
  handle0 = get(handle0,'children');
end
if isequal(get(handle1,'type'),'hggroup')
  handle1 = get(handle1,'children');
end
n0 = length(handle0);
n1 = length(handle1);

x  = [];
y  = [];
m1 = [];
m2 = [];
v  = [];
for in0 = 1:n0
  x0 = get(handle0(in0),'xdata');
  y0 = get(handle0(in0),'ydata');

  % get contour values: notice that the contours should be the first input
  if isequal(get(handle0(in0),'type'),'line')
    val=get(handle0(in0),'userdata');
  else
    val=get(handle0(in0),'cdata'); val=val(1);
  end

  for in1 = 1:n1
    x1 = get(handle1(in1),'xdata');
    y1 = get(handle1(in1),'ydata');
    [x_,y_,m1_,m2_] = theCalc(x0,y0,x1,y1);
    x  = [x   x_];
    y  = [y   y_];
    m1 = [m1 m1_];
    m2 = [m2 m2_];    
  end
  v  = [v repmat(val,size(x_))];
end

if length(x) == 0
  return
end
I=m2>90 & m2<270;
m2(I) = m2(I) - 180;

theLabels  = nan;
theMarkers = nan;
for i=1:length(x)
  X = x(i);
  Y = y(i);
  M = m2(i);
  V = v(i);
  if Angle == 0 | Angle == 1
    theLabels=text(X,Y,num2str(V),'color',fgColor,'fontSize',fontSize);
    try
      set(theLabels,'backgroundcolor',bgColor);
    end
    set(theLabels,'HorizontalAlignment','center','VerticalAlignment','middle');
    if Angle == 1
      set(theLabels,'rotation',M);
    end
  elseif Angle == 2
    theLabels  = text(X,Y,[' ',num2str(V)],'color',fgColor,'fontSize',fontSize);
    set(theLabels,'VerticalAlignment','bottom');
    theMarkers = plot(X,Y,'k+','MarkerSize',5);
  end
  TextHandles(i)   = theLabels;
  MarkerHandles(i) = theMarkers;
end

% unchanged form here (in MEETPOINT)
function [X,Y,M1,M2] = theCalc(x0,y0,x1,y1)
X  = [];
Y  = [];
M1 = [];
M2 = [];

cont = 0;
i=0;
while 1
  i=i+1;
  if i+1 > length(x1)
    break
  end
  fx = x1(i:i+1);
  fy = y1(i:i+1);
  j=0;
  while 1
    j=j+1;
    if j+1 > length(x0)
      break
    end
    gx = x0(j:j+1);
    gy = y0(j:j+1);
    ang1 = atan2(diff(fy),diff(fx))*180/pi;
    ang2 = atan2(diff(gy),diff(gx))*180/pi;
    if ~(max(fx) < min(gx)  | min(fx) > max(gx) |   max(fy) < min(gy)  | min(fy) > max(gy))
      if (diff(fx) ~= 0 & diff(gx) ~= 0)
        m1 = diff(fy)/diff(fx);
        m2 = diff(gy)/diff(gx);
        x01 = fx(1);
        y01 = fy(1);
        x02 = gx(1);
        y02 = gy(1);
        if m1==m2
          x=inf;
          y=inf;
        else
          y = 1/(m1-m2) * ( m1*y02 - m2*y01 + m1*m2*(x01-x02));
          if m1 ~= 0
            x = (y-y01+m1*x01)/m1;
          elseif m2 ~= 0
            x = (y-y02+m2*x02)/m2;
          end
        end
      elseif diff(fx) == 0 & diff(gx) ~= 0
        m2 = diff(gy)/diff(gx);
        x02 = gx(1);
        y02 = gy(1);
        x = fx(1);
        y = m2*(x-x02) + y02;
      elseif diff(fx) ~= 0 & diff(gx) == 0
        m1 = diff(fy)/diff(fx);
        x01 = fx(1);
        y01 = fy(1);
        x = gx(1);
        y = m1*(x-x01) + y01;
      else
        x=inf;
        y=inf;
      end
      if x>=max([min(fx) min(gx)]) & x<=min([max(fx) max(gx)])  & y>=max([min(fy) min(gy)]) & y<=min([max(fy) max(gy)])
        cont = cont+1;
        X(cont)  = x;
        Y(cont)  = y;
        M1(cont) = ang1;
        M2(cont) = ang2;
      end
    end
  end
end
% remove repeated points: they happen when curves touch in a vertice!
[X,I] = unique(X);
Y  = Y(I);
M1 = M1(I);
M2 = M2(I);
