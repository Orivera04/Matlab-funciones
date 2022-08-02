function renamefiles

% A gui utility to rename file(s) in a directory. This gui contains
% two list box:
% on the lefthand side is the contents of the current directory,
% on the righthand side are the files selected for renaming
% a button '>' is used to select the files
% a button 'Rename' start the actual renaming process
% a button 'dir' to select the work directory
% a thick box to specify wether to rename read only files or not
%
% the user, in order to rename files, must
% 1) select the working directory with the button 'dir'
% 2) select the file(s) on the righthand side window with mouse and 'ctrl'
%    to make multiple selaction of non-adiacent files
% 3) press the putton '>' to select the files and choose the new name:
%    the character that cannot be changed in multiple selection are
%    represented by '?' (question marks), the remaining character can be
%    changed or removed; characters can be also added, thus the resulting
%    filename(s) will become longer.
% 4) press the button 'Rename' to start the renaming. A progress bar shows
%    the progress of the operation.
%
%    Version 2
%    Is now possible to change the extention in multiple selections:
%    At the point 3) write the new name starting with a dot.
%    The first three characters after the dot will be used as the new
%    extention. Otherwise, no matter the number of selected files, using
%    the expresssion *.ext1 *.ext2
%
% Author: Stefano Gianoli
% Inst.f.Chemie-/Bioingenieurwissenschaft.
% Safety and Environmental technology group
% ETH Hönggerberg, HCI G 143
% email: stefano.gianoli@chem.ethz.ch
% date of last update: 10.August.2005



f = figure('MenuBar','none',...
    'Name','Rename file(s)',...
    'NumberTitle','off',...
    'ResizeFcn', @figure_ResizeFcn,...
    'Units','characters',...
    'CreateFcn', @figure_CreateFcn,...
    'HandleVisibility','callback');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function figure_CreateFcn(obj,eventdata)

listBox1 = uicontrol(obj,'Tag','dir_list1',...
    'Style','listbox',...
    'Units','characters',...
    'BackgroundColor','white',...
    'Max',10,'Min',1);

listBox2 = uicontrol(obj,'Tag','dir_list2',...
    'Style','listbox',...
    'Units','characters',...
    'BackgroundColor','white',...
    'Max',10,'Min',1);

renameBtn = uicontrol(obj,'Tag','renamebtn',...
    'Style','pushbutton',...
    'Units','characters',...
    'String','Rename',...
    'Callback', @renameBtn_Callback);

selectBtn = uicontrol(obj,'Tag','selectbtn',...
    'Style','pushbutton',...
    'Units','characters', 'String', '>',...
    'Callback', @selectBtn_Callback);

changedirBtn = uicontrol(obj,'Tag','changedirbtn',...
    'Style','pushbutton',...
    'Units','characters',...
    'String', 'dir',...
    'Callback', @changedirBtn_Callback);

currentDirTxt = uicontrol(obj,'Tag','currentDirTxt',...
    'Style','Text',...
    'Units','characters');

checkBox = uicontrol(obj,'Tag','chkBox',...
    'Style','checkbox','String','RO',...
    'Units','characters',...
    'TooltipString','Rename read only files',...
    'Callback',@chkBtn_Callback);

data = guidata(obj);
data.waitbar = createaxis(obj);
data.listBox1 = listBox1;
data.listBox2 = listBox2;
data.renameBtn = renameBtn;
data.selectBtn = selectBtn;
data.changedirBtn = changedirBtn;
data.currentDirTxt = currentDirTxt;
data.checkBox = checkBox;
data.pathname = pwd;
guidata(obj,data);

setposition(obj);
setpathname;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function figure_ResizeFcn(obj, eventdata)
setposition(gcbf)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function renameBtn_Callback(obj, eventdata)
data = guidata(gcbf);
set(gcbf,'Pointer','watch');
set(data.selectBtn,'Enable','off');
set(data.renameBtn,'Enable','off');
set(data.changedirBtn,'Enable','off');
set(gca,'Visible','on')
nIter = length(data.source);
mess = cell(nIter,1);
for iIter = 1:nIter
    sReadOnlyDest = {fullfile(data.pathname,data.source{iIter}),...
        fullfile(data.pathname,data.dest{iIter})};
    if get(data.checkBox,'Value')
        sReadOnlyDest{3} = 'f';
    end
    [s,mess{iIter},messid] = feval(@movefile,sReadOnlyDest{:});
    waitbar(iIter/nIter);
end
filelist = dir(fullfile(data.pathname,'*.*'));
filelist = {filelist(~[filelist.isdir]).name};
set(data.listBox1,'String',filelist,'Value',1);
set(data.listBox2,'String',mess);
data.filenames = filelist;
guidata(gcbf,data);
waitbar(0);
set(gca,'visible','off')
set(data.selectBtn,'Enable','on');
set(data.changedirBtn,'Enable','on');
set(gcbf,'Pointer','arrow');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function selectBtn_Callback(obj, eventdata)
data = guidata(gcbf);
b=get(data.listBox1,'Value');
data.source=[data.filenames(b)'];
s = data.source{1};
a = char(data.source);
c = ~all(a==repmat(a(1,:),size(a,1),1));
if all(c)
    s = '';
else
    s(c)='?';
end
v = char(inputdlg('make the changes','Destination filename',1,{s},'on'));
% in case of a false input the box is disabled
data.dest = [];
set(data.listBox2,'String',data.dest);
set(data.renameBtn,'Enable','off');
guidata(gcbf,data);

if ~isempty(v)
    if v(1)=='.' % changing extensions
        data.dest = regexprep(data.source, '\..+$', v(1:min(4,length(v))));
    elseif v(1) == '*'
        ext = regexp(v, '\<\*\.\w{0,3}','match');
        if length(ext) == 2
            source = regexp(data.filenames, ['\' ext{1}(2:end) '$']);
            data.source = data.filenames(~(cellfun('isempty',source)));
            data.dest = regexprep(data.source, ['\' ext{1}(2:end) '$'], ext{2}(2:end));
            if isempty(data.dest)
                return
            end
        end
    elseif ~isequal(s,v) && any(s=='?') && (sum(char(v)=='?') == sum(char(s)=='?'))
        data.dest = repmat(v,size(data.source,1),1);
        data.dest(data.dest=='?')=a(:,c);
        data.dest = cellstr(data.dest);
    else
        return
    end
    set(data.listBox2,'String',data.dest);
    set(data.renameBtn,'Enable','on');
    guidata(gcbf,data);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function changedirBtn_Callback(obj, eventdata)
data = guidata(gcbf);
npathname = uigetdir(data.pathname);
if ~isnumeric(npathname)
    data.pathname = npathname;
    guidata(gcbf,data);
    setpathname;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function chkBtn_Callback(obj, eventdata)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function setposition(h)
fpos = get(h,'Position');
data = guidata(h);
set(data.listBox1,'Position',...
    [fpos(3:4),fpos(3:4)].*[.05 .10 .40 .90]);
set(data.listBox2,'Position',...
    [fpos(3:4),fpos(3:4)].*[.55 .10 .40 .90]);
set(data.changedirBtn,'Position',...
    [fpos(3:4),fpos(3:4)].*[.46 .45 .08 .05]);
set(data.renameBtn,'Position',...
    [fpos(3:4),fpos(3:4)].*[.46 .50 .08 .05]);
set(data.selectBtn,'Position',...
    [fpos(3:4),fpos(3:4)].*[.46 .55 .08 .05]);
set(data.checkBox,'Position',...
    [fpos(3:4),fpos(3:4)].*[.46 .40 .08 .05]);
set(data.currentDirTxt,'Position',...
    [fpos(3:4),fpos(3:4)].*[.05 .05 .90 .03]);
set(data.waitbar,'Position',...
    [fpos(3:4),fpos(3:4)].*[.05 .01 .90 .03]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function setpathname
data = guidata(gcbf);
filelist = dir(fullfile(data.pathname,'*.*'));
filelist = {filelist(~[filelist.isdir]).name};
set(data.listBox1,'String',filelist,'value',1);
set(data.listBox2,'String','');
set(data.renameBtn,'Enable','off');
set(data.currentDirTxt,'String',data.pathname);
if isempty(filelist)
    set(data.selectBtn,'Enable','off');
else
    set(data.selectBtn,'Enable','on');
end
data.filenames = filelist;
data.dest = cellstr('');
data.source = cellstr('');
guidata(gcbf,data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function waitbar(x)
x = max(0,min(100*x,100));
p = findobj(gcbf,'Type','patch');
l = findobj(gcbf,'Type','line');
if isempty(gcbf) | isempty(p) | isempty(l),
    error('Couldn''t find waitbar handles.');
end
xpatch = get(p,'XData');
xpatch = [0 x x 0];
set(p,'XData',xpatch)
drawnow;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = createaxis(f)
colormap([]);
axNorm = [.05 0.01 .9 .03];
pos = get(f,'Position');
axPos = axNorm.*[pos(3:4),pos(3:4)];

h = axes('XLim',[0 100],...
    'YLim',[0 1],...
    'Box','on', ...
    'Units','characters',...
    'FontSize', 1,...
    'Position',axPos,...
    'XTickMode','manual',...
    'YTickMode','manual',...
    'XTick',[],...
    'YTick',[],...
    'XTickLabelMode','manual',...
    'XTickLabel',[],...
    'YTickLabelMode','manual',...
    'YTickLabel',[],...
    'HandleVisibility','callback',...
    'visible','off');

xpatch = [0 0 0 0];
ypatch = [0 0 1 1];
xline = [100 0 0 100 100];
yline = [0 0 1 1 0];

p = patch(xpatch,ypatch,'r','EdgeColor','r','EraseMode','none');
l = line(xline,yline,'EraseMode','none','Color',get(gca,'XColor'));




