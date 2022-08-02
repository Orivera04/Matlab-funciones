function tabpanel( figname , tag , action )
%TABPANEL  TabPanel Constructor offers the easiest way for creating of tabpanels
%   Usage:
%      1. Reserve place for tabpanel with textobject under GUIDE and notice
%         the fig-file name and the 'tag'-property of the created textobject.
%      2. Initialize TabPanel Constructor with:
%         tabpanel('fig_file','tag_name',{'Tab1' 'Tab2' 'Tab3'})
%      3. Use constructor for creating tabpanels (might be selfexplicatory...)
%      4. ready? update tabpanel, close GUI und restart it.
%
%   Options:
%      a. activate TabPanel Constructor:
%         tabpanel('fig_file','tag_name')
%      b. add or remove a panel:
%         tabpanel('fig_file','tag_name',{'Tab1' 'NewPanel1' 'Tab3' 'NewPanel2'})
%      c. remove tabpanel from GUI
%         tabpanel('fig_file','tag_name','delete')

%   Version: 1.3 $  
%   Date:    2005/02/25 21:44:00 $
%   (c) 2005 By Elmar Tarajan [MCommander@gmx.de]
%
figname = [strrep(figname,'.fig','') '.fig'];
fig     = openfig(figname,'reuse');
handles = guihandles(fig);
%
%
if nargin == 3 & ischar(action)
   %
   tab = get(handles.(tag)(end),'Userdata');
   htabs = handles.(tab.tag)(end-length(tab.names)-1:end-2);   
   hcurr = findobj(htabs,'String',tab.current);
   %
   switch action
      case 'edit'
         %
         currfig = figure('NumberTitle','off', ...
            'Name',[tab.tag '_' tab.current], ...
            'Units','pixels', ...
            'Menubar','none', ...
            'color',tab.CurrBackColor, ...
            'position',tab.pos-[0 0 6 tab.height+tab.outbreak+4], ...
            'visible','off');
         %
         children = get(hcurr,'UserData');
         [cancel order] = unique(children);
         for j = children(-sort(-order))
            tmp = handle2struct(handles.(char(j)));
            for i=1:length(tmp)
               tmp(i).properties.Position(1:2) = tmp(i).properties.Position(1:2)-tab.pos(1:2)-[ 3 3];
               tmp(i).properties.Tag = tmp(i).properties.Tag(max(find(tmp(i).properties.Tag=='_'))+1:end);
            end% for
            struct2handle(tmp,currfig);
         end% for
         %
         hgS_050200 = handle2struct(currfig);
         hgS_050200.properties.Color = tab.CurrBackColor;
         save([tab.tag '_' tab.current '.fig'],'hgS_050200','-mat');
         delete(currfig);
         %
         try
            result = get(handles.(constructor)(1),'UserData');
            result.java.closeWindow(0);
         end% try
         %
         result.java = guide([tab.tag '_' tab.current '.fig']);
         result.figname = [tab.tag '_' tab.current '.fig'];
         set(handles.(['constructor_' tag])(1),'UserData', result)
         return
         %
      case 'update'
         %
         figfiles = dir([tab.tag '_*.fig']);
         for j={figfiles.name}
            tabfile = j{:}(max(find(char(j)=='_'))+1:max(find(char(j)=='.'))-1);
            tags=[];
            %
            children = get(findobj(htabs,'String',tabfile),'UserData');
            [cancel order] = unique(children);
            for i = children(sort(order))
               delete(handles.(char(i)));
            end% for
            %
            hpage = openfig(char(j),'new','invisible');
            set(get(hpage,'Children'),'Units','pixels');
            for i=get(hpage,'children')'
               tmp = get(i,'position');
               tags{end+1} = [tab.tag '_' tabfile '_' get(i,'Tag')];
               set(i,'Position',[[tmp(1:2)+tab.pos(1:2) + [3 3]] tmp(3:4)],'Tag',tags{end});
                  %
               if strcmp(tab.current,tabfile)
                  set(i,'Visible','on');
               else
                  set(i,'Visible','off');
               end% if
               %
               try
                  if isempty(get(i,'callback'))
                     switch lower(get(i,'Style'))
                        case {'listbox' 'popupmenu' 'listbox' 'slider' 'edit'}
                           set(i,'callback','%automatic');
                           set(i,'CreateFcn','%automatic');
                        case {'checkbox' 'pushbutton' 'togglebutton' 'radiobutton'}
                           set(i,'callback','%automatic');
                     end% switch
                  end% if
               end% try
            end% for
            set(findobj(htabs,'String',tabfile),'Userdata',tags);
            tmp = get(hpage,'children');
            copyobj(tmp(end:-1:1),fig)
            close(hpage);
            delete(char(j));
         end% for
         try
            delete(findobj(get(fig,'children'),'UserData',[tab.tag '_warning']));
         end% try
         uicontrol('Parent',fig,'Style','text','Tag',tab.tag,'String', ...
            {'TABPANEL' '!!! CHANGE NOTHING !!!' '' 'usage for editing tabpanel' ...
               '---------------------------------------------------------' ['tabpanel(''' figname ''',''' tag ''')']}, ...
            'Enable','inactive', 'units','pixels','position',tab.pos, ...
            'BackgroundColor',[.2 .2 .2],'foregroundcolor',[1 .25 0], 'Visible','off','FontSize',8,'UserData',[tab.tag '_warning']);
         %
         try
            result = get(handles.(['constructor_' tag])(1),'UserData');
            result.java.closeWindow(0);
         end% try         
         try
            tmp = fieldnames(handles);
            delete(handles.(tmp{strncmp(tmp,'constructor_',12)}))
         end% try
         %
         setappdata(fig,'UsedByGUIData_m',guihandles(fig));
         guidemfile('updateFile',fig, which(figname));
         hgsave(fig, figname);
         %
         %
      case {'CurrForeColor' 'CurrBackColor' 'BackColor' 'ForeColor'}
         tmpcolor = uisetcolor;
         if length(tmpcolor)>1
            tab.(action) = tmpcolor;
         end% if
         %
      case 'height'
         try
            answer = inputdlg({'lateral offset [left right]' 'tab height' 'tab outbreak - as a rule [0...5]'}, ...
               'input...',1,{sprintf('%d  %d',tab.outlet) sprintf('%d',tab.height) sprintf('%d',tab.outbreak)});
            tab.outlet = str2num(char(answer{1}));
            tab.height = str2num(char(answer{2}));
            tab.outbreak = str2num(char(answer{3}));
            sizename = {tab.current tab.height};
         end% try
         %
      case 'size'
         try
            answer = inputdlg({'Tab name' ...
                  sprintf('Length in pixels (%d) or ''auto''',tab.dim(strcmp(tab.names,tab.current)))}, ...
               'input...',1,{tab.current 'auto'});
            tmp = answer{1}(~ismember(answer{1},' .,:;\/+-',''));
            if any(ismember(tab.names(~ismember(tab.names,tab.current)),tmp))
               warndlg({'tabname already exist' 'please, choose another'},'warning','modal')
               uiwait
               tabpanel(figname,tab.tag,'size');
               return
            end% if
            tab.names{find(strcmp(tab.names,tab.current))} = tmp;
            tab.current = tmp;         
            if strcmp('auto',answer{2})
               tab.dim = [];
               for i=tab.names
                  tab.dim = [tab.dim sum((char(i)<90)*1.5+(char(i)>90))+0.5];       
               end% for
            else
               tab.dim(strcmp(tab.names,tab.current)) = str2num(answer{2});
            end% if
         end% try
         %
      case 'font'
         try
            font = uisetfont('choose font');
            set(htabs, ...
               'FontName' ,font.FontName, ...
               'FontUnits',font.FontUnits, ...
               'FontSize' ,font.FontSize, ...
               'FontAngle',font.FontAngle);
         end% try
         %
      case 'info'
         answer = questdlg({'TabPanel Constructor v1.3' ...
               '(c) 2005' '' 'by Elmar Tarajan [MCommander@gmx.de]'}, ...
            'who says that MATLAB does not support Tabpanels? :)', ...
            'look for updates','Bug found?','OK','OK');
         switch answer
            case 'look for updates'
               web('http://www.mathworks.com/matlabcentral/fileexchange/loadAuthor.do?objectId=936824&objectType=author');
            case 'Bug found?'
               web(['mailto:MCommander@gmx.de?subject=TabPanel-BUG:[Description]-[ReproductionSteps]-[Suggestion(if%20possible)]-[MATLAB%20v' strrep(version,' ','%20') ']-[TabPanel%20v1.3]']);
            case 'OK',
         end % switch
         return         
         %
      case 'delete'
         tmp = get(handles.(tab.tag)(end-length(tab.names):end-1),'UserData');
         for i=unique([tmp{:}])
            delete(handles.(char(i)))
         end% for
         delete(handles.(tag)(1:end-1))
         set(handles.(tag)(end),'UserData',[],'visible','on')
         if isfield(handles,['constructor_' tag])
            delete(handles.(['constructor_' tag]))
         end% if
         hgsave(fig, figname);
         return
         %
   end% if
   TPConstructor(fig,figname,tab,handles)
   return       
end% switch
%
%
%
if ~isempty(get(handles.(tag),'Userdata'))
   %
   tab = get(handles.(tag)(end),'UserData');
   if exist('action')
      %
      
      %
      [cancel order] = unique(action);
      action = action(sort(order));
      %
      for i=1:length(action)
         action{i} = action{i}(~ismember(action{i},' .,:;\/<>''~+-_',''));
      end% for
      %
      for i=tab.names(~ismember(tab.names,action))
         for j=fieldnames(handles)'
            if ~isempty(findstr(char(j),['_' char(i) '_']))
               delete(handles.(char(j)))
            end% if
         end% for
      end% for
      %
      delete(handles.(tab.tag)(1:end-1))
      %
      handles = guihandles(fig);
      tmp = fieldnames(handles);
      htmp = [];
      for i=tmp(strncmp([tab.tag '_'],tmp,length(tab.tag)+1))'
         htmp = [htmp handles.(char(i))];
      end% for
      set(htmp,'visible','off')
      t = handle2struct(htmp);
      delete(htmp)
      %
      % 'tab' aktualisieren
      tab.names      = action;
      tab.current = action{1};
      tab.dim = [];
      for i=1:length(tab.names)
         tmp = tab.names{i}(~ismember(tab.names{i},' .,:;\/<>''~+-',''));
         tab.dim = [tab.dim sum((tmp<90)*1.5+(tmp>90))+0.5];
         tab.names{i} = tmp;
      end% for
      TabBuildUp(fig,figname,tab,handles);
      %
      UpdateTabpanel(fig,tab,guihandles(fig));
      %
      struct2handle(t,fig);
      %
      handles = guihandles(fig);
      for i=1:length(t)
         tag = t(i).properties.Tag;
         tmp = tag(1:max(find(tag=='_'))-1);
         tmp = tmp(max(find(tmp=='_'))+1:end);
         %
         h = findobj(handles.(tab.tag)(end-length(tab.names)-1:end-2),'String',tmp);
         %
         tg = get(h,'Userdata');
         set(h,'Userdata',[tg {tag}])
      end% for
      try
         delete(findobj(get(fig,'children'),'UserData',[tab.tag '_warning']));
      end% try
      uicontrol('Parent',fig,'Style','text','Tag',tab.tag,'String', ...
         {'TABPANEL' '!!! CHANGE NOTHING !!!' '' 'usage for editing tabpanel' ...
         '---------------------------------------------------------' ['tabpanel(''' figname ''',''' tab.tag ''')']}, ...
         'Enable','inactive', 'units','pixels','position',tab.pos, ...
         'BackgroundColor',[.2 .2 .2],'foregroundcolor',[1 .25 0], 'Visible','off','FontSize',8,'UserData',[tab.tag '_warning']);

      TPConstructor(fig,figname,tab,handles);
      %
      for i = get(findobj(handles.(tab.tag)(end-length(tab.names)-1:end-2),'String',tab.current),'Userdata')
         set(handles.(char(i)),'visible','on')
      end% for
      return
   end% if
   %
else
   %
   set(findobj(fig,'Tag',tag),'units','pixels')
   %
   %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % TabPanel Constructor wird zum ersten mal gestartet
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %
   % tabpanel settings-struct
   %
   tab.tag           = tag;
   tab.pos           = get(findobj(fig,'Tag',tab.tag),'position');
   try
      [cancel order] = unique(action);
      tab.names      = action(sort(order));
   catch
      errordlg({'tabpanel do not exist yet' 'try again with (e.g.):' '' ...
            ['tabpanel(''' figname ''',''' tab.tag ''',{''Tab1'' ''Tab2'' ''Tab3''})']}, ...
         'Not enough input arguments.','modal')
      return
   end% try
   tab.fontsize      = 8;
   tab.fontname      = 'default';
   tab.current       = tab.names{1};
   tab.outlet        = [1 1];
   tab.height         = 21;
   tab.dim = [];
   for i=1:length(tab.names)
      tmp = tab.names{i}(~ismember(tab.names{i},' .,:;\/<>''~+-_',''));
      tab.dim = [tab.dim sum((tmp<90)*1.5+(tmp>90))+0.5];
      tab.names{i} = tmp;
   end ;
   tab.outbreak      = 3;
   tab.CurrBackColor = get(0,'defaultFigureColor');
   tab.CurrForeColor = get(0,'defaultTextColor');
   tab.BackColor     = tab.CurrBackColor - [0.3 0.3 0.3];
   tab.ForeColor     = tab.CurrForeColor + [0.2 0.2 0.2];
   tab.XCallback     = get(fig,'CloseRequestFcn');   
   tab.Callback      = ...
      ['tpchandles = guihandles(gcbo);' ...
         'tpctab = get(tpchandles.(get(gcbo,''Tag''))(end),''UserData'');' ...
         'tpchtab = findobj(tpchandles.(tpctab.tag)(end-length(tpctab.names)-1:end-2),''String'',tpctab.current);' ...
         'tpcpos = get(tpchtab,''position'');' ...
         'set(tpchtab,''Enable'',''on'',''Fontweight'',''normal'',' ...
         '''position'',[tpcpos(1:3) tpctab.height],' ...
         '''BackGroundColor'',tpctab.BackColor,' ...
         '''ForeGroundColor'',tpctab.ForeColor);' ...
         'tpcpos = get(gcbo,''Position'');' ...
         'set(gcbo,''Enable'',''inactive'',''Fontweight'',''bold'',' ...
         '''Position'',tpcpos+[0 0 0 tpctab.outbreak],' ...
         '''BackGroundColor'',tpctab.CurrBackColor,' ...
         '''ForeGroundColor'',tpctab.CurrForeColor);' ...
         'set(findobj(tpchandles.(tpctab.tag),''String'',''backhide''),''position'',[tpcpos(1:3) + [1 0 -3] 2]);' ...
         'tpcvisoff = [];' ...
         'for tpci=unique(get(tpchtab,''UserData''));' ...
         'tpcvisoff = [tpcvisoff getfield(tpchandles,char(tpci))];' ...
         'end;' ...
         'tpcvison = [];' ...
         'for tpci=unique(get(gcbo,''UserData''));' ...
         'tpcvison = [tpcvison getfield(tpchandles,char(tpci))];' ...
         'end;' ...
         'set(tpcvisoff,''Visible'',''off'');' ...
         'set(tpcvison,''Visible'',''on'');' ...
         'drawnow;' ...
         'tpctab.current = get(gcbo,''String'');' ...
         'set(tpchandles.(tpctab.tag)(end),''UserData'',tpctab);' ...
         'clear tpchandles tpchtab tpci tpcpos tpctab tpcvisoff tpcvison visoff vison'];
   %
   TabBuildUp(fig,figname,tab,handles)
   %
end% if
TPConstructor(fig,figname,tab,handles)
%
%
% Update TabPanel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function UpdateTabpanel(fig,tab,handles)
%-------------------------------------------------------------------------------
%
% axes
tab.dim      = round((tab.pos(3)-tab.outlet(1)-tab.outlet(2))/sum(tab.dim)*tab.dim);
tab.dim(end) = tab.dim(end)-(tab.outlet(1)+sum(tab.dim))+tab.pos(3)-tab.outlet(2);
%
pos = tab.pos-[0 0 0 tab.height+tab.outbreak-3];
set(handles.(tab.tag)(end-1),'position',[pos+[0 1 -1 -2]],'color',tab.CurrBackColor)
%
% background
tmp = find(strcmp(tab.names,tab.current));
tmp1 = [tab.outlet(1) tab.dim];
pos = {[tab.pos(1:2)+[sum(tmp1(1:tmp))+1 tab.pos(4)-tab.height-tab.outbreak] tab.dim(tmp)-3 2];...
      [sum(pos([1 3]))-2 pos(2)+1 1 pos(4)-3];[tab.pos(1:3)+[1 1 -2] 1];[pos(1:2)+[1 1] 1 pos(4)-3]; ...
      [pos(1)+1 sum(pos([2 4]))-3 pos(3)-2 1];[sum(pos([1 3]))-1 pos(2) 1 pos(4)-1]; ...
      [tab.pos(1:3) 1];[pos(1:2) 1 pos(4)-1];[pos(1) sum(pos([2 4]))-2 pos(3) 1]};
clr = {[tab.CurrBackColor];[(tab.CurrBackColor)*.7];[(tab.CurrBackColor)*.7]; ...
      [(tab.CurrBackColor)*.8+[.2 .2 .2]];[(tab.CurrBackColor)*.8+[.2 .2 .2]]; ...
      [(tab.CurrBackColor)*.2];[(tab.CurrBackColor)*.2]; ...
      [(tab.CurrBackColor)*.5+[.5 .5 .5]];[(tab.CurrBackColor)*.5+[.5 .5 .5]]};
set(handles.(tab.tag)(2:end-length(tab.names)-2), ...
    {'Position'},pos, ...
    {'BackgroundColor'},clr, ...
    {'ForegroundColor'},clr)
%
% tabs
pos = [];
for i=1:length(tab.names)
   tmp = tab.outbreak*strcmp(tab.names{i},tab.current);
   tmp1 = [tab.outlet(1) tab.dim];
   pos{i} = [tab.pos(1)+sum(tmp1(1:i)) tab.pos(2)+tab.pos(4)-tab.height-tab.outbreak tab.dim(i) tab.height+tmp];
end% for
set(handles.(tab.tag)(end-length(tab.names)-1:end-2), ...
   'backgroundcolor',tab.BackColor, ...
   'foregroundcolor',tab.ForeColor, ...
   {'position'},pos(end:-1:1)', ...
   {'String'},tab.names(end:-1:1)');
%
% current tab
set(findobj(handles.(tab.tag)(end-length(tab.names)-1:end-2),'String',tab.current), ...
   'BackgroundColor',tab.CurrBackColor, ...
   'ForegroundColor',tab.CurrForeColor, ...
   'FontWeight','bold', ...
   'Enable','inactive');
%
set(handles.(tab.tag)(end),'visible','off','UserData',tab)
%
%
% TabPanel Contructor User Interface
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function TPConstructor(fig,figname,tab,handles)
%-------------------------------------------------------------------------------
%
% delete existing constructors
try
   tmp = fieldnames(handles);
   delete(handles.(tmp{strncmp(tmp,'constructor_',12)}))
end% try
UpdateTabpanel(fig,tab,guihandles(fig));
hgsave(fig,figname)
%
%
% gerechnet von der unteren rechten Ecke des Tabpanels
ypos = -3;
xpos = 2;
% 
% constructor
h(1) = uicontrol('Parent',fig,'Style','edit','Tag',['constructor_' tab.tag], ...
   'BackgroundColor',[1 1 1], 'Visible', 'off', ...
   'units','pixels','position',[sum(tab.pos([1 3]))-139-xpos tab.pos(2)-ypos-1 139 19]);
%
% info
h(2) = uicontrol('Parent',fig,'Style','pushbutton','Tag', ...
   ['constructor_' tab.tag], 'Callback',['tabpanel(get(gcf,''Name''),''' tab.tag ''',''info'')'], ...
   'BackgroundColor',[0 0 0],'ForegroundColor',[1 1 1],'FontWeight','bold','String','i',...
   'ToolTipString','finisches edit mode', 'Visible', 'off', ...
   'units','pixels','position',[sum(tab.pos([1 3]))-17-xpos tab.pos(2)-ypos 15 16]);
%
% setting
hv = get(fig,'HandleVisibility');
set(fig,'HandleVisibility','on')
cmenu = uicontextmenu('Tag',['constructor_' tab.tag]);
set(fig,'HandleVisibility',hv);
h(3) = uicontrol('Parent',fig,'Style','pushbutton','Tag',['constructor_' tab.tag], 'Enable','inactive', ...
   'Callback','tabpanel(get(gcf,''Name''),''color'')', 'Visible', 'off', ...
   'BackgroundColor',[1 1 0.85],'ForegroundColor',[0.25 0.25 0.25],'String','settings',...
   'ToolTipString','use right mouse button to change colors','uicontextmenu', cmenu, ...   
   'units','pixels','position',[sum(tab.pos([1 3]))-61-xpos tab.pos(2)-ypos 44 16]);
uimenu(cmenu,'Label','current tabname', 'Callback', ['tabpanel(get(gcf,''Name''),''' tab.tag ''',''size'')']);
uimenu(cmenu,'Label','font options', 'Callback', ['tabpanel(get(gcf,''Name''),''' tab.tag ''',''font'')']);
uimenu(cmenu,'Label','general settings', 'Callback', ['tabpanel(get(gcf,''Name''),''' tab.tag ''',''height'')']);
uimenu(cmenu,'Label','backgroundcolor for current panel', 'Callback', ['tabpanel(get(gcf,''Name''),''' tab.tag ''',''CurrBackColor'')'],'separator','on');
uimenu(cmenu,'Label','font color for current panel', 'Callback', ['tabpanel(get(gcf,''Name''),''' tab.tag ''',''CurrForeColor'')']);
uimenu(cmenu,'Label','backgroundcolor for other tabpanel', 'Callback', ['tabpanel(get(gcf,''Name''),''' tab.tag ''',''BackColor'')']);
uimenu(cmenu,'Label','font color for other tabpanels', 'Callback', ['tabpanel(get(gcf,''Name''),''' tab.tag ''',''ForeColor'')']);
%
% update
h(4) = uicontrol('Parent',fig,'Style','pushbutton','Tag',['constructor_' tab.tag], ...
   'Callback',['tabpanel(get(gcf,''Name''),''' tab.tag ''',''update'')'], 'Visible', 'off', ...
   'BackgroundColor',[1 0.85 0.85],'ForegroundColor',[0.25 0.25 0.25],'String','update',...
   'ToolTipString','update changed tabpanel', ...   
   'units','pixels','position',[sum(tab.pos([1 3]))-104-xpos tab.pos(2)-ypos 43 16]);
%
% edit
h(5) = uicontrol('Parent',fig,'Style','pushbutton','Tag',['constructor_' tab.tag], ...
   'Callback',['tabpanel(get(gcf,''Name''),''' tab.tag ''',''edit'')'], 'Visible', 'off', ...
   'BackgroundColor',[0.8 1 0.8],'ForegroundColor',[0.25 0.25 0.25],'String','edit',...
   'ToolTipString','open guide to edit tabpanel', ...   
   'units','pixels','position',[sum(tab.pos([1 3]))-137-xpos tab.pos(2)-ypos 33 16]);
set(h,'Visible','on')
drawnow
%
%
%
% Aufbau der Grundelemente
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function TabBuildUp(fig,figname,tab,handles)
%-------------------------------------------------------------------------------%
h = [];
%
% axes background
pos = tab.pos-[0 0 0 tab.height+tab.outbreak-3];
h{end+1} = axes('parent',fig,'units','pixels','position',pos+[0 1 -1 -2],'HandleVisibility','off', ...
   'Tag',tab.tag,'Box','on','color',tab.CurrBackColor, ...
   'XTickLabel',[],'YTickLabel',[],'XTick',[],'YTick',[]);
%
% handle-Vektor
for i=1:length(tab.names)
   h{end+1} = uicontrol('Parent',fig, ...
      'Style','pushbutton', ...
      'Tag',tab.tag,'String',tab.names{i}, ...
      'Callback',tab.Callback);
end% if
%
% background
for i={'ah' 'ah' 'ad' 'ad' 'ih' 'ih' 'id' 'id' 'hide'}
   h{end+1} = uicontrol('Parent',fig, ...
      'Style','text', ...
      'Tag',tab.tag, ...
      'String',['back' char(i)], ...
      'Enable','inactive', ...
      'units','pixels');
end% for
%
% warnung
h{end+1} = uicontrol('Parent',fig,'Style','text','Tag',tab.tag,'String', ...
   {'TABPANEL' '!!! CHANGE NOTHING !!!' '' 'usage for editing tabpanel' ...
   '---------------------------------------------------------' ...
   ['tabpanel(''' figname ''',''' tab.tag ''')']}, ...
   'Enable','inactive', 'units','pixels','position',get(handles.(tab.tag)(end),'Position'), ...
   'BackgroundColor',[.2 .2 .2],'foregroundcolor',[1 .25 0],'Visible','off','FontSize',8,'UserData',[tab.tag '_warning']);
%