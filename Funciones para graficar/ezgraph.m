function []=ezgraph(varargin)
%EZGRAPH Use to help format a plot with most of the basic tools.
% Call as you would 'plot', with the exception that NO formatting calls are
% permitted; all formatting will be done in the GUI. 
% For example:      >>x=[1:10];  y=x.^2;  z=x.^2.1;  v=[1:.1:10]; w=v.^2.2;
%                   >>ezgraph(x,y,x,z,v,w)
% where x,y,z,w,v are all data sets.  Note that as with 'plot', the length
% of the paired vectors must be equal (length(x)==length(y)).
%
% When all formatting is completed, click on the 'Create Figure' button to
% create a resizeable figure for further manipulations.  More than one
% figure can be created by clicking the 'Create Figure' button repeatedly.
% There are three help buttons, marked with a question mark, that give more
% instructions for specific figures. Tested with version 6.5 and 7.0.1
% The user may NOT place annotations (arrows, etc.) in the axes until the  
% formatting is completed and a new figure is created.
% Author:    Matt Fig 
% Contact:   popkenai@yahoo.com
% Date:      12-05

if nargin==0,  error('        Nothing to plot'),  end   % Self explanitory.

% Create a custom color list for use in the plot.
clrs = [0 0 1; 0 .5 0; 1 0 0; 0 .75 .75; .75 0 .75; .75 .75 0;...
        1 1 0; .25 .25 .25; .5 .5 .5; .45 .35 0; 1 .65 .35];       
% Create figure and axes.
h_fig = figure('units','pixels','position',[30 30 580 785],...
               'menubar','none','name','EZ-graph','resize','off');
ax = axes('units','pixels','position',[150 455 410 300],'nextplot',...
          'add');
% Check the inputs.      
if nargin==1                               % Here the user passed a matrix.
   lines = plot(varargin{1});
elseif any(cellfun('isclass',varargin,'char'))    % Formatting not allowed.
    delete(h_fig)
    error(' Formatting not allowed')
elseif rem(nargin,2)==0              % Here the user passed data set pairs.
    lines = plot(varargin{1},varargin{2});          % Plot first data pair.
    for jj=2:nargin/2                              % Plot rest of the data.
        lines(jj) = plot(varargin{2*jj-1},varargin{2*jj},'color',...
                         clrs(mod(jj-1,11)+1,:));  
    end
else
    delete(h_fig)
    error('Unmatched data set, or unknown error.')
end

set(ax,'userdata',lines(1)); % Used to store and retrieve info about lines.
% Next create uicontrol elements.
%---------------------------Y-axis editors.--------------------------------
frm1 = uicontrol(h_fig,'style','frame','position',[10 445 80 325]);
txt1 = uicontrol(h_fig,'style','text','position',[15 760 55 15],...
                 'string','y-axis','fontweight','bold',...
                 'backgroundcolor',[.988 .804 .988]);
edt1 = uicontrol(h_fig,'style','edit','position',[15 735  70  20],...
                 'string','y-max','backgroundcolor','w',...
                 'tooltipstring','y-max'); 
chk1 = uicontrol(h_fig,'style','checkbox','position',[15 645  60  20],...
                 'string','Log','callback',{@log_c,ax,'yscale'});             
edt2 = uicontrol(h_fig,'style','edit','position',[15 615  70  20],...
                 'string','y-step','backgroundcolor','w','callback',...
                 {@step_c,ax,'ylim','ytick'},'tooltipstring','y-step');             
chk2 = uicontrol(h_fig,'style','checkbox','position',[15 585  60  20],...
                 'string','Bold','callback',{@xybold_c,ax});             
pop1 = uicontrol(h_fig,'style','popupmenu','position',[15 550 65 20],...
                 'string','Fontsize|8|10|12','callback',...
                 {@xyfont_c,ax});             
edt3 = uicontrol(h_fig,'style','edit','position',[15 455  70  20],...
                 'string','y-min','backgroundcolor','w','callback',... 
                 {@min_c,ax,edt2,'ylim','ytick'},'tooltipstring','y-min');
set(edt1,'callback',{@max_c,ax,edt2,'ylim','ytick'});
%---------------------------X-axis editors.--------------------------------
frm2 = uicontrol(h_fig,'style','frame','position',[85 370 490 35]);
txt2 = uicontrol(h_fig,'style','text','position',[90 395 55 15],...
                 'string','x-axis','fontweight','bold',...
                 'backgroundcolor',[.988 .804 .988]);
edt4 = uicontrol(h_fig,'style','edit','position',[150 377 70 20],...
                 'string','x-min','backgroundcolor','w','tooltipstring',...
                 'x-min');
chk3 = uicontrol(h_fig,'style','checkbox','position',[265 377 53 20],...
                 'string','Log','callback',{@log_c,ax,'xscale'});             
edt5 = uicontrol(h_fig,'style','edit','position',[355 377 70 20],...
                 'string','x-step','backgroundcolor','w','callback',...
                 {@step_c,ax,'xlim','xtick'},'tooltipstring','x-step');             
edt6 = uicontrol(h_fig,'style','edit','position',[480 377 70 20],...
                 'string','x-max','backgroundcolor','w','callback',...
                 {@max_c,ax,edt5,'xlim','xtick'},'tooltipstring','x-max'); 
set(edt4,'callback',{@min_c,ax,edt5,'xlim','xtick'});
%---------------------------Title and label editors.-----------------------
frm3 = uicontrol(h_fig,'style','frame','position',[15 240 550 120]);
txt3 = uicontrol(h_fig,'style','text','position',[20 350 105 15],...
                 'string',' Titles and Labels ','fontweight','bold',...
                 'backgroundcolor',[.988 .804 .988]);
txt4 = uicontrol(h_fig,'style','text','position',[45 317 55 20],...
                 'string','    Title:','fontweight','bold'); 
txt5 = uicontrol(h_fig,'style','text','position',[45 287 55 20],...
                 'string','x-label:','fontweight','bold'); 
txt6 = uicontrol(h_fig,'style','text','position',[45 257 55 20],...
                 'string','y-label:','fontweight','bold');             
edt7 = uicontrol(h_fig,'style','edit','position',[105 320 310 20],...
                 'string','Enter Title','backgroundcolor','w',...
                 'callback',{@label_c,ax,'title'});
chk4 = uicontrol(h_fig,'style','checkbox','position',[425 320 50 20],...
                 'string','Bold','callback',{@bold_c,ax,'title'});
pop2 = uicontrol(h_fig,'style','popupmenu','position',[485 320 70 20],...
                 'string','Fontsize|8|10|12|14|16','callback',...
                 {@font_c,ax,'title'});              
edt8 = uicontrol(h_fig,'style','edit','position',[105  290 310  20],...
                 'string','Enter x-axis label','backgroundcolor','w',...
                 'callback',{@label_c,ax,'xlabel'});
chk5 = uicontrol(h_fig,'style','checkbox','position',[425 290 50 20],...
                 'string','Bold','callback',{@bold_c,ax,'xlabel'} );
pop3 = uicontrol(h_fig,'style','popupmenu','position',[485 290 70 20],...
                 'string','Fontsize|8|10|12|14|16','callback',...
                 {@font_c,ax,'xlabel'});              
edt9 = uicontrol(h_fig,'style','edit','position',[105 260 310 20],...
                 'string','Enter y-axis label','backgroundcolor','w',...
                 'callback',{@label_c,ax,'ylabel'});
chk6 = uicontrol(h_fig,'style','checkbox','position',[425 260 50 20],...
                 'string','Bold','callback',{@bold_c,ax,'ylabel'} ); 
pop4 = uicontrol(h_fig,'style','popupmenu','position',[485 260 70 20],...
                 'string','Fontsize|8|10|12|14|16','callback',...
                 {@font_c,ax,'ylabel'}); 
%---------------------------Line editors.----------------------------------
frm4 = uicontrol(h_fig,'style','frame','position',[35 80 150 150]);
txt7 = uicontrol(h_fig,'style','text','position',[40 220 95 15],...
                 'string',' Line Properties ','fontweight','bold',...
                 'backgroundcolor',[.988 .804 .988]);
psh1 = uicontrol(h_fig,'style','pushbutton','position',[165 210 15 15],...
                 'string','?','fontweight','bold',...
                 'backgroundcolor',[.75 .75 .75],'callback',{@hlp,1});             
chk7 = uicontrol(h_fig,'style','checkbox','position',[65 195  75  15],...
                 'string','Line On','value',1);             
pop5 = uicontrol(h_fig,'style','popupmenu','position',[65 160 90 20],...
                 'string',['Line Color|blue|green|red|cyan|magenta|'...
                 'pea soup|black|mid-grey|brown|orange|yellow'],...
                 'callback',{@lnclr,ax});
pop6 = uicontrol(h_fig,'style','popupmenu','position',[65 130 90 20],...
                 'string','Line Width|0.5|2|3|4','callback',{@lnwdth,ax});              
pop7 = uicontrol(h_fig,'style','popupmenu','position',[65 100 90 20],...
                 'string','Line Style|solid|dotted|dashdot|dashed',...
                 'callback',{@lnstl,ax});
%---------------------------Data Marker editors.---------------------------
frm5 = uicontrol(h_fig,'style','frame','position',[195  80 150 150]);
txt9 = uicontrol(h_fig,'style','text','position',[200 220 110 15],...
                 'string',' Marker Properties ','fontweight','bold',...
                 'backgroundcolor',[.988 .804 .988]);
psh2 = uicontrol(h_fig,'style','pushbutton','position',[325 210 15 15],...
                 'string','?','fontweight','bold',...
                 'backgroundcolor',[.75 .75 .75],'callback',{@hlp,1});             
pop8 = uicontrol(h_fig,'style','popupmenu','position',[225 190 90 20],...
                 'string',['Data Marker|none|point|circle|x-mark|plus|'...
                 'star|square|diamond|triangle (down)|triangle (up)|',...
                 'triangle (left)|triangle (right)|',...
                 'pentagram|hexagram']);
pop9 = uicontrol(h_fig,'style','popupmenu','position',[225 160 90 20],...
                 'string','Marker Size|4|5|6|9|12','callback',...
                 {@mrkrsz,ax});
pop10 = uicontrol(h_fig,'style','popupmenu','position',[225 130 90 20],...
                  'string',['Edge Color|blue|green|red|cyan|magenta|'...
                  'pea soup|black|mid-grey|brown|orange|yellow|white'],...
                  'callback',{@edgclr,ax});              
pop11 = uicontrol(h_fig,'style','popupmenu','position',[225 100 90 20],...
                  'string',['Face Color|blue|green|red|cyan|magenta|'...
                  'pea soup|black|mid-grey|brown|orange|yellow|white'],...
                  'callback',{@fc_clr,ax});
set(pop8,'callback',{@dtmrk,ax,chk7,pop5,pop6,pop7,pop8,pop9,pop10,pop11});              
set(chk7,'callback',{@lnon_c,ax,pop5,pop6,pop7,pop8,pop9,pop10,pop11})
set(lines(:),'buttondownfcn',{@st_usrdta,ax,chk7,pop5,pop6,pop7,pop8,...
                              pop9,pop10,pop11});
%---------------------------Box and Grid editors.--------------------------
frm6 = uicontrol(h_fig,'style','frame','position',[360 90 180 130]);
txt10 = uicontrol(h_fig,'style','text','position',[365 210 80 15],...
                 'string',' Box and Grid ','fontweight','bold',...
                 'backgroundcolor',[.988 .804 .988]);
chk8 = uicontrol(h_fig,'style','checkbox','position',[425 185 75 15],...
                 'string','Box On','callback',{@bxon,ax});             
chk9 = uicontrol(h_fig,'style','checkbox','position',[390 150 75 15],...
                 'string','x-Grid','callback',{@grd,ax,'xgrid'});
chk10 = uicontrol(h_fig,'style','checkbox','position',[470 150 60 15],...
                 'string','y-Grid','callback',{@grd,ax,'ygrid'});             
pop12 = uicontrol(h_fig,'style','popupmenu','position',[410 110 80 20],...
                 'string','Grid Style|solid|dotted|dashdot|dashed',...
                 'callback',{@grdstl,ax});            
%---------------------------Legend editors.--------------------------------
frm7 = uicontrol(h_fig,'style','frame','position',[35 10 350 60]);
txt11 = uicontrol(h_fig,'style','text','position',[40 60 90 15],...
                 'string',' Legend Maker ','fontweight','bold',...
                 'backgroundcolor',[.988 .804 .988]);
psh3 = uicontrol(h_fig,'style','pushbutton','position',[365 50 15 15],...
                 'string','?','fontweight','bold',...
                 'backgroundcolor',[.75 .75 .75],'callback',{@hlp,2});             
chk11 = uicontrol(h_fig,'style','checkbox','position',[55 33 60 15],...
                 'string','Visible','value',1);             
edt10 = uicontrol(h_fig,'style','edit','position',[120 30 225 20],...
                 'string',['Enter Label for current selection.'],...
                 'backgroundcolor','w','callback',...
                 {@lgstr,ax,lines});
set(chk11,'callback',{@lgshow,ax,edt10})
%---------------------------Create Figure button.--------------------------
psh4 = uicontrol(h_fig,'style','pushbutton','position',[445 20 90 45],...
                 'string','Create Figure','fontweight','bold',...
                 'callback',{@mkfig,ax,lines});
             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% These are callbacks that aren't matched to a particular block in GUI.
function [] = st_usrdta(hand,eventdata,ax,chk7,pop5,pop6,pop7,pop8,...
                        pop9,pop10,pop11)
% Callback for the user clicking on the lines in the plot.
% These will set all the values in the 'Line Properties' and 'Marker
% Properties' blocks to match that of the currently selected line. 
set(ax,'userdata',gco);       % Store the selected line in axes 'userdata'.
lnst = get(gco,'linestyle');
if strcmp(lnst,'none')
    set(chk7,'value',0);      
    set([pop5,pop6,pop7],'enable','off');    % No line=>no line color, etc.
else
    set(chk7,'value',1);
    set([pop5,pop6,pop7],'enable','on'); 
end
% Next set color popup to correct value.
clr = get(gco,'color');            
clr = deblank(colorslct(clr));                                % Get string.
clrlst = get(pop5,'string');
vlu = strmatch(clr,clrlst);                 % Find which color the line is.  
set(pop5,'value',vlu);
% Next set width popup to correct value.
wdth = get(gco,'linewidth');       
wdthlst = get(pop6,'string');
vlu = strmatch(num2str(wdth),wdthlst);      % Find which width the line is.
set(pop6,'value',vlu);
% Next set linestyle popup to correct value.
lnstl = get(gco,'linestyle');  
if strcmp(lnstl,'-')
    vlu = 2;
elseif strcmp(lnstl,':')
    vlu = 3;
elseif strcmp(lnstl,'-.')
    vlu = 4;
elseif strcmp(lnstl,'--')
    vlu = 5;
end
set(pop7,'value',vlu);
% Next set datamarker popup to correct value.
dtmrk = get(gco,'marker');    
if length(dtmrk)<3
dtmrk = mrkrslct(dtmrk);                                      % Get string.
end
dtmlst = get(pop8,'string');
vlu = strmatch(dtmrk,dtmlst);
if vlu==2
    set([pop9,pop10,pop11],'enable','off');
else
    set([pop9,pop10,pop11],'enable','on');
end
set(pop8,'value',vlu);
% Next set markersize popup to correct value.
mrksz = get(gco,'markersize');
mrkszlst = get(pop9,'string');
vlu = strmatch(num2str(mrksz),mrkszlst);
set(pop9,'value',vlu);
% Next set markeredgecolor to value.
mrkec = get(gco,'markeredgecolor');    
if ~strcmp(mrkec,'auto')
mrkec = deblank(colorslct(mrkec));                            % Get string.
mrkeclst = get(pop10,'string');
vlu = strmatch(mrkec,mrkeclst);   % Find which one it is from string array.
set(pop10,'value',vlu(1));
else
set(pop10,'value',1);
end
% Next set markerfacecolor to value.
mrkfc = get(gco,'markerfacecolor');    
if ~strcmp(mrkfc,'none');    
mrkfc = deblank(colorslct(mrkfc));                            % Get string.
mrkfclst = get(pop11,'string');
vlu = strmatch(mrkfc,mrkfclst);
set(pop11,'value',vlu(1));
else
set(pop11,'value',1);
end

function anss = colorslct(clr)
% Converts a string color input to an rgb vect and an rgb vect to a string.
lst_ch1 = strvcat('blue','green','red','cyan','magenta','pea soup',...
                  'yellow','black','mid-grey','brown','orange','white');
lst_n = [0 0 1; 0 .5 0; 1 0 0; 0 .75 .75; .75 0 .75; .75 .75 0;...
         1 1 0; .25 .25 .25; .5 .5 .5; .45 .35 0; 1 .65 .35;1 1 1];             
if ischar(clr)                     % Here a string from lst_ch1 was passed.
   clr = deblank(clr);
   idx = strmatch(clr,lst_ch1);    
   anss = lst_n(idx,:);     
else                          % Here an RGB vector from lst_ch1 was passed.
   idx = find(lst_n(:,1)==clr(1) & lst_n(:,2)==clr(2) & lst_n(:,3)==clr(3));
   anss = lst_ch1(idx,:); 
end

function stl = mrkrslct(dtmrkstr)
% Converts strings to marker symbols and marker symbols to strings.
mrklst1 = strvcat('none','point','circle','x-mark','plus','star',...
                 'square','diamond','triangle (down)','triangle (up)',...
                 'triangle (left)','triangle (right)','pentagram',...
                 'hexagram');
mrklst2 = strvcat('none','.','o','x','+','*','s','d','v','^','<','>',...
                  'p','h');                
dtmrkstr = deblank(dtmrkstr);
if length(dtmrkstr)>2                    % Here the symbol name was passed.
   idx = strmatch(dtmrkstr,mrklst1);
   stl = mrklst2(idx,:);                                    
else                                   % Here the marker symbol was passed.
    idx = strmatch(dtmrkstr,mrklst2);
    stl = mrklst1(idx,:);  
end

function [] = hlp(hand,eventdata,num)
% Callback for help buttons.  Issues a modal messagebox.
if num==1  % User wants help from the Line Block.
str = ['To set Line and Marker Properties: First select a line or data',...
       ' point, then set the properties you wish for that set of data.'];
else  % User wants help from the Legend Block.
str = ['Enter the label you wish for the currently selected line or ',...
       'set of data points.  The labels can be changed after you assign'...
       ' them by reselecting the line and entering a new label.  When ',...
       'the new figure is created, you can move the legend by clicking',...
       ' on it and dragging.'];    
end
uiwait(msgbox(str,'ezgraph help','modal'));

%----------------------------Callbacks for x&y-axis blocks.----------------
function [] = max_c(hand,eventdata,ax,edt,str1,str2)
% Callback for x&y-max edit, sets the y-max value for plot, if legal.
old = get(ax,str1);
new = str2num(get(hand,'string'));
if length(new)==1  & old(1)<new         % Excludes strings and ymax < ymin.
   set(ax,str1,[old(1) new]);
end
step_c(edt,eventdata,ax,str1,str2)

function [] = log_c(hand,eventdata,ax,str)
% Callback for x&y-axis scale checkbox. Toggles between lin and log scales.
onoff = get(hand,'value');
if onoff==1
    set(ax,str,'log');
else
    set(ax,str,'linear');
end

function [] = step_c(hand,eventdata,ax,str1,str2)
% Callback for x&y-step edit.  Sets the increment for the y-axis.
step = str2num(get(hand,'string'));
ylim = get(ax,str1);
if length(step)==1               % Excludes user trying a character string.
   set(ax,str2,[ylim(1):step:ylim(2)]);
end

function [] = xybold_c(hand,eventdata,ax)
% Callback for bold checkbox.  Sets both axes to bold or normal.  
onoff = get(hand,'value');
if onoff==1
    set(ax,'fontweight','bold');
else
    set(ax,'fontweight','normal');
end

function [] = xyfont_c(hand,eventdata,ax)
% Callback for x&y-font popup.  Lets the user choose a font for both axes.
str = get(hand,'string');
siz = str(get(hand,'value'),:);
if ~strcmp(siz,'Fontsize')
    set(ax,'fontsize',str2num(siz));
end

function [] = min_c(hand,eventdata,ax,edt,str1,str2)
% Callback for x&y-min edit, sets the x&y-min value for plot, if legal.
old = get(ax,str1);
new = str2num(get(hand,'string')); 
if length(new)==1  & old(2)>new       % Excludes strings and y-min > y-max.
   set(ax,str1,[new old(2)]);
end
step_c(edt,eventdata,ax,str1,str2)

%-----------------Callbacks for Titles and Labels block.-------------------
function [] = label_c(hand,eventdata,ax,str)
% Callback for title edit box.
titl = get(hand,'string');
oldtitle = get(ax,str);
set(oldtitle,'string',titl)

function [] = bold_c(hand,eventdata,ax,str)
% Callback for title bold checkbox. Toggles between bold and normal font.
onoff = get(hand,'value');
titl = get(ax,str);
if onoff==1
    set(titl,'fontweight','bold');
else
    set(titl,'fontweight','normal');
end

function [] = font_c(hand,eventdata,ax,str)
% Callback for title font popup.  Sets the fontsize for the Title.
str2 = get(hand,'string');
siz = str2(get(hand,'value'),:);
titl=get(ax,str);
if ~strcmp(siz,'Fontsize')
    set(titl,'fontsize',str2num(siz));
end

%-------------------Callbacks for Line Properties block.-------------------
function [] = lnon_c(hand,eventdata,ax,pop5,pop6,pop7,pop8,pop9,pop10,pop11)
% Callback for Line On checkbox.
onoff = get(hand,'value');
ln = get(ax,'userdata');
if onoff==1       % If line gets turned on, set all popups to correct vals.
    set(ln,'linestyle','-');
    set([pop5,pop6,pop7],'enable','on');
else
    set(ln,'linestyle','none');
    if strcmp(get(ln,'Marker'),'none')   % Prevents data from disappearing.
        set(ln,'marker','o');    % If user turns off a line with no marker.
        set([pop8,pop9],'value',4);   % Set default marker size and symbol.  
        set([pop10,pop11],'value',1);
    end
    set([pop5,pop6,pop7],'enable','off');
    set([pop9,pop10,pop11],'enable','on');        % Turn on Marker options.
end

function [] = lnclr(hand,eventdata,ax)
% Callback for Line Color popup.  Allows user to select a color for line.
ln = get(ax,'userdata');                                % Get current line.
str = get(hand,'string');                               % Get users choice.
num = get(hand,'value');
val = str(num,:);
if strcmp(val,'Line Color')     % User selects the popup label.  No action.
    return
end
clr = colorslct(val);                                     % Get RGB vector.
set(ln,'color',clr)

function [] = lnwdth(hand,eventdata,ax)
% Callback for Line Width popup.  Allows user to chose line's width.
ln = get(ax,'userdata');                                % Get current line.
str = get(hand,'string');                               % Get users choice.
num = get(hand,'value');
val = str(num,:);
if strcmp(val,'Line Width')     % User selects the popup label.  No action.
    return
end
set(ln,'linewidth',str2num(val))            

function [] = lnstl(hand,eventdata,ax)
% Callback for Line Style popup.  Lets user choose style of line to use.
ln = get(ax,'userdata');                                % Get current line.
str = get(hand,'string');                               % Get users choice.
num = get(hand,'value');
val = str(num,:);
if strcmp(val,'Line Style')     % User selects the popup label.  No action.
    return
end
if strfind(val,'solid')                   % Find out which style is picked.
    stl='-';
elseif strfind(val,'dotted')
    stl=':';
elseif strfind(val,'dashdot')
    stl='-.';
elseif strfind(val,'dashed')
    stl='--';  
end 
set(ln,'linestyle',stl)

%-------------------Callbacks for Marker Properties block.-----------------
function [] = dtmrk(hand,eventdata,ax,chk7,pop5,pop6,pop7,pop8,pop9,...
                    pop10,pop11)
% Callback for Data Marker popup.  Lets user choose which marker to use.
ln = get(ax,'userdata');                                % Get current line.
str = get(hand,'string');                               % Get users choice.
num = get(hand,'value');
dtmrkstr = deblank(str(num,:));
if strcmp(dtmrkstr,'Data Marker')   % User selects the popup label. A nono.
    return
end
stl = mrkrslct(dtmrkstr);             % Call to decide which symbol to use.
if strcmp(stl,'none') % If no symbol, turn on line so data isn't invisible.
    if get(chk7,'value')==0
       set(chk7,'value',1)
       lnon_c(chk7,1,ax,pop5,pop6,pop7,pop8,pop9,pop10,pop11);             
    end 
    set([pop9,pop10,pop11],'enable','off');      % Turn off marker choices.
else    
    set([pop9,pop10,pop11],'enable','on');        % Turn on marker choices.
end
set(ln,'marker',stl)

function [] = mrkrsz(hand,eventdata,ax)
% Callback for Marker Size popup.  Lets user choose size of marker. 
ln = get(ax,'userdata');                                % Get current line.
str = get(hand,'string');                               % Get users choice.
num = get(hand,'value');
val = str(num,:);
if strcmp(val,'Marker Size')    % User selects the popup label.  No action.
    return
end
set(ln,'markersize',str2num(val))

function [] = edgclr(hand,eventdata,ax)
% Callback for Marker EdgeColor popup.  Lets user select color for M. edge.
ln = get(ax,'userdata');                                % Get current line.
str = get(hand,'string');                               % Get users choice.
num = get(hand,'value');
val = str(num,:);
if strcmp(val,'Edge Color')     % User selects the popup label.  No action.
    return
end
clr = colorslct(val);
set(ln,'markeredgecolor',clr)

function [] = fc_clr(hand,eventdata,ax)
% Callback for Marker Facecolor popup.  Lets user select color for M. face. 
ln = get(ax,'userdata');                                % Get current line.
str = get(hand,'string');                               % Get users choice.
num = get(hand,'value');
val = str(num,:);
if strcmp(val,'Face Color')     % User selects the popup label.  No action.
    return
end
clr = colorslct(val);
set(ln,'markerfacecolor',clr)

%----------------------Callbacks for Box and Grid block.-------------------
function [] = bxon(hand,eventdata,ax)
% Callback for axes box checkbox.  Toggles between box on and box off.
onoff = get(hand,'value');
if onoff==1
    set(ax,'box','on');
else
    set(ax,'box','off');
end

function [] = grd(hand,eventdata,ax,str)
% Callback for both x and y-axis grid lines checkboxes.
onoff = get(hand,'value');
if onoff==1
   set(ax,str,'on');
else
   set(ax,str,'off');
end

function [] = grdstl(hand,eventdata,ax)
% Callback for Axes Grid Style popup. Lets user choose style of grid lines.
str = get(hand,'string');                               % Get users choice.
num = get(hand,'value');
val = str(num,:);
if strcmp(val,'Grid Style')     % User selects the popup label.  No action.
    return
end
if strfind(val,'solid')
    stl='-';
elseif strfind(val,'dotted')
    stl=':';
elseif strfind(val,'dashdot')
    stl='-.';
elseif strfind(val,'dashed')
    stl='--';  
end 
set(ax,'gridlinestyle',stl)

%-----------------------------Callback for Legend Block--------------------
function [] = lgshow(hand,eventdata,ax,edt10)
% Callback for Legend Visible checkbox.  Toggles between invisible or not.
onoff = get(hand,'value');                              % Get users choice.
lg = findobj(get(ax,'parent'),'tag','legend');
if onoff==1
    set(edt10,'enable','on');
    if ~isempty(lg), legend(ax,'show'), end        % Set legend to visible.
else
    set(edt10,'enable','off');
    if ~isempty(lg), legend(ax,'hide'), end      % Set legend to invisible.
end

function [] = lgstr(hand,eventdata,ax,lines)
% Callback for Legend edit Box.  Displays a legend when user enters label.
str = get(hand,'string');                               % Get string label.
ln = get(ax,'userdata');
set(ln,'tag',str);              % Store each lines label in 'tag' property.
for ii = 1:length(lines)           % Get all the labels that are available.
    list{ii}= get(lines(ii),'tag');
end
lg = legend(char(list),0);

%-----------------------------Callback for Create Figure Pushbutton.-------
function [] = mkfig(hand,eventdata,ax,lines)
% Callback for Create Figure pushbutton.  Creates the plot user created.
lg = findobj(get(ax,'parent'),'tag','legend');       % Find legend to plot.
ax2 = rezize(ax);
pos=get(ax2,'position'); % This is necessary in 7.01?   
if ~isempty(lg)
    for ii = 1:length(lines)
    list{ii}= get(lines(ii),'tag');
    end
    lg = legend(char(list),0);
end
set(ax2,'position',pos)      % Set axes to prior position.  See 7 lines up.

function ax2 = rezize(ax1)
% Makes a new figure and makes sure that the axes and labels fit inside it.
y1 = get(ax1,'ylabel');     % Handles to the text objects in original plot.
x1 = get(ax1,'xlabel');
t1 = get(ax1,'title');
set([ax1,y1,x1,t1],'units','pixels');                % Use units of pixels.
y1ex = get(y1,'extent');               % Get the extent of all text fields.
x1ex = get(x1,'extent');
t1ex = get(t1,'extent');
buffer = 20;                % This is how many pixels the border will have.
f2 = figure('units','pixels');                       % Make another figure.
f2pos = get(f2,'position');
ax2 = copyobj(ax1,f2);                     % Recreate axes into new figure.
ax2pos = get(ax2,'position');
f2usex =f2pos(3)-2*buffer;    % These will be the 'useable' area of figure.
f2usey = f2pos(4)-2*buffer;
% Now put the axes in the correct place within new figure.
set(ax2,'position',[buffer+abs(y1ex(1))   buffer+abs(x1ex(2)) ,...
                   f2usex-abs(y1ex(1)),...
                   f2usey-abs(x1ex(2))-t1ex(4)+t1ex(2)-ax2pos(4)]);
y2 = get(ax2,'ylabel');      % Set these to normalized for resizing figure.
x2 = get(ax2,'xlabel');
t2 = get(ax2,'title');
set([ax1,ax2,y2,x2,t2],'units','normalized')