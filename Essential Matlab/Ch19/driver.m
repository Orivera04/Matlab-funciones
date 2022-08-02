function varargout = Driver2(varargin)
% DRIVER Application M-file for Driver2.fig
%    FIG = DRIVER launch Driver2 GUI.
%    DRIVER('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 04-May-2001 16:24:12

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

	if nargout > 0
		varargout{1} = fig;
	end

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
	catch
		disp(lasterr);
	end

end


%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.

% --------------------------------------------------------------------
function varargout = run_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.run.
% get current Driver reference info
DriverRef = handles.DriverRef;

for i = 1:DriverRef.nvars
    x0(i,1) = DriverRef.vars(i).inval;
end

time = DriverRef.time;
dt = DriverRef.dt;
runtim = DriverRef.runtim;
opint = DriverRef.opint;
name = DriverRef.filename;
fname = strcat( '@', DriverRef.filename );
fname = eval(fname);             % create handle to filename
[t,x] = ode45(fname,[time:dt:time+dt*runtim],x0,[], ...
              DriverRef.nvars,DriverRef.parms); 
for i = 1:DriverRef.nvars
    DriverRef.vars(i).finval = x(end,i);  %finval not used at the moment
end
[t(1:opint/dt:end),x(1:opint/dt:end,:)]   % display results in Command Window
DriverRef.results = [t,x];

%update Driver reference info
handles.DriverRef = DriverRef;
guidata(h, handles)             % update handles structure

% --------------------------------------------------------------------
function varargout = plot_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.plot.
v = get(handles.listplot,'Value');
%assume if they want to plot against time it is the first variable selected:
DriverRef = handles.DriverRef;
if v(1) == 1 % plot remaining selection against time:
    hold on
    xlabel('time')
    for i = 2:length(v)
        plot(DriverRef.results(:,1), DriverRef.results(:,v(i)));    
        text(DriverRef.results(end,1), DriverRef.results(end,v(i)), ...
             DriverRef.vars(v(i)-1).name)
    end
else         %assume only two variables selected: plot trajectory in 2D       
    hold on
    plot(DriverRef.results(:,v(1)), DriverRef.results(:,v(2)));           
    xlabel(DriverRef.vars(v(1)-1).name)
    ylabel(DriverRef.vars(v(2)-1).name)
end

hold off

% --------------------------------------------------------------------
function varargout = listvars_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.listvars.
set(handles.editvar,'Visible','on')
set(handles.editvartext,'Visible','on')

% --------------------------------------------------------------------
function varargout = listparms_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.listparms.
set(handles.editpar,'Visible','on')
set(handles.editpartext,'Visible','on')

% --------------------------------------------------------------------
function varargout = editvar_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.editvar.
% get index of var to change
i = get(handles.listvars,'Value');

% change its value
if i == 1
    handles.DriverRef.time = str2num(get(gcbo,'String'));
else
    handles.DriverRef.vars(i-1).inval = str2num(get(gcbo,'String'));
end
% clear the box (for next time) and make it invisible again ...
set(gcbo,'String','','Visible','off')
set(handles.editvartext,'Visible','off')

guidata(h, handles)  % update handles structure to reflect change

%update listbox
DriverRef = handles.DriverRef;

str(1) = {sprintf('%s   %g', 'time', DriverRef.time)};

for i = 1:DriverRef.nvars
    str(i+1) = {sprintf('%s   %g', DriverRef.vars(i).name,...
                                   DriverRef.vars(i).inval)};
end
set(handles.listvars,'String',str);

% --------------------------------------------------------------------
function varargout = editpar_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.editpar.
% get index of parm to change
i = get(handles.listparms,'Value');

% change its value
if i == 1
    handles.DriverRef.runtim = str2num(get(gcbo,'String'));
elseif i == handles.DriverRef.nparms+2
    handles.DriverRef.dt = str2num(get(gcbo,'String'));
elseif i == handles.DriverRef.nparms+3
    handles.DriverRef.opint = str2num(get(gcbo,'String'));
else
    handles.DriverRef.parms(i-1).val = str2num(get(gcbo,'String'));
end
% clear the box (for next time) and make it invisible again ...
set(gcbo,'String','','Visible','off')
set(handles.editpartext,'Visible','off')

guidata(h, handles)  % update handles structure to reflect change

%update listbox
DriverRef = handles.DriverRef;

str(1) = {sprintf('%s   %g', 'runtime', DriverRef.runtim)};

for i = 1:DriverRef.nparms
    str(i+1) = {sprintf('%s   %g', DriverRef.parms(i).name,...
                                   DriverRef.parms(i).val)};
end

str(DriverRef.nparms+2) = {sprintf('%s   %g', 'dt', DriverRef.dt)};
str(DriverRef.nparms+3) = {sprintf('%s   %g', 'opint', DriverRef.opint)};
set(handles.listparms,'String',str);

% --------------------------------------------------------------------
function varargout = loadfile_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.loadfile.
% load Driver data (ref file) from MAT file
handles.DriverRef.filename = get(gcbo,'String');  % Mat file name
load(handles.DriverRef.filename)  
handles.DriverRef.time = time;
handles.DriverRef.dt = dt;
handles.DriverRef.nvars = nvars;
handles.DriverRef.nparms = nparms;
handles.DriverRef.parms = parms;
handles.DriverRef.vars = vars;
handles.DriverRef.runtim = runtim;  % cant use 'runtime'!
handles.DriverRef.opint = opint;
handles.DriverRef.results = [];     % results generated by run
guidata(h, handles)  % update handles structure

DriverRef = handles.DriverRef;

%list of var names and initial values for listvars
str(1) = {sprintf('%s   %g', 'time', DriverRef.time)};
for i = 1:DriverRef.nvars
    str(i+1) = {sprintf('%s   %g', DriverRef.vars(i).name,...
                                   DriverRef.vars(i).inval)};
    end
set(handles.listvars,'String',str);

%list of var names for listplot
str(1) = {'time'};
for i = 1:DriverRef.nvars
    str(i+1) = {DriverRef.vars(i).name};
end
set(handles.listplot,'String',str);

%list of param names for listparms
str(1) = {sprintf('%s   %g', 'runtim', DriverRef.runtim)};
for i = 1:DriverRef.nparms
    str(i+1) = {sprintf('%s   %g', DriverRef.parms(i).name,...
                                   DriverRef.parms(i).val)};
end

str(DriverRef.nparms+2) = {sprintf('%s   %g', 'dt', DriverRef.dt)};
str(DriverRef.nparms+3) = {sprintf('%s   %g', 'opint', DriverRef.opint)};
set(handles.listparms,'String',str);

% --------------------------------------------------------------------
function varargout = listplot_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.listplot.