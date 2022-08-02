function varargout = matedit(varargin)
% MATEDIT matrix editor using GridLite ActiveX plugin
%  M = MATEDIT(Min,RNames,CNames,FigName) provides a GUI 
%  matrix editor for the matrix Min using the column names
%  CNames and the row names RNames. FigName is the window
%  title.
%  If LiteGrid is not installed an empty matrix is returned.

% function     matedit(CBName,h,eventdata,handles,varargin)
% function M = matedit(M,CNames,RNames,FigName)

% Dimensional Analysis Toolbox for Matlab
% Steffen Brueckner, 2002-02-07

% --------------------------------------
% VERSION HISTORY
% --------------------------------------
% V1.01: 2002-02-14 Bü
%        + Load and Save implemented
%        + Clear button added
% V1.01: 2002-02-18 Bü
%        + Cancel button added
% --------------------------------------

if nargin == 0
    error('wrong number of input arguments');
    break;
end

% check if GUI command
if ischar(varargin{1})
	try
		if (nargout)
			[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else
			feval(varargin{:}); % FEVAL switchyard
		end
	catch
		disp(lasterr);
	end

    break;
end

% Check input arguments
msg = nargchk(1,4,nargin);
if msg
    error(msg);
    break;
end

% check operating system
if ispc
    % Windows systems with (hopefully) LiteGrid ActiveX control
    M = varargin{1};
    if nargin > 1
        RNames = varargin{2};
    end
    if nargin > 2
        CNames = varargin{3};
    end
    if nargin > 3
        FigName = varargin{4};
    else
        FigName = 'Dimensional Analysis Toolbox: Matrix Editor';
    end

    % name of the ActiveX control
    progid = 'LiteGrid.LiteGrid.1';

    % figure position
    fposition = [100 100 400 270];
    % grid position
    gposition = [0 20 400 250];
    % button position
    bposition = [350 0 50 20];   % Ok
    aposition = [290 0 50 20];   % Cancel
    lposition = [  0 0 50 20];   % Load
    sposition = [ 60 0 50 20];   % Save
    rposition = [120 0 50 20];   % Reset
    cposition = [180 0 50 20];   % Clear
	
	% we need to pump the data in by a for loop, which is going to take
	% some time.  therefore, turn visibility off until we are all
	% setup.
	parent = figure(...
       'Name',FigName,...
       'NumberTitle','off',...
       'Position',fposition,...
       'Resize','off',...
       'Visible','off',...
       'Menubar','none',...
       'Units','normalized',...
       'WindowStyle','modal');
	
	% create ok button
	btnOK = uicontrol('Tag','btnOK',...
                      'String','OK',...
                      'Callback','matedit(''btnOK_Callback'',gcbo,[],guidata(gcbo))',...
                      'Position',bposition);

	% create cancel button
	btnCancel = uicontrol('Tag','btnCancel',...
                      'String','Cancel',...
                      'Callback','matedit(''btnCancel_Callback'',gcbo,[],guidata(gcbo))',...
                      'Position',aposition);

	%  create load button
	btnLoad = uicontrol('Tag','btnLoad',...
                        'String','Load',...
                        'Enable','on',...
                        'Callback','matedit(''btnLoad_Callback'',gcbo,[],guidata(gcbo))',...
                        'Position',lposition);
	
	%  create save button
	btnSave = uicontrol('Tag','btnSave',...
                        'String','Save',...
                        'Enable','on',...
                        'Callback','matedit(''btnSave_Callback'',gcbo,[],guidata(gcbo))',...
                        'Position',sposition);
	
	% create reset button
	btnReset = uicontrol('Tag','btnReset',...
                        'String','Reset',...
                        'Callback','matedit(''btnReset_Callback'',gcbo,[],guidata(gcbo))',...
                        'Position',rposition);
	
	btnClear = uicontrol('Tag','btnClear',...
                        'String','Clear',...
                        'Callback','matedit(''btnClear_Callback'',gcbo,[],guidata(gcbo))',...
                        'Position',cposition);
	
	% instanciate our control
	try
        gridh = actxcontrol(progid, gposition, parent);
	catch
        varargout{1} = [];
        %warning('MATEDIT requires LiteGrid ActiveX control');
	end
	
	% create structure of handles
	handles = guihandles(parent);
	handles.figure1 = parent;
	handles.M       = M;
    handles.M0      = M;
	handles.gridh   = gridh;
    handles.cancel  = 0;
	guidata(parent,handles);
	
	% grow the number of rows and cols
	set(gridh,'Rows',size(M,1)+1);
	set(gridh,'Cols',size(M,2)+1);
	
	% set row names
	if nargin > 1
        for ii = 1:length(RNames)
            set(gridh,'CellText',ii,0,RNames{ii});
        end
	end
	
	if nargin > 2
        for ii = 1:length(CNames)
            set(gridh,'CellText',0,ii,CNames{ii});
        end
	end
	
	for ii = 1:size(M,1)
        for jj = 1:size(M,2)
            set(gridh,'CellText',ii,jj,num2str(M(ii,jj)));
        end
	end
	
	% now that all of the data is in, make the figure visible
	set(parent,'Visible','on')
	
	uiwait(parent);
	
	% read matrix from table
	handles = guidata(parent);
    if ~handles.cancel
        % if not cancel
      	M = handles.M;
    	for ii = 1:size(M,1)
            for jj = 1:size(M,2)
                M(ii,jj) = str2double(get(gridh,'CellText',ii,jj));
            end
    	end
    else
        M = handles.M0;
    end
	
	varargout{1} = M;
	% close window if necessary
	if ishandle(parent)
        delete(parent);
	end
else
    varargout{1} = [];
    %warning('matedit requires PC with ActiveX controls');
    break;
end

% -------------------------------------------------------
function varargout = btnOK_Callback(h,eventdata,handles,varargin)
% OK button pressed
% Steffen Brueckner, 2002-02-07
    uiresume(handles.figure1);
    
function varargout = btnCancel_Callback(h,eventdata,handles,varargin)
% Cancel button pressed
% Steffen Brueckner, 2002-02-18
    handles.cancel = 1;
    guidata(gcbo,handles);
    uiresume(handles.figure1);

% -------------------------------------------------------
function varargout = btnLoad_Callback(h,eventdata,handles,varargin)
% Load Matrix from file
% Steffen Brueckner, 2002-02-14
    [Fname,Pname] = uigetfile({'*.mat','Matlab data files (*.mat)'},'Load matrix');
    
    if ~isequal(Fname,0) & ~isequal(Pname,0)
        S = load(fullfile(Pname,Fname));
        N = fieldnames(S);
        if length(N) ~= 1
            warning('Only one matrix in mat-file allowed');
            break;
        end
        M = getfield(S,N{1});
        % determine matrix size
        [r,c] = size(M);
        if r ~= size(handles.M,1) | c ~= size(handles.M,2)
            warning('incorrect matrix size');
            break;
        end
    handles.M = zeros([size(handles.M,1) size(handles.M,2)]);
    guidata(gcbo,handles);

    % and fill the control again
    for ii = 1:size(M,1)
        for jj = 1:size(M,2)
            set(handles.gridh,'CellText',ii,jj,num2str(M(ii,jj)));
        end
    end
    set(handles.gridh,'Visible',0);
    pause(0.01);
    set(handles.gridh,'Visible',1);        
    end
    
% -------------------------------------------------------
function varargout = btnSave_Callback(h,eventdata,handles,varargin)
% Save matrix to file
% Steffen Brückner, 2002-02-14

    [Fname,Pname] = uiputfile({'*.mat','Matlab data files (*.mat)'},'Save matrix');
    
    if ~isequal(Fname,0) & ~isequal(Pname,0)
        M = zeros(size(handles.M));
        for ii=1:size(handles.M,1)
            for jj=1:size(handles.M,2)
                M(ii,jj) = str2num(get(handles.gridh,'CellText',ii,jj));
            end
        end
        save(fullfile(Pname,Fname),'M');
    end
% -------------------------------------------------------
function varargout = btnReset_Callback(h,eventdata,handles,varargin)
% Reset button pressed
% Steffen Brueckner 2002-02-07
    handles.M = eye([size(handles.M,1) size(handles.M,2)]);
    guidata(gcbo,handles);

    % and fill the control again
    M = handles.M;
    for ii = 1:size(M,1)
        for jj = 1:size(M,2)
            set(handles.gridh,'CellText',ii,jj,num2str(M(ii,jj)));
        end
    end
    set(handles.gridh,'Visible',0);
    pause(0.01);
    set(handles.gridh,'Visible',1);
    
% -------------------------------------------------------
function varargout = btnClear_Callback(h,eventdata,handles,varargin)
% Reset button pressed
% Steffen Brueckner 2002-02-14
    handles.M = zeros(size(handles.M));
    guidata(gcbo,handles);

    % and fill the control again
    M = handles.M;
    for ii = 1:size(M,1)
        for jj = 1:size(M,2)
            set(handles.gridh,'CellText',ii,jj,num2str(M(ii,jj)));
        end
    end
    set(handles.gridh,'Visible',0);
    pause(0.01);
    set(handles.gridh,'Visible',1);