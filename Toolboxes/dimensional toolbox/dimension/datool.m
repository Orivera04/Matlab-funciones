function varargout = datool(varargin)
% DATOOL Application M-file for datool.fig
%    piset = DATOOL(Name,Unit) launch datool GUI.
%    DATOOL('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 11-Feb-2002 12:02:54

% Steffen Brueckner, 2002-02-07

if (nargin == 0) | (nargin == 2 & iscell(varargin{1}))  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

    % set simple warnings
    handles.wstat = warning;
    warning on
    
    if nargin == 0
        Names = {'var'};
        Units = {'0'};
    else
        Names = varargin{1};
        Units = varargin{2};
    end

    % define temporaray file names
    handles.TmpVarDim  = 'DimensionalMatrix';
    handles.TmpVarDMat = 'Dsubmatrix';
    
    % create a relevance list for the given problem
    handles.RL = rlist(Names,unit2si(Units));
    
    % find number of base variables
    [npi,nbase] = numpi(handles.RL);
    
    % Create empty dimensional set
    handles.piset = CreateEmptyPiSet;
    
    % determine and store number of equested output arguments
    handles.nargout = nargout;
    
    guidata(fig,handles);
    
    % initialize GUI objects with data
    set(findobj(fig,'Tag','lbVars'),'String',{handles.RL.Name});
    set(findobj(fig,'Tag','lbVars'),'Max',length({handles.RL.Name}));
    set(findobj(fig,'Tag','lbVars'),'Value',1);

    set(findobj(fig,'Tag','lbBaseVars'),'Value',1);
    set(findobj(fig,'Tag','lbBaseVars'),'String','');
    set(findobj(fig,'Tag','lbBaseVars'),'Max',1);

    set(findobj(fig,'Tag','lbDepVars'),'Value',1);
    set(findobj(fig,'Tag','lbDepVars'),'String','');
    set(findobj(fig,'Tag','lbDepVars'),'Max',1);
    
    set(findobj(fig,'Tag','lbPi'),'String','');

    set(findobj(fig,'Tag','edtNPi'),'String',num2str(npi));
    set(findobj(fig,'Tag','edtNBase'),'String',num2str(nbase));
    
	if nargout > 0
        % make it modal and wait for exit command
        uiwait(fig);
                
        if ishandle(fig)
            handles = guidata(fig);
            warning(handles.wstat);
            varargout{1} = handles.piset;
            delete(fig);
        end
	end

elseif nargin > 0 & ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		if (nargout)
			[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else
			feval(varargin{:}); % FEVAL switchyard
		end
	catch
		disp(lasterr);
	end
    
else
    error('calling syntax: datool(Name,Unit) or piset = datool(Name,Unit) or datool(''Method'',...)');
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
function varargout = btnToBase_Callback(h, eventdata, handles, varargin)
% move variable(s) to base variables
% Steffen Brueckner, 2002-02-07
    nr = get(handles.lbVars,'Value');
    s1 = get(handles.lbVars,'String');
    if isequal(s1,'')
        break;
    end
    s2 = get(handles.lbBaseVars,'String');
    s21 = s1(nr);
    ind = 1:length(s1);
    ind(nr) = 0; 
    ind = find(ind);
    s12 = s1(ind);
    if ~length(s12)
        s12 = '';
    end
    set(handles.lbVars,'String',s12);
    set(handles.lbVars,'Value',1);
    set(handles.lbBaseVars,'String',[s2 ; s21]);
    set(handles.lbVars,'Max',length(s12));
    set(handles.lbBaseVars,'Max',length([s2 ; s21]));   
    
    setAB(handles);
    
% --------------------------------------------------------------------
function varargout = btnFromBase_Callback(h, eventdata, handles, varargin)
% delete variable(s) from base variables
% Steffen Brückner, 2001-02-07
    nr = get(handles.lbBaseVars,'Value');
    s1 = get(handles.lbBaseVars,'String');
    if isequal(s1,'')
        break;
    end
    s2 = get(handles.lbVars,'String');
    s21 = s1(nr);
    ind = 1:length(s1);
    ind(nr) = 0; 
    ind = find(ind);
    s12 = s1(ind);
    if ~length(s12)
        s12 = '';
    end
    set(handles.lbBaseVars,'String',s12);
    set(handles.lbBaseVars,'Value',1);
    set(handles.lbVars,'String',[s2 ; s21]);
    set(handles.lbBaseVars,'Max',length(s12));
    set(handles.lbVars,'Max',length([s2 ; s21]));

    setAB(handles);
    
% --------------------------------------------------------------------
function varargout = btnFromDep_Callback(h, eventdata, handles, varargin)
% delete variable(s) from dependent variables
% Steffen Brückner, 2001-02-07
    nr = get(handles.lbDepVars,'Value');
    s1 = get(handles.lbDepVars,'String');
    if isequal(s1,'')
        break;
    end
    s2 = get(handles.lbVars,'String');
    s21 = s1(nr);
    ind = 1:length(s1);
    ind(nr) = 0; 
    ind = find(ind);
    s12 = s1(ind);
    if ~length(s12)
        s12 = '';
    end
    set(handles.lbDepVars,'String',s12);
    set(handles.lbDepVars,'Value',1);
    set(handles.lbVars,'String',[s2 ; s21]);
    set(handles.lbDepVars,'Max',length(s12));
    set(handles.lbVars,'Max',length([s2 ; s21]));

    setAB(handles);
    
% --------------------------------------------------------------------
function varargout = btnToDep_Callback(h, eventdata, handles, varargin)
% move variable(s) to dependent variables
% Steffen Brueckner, 2002-02-07
    nr = get(handles.lbVars,'Value');
    s1 = get(handles.lbVars,'String');
    if isequal(s1,'')
        break;
    end
    s2 = get(handles.lbDepVars,'String');
    s21 = s1(nr);
    ind = 1:length(s1);
    ind(nr) = 0; 
    ind = find(ind);
    s12 = s1(ind);
    if ~length(s12)
        s12 = '';
    end
    set(handles.lbVars,'String',s12);
    set(handles.lbVars,'Value',1);
    set(handles.lbDepVars,'String',[s2 ; s21]);
    set(handles.lbVars,'Max',length(s12));
    set(handles.lbDepVars,'Max',length([s2 ; s21]));   

    setAB(handles);
    
% --------------------------------------------------------------------
function varargout = btnEditDim_Callback(h, eventdata, handles, varargin)
% edit dimensional information for all(!) variables
% Steffen Brueckner, 2002-02-07
    RL = handles.RL;
    DMat = [RL.Dimension];
    DMat = matedit(DMat,{'M','L','T','Temp.','A','cd','n'},{RL.Name},...
                   'Edit Dimensional Matrix');

    if isequal(DMat,[])  % error in matedit
       istr = {'No LiteGrid plugin found'; ...
               'Starting Array Editor instead';....
               'Please re-load data after editing using';...
               '"Edit -> Reload Dimensions from WS" menu'};
       uiwait(msgbox(istr,'modal'));
       assignin('base',handles.TmpVarDim,[RL.Dimension]);
       evalin('base',['openvar(''' handles.TmpVarDim ''')']);
       break;
    end
           
    for ii=1:size(DMat,2)
        RL(ii).Dimension = DMat(:,ii);
    end
    handles.RL = RL;
    guidata(gcbo,handles);
    setAB(handles);

% --------------------------------------------------------------------
function varargout = btnEditD_Callback(h, eventdata, handles, varargin)
% edit the D-Matrix
% Steffen Brueckner, 2002-02-07
    [A,B,order] = getAB(handles);
    
    if ~checkdm(A,B)
        warning('base vars chosen inappropriately');
        break;
    else
        % dimensional set seems to be OK
        D = handles.piset.D;
        [r,c] = size(D);
        if (r ~= c) | (r ~= size(B,2))
            % if not exist, if not square, if not right size
            % Create new D matrix as identitiy matrix
            D = eye(size(B,2));
            handles.D = D;
            guidata(gcbo,handles);
        end
        for ii=1:size(B,2)
            P{ii} = ['pi_' num2str(ii)];
        end
        % Get variable names of dependent variables
        %Nd = get(handles.lbDepVars,'String');
        Nd = {handles.RL(order(1:size(B,2))).Name};
        
        D1 = matedit(D,P,Nd,'Edit D-Matrix');

        if isequal(D1,[])  % error in matedit
           istr = {'No LiteGrid plugin found'; ...
                   'Starting Array Editor instead';....
                   'Please re-load data after editing using';...
                   '"Edit -> Reload D-Matrix from WS" menu'};
           msgbox(istr);
           assignin('base',handles.TmpVarDMat,D);
           D = evalin('base',['openvar(''' handles.TmpVarDMat ''')']);
           break;
        else
           D = D1;
        end

        if (size(D,1) ~= size(D,2)) | (size(D,1) ~= rank(D))
            warning('D matrix must be regular');
        else
            % resort D submatrix according to relevance list
            D = created(handles.RL,Nd,D,Nd);
            % and store in figure data
            handles.piset.D = D;
            guidata(gcbo,handles);
        end
    end

    setAB(handles);
    
% --------------------------------------------------------------------
function varargout = btnOK_Callback(h, eventdata, handles, varargin)
% End datool and return piset if requested
% Steffen Brueckner, 2002-02-07

    % if no output parameters are specified delete figure and exit
    if handles.nargout == 0
        delete(handles.figure1);
        break;
    end

    % check if valid dimensional set, otherweise return
    % error message
    msg = chkDimensionalSet(handles.piset);
    if msg
        handles.piset = msg;
    end
    uiresume(handles.figure1);
        


% --------------------------------------------------------------------
function varargout = mnuFileLoadSet_Callback(h, eventdata, handles, varargin)
% Load Dimensional Set from File
% Steffen Brueckner, 2002-02-07
    [FILENAME,PATHNAME] = uigetfile({'*.mat','data files'},'Load Dimensional Set');
    if ~isequal(PATHNAME,0) & ~isequal(FILENAME,0)
        S = load(fullfile(PATHNAME,FILENAME));
        if isfield(S,'piset')
            handles.piset = S.piset;
            if isfield(S,'RL')
                handles.RL = S.RL;
            elseif isfield(S,'V')
                % support "old" file format
                handles.RL     = S.V;
            else
                warning('incompatible file format');
                break;
            end
            
            guidata(gcbo,handles);
            
            % put the corresponding variables to the listboxes
            piset = handles.piset;

            % base variables
            for ii = 1:size(piset.B,2)
                str{ii} = piset.Name{ii};
            end
            if size(piset.B,2) > 0
                set(handles.lbDepVars,'String',str);
                set(handles.lbDepVars,'Max'   ,length(str));
                set(handles.lbDepVars,'Value' ,1);
            else
                set(handles.lbDepVars,'String','');
                set(handles.lbDepVars,'Max'   ,1);
                set(handles.lbDepVars,'Value' ,1);
            end

            % dependent variables
            clear str
            for ii = 1:size(piset.A,2)
                str{ii} = piset.Name{ii + size(piset.B,2)};
            end
            if size(piset.A,2) > 0
                set(handles.lbBaseVars,'String',str);
                set(handles.lbBaseVars,'Max'   ,length(str));
                set(handles.lbBaseVars,'Value' ,1);
            else
                set(handles.lbBaseVars,'String','');
                set(handles.lbBaseVars,'Max'   ,1);
                set(handles.lbBaseVars,'Value' ,1);
            end

            % unassigned variables
            clear str
            jj = 1;
            for ii=1:length({handles.RL.Name})
                if isequal((strmatch(handles.RL(ii).Name,piset.Name,'exact')),[])
                    str{jj} = handles.RL.Name{ii};
                    jj = jj + 1;
                end
            end
            if jj > 1
                set(handles.lbVars,'String',str);
                set(handles.lbVars,'Max'   ,length(str));
                set(handles.lbVars,'Value' ,1);
            else
                set(handles.lbVars,'String','');
                set(handles.lbVars,'Max'   ,1);
                set(handles.lbVars,'Value' ,1);
            end
            
            setAB(handles);
        else
            warning('incompatible file format');
        end
    end

% --------------------------------------------------------------------
function varargout = mnuFileSaveSet_Callback(h, eventdata, handles, varargin)
% Save Dimensional Set
% Steffen Brueckner, 2002-02-07
    [FILENAME,PATHNAME] = uiputfile({'*.mat','data files'},'Save Dimensional Set');
    if ~isequal(PATHNAME,0) & ~isequal(FILENAME,0)
        piset = handles.piset;
        RL     = handles.RL;
        save(fullfile(PATHNAME,FILENAME),'piset','RL');
    end

% --------------------------------------------------------------------
function varargout = mnuFileLaTeX_Callback(h, eventdata, handles, varargin)
% Save Set as LaTeX file
% Steffen Brueckner, 2002-02-07
    [FILENAME,PATHNAME] = uiputfile({'*.tex','LaTeX files'},'Save LaTeX output');
    if ~isequal(PATHNAME,0) & ~isequal(FILENAME,0)
        texfile(fullfile(PATHNAME,FILENAME),handles.piset);
    end
    
% --------------------------------------------------------------------
function varargout = mnuFileExit_Callback(h, eventdata, handles, varargin)
% exit from datool
% Steffen Brueckner, 2002-02-07
    btnOK_Callback(h, eventdata, handles, varargin);

% --------------------------------------------------------------------
function varargout = mnuCopyPiset_Callback(h, eventdata, handles, varargin)
% copy piset to workspace
% Steffen Brueckner, 2002-02-07
    piset = handles.piset;
    assignin('base','piset',piset);
    
% --------------------------------------------------------------------
function varargout = WSReloadDim_Callback(h, eventdata, handles, varargin)
% load dimensional set from Workspace
% only intend for use on non-Windows OS
% Steffen Brueckner, 2002-02-11
    VarName = handles.TmpVarDim;
    
    if evalin('base',['exist(''' VarName ''',''var'')'])
        DMat = evalin('base',VarName);
        
        % check for validity
        if (size(DMat,1) ~= size(handles.RL(1).Dimension)) | ...
           (size(DMat,2) ~= length(handles.RL))
           warning('Data format incompatible');
           break;
        end
        
        for ii=1:size(DMat,2)
            handles.RL(ii).Dimension = DMat(:,ii);
        end
        guidata(gcbo,handles);
        setAB(handles);
    end
 
% --------------------------------------------------------------------
function varargout = WSReloadDMatrix_Callback(h, eventdata, handles, varargin)
% Reload D-matrix from workspace
% only intended for use on non-Windows OS
% Steffen Brückner, 2002-02-11
    VarName = handles.TmpVarDMat;

    if evalin('base',['exist(''' VarName ''',''var'')'])
        
        D = evalin('base',VarName');

        % check for validity
        if size(D) ~= size(handles.piset.D)
            warning('data format incompatible');
            break;
        end
        
        if (size(D,1) ~= size(D,2)) | (size(D,1) ~= rank(D))
            warning('D matrix must be regular');
        else
            handles.piset.D = D;
            guidata(gcbo,handles);
        end
        setAB(handles);
    end

% --------------------------------------------------------------------
function varargout = mnuHelpAbout_Callback(h, eventdata, handles, varargin)
% display about dialog
% Steffen Brueckner, 2002-02-07
    msg = {'Dimensional Analysis Tool for Matlab'; 'Version 1.0'; ...
           'Copyright (c) Steffen Brückner, 2002'; ...
           'http://www.sbrs.net/'; ...
           'brueckner@sbrs.net'};
   msgbox(msg,'About ...');


% --------------------------------------------------------------------
function varargout = mnuHlpHomepage_Callback(h, eventdata, handles, varargin)
% point web browser to dimensional analysis homepage
% Steffen Brueckner, 2002-02-07
    stat = web('http://www.sbrs.net/');
    if stat
        msg = {'Sorry, Matlab could not launch your web'; ...
               'browser. Please visit the author at'; ...
               'http://www.sbrs.net';...
               'brueckner@sbrs.net'};
       msgbox(msg,'Web Browser Failure');
   end

% --------------------------------------------------------------------
function varargout = lbPi_Callback(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = lbVars_Callback(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = lbBaseVars_Callback(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = lbDepVars_Callback(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = mnuFile_Callback(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = mnuEdit_Callback(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = mnuHelp_Callback(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = edtNBase_Callback(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = edtNPi_Callback(h, eventdata, handles, varargin)


% ====================================================================
function piset = CreateEmptyPiSet()
% creates an empty piset
% Steffen Brueckner, 2002-02-07
    piset.A = [];
    piset.B = [];
    piset.C = [];
    piset.D = [];
    piset.order = [];
    piset.Name  = [];
    
% -------------------------------------------------------------
function msg = chkDimensionalSet(piset)
% checks the dimensional set for consistency
% Steffen Brueckner, 2002-02-07
    msg = [];
    A = piset.A;
    B = piset.B;
    C = piset.C;
    D = piset.D;
    order = piset.order;
    Name  = piset.Name;
    
    if isequal(A,[])
        msg = 'no base variables selected or dimensional set invalid';
        break;
    end
    if isequal(B,[])
        msg = 'no dependent variables selected';
        break;
    end
    if size(B,1) ~= size(A,1)
        msg = 'A and B matrices must have same number of rows';
        break;
    end
    if ~isequal(D,[])
        if size(D,1) ~= size(D,2)
            msg = 'D matrix must be square';
            break;
        end
        if size(D,2) ~= size(B,2)
            msg = 'B and D matrices must have same number of columns';
            break;
        end
    end
    if ~isequal(C,[])
        if isequal(D,[])
            msg = 'C matrix without D matrix makes no sense';
            break;
        end
        if size(D,1) ~= size(C,1)
            msg = 'C and D matrices must have same number of rows';
            break;
        end
        if size(C,2) ~= size(A,2)
            msg = 'A and C matrices must have same number of columns';
            break;
        end
    end
    if ~checkdm([B A])
        msg = 'dimensional matrix invalid';
        break;
    elseif ~checkdm(A,B)
        msg = 'A matrix must have same rank as [B A]';
        break;
    end
    if length(order) ~= (size(B,2) + size(A,2))
        msg = 'order must be of same length as [B A] has columns';
        break;
    end
    if length(Name) ~= (size(B,2) + size(A,2))
        msg = 'Name must be of same length as [B A] has columns';
        break;
    end
    
% --------------------------------------------------------------------
function redraw_pis(handles)
% draws the pi variables to the listbox
% Steffen Brueckner, 2002-02-07
    piset = handles.piset;
    DC = [piset.D piset.C];
    
    % create strings with the equations
    for ii=1:size(DC,1)
        p1{ii} = ['pi' num2str(ii) '=1'];
        for jj=1:size(DC,2)
            if DC(ii,jj) ~= 0
                p1{ii} = [p1{ii} '*' piset.Name{jj} '^(' num2str(DC(ii,jj)) ')'];
            end
        end
    end

    % use my own display method
    kk = 1;
    for ii=1:size(DC,1)
        lside = ['pi' num2str(ii) ' = ']; 
        nenner  = [];
        zaehler = [];
        for jj = 1:size(DC,2)
            if DC(ii,jj) > 0
                nenner = [nenner ' ' piset.Name{jj} '^(' num2str(DC(ii,jj)) ')'];
            elseif DC(ii,jj) < 0
                zaehler = [zaehler ' ' piset.Name{jj} '^(' num2str(-DC(ii,jj)) ')'];
            end
        end
        lmax      = max(length(nenner),length(zaehler));
        clear leernenn leerzaeh bruch
        bruch(1:lmax) = '-';
        leernenn(1:(length(lside) + ceil((lmax - length(nenner))/2))) = ' ';
        leerzaeh(1:(length(lside) + ceil((lmax - length(zaehler))/2))) = ' ';

        if length(zaehler) > 0
            if length(nenner) < 1
                nenner = '1';
            end
            S{kk} = [leernenn nenner];   kk = kk + 1;
            S{kk} = [lside bruch];       kk = kk + 1;
            S{kk} = [leerzaeh zaehler];  kk = kk + 1;
            S{kk} = ' ';                 kk = kk + 1;
        else
            S{kk} = [lside nenner];      kk = kk + 1;
            S{kk} = ' ';                 kk = kk + 1;
        end
    end
    set(handles.lbPi,'String',S);
    
% -------------------------------------------------------------------------------
function setAB(handles)
% set the dimensional set according to the listboxes
% Steffen Brueckner, 2002-02-07
    [A,B,order] = getAB(handles);
    if checkdm(A,B)
        % dimensional set can be built
        handles.piset.A = A;
        handles.piset.B = B;
        if size(handles.piset.D,2) ~= size(B,2)
            handles.piset.D = eye(size(B,2));
        end
        handles.piset.C = -handles.piset.D * ( inv(A) * B)';
        handles.piset.order = order;
        handles.piset.Name  = {handles.RL(order).Name};
        guidata(gcbo,handles);
        redraw_pis(handles);    
    else
        handles.piset.A = [];
        handles.piset.B = [];
        handles.piset.C = [];
        handles.piset.D = [];
        handles.piset.order = [];
        handles.piset.D     = [];
        set(handles.lbPi,'String','');
        guidata(gcbo,handles);
    end

% -------------------------------------------------------------    
function [A,B,order] = getAB(handles)
% determine A and B matrices from GUI
% Steffen Brueckner, 2002-02-07
    A = [];
    B = [];
    order = [];
    
    sb   = get(handles.lbBaseVars,'String');    % base variables
    nb   = length(sb);
    sd   = get(handles.lbDepVars ,'String');    % dependent variables
    nd   = length(sd);
    su   = get(handles.lbVars ,'String');       % unused variables
    nu   = length(su);
    
    [nPi,nBase] = numpi(handles.RL);
%     if nb ~= nBase
%         break;
%     end
    
    if nb == 0 | isequal(sb,'')
        break;
    end
    if nd == 0 | isequal(sd,'')
        break;
    end

    % create a relevance list eliminating unselected
    % variables from the dimensional set
    [RL,order] = resortRL(handles.RL,[su ;sd ; sb]);
    
    % delete unused variables from relevance list
    RL = RL(nu+1:end);
    
    % and now create the A and B submmatrices
    [A,B,order1] = createab(RL,sb);
 
    if (size(A,1) ~= size(A,2)) | (rank(A) ~= size(A,1))
        A = [];
        B = [];
        order = [];
        break;
    end
    
    % incorporate new order1 to order vector
    order = order(order1 + nu);
    
% ----------------------------------------------------------
function [RLnew,order] = resortRL(RL,vars)
% RESORTRL resorts a relevance list for given variable names
%   [RL,order] = resortRK(RL,vars)

% Achtung: vars muss eine vollstaendige Liste der Variablen
% in der Relevanzliste sein, sonst bleiben nicht genannte
% Variablen nicht erhalten!

% Achtung: Mehrfachnennungen von Variablen werden nicht
% ueberprueft!

% Steffen Brückner, 2002-02-10

for ii=1:length(vars)
    jj = strmatch(vars{ii},{RL.Name},'exact');
    if isequal(jj,[])
        error('RESORTRL: variable not found in relevance list');
        break;
    end
    RLnew(ii) = RL(jj);
    order(ii) = jj;
end


