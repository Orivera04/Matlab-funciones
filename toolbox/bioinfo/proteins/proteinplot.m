function varargout = proteinplot(varargin)
%PROTEINPLOT displays property values for amino acid sequences.
%   PROTEINPLOT is a tool for analyzing and comparing different amino acid
%   properties for a single amino acid sequence. It displays smoothed line
%   plots of various properties such as hydrophobicity of the amino acids
%   in the sequence.
%
%   You can type or paste an amino acid sequence into the Sequence text box
%   in the tool. Alternatively, you can import a sequence, by clicking the
%   "Import Sequence" button, from a variable in the Workspace, from a
%   FASTA format file, from a plain text file, from a GenPept format file,
%   or directly from the GenPept database.
%
%   PROTEINPLOT(SEQ) starts PROTEINPLOT and imports sequence SEQ into the
%   tool.
%
%   PROTEINPLOT(SEQSTRUCT) starts PROTEINPLOT and imports the sequence from
%   SEQSTRUCT's Sequence field.  
%
%   PROTEINPLOT has information about many properties built in. Select the
%   References item from the PROTEINPLOT Help menu for a full list. When
%   you click on a property a smoothed plot of the property values along
%   the sequence will be displayed. Multiple properties can be selected
%   from the list by holding down Shift or Ctrl while selecting properties.
%   When two properties are selected, the plots are displayed using a
%   PLOTYY-style layout, with one Y axis on the left and one on the right.
%   For all other selections, a single Y axis is displayed.
%
%   When displaying one or two properties, the Y values displayed are the
%   actual property values.  When three or more properties are displayed,
%   the values are normalized to the range 0-1.
%
%   You can add your own property values by clicking on the Add... button
%   next to the property list. This will open up a dialog that allows you
%   to specify the values for each of the amino acids. The Display Text
%   text box allows you to specify the text that will be displayed in the
%   selection box on the main PROTEINPLOT window. You can also save the
%   property values to an m-file for future use by typing a file name into
%   the Filename box.
%
%   The Terminal Selection boxes allow you to choose to plot only part of
%   the sequence. By default all of the sequence is plotted.
%
%   The default smoothing method is an unweighted linear moving average
%   with a window length of five residues. You can change this using the
%   "Configuration Values" dialog from the Edit menu. The dialog allows you
%   to select the window length from 5 to 29 residues. You can modify the
%   shape of the smoothing window by changing the edge weighting factor.
%   And you can choose the smoothing function to be a linear moving
%   average, an exponential moving average or a linear Lowess smoothing.
%
%   The File menu allows you to Import a sequence, save the plot that you
%   have created to a .FIG file, you can export the data values in the
%   figure to a workspace variable or to a MAT file, you can export the
%   figure to a normal figure window for customization, and you can print
%   the figure. You can also close PROTEINPLOT from the File menu.
%
%   The Edit menu allows you to create a new property, to reset the
%   property values to the default values, and to modify the smoothing
%   parameters with the "Configuration Values" menu item.
%
%   The View menu allows you to turn the toolbar on and off, and to add a
%   legend to the plot.
%
%   The Tools menu allows you to zoom in and zoom out of the plot, to view
%   Data Statistics such as mean, minimum and maximum values of the plot,
%   and to normalize the values of the plot from 0 to 1.
%
%   The Help menu allows you to view this document and to see the
%   references for the sequence properties built in to PROTEINPLOT .
%
%   Examples:
%
%       prion = getpdb('1HJM', 'SEQUENCEONLY', true)
%       proteinplot(prion)
%
%       s = getgenpept('aad50640');
%       proteinplot(s)
%
%   See also AACOUNT, ATOMICCOMP, MOLWEIGHT, PLOTYY.

%   $Revision: 1.12.6.6 $  $Date: 2004/02/01 21:38:11 $
%   Copyright 2003-2004 The MathWorks, Inc.

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @proteinplot_OpeningFcn, ...
    'gui_OutputFcn',  @proteinplot_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1}) && nargin > 1
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end


% --- Executes just before proteinplot is made visible.
function proteinplot_OpeningFcn(hObject, eventdata, handles, varargin) %#ok
% Choose default command line output for proteinplot
handles.output = hObject;

set(hObject,'Color',get(0,'DefaultFigureColor'))

% add the toolbar
handles.proteinplottoolbar = makeproteinplottoolbar(handles.proteinplotfig);

% initialize the property list box
[handles.propfcnnames, handles.propfcnhandles] = getproteinpropfcns;
set(handles.propertylist,'String',handles.propfcnnames);

% initialize the matrix that stores the property values
handles.propfcnvalues = makepropvalmatrix(handles.propfcnhandles);

% initialize field for line handles
handles.linehandles = [];

%initialize field for selected property names
handles.propnames = [];

% initialize fields for the legend handle, and the data/property used to
% create the lines, as empties
handles.legend = []; handles.legenddata = [];

% field for handle for additional axes
handles.proteinax2 = [];

%initialize configuration field values
handles.windowlength = 5;
handles.windowrange = (5:2:29)';
handles.edgeweight = 1;
handles.uselinear = true;
handles.useexp = false;
handles.uselowess = false;

% handles for import/export guis
handles.proteinplotimport = [];
handles.proteinplotexport = [];

% automatic apply
handles.autoapply = false;

% handle for gidden, tmeporary figure for printing
handles.tempfig = [];

% create field to hold message for status display
handles.statusmessage = '';

% create the timer used for the status bar
handles.statustimer = createtimer(handles);

% create dialog
handles = proteinpropertydlg(handles);

set(handles.statustimer,'UserData',handles);

% make sure that the objects are aligned properly
ppalign(handles)

% Update handles structure
guidata(hObject, handles);



% if a string was passed as the only input, use it to set the sequence
if numel(varargin) == 1 
    if ischar(varargin{1})
        seq = cleansequence(varargin{1});
        set(handles.sequence,'String',seq);
        set(handles.ntermedit,'String',num2str(1));
        set(handles.ctermedit,'String',num2str(length(seq)));
        analyze(hObject,[],handles);
    elseif isstruct(varargin{1}) && isfield(varargin{1},'Sequence')      
        seq = cleansequence(varargin{1}.Sequence);
        set(handles.sequence,'String',seq);
        set(handles.ntermedit,'String',num2str(1));
        set(handles.ctermedit,'String',num2str(length(seq)));
        analyze(hObject,[],handles);
    else
        uiwait(warndlg('The input sequence must be an array of characters, or a structure with the field ''Sequence''.','Invalid Sequence','modal'));
    end
end




% --------------------------------------------------------------------
function varargout = proteinplot_OutputFcn(hObject, eventdata, handles) %#ok
varargout{1} = handles.output;


% --------------------------------------------------------------------
function proteinplotfig_CloseRequestFcn(hObject, eventdata, handles) %#ok
%close property dialog
if ~isempty(handles.dialog) && ishandle(handles.dialog.frame)
    handles.dialog.frame.dispose;
end

if ~isempty(handles.proteinplotimport) && ishandle(handles.proteinplotimport)
    close(handles.proteinplotimport);
else
    ppimport = findall(0,'Type','figure','Tag','ppimport');
    if ~isempty(ppimport),
        close(ppimport)
    end
end

if ~isempty(handles.proteinplotexport) && ishandle(handles.proteinplotexport)
    close(handles.proteinplotexport);
end

% delete the timer
delete(handles.statustimer)

% now delete the figure
delete(hObject);

% --------------------------------------------------------------------
function ppalign(handles)

% make sure the terminal selection label, property label and add property
% button are aligned to the right

trmtxtpos = get(handles.terminalframetext,'Position');
proptxtpos = get(handles.propertytext,'Position');
addproppos = get(handles.addproppush,'Position');

rightedge = [trmtxtpos(1) + trmtxtpos(3);...
    proptxtpos(1) + proptxtpos(3);...
    addproppos(1) + addproppos(3)];

maxright = max(rightedge);

set(handles.terminalframetext,'Position',[(maxright - trmtxtpos(3)) trmtxtpos(2:4)])
set(handles.propertytext,'Position',[(maxright - proptxtpos(3)) proptxtpos(2:4)])
set(handles.addproppush,'Position',[(maxright - addproppos(3)) addproppos(2:4)])

% now make sure that the listbox and label for the N terminal edit box are
% left aligned, and spaced 10 pixels to the right

% get the position in pixels

oldUnits = get(handles.terminalframetext,'Units');
set(handles.terminalframetext,'Units','pixels');
pix_trmtxtpos = get(handles.terminalframetext,'Position');
set(handles.terminalframetext,'Units',oldUnits);

pix_leftpos = pix_trmtxtpos(1) + pix_trmtxtpos(3) + 10;


oldUnits = get([handles.ntermtext; handles.propertylist],'Units');
set([handles.ntermtext; handles.propertylist],'Units','pixels');

pix_ntermtextpos = get(handles.ntermtext,'Position');
pix_ntermtextpos(1) = pix_leftpos;
set(handles.ntermtext,'Position',pix_ntermtextpos);
set(handles.ntermtext,'Units',oldUnits{1});

pix_proplistpos = get(handles.propertylist,'Position');
pix_proplistpos(1) = pix_leftpos;
set(handles.propertylist,'Position',pix_proplistpos);
set(handles.propertylist,'Units',oldUnits{2});


% place the N terminal edit box 10 pixels to the right of the label
oldUnits = get(handles.ntermedit,'Units');
set(handles.ntermedit,'Units','pixels');
pix_ntermeditpos = get(handles.ntermedit,'Position');

pix_ntermeditpos(1) = pix_ntermtextpos(1) + pix_ntermtextpos(3) + 10;
set(handles.ntermedit,'Position',pix_ntermeditpos)
set(handles.ntermedit,'Units',oldUnits);

% place the label for the C terminal edit box 20 pixels to the right of the
% N terminal edit box
oldUnits = get(handles.ctermtext,'Units');
set(handles.ctermtext,'Units','pixels');
pix_ctermtextpos = get(handles.ctermtext,'Position');
pix_ctermtextpos(1) = pix_ntermeditpos(1) + pix_ntermeditpos(3) + 20;
set(handles.ctermtext,'Position',pix_ctermtextpos);
set(handles.ctermtext,'Units',oldUnits);

% place the C terminal edit box 10 pixels to the right of the label
oldUnits = get(handles.ctermedit,'Units');
set(handles.ctermedit,'Units','pixels');
pix_ctermeditpos = get(handles.ctermedit,'Position');
pix_ctermeditpos(1) = pix_ctermtextpos(1) + pix_ctermtextpos(3) + 10;
set(handles.ctermedit,'Position',pix_ctermeditpos);
set(handles.ctermedit,'Units',oldUnits);



% --------------------------------------------------------------------
function tmr = createtimer(handles) %#ok
% create the timer used for the status bar
tmr = timer('Tag','proteinplottimer');



% --------------------------------------------------------------------
function whiteuicontrol_CreateFcn(hObject, eventdata, handles) %#ok
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --------------------------------------------------------------------
function propertylist_Callback(hObject, eventdata, handles) %#ok

% only allow data statistics if a single property is selected
if numel(get(hObject,'Value')) > 1
    set(handles.tools_datastatisticsmenu,'Enable','off')


    if numel(get(hObject,'Value')) > 2
        %if more than 2, automatically normalize
        set(handles.tools_normalizemenu,'Checked','on')
    else
        % see if normalization was selected manually
        set(handles.tools_normalizemenu,'Checked','off')
    end
else
    set(handles.tools_datastatisticsmenu,'Enable','on')
end

analyze(hObject, eventdata, handles)

%reload handles
handles = guidata(handles.proteinplotfig);

if isempty(handles.linehandles)
    legend(handles.proteinax,'off')
elseif ~isempty(legend(handles.proteinax))
    %update the legend
    handles.legend = legend(handles.proteinax,handles.linehandles,handles.propnames);
    guidata(handles.proteinplotfig,handles);
end





% --------------------------------------------------------------------
function statusdisplay(hFig,timeout,handles) %#ok
% STATUSDISPLAY(MSG,T,HANDLES) displays the string MSG for T seconds

% get timer handle
t = handles.statustimer;

if ~ishandle(t)
    t = createtimer(guidata(handles.proteinplotfig));
    handles.statustimer = t;
    guidata(handles.proteinplotfig,handles);
end



% set the status string
set(handles.status,'String',handles.statusmessage)

% set the timer properties
set(t,'TimerFcn',{@statusclear ,handles},...
    'StartDelay',timeout);
% check to see if the timer is already running
if strcmp(get(t,'Running'),'off')
    start(t)
else
    stop(t)
    start(t)
end

% --------------------------------------------------------------------
function statusclear(hObject, eventdata, handles) %#ok
% use to clear the status display
set(handles.status,'String','')

% --------------------------------------------------------------------
function sequence_Callback(hObject, eventdata, handles) %#ok
seq = get(hObject','String');

% see if it corresponds to a variable name in the base workspace
if isvarname(seq) && evalin('base',['exist(''' seq ''')']) == 1
    tempseq = evalin('base',seq);
    if ischar(tempseq)
        % create a dialog, mention that the string is a variable name
        % ask if the user wants to use it
        if strcmp('Yes',questdlg(['Do you want to import the variable ' seq ' from the MATLAB workspace?'],'Import Variable','No'))
            seq = tempseq;
        end
    end
end

seq = cleansequence(seq);
set(hObject,'String',seq);

seq_length = length(seq);
if seq_length
    set(handles.ntermedit,'String','1')
    set(handles.ctermedit,'String',num2str(seq_length))
end

analyze(hObject, eventdata, handles)

% --------------------------------------------------------------------
function samebackground_CreateFcn(hObject, eventdata, handles) %#ok
set(hObject,'BackgroundColor',get(0,'DefaultFigureColor'));

% --------------------------------------------------------------------
function checkterminals(handles)
% check the N and C terminal values

seq_length = length(get(handles.sequence,'String'));

%no sequence
if seq_length == 0,
    return
end

% N
nstr = get(handles.ntermedit,'String');
nval = str2num(nstr); %#ok

% no N terminal value
if isempty(nstr) || isempty(nval)
    set(handles.ntermedit,'String',num2str(1))
    nval = 1;
end

% N is too low
if nval < 1
    uiwait(warndlg('The N terminal value cannot be less than 1.  It has been set to 1.','Invalid Terminal Values','modal'))
    set(handles.ntermedit,'String',num2str(1))
    nval = 1;
end

% C
cstr = get(handles.ctermedit,'String');
cval = str2num(cstr); %#ok

% no C terminal value
if isempty(cstr) || isempty(cval)
    set(handles.ctermedit,'String',num2str(seq_length))
    cval = seq_length;
end

% C is too low
if cval < 1
    uiwait(warndlg('The C terminal value cannot be less than 1.  It has been set to the sequence''s length.','Invalid Terminal Values','modal'))
    set(handles.ctermedit,'String',num2str(seq_length))
    cval = seq_length;
end


% N is too high
if nval > seq_length
    uiwait(warndlg('The N terminal value cannot be greater than the sequence''s length.  It has been set to 1.','Invalid Terminal Values','modal'))
    set(handles.ntermedit,'String',num2str(1))
    nval = 1;
end

% N cannot be larger than C
if nval > cval
    uiwait(warndlg('The N terminal value cannot be greater than the C terminal value.  The C terminal value has been set to the sequence''s length.','Invalid Terminal Values','modal'))
    set(handles.ctermedit,'String',num2str(seq_length))
end

% C cannot be larger than the sequence length
if cval > seq_length
    uiwait(warndlg('C terminal value cannot be greater than the sequence''s length.  It has been set to the sequence''s length.','Invalid Terminal Values','modal'))
    set(handles.ctermedit,'String',num2str(seq_length))
end


% --------------------------------------------------------------------
function ntermedit_Callback(hObject, eventdata, handles) %#ok

checkterminals(handles)

analyze(hObject, eventdata, handles)



% --------------------------------------------------------------------
function ctermedit_Callback(hObject, eventdata, handles) %#ok

checkterminals(handles)

analyze(hObject, eventdata, handles)



% --------------------------------------------------------------------
function analyze(hObject, eventdata, handles) %#ok
% process and plot the data values

% clear the axes
cla(handles.proteinax)
if ~isempty(handles.proteinax2) && ishandle(handles.proteinax2)
    cla(handles.proteinax2)
end

% get the sequence
seq = cleansequence(get(handles.sequence,'String'));
if isempty(seq)
    return
end

% get the Nterm and Cterm values
nterm = str2num(get(handles.ntermedit,'String')); %#ok
cterm = str2num(get(handles.ctermedit,'String')); %#ok

% use the selected segment of the sequence
seq = seq(nterm:cterm);


% determine which properties were selected
selectedprop = get(handles.propertylist,'Value');
allpropnames = get(handles.propertylist,'String');
propnames = {allpropnames{selectedprop}};

% create array of data for lines
data = [];
for p = 1:numel(selectedprop),
    fcndata = handles.propfcnvalues(:,selectedprop(p));
    data = [data fcndata(seq - 'a' + 1)];
end

% no data
if isempty(data)
    handles.linehandles = [];
    handles.propnames;
    guidata(handles.proteinplotfig,handles);
    return
end

% process data, using windowlength
ws = handles.windowlength;
mid = (ws + 1)/2;

% determine if using linear or exponential
edgeval = handles.edgeweight;

% check length of data versus the window length
if length(data) < ws,
    uiwait(warndlg(['The selected sequence is shorter than the filter window length, ' num2str(ws) '.'],'Sequence Length','modal'))
    return
end

if handles.uselinear % linear
    fb = ones(1,ws);
    fs = linspace(edgeval,1,mid);
    fb(1:mid) = fs;
    fb(mid:ws) = fliplr(fs);
    fb = fb / sum(fb);
    data = filter(fb,1,data);
    data = data(mid:(end - mid + 1),:);
    dataInd = (nterm + (ws-1)/2):(cterm - (ws-1)/2);
elseif handles.useexp % exponential
    fb = ones(1,ws);
    fb(1) = edgeval; fb(ws) = edgeval;
    if ~edgeval
        edgeval = 1e-6;
    end
    k = log(edgeval) /  (mid - 1);
    fb(2:mid-1) = exp(k) .^((mid-2):-1:1);
    fb((mid+1): (ws-1)) = fliplr(fb(2:mid-1));
    fb = fb / sum(fb);
    data = filter(fb,1,data);
    data = data(mid:(end - mid + 1),:);
    dataInd = (nterm + (ws-1)/2):(cterm - (ws-1)/2);
elseif handles.uselowess % lowess
    for n = 1:size(data,2),
        data(:,n) = masmooth(data(:,n),ws,'lowess');
    end
    dataInd = nterm:cterm;
end


% normalize if the normalize menu item is checked.  this is automatically
% set in the callback for the property list when there are more than two
% items selected
if strcmp(get(handles.tools_normalizemenu,'Checked'),'on')
    mindata = repmat(min(data),size(data,1),1);
    maxdata = repmat(max(data),size(data,1),1);
    data = (data - mindata) ./ (maxdata-mindata);
else
    set(handles.proteinax,'YLimmode','auto')
end

% plotyy format
if size(data,2) == 2
    % check for another axes
    if isempty(handles.proteinax2) || ~ishandle(handles.proteinax2)
        units = get(handles.proteinax,'Units');
        position = get(handles.proteinax,'Position');
        handles.proteinax2 = axes('Parent',handles.proteinplotfig,...
            'Units',units,...
            'Position',position,...
            'HandleVisibility','callback',...
            'Tag','proteinax2',...
            'YaxisLocation','right',...
            'Color','none',...
            'Box','off');
    end


    set(handles.proteinax,'XLim',[nterm cterm],...
        'Box','off',...
        'YLimmode','auto');
    set(handles.proteinax2,'XLim',[nterm cterm],...
        'YLimmode','auto');

    handles.linehandles = zeros(2,1);

    handles.linehandles(1) = line('XData',dataInd,...
        'YData',data(:,1),...
        'Color','b',...
        'Parent',handles.proteinax,...
        'Tag',propnames{1});
    set(handles.proteinax,'YColor','b');

    % make sure Ylim is acceptable
    s = warning;
    warning('off');
    ylim = get(handles.proteinax,'YLim');
    warning(s);
    if diff(ylim) < 1e-6
        newylim = ylim + [-1e-6 1e-6];
        set(handles.proteinax,'YLim',newylim)
    end


    handles.linehandles(2) = line('XData',dataInd,...
        'YData',data(:,2),...
        'Color','r',...
        'Parent',handles.proteinax2,...
        'Tag',propnames{2});
    set(handles.proteinax2,'YColor','r')

    % make sure Ylim is acceptable
    s = warning;
    warning('off');
    ylim2 = get(handles.proteinax2,'YLim');
    warning(s);
    if diff(ylim) < 1e-6
        newylim2 = ylim2 + [-1e-6 1e-6];
        set(handles.proteinax2,'YLim',newylim2)
    end
    
    % constrain zooming to X only for 2 properties 
    zoom(handles.proteinplotfig,'constraint','horizontal')
    % link the axes' X limits
    linkaxes([handles.proteinax;handles.proteinax2],'x')

else
    % no zoom constraint
    zoom(handles.proteinplotfig,'constraint','none');
    % see if there are two axes, delete extra
    if ~isempty(handles.proteinax2) && ishandle(handles.proteinax2)
        % unlink axes
        linkaxes([handles.proteinax;handles.proteinax2],'off')
        delete(handles.proteinax2)
        handles.proteinax2 = [];
    end

    %     set(handles.proteinax,'XLim',[1 max(2,size(data,1))],...
    %         'YColor','k')
    set(handles.proteinax,'XLim',[nterm cterm],...
        'YColor','k')
    handles.linehandles = plot(dataInd,data,'Parent',handles.proteinax);
    for n = 1:length(handles.linehandles),
        set(handles.linehandles(n),'Tag',propnames{n})
    end

    % make sure Ylim is acceptable
    s = warning;
    warning('off');
    ylim = get(handles.proteinax,'YLim');
    warning(s);
    if diff(ylim) < 1e-6
        newylim = ylim + [-1e-6 1e-6];
        set(handles.proteinax,'YLim',newylim)
    end

end

% normalize
if strcmp(get(handles.tools_normalizemenu,'Checked'),'on');
    set(handles.proteinax,'YLim',[-0.1 1.1])
end

% store property names
handles.propnames = propnames;

if ~isempty(handles.legend) && ishandle(handles.legend)
    % refresh the legend
    handles.legend = legend(handles.proteinax,handles.linehandles,handles.propnames(:)');
else
    handles.legend = [];
end

guidata(handles.proteinplotfig,handles);


% --------------------------------------------------------------------
function addproppush_Callback(hObject, eventdata, handles) %#ok
addprop(handles);


% --------------------------------------------------------------------
function view_toolbarmenu_Callback(hObject, eventdata, handles) %#ok
if strcmp(get(hObject,'Checked'),'on')
    set(hObject','Checked','off')
    set(handles.proteinplottoolbar,'Visible','off')
else
    set(hObject','Checked','on')
    set(handles.proteinplottoolbar,'Visible','on')
end


% --------------------------------------------------------------------
function tools_datastatisticsmenu_Callback(hObject, eventdata, handles) %#ok
basicfitdatastat('bfit', handles.proteinplotfig, 'ds')


% --------------------------------------------------------------------
function file_importmenu_Callback(hObject, eventdata, handles) %#ok
importsequencedata(handles)


% --------------------------------------------------------------------
function importpush_Callback(hObject, eventdata, handles) %#ok
importsequencedata(handles)


% --------------------------------------------------------------------
function importsequencedata(handles)
handles.proteinplotimport = proteinplotimport(handles);

%store the handle for the dialog
guidata(handles.proteinplotfig,handles);

%wait for dialog to close
uiwait(handles.proteinplotimport)

% if proteinplot is closed while the import dialog is open, then return
% early
if ~ishandle(handles.sequence)
    return
end

seq = get(handles.sequence,'String');
seq_length = length(seq);
if seq_length
    set(handles.ntermedit,'String','1')
    set(handles.ctermedit,'String',num2str(seq_length))
end

analyze(handles.proteinplotfig,[], handles)

% --------------------------------------------------------------------
function file_savetofigurefilemenu_Callback(hObject, eventdata, handles) %#ok

save_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function file_exportdatamenu_Callback(hObject, eventdata, handles) %#ok

handles.proteinplotexport = proteinplotexport(handles);
guidata(handles.proteinplotfig,handles);


% --------------------------------------------------------------------
function file_exportfiguremenu_Callback(hObject, eventdata, handles) %#ok

newfig = figure('Visible','off');
%create new axes to get position
newax = axes('Parent',newfig,...
    'Units',get(handles.proteinax,'Units'));
newpos = get(newax,'Position');
delete(newax)
newax = copyobj(handles.proteinax,newfig);
set(newax,'HandleVisibility','on',...
    'Position',newpos)

linehandles = findall(newax,'Type','line');

if ~isempty(handles.proteinax2)
    newax2 = copyobj(handles.proteinax2,newfig);
    set(newax2,'HandleVisibility','on',...
        'Position',newpos)
    linehandles = [linehandles findall(newax2,'Type','line')];
end

if ~isempty(handles.legend) && ishandle(handles.legend)
    [legend_h,object_h,plot_h,text_strings] = legend(handles.proteinax); %#ok
    legend(newax,linehandles,cellstr(text_strings));
end

set(newfig,'Visible','on')

% --------------------------------------------------------------------
function file_printpreviewmenu_Callback(hObject, eventdata, handles) %#ok

if ~isempty(handles.tempfig) && ishandle(handles.tempfig)
    delete(handles.tempfig)
    handles.tempfig = [];
end

handles.tempfig = figure('Visible','off');
copyobj([handles.proteinax, handles.legend],handles.tempfig);
printpreview(handles.tempfig)
guidata(handles.proteinplotfig,handles)


% --------------------------------------------------------------------
function file_printmenu_Callback(hObject, eventdata, handles) %#ok
print_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function print_Callback(hObject, eventdata, handles) %#ok

if ~isempty(handles.tempfig) && ishandle(handles.tempfig)
    delete(handles.tempfig)
    handles.tempfig = [];
end

handles.tempfig = figure('Visible','off');
if ~isempty(handles.legend) && ishandle(handles.legend)
    [newh] = copyobj([handles.proteinax, handles.legend],handles.tempfig);
    set(newh(2),'DeleteFcn','legend(''DeleteLegend'')')
    ud = get(newh(2),'UserData');
    ud.DeleteProxy = findall(newh(1),'Type','text','Tag','LegendDeleteProxy');
    set(ud.DeleteProxy,'UserData',newh(2))
    ud.LegendHandle = newh(2);
    set(newh(2),'UserData',ud);
else
    copyobj(handles.proteinax,handles.tempfig)
end
printdlg(handles.tempfig);
close(handles.tempfig);

% --------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles) %#ok

newfig = figure('Visible','off',...
    'UserData',get(handles.sequence,'String'));

%create new axes to get position
newax = axes('Parent',newfig,...
    'Units',get(handles.proteinax,'Units'));
newpos = get(newax,'Position');
delete(newax)


newax = copyobj(handles.proteinax,newfig);
set(newax,'HandleVisibility','on',...
    'Position',newpos)


if ~isempty(handles.legend) && ishandle(handles.legend)
    [legend_h,object_h,plot_h,text_strings] = legend(handles.proteinax); %#ok
    legend(newax,text_strings)
end


[fname,pname] = uiputfile({'*.fig', 'Figure file'},'Save As');

if ischar(fname) && ischar(pname)
    set(newfig,'Visible','on')
    hgsave(newfig,fullfile(pname,fname));
end

close(newfig)


% --------------------------------------------------------------------
function file_closemenu_Callback(hObject, eventdata, handles) %#ok

proteinplotfig_CloseRequestFcn(hObject, eventdata, handles)



% --------------------------------------------------------------------
function edit_addproteinpropmenu_Callback(hObject, eventdata, handles) %#ok

addprop(handles)



% --------------------------------------------------------------------
function edit_resetpropmenu_Callback(hObject, eventdata, handles) %#ok

btnstr = questdlg('You are about to reset all of the property values to the default values.  This will also affect the current plot.  Do you want to continue?',...
    'Reset property values?',...
    'Yes','No','No');

if strcmp(btnstr,'Yes')

    % initialize the matrix that stores the property values
    handles.propfcnvalues = makepropvalmatrix;
    [handles.propfcnnames,handles.propfcnhandles] = getproteinpropfcns;
    pd = handles.dialog;
    pl = pd.propertylist;

    % store the current selection
    sel = pl.getSelectedIndex + 1;
    selValue = pl.getSelectedValue;

    % update the property list:
    pl.setListData(handles.propfcnnames);

    % no properties selected
    if sel == 0,
        sel = 1;
        % select the first property
        awtinvoke(pl,'setSelectedIndex',0);
    else
        % determine which one was selected, by location in the new list:
        sel = strmatch(selValue,handles.propfcnnames,'exact');
        awtinvoke(pl,'setSelectedIndex',sel-1);
    end

    % reset Add Property table
    addpTable = pd.addproptable;

    edRow = addpTable.getEditingRow;
    edCol = addpTable.getEditingColumn;

    % need to stop editing, if a value is currently being edited
    % otherwise, the value won't be reset
    if edRow > -1
        addpTable.getCellEditor(edRow,edCol).cancelCellEditing;
    end

    % determine which are valid amino acids
    intAA = aa2int(char(double('a'):double('z')));

    % shut off TableChangedCallback temporarily
    tm = get(addpTable,'Model');
    currentcb = get(tm,'TableChangedCallback');
    set(tm,'TableChangedCallback','')

    % table contents
    dataVector = javaArray('java.lang.Object',26,3);
    namedata = defaultaanames;
    for n = 1:26,
        dataVector(n,1) = java.lang.String(namedata{n});
        if intAA(n) > 20 || intAA(n) < 1
            dataVector(n,2) = java.lang.Double(NaN);
            dataVector(n,3) = java.lang.Boolean(false);
        else
            dataVector(n,2) = java.lang.Double(0);
            dataVector(n,3) = java.lang.Boolean(true);
        end
    end

    % table column headers
    columnIdentifiers = javaArray('java.lang.Object',3);
    columnIdentifiers(1) = java.lang.String('Amino Acid');
    columnIdentifiers(2) = java.lang.String('Value');
    columnIdentifiers(3) = java.lang.String('Use');

    % get table model's Class, use to get Method
    tmClass = getClass(tm);

    paramtypes = javaArray('java.lang.Class',2);
    paramtypes(1) = dataVector.getClass;
    paramtypes(2) = columnIdentifiers.getClass;

    % get Method object
    meth = tmClass.getMethod(java.lang.String('setDataVector'),paramtypes);

    % inputs to Method
    arglist = javaArray('java.lang.Object',2);
    arglist(1) = dataVector;
    arglist(2) = columnIdentifiers;

    % invoke method
    com.mathworks.mwswing.MJUtilities.invokeLater(tm, meth, arglist);    
    
    % make sure proper cell editors are used
    nameEditor = javax.swing.DefaultCellEditor(javax.swing.JTextField);
    valueEditor = javax.swing.DefaultCellEditor(javax.swing.JTextField);
    useEditor = javax.swing.DefaultCellEditor(javax.swing.JCheckBox);    
  
    cm = addpTable.getColumnModel;
    awtinvoke(cm.getColumn(0),'setCellEditor',nameEditor);
    awtinvoke(cm.getColumn(1),'setCellEditor',valueEditor);
    awtinvoke(cm.getColumn(2),'setCellEditor',useEditor);    

    % restore callback
    set(tm,'TableChangedCallback',currentcb);

    % reset property table
    pTable = pd.propertytable;
    origvals = handles.propfcnvalues(:,sel);

    tm = get(addpTable,'Model');
    currentcb = get(tm,'TableChangedCallback');
    set(tm,'TableChangedCallback','')


    namedata = defaultaanames;
    % reuse dataVector
    for n = 1:26,
        dataVector(n,1) = java.lang.String(namedata{n});
        dataVector(n,2) = java.lang.Double(origvals(n));
        dataVector(n,3) = java.lang.Boolean(~isnan(origvals(n)));
    end

      
    columnIdentifiers = javaArray('java.lang.Object',3);
    columnIdentifiers(1) = java.lang.String('Amino Acid');
    columnIdentifiers(2) = java.lang.String('Value');
    columnIdentifiers(3) = java.lang.String('Use');
    
    % get table model's Class, use to get Method
    tmClass = getClass(tm);

    paramtypes = javaArray('java.lang.Class',2);
    paramtypes(1) = dataVector.getClass;
    paramtypes(2) = columnIdentifiers.getClass;

    % get Method object
    meth = tmClass.getMethod(java.lang.String('setDataVector'),paramtypes);

    % inputs to Method
    arglist = javaArray('java.lang.Object',2);
    arglist(1) = dataVector;
    arglist(2) = columnIdentifiers;

    % invoke method
    com.mathworks.mwswing.MJUtilities.invokeLater(tm, meth, arglist); 
    
    % make sure proper cell editors are used
    nameEditor = javax.swing.DefaultCellEditor(javax.swing.JTextField);
    valueEditor = javax.swing.DefaultCellEditor(javax.swing.JTextField);
    useEditor = javax.swing.DefaultCellEditor(javax.swing.JCheckBox);
    
    cm = pTable.getColumnModel;
    awtinvoke(cm.getColumn(0),'setCellEditor',nameEditor);
    awtinvoke(cm.getColumn(1),'setCellEditor',valueEditor);
    awtinvoke(cm.getColumn(2),'setCellEditor',useEditor); 
    
    % restore callback
    set(tm,'TableChangedCallback',currentcb);

    
    guidata(handles.proteinplotfig,handles)
    analyze(hObject,eventdata,handles)
end



% --------------------------------------------------------------------
function edit_editprop_proteinmenu_Callback(hObject, eventdata, handles) %#ok

% show the GUI
handles.dialog.frame.show;
% show the tab
%handles.dialog.tabpane.setSelectedIndex(0);
awtinvoke(handles.dialog.tabpane,'setSelectedIndex',0);

% --------------------------------------------------------------------
function edit_editprop_figuremenu_Callback(hObject, eventdata, handles) %#ok
propedit(handles.proteinplotfig)


% --------------------------------------------------------------------
function view_legendmenu_Callback(hObject, eventdata, handles) %#ok

if strcmp(get(handles.view_legendmenu,'Checked'),'off')
    if ~isempty(handles.linehandles) && all(ishandle(handles.linehandles)) && ~isempty(handles.propnames)
        if ~isempty(legend(handles.proteinax))
            legend(handles.proteinax,'off');
        end
        handles.legend = legend(handles.proteinax,handles.linehandles,handles.propnames);
        set(handles.legend, 'DeleteFcn', ' legend(''DeleteLegend''); proteinplot(''enablelegendmenu'',gcbo,[],guidata(gcbo))');
        set(handles.view_legendmenu,'Checked','on');
    end
else
    if ishandle(handles.legend)
        delete(handles.legend);
    end
    handles.legend = [];
    set(handles.view_legendmenu,'Checked','off')
end

guidata(hObject,handles);

% --------------------------------------------------------------------
function enablelegendmenu(hObject, eventdata, handles) %#ok
set(handles.view_legendmenu,'Enable','on')




% --------------------------------------------------------------------
function tools_normalizemenu_Callback(hObject, eventdata, handles) %#ok

if strcmp(get(hObject,'Checked'),'on')
    set(hObject,'Checked','off')
else
    set(hObject,'Checked','on')
end

analyze(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proteinplotzoom(hObject,eventdata,handles,mode) %#ok

zoommode = zoom(handles.proteinplotfig,'getmode'); 
if strcmpi('zoomin',mode)    
    switch zoommode
        case {'off' 'out'}
            zoom(handles.proteinplotfig,'inmode');
        case {'in' 'on'}
            zoom(handles.proteinplotfig,'off');
    end
else
    switch zoommode
        case {'on' 'off' 'in'}
            zoom(handles.proteinplotfig,'outmode');
        case 'out'
            zoom(handles.proteinplotfig,'off');
    end
end


% --------------------------------------------------------------------
function addprop(handles)
% make sure the dialog is showing

handles.dialog.frame.show;

% show the tab
awtinvoke(handles.dialog.tabpane,'setSelectedIndex',2);

% ----------------------------------------------------------------
function set_os_text(hObject)

if ispc
    set(hObject,'FontName','MS Sans Serif',...
        'FontSize',8)
else
    set(hObject,'FontName','Helvetica',...
        'FontSize',10)
end

% ----------------------------------------------------------------
function set_os_position(hObject,offset)

% use offset to add extra spaces for character-based Position
if nargin == 1,
    offset = 2;
end
oldunits = get(hObject,'Units');
set(hObject,'Units','characters');
p = get(hObject,'Position');
str = get(hObject,'String');
set(hObject,'Position',[p(1) p(2) (length(str) + offset) p(4)])
set(hObject,'Units',oldunits)


% ----------------------------------------------------------------
function propertytext_CreateFcn(hObject, eventdata, handles) %#ok
set_os_text(hObject)
set_os_position(hObject)


% ----------------------------------------------------------------
function terminalframetext_CreateFcn(hObject, eventdata, handles) %#ok
set_os_text(hObject)
set_os_position(hObject)

% ----------------------------------------------------------------
function sequencetext_CreateFcn(hObject, eventdata, handles) %#ok
set_os_text(hObject)
set_os_position(hObject,10)

% ----------------------------------------------------------------
function addproppush_CreateFcn(hObject, eventdata, handles) %#ok
set_os_text(hObject)


% ----------------------------------------------------------------
function ntermtext_CreateFcn(hObject, eventdata, handles) %#ok
set_os_text(hObject)
set_os_position(hObject,0)


% ----------------------------------------------------------------
function ctermtext_CreateFcn(hObject, eventdata, handles) %#ok
set_os_text(hObject)
set_os_position(hObject,0)


% ----------------------------------------------------------------
function importpush_CreateFcn(hObject, eventdata, handles) %#ok
set_os_text(hObject)


% ----------------------------------------------------------------
function ntermedit_CreateFcn(hObject, eventdata, handles) %#ok
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

set_os_position(hObject,12)


% ----------------------------------------------------------------
function ctermedit_CreateFcn(hObject, eventdata, handles) %#ok

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

set_os_position(hObject,12)


