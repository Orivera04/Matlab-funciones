function varargout = addremovelist(varargin)

%
% ADDREMOVELIST creates a GUI which contains two main listboxes, one on the left and one
% on the right. With the usage of two buttons (Add/Remove) the user can select items from
% the list on the left and transfer them to the list on the right and vice versa. Two
% checkboxes allow selecting multiple elements from each list and sort the list contents
% respectively. Hitting the OK button returns ADDREMOVELIST outputs (depending on user
% selections) in MATLAB's workspace. Hitting the Cancel button returns default outputs.
%
% Syntax:
% ---------------------------
%
% addremovelist
% [new_right_contents]=addremovelist
% [new_right_contents,new_left_contents]=addremovelist
% [new_right_contents,new_left_contents,right_index]=addremovelist
% [new_right_contents,new_left_contents,right_index]=addremovelist
% [new_right_contents,new_left_contents,right_index,left_index]=addremovelist
%
% also...
%
% addremovelist
% [new_right_contents]=addremovelist(data)
% [new_right_contents,new_left_contents]=addremovelist(data)
% [new_right_contents,new_left_contents,right_index]=addremovelist(data)
% [new_right_contents,new_left_contents,right_index]=addremovelist(data)
% [new_right_contents,new_left_contents,right_index,left_index]=addremovelist(data)
%
% and also...
%
% addremovelist('PropertyName',PropertyValue)
% [new_right_contents]=addremovelist('PropertyName',PropertyValue)
% [new_right_contents,new_left_contents]=addremovelist('PropertyName',PropertyValue)
% [new_right_contents,new_left_contents,right_index]=addremovelist('PropertyName',PropertyValue)
% [new_right_contents,new_left_contents,right_index]=addremovelist('PropertyName',PropertyValue)
% [new_right_contents,new_left_contents,right_index,left_index]=addremovelist('PropertyName',PropertyValue)
%
% In the above possible syntaxes, addremovelist without any further input arguments
% creates a usage example, addremove(data) creates the main window with data being the
% contents of the list on the left and all other properties to their default values and
% addremovelist('PropertyName',PropertyValue) starts the program by setting pairs of
% possible properties which are described below.
%
% PropertyName          PropertyValue                                                  
% -----------------------------------------------------------------------------
% LeftContents          A cell array of strings containing the contents of the list on the
%                       left (theoretically the list from which the user chooses a subpart
%                       of it as the output
%
% RightContents         A cell array of strings containing the contents of the list on the
%                       right (the output list or a list for an invert process - that is
%                       given the 'output' list create and 'input' list). Note that if
%                       this property is given the return of content corresponding
%                       incdices (see further below) will not be possible. If you try
%                       otherwise, an error will be thrown
%         
% ListNames             A cell array of strings of length 2 containing names for the lists.
%                       The first part of it corresponds to the name of the left list and
%                       the second part to the name of the right list. If not given the
%                       lists are named 'List 1' and 'List 2' respectively
%
% Title                 A string (NOT a cell array) with the window title.
%
% MultiSelect           It should be set to true or false (default true). It controls
%                       whether the user can make multiple selections from both lists or
%                       not. This property can also be changed from within the GUI.
%
% KeepSorted            It should be set to true or false (default false). It controls
%                       whether the list contents (and their corresponding index) remains
%                       sorted during the selections or not. This property can also be 
%                       changed from within the GUI.
%
% Output arguments:
% ---------------------------
% Name                  Value                                                  
% -----------------------------------------------------------------------------
% new_right_contents    A cell array of strings containing the new contents of the list on
%                       the right.
%
% new_left_contents     A cell array of strings containing the new contents of the list on
%                       the left.
%
% right_index           The indices of the items on the right list (derived from the list
%                       on the left)
%
% right_index           The indices of the items on the left list (derived from the list
%                       on the right)
%
% Concerning the indices (right and left): suppose that the initial content of the left
% list is the cell {'Alpha','Bravo','Charlie','Delta'}. Then the corresponding indices are
% [1 2 3 4]. If the user selects 'Bravo' and 'Delta' to be transfered to the list on the
% right, then the indices on the left list become [1 3] and on the right list [2 4]. If we
% choose to sort the contents of the lists then the indices are sorted respectively.
%
% Usage Examples
%----------------------------
%
% Example 1:
%
% [new_right_contents] = addremovelist
%
% new_right_contents = 
% 
%     'Mary'
%     'John'
%     'Susan'
%
% Example 2
%
% lcon = {'Apples','Pears','Oranges','Strawberries','Cherries'};
% lnames = {'Fruits','Buy'};
% wtitle= 'Grocer list';
% 
% [new_right_contents,new_left_contents] = addremovelist('LeftContents',lcon,...
%                                                        'ListNames',lnames,...
%                                                        'Title',wtitle,...
%                                                        'KeepSorted',true)
%
% new_right_contents = 
% 
%     'Oranges'
%     'Pears'
%     'Strawberries'
% 
% 
% new_left_contents = 
% 
%     'Apples'
%     'Cherries'
%
% Example 3
%
% lcon = {'Analysis 1','Analysis 2','Analysis 3','Analysis 4','Analysis 5'};
% wtitle= 'Analysis Results';
% 
% [new_right_contents,new_left_contents,right_index,left_index] = ...
%     addremovelist('LeftContents',lcon,...
%                   'Title',wtitle,...
%                   'KeepSorted',true)
%
% new_right_contents = 
% 
%     'Analysis 2'
%     'Analysis 4'
%     'Analysis 5'
% 
% 
% new_left_contents = 
% 
%     'Analysis 1'
%     'Analysis 3'
% 
% 
% right_index =
% 
%      2     4     5
% 
% 
% left_index =
% 
%      1     3
%
% Example 4
%
% lcon = {'Mary','George','John','Sarah','Susan','Joe','Eric','Helen'};
% lnames = {'Friends','Guests'};
% wtitle = 'Party';
%
% [new_right_contents,new_left_contents,right_index,left_index] = ...
%     addremovelist('LeftContents',lcon',...
%                   'ListNames',lnames,...
%                   'Title',wtitle,...
%                   'KeepSorted',true)
%
% new_right_contents = 
% 
%     'Eric'
%     'Helen'
%     'John'
%     'Mary'
% 
% 
% new_left_contents = 
% 
%     'George'
%     'Joe'
%     'Sarah'
%     'Susan'
% 
% 
% right_index =
% 
%      1     3     5     6
% 
% 
% left_index =
% 
%      2     4     7     8
%
% Example 5
%
% lcon = {'Mary','George','John','Sarah'};
% rcon = {'Susan','Joe','Eric','Helen'};
% lnames = {'Friends','Guests'};
% wtitle = 'Party';
% 
% [new_right_contents,new_left_contents] = ...
%     addremovelist('LeftContents',lcon',...
%                   'RightContents',rcon,...
%                   'ListNames',lnames,...
%                   'Title',wtitle,...
%                   'KeepSorted',true)
%
% new_right_contents = 
% 
%     'Eric'
%     'Helen'
%     'Joe'
%     'John'
%     'Sarah'
%     'Susan'
% 
% 
% new_left_contents = 
% 
%     'George'
%     'Mary'
%
% =============================================================================
%
% Author        : Panagiotis Moulos (pmoulos@eie.gr)
% Version       : 1.0
% First created : June 10, 2007
% Last modified : June 10, 2007
% 




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @addremovelist_OpeningFcn, ...
                   'gui_OutputFcn',  @addremovelist_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before addremovelist is made visible.
function addremovelist_OpeningFcn(hObject, eventdata, handles, varargin)

% Set Window size and Position
set(handles.mainFigure,'Units','pixels')
screensize=get(0,'screensize');                       
winsize=get(handles.mainFigure,'Position');
winwidth=winsize(3);
winheight=winsize(4);
screenwidth=screensize(3);                           
screenheight=screensize(4);                           
winpos=[0.5*(screenwidth-winwidth),0.5*(screenheight-winheight),winwidth,winheight];                          
set(handles.mainFigure,'Position',winpos);

% Set all uicontrol units to normalized so as the default resize function works
set(handles.leftListName,'Units','normalized')
set(handles.rightListName,'Units','normalized')
set(handles.leftList,'Units','normalized')
set(handles.rightList,'Units','normalized')
set(handles.addElement,'Units','normalized')
set(handles.optionsPanel,'Units','normalized')
set(handles.removeElement,'Units','normalized')
set(handles.sortLists,'Units','normalized')
set(handles.allowMultiSelect,'Units','normalized')
set(handles.okButton,'Units','normalized')
set(handles.cancelButton,'Units','normalized')

% Initialize list contents by giving default values
handles.leftListContents='';
handles.rightListContents='';
handles.leftContents=handles.leftListContents;
handles.rightContents=handles.rightListContents;

% Define a flag for processing indices (if up position indices cannot be returned) and a
% flag to control whether the list contents are sorted or not and a multi-selection flag
handles.indflag=false;
handles.sort=false;
handles.multi=true;

% Get input variables from varargin and check for errors
if isempty(varargin) 
    % Create an example (initial contents always sorted)
    handles.leftListContents=sort({'Mary','George','John','Sarah','Susan'});
    % handles.leftListContents={'Analysis 1','Analysis 2','Analysis 3','Analysis 4','Analysis 5'};
    handles.rightListContents='';
    handles.leftContents=handles.leftListContents;
    handles.rightContents=handles.rightListContents;
    set(handles.leftList,'String',handles.leftListContents)
    set(handles.rightList,'String',handles.rightListContents)
    set(handles.leftListName,'String','Friends')
    set(handles.rightListName,'String','Guests')
    set(handles.mainFigure,'Name','Example of Add/Remove listboxes')
elseif length(varargin)==1
    if ~iscellstr(varargin{1})
        error('The first argument to %s must be a cell array of strings',mfilename)
    else
        % Initial contents always sorted
        handles.leftListContents=sort(varargin{1});
        handles.rightListContents='';
        handles.leftContents=handles.leftListContents;
        handles.rightContents='';
    end
elseif length(varargin)>1
    if rem(nargin,2)==0
        error('Incorrect number of arguments to %s.',mfilename);
    end
    okargs={'leftcontents','rightcontents','listnames','title','multiselect','keepsorted'};
    for i=1:2:length(varargin)-1
        parName=varargin{i};
        parVal=varargin{i+1};
        j=strmatch(lower(parName),okargs);
        if isempty(j)
            error('Unknown parameter name: %s.',parName);
        elseif length(j)>1
            error('Ambiguous parameter name: %s.',parName);
        else
            switch(j)
                case 1 % Left list contents
                    if ~iscellstr(parVal)
                        error('The %s parameter value must be a cell array of strings',parName)
                    else
                        % Initial contents always sorted
                        handles.leftListContents=sort(parVal);
                    end
                case 2 % Right list contents
                    if ~iscellstr(parVal) && ~isempty(parVal)
                        error('The %s parameter value must be a cell array of strings or empty',parName)
                    else
                         % Initial contents always sorted
                         handles.rightListContents=sort(parVal);
                    end
                case 3 % List names
                    if ~iscellstr(parVal) && ~length(parVal)==2
                        error('The %s parameter value must be a cell array of strings of length 2',parName)
                    else
                        set(handles.leftListName,'String',parVal{1})
                        set(handles.rightListName,'String',parVal{2})
                    end
                case 4 % Window title
                    if ~ischar(parVal)
                        error('The %s parameter value must be a string',parName)
                    else
                        set(handles.mainFigure,'Name',parVal)
                    end
                case 5 % Multiselection
                    if ~islogical(parVal)
                        error('The %s parameter value must be either true or false',parName)
                    else
                        if parVal
                            set(handles.allowMultiSelect,'Value',1)
                            handles.multi=true;
                        else
                            set(handles.allowMultiSelect,'Value',0)
                            handles.multi=false;
                        end
                    end
                case 6 % Keep contents and corresponding indices sorted
                    if ~islogical(parVal)
                        error('The %s parameter value must be either true or false',parName)
                    else
                        if parVal
                            set(handles.sortLists,'Value',1)
                            handles.sort=true;
                            handles.rightListContents=sort(handles.rightListContents);
                            handles.leftListContents=sort(handles.leftListContents);
                        else
                            set(handles.sortLists,'Value',0)
                            handles.sort=false;
                        end
                    end
                    
            end
        end
    end
end

% Initialize the listboxes (fill) and the indices of items
set(handles.leftList,'String',handles.leftListContents,'Value',1)
if handles.multi
    set(handles.leftList,'Max',length(handles.leftListContents))
end
if ~isempty(handles.rightListContents)
    set(handles.rightList,'String',handles.rightListContents,'Value',1)
    set(handles.removeElement,'Enable','on')
    if handles.multi
        set(handles.rightList,'Max',length(handles.rightListContents))
    end
    handles.indflag=true;
end
handles.leftIndices=1:length(handles.leftListContents);
handles.rightIndices=[];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes addremovelist wait for user response (see UIRESUME)
uiwait(handles.mainFigure);


% --- Outputs from this function are returned to the command line.
function varargout = addremovelist_OutputFcn(hObject, eventdata, handles) 

% Handles button press
if (get(handles.cancelButton,'Value')==0)
    delete(handles.mainFigure);
elseif (get(handles.okButton,'Value')==0)
    delete(handles.mainFigure);
end

% Get default command line output from handles structure
varargout{1}=handles.rightContents;
varargout{2}=handles.leftContents;
if ~handles.indflag
    varargout{3}=handles.rightIndices;
    varargout{4}=handles.leftIndices;
end


%%%%%%%%%%%%%%%%%%% BEGIN LISTBOXES %%%%%%%%%%%%%%%%%%%%

% --- Executes on selection change in leftList.
function leftList_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function leftList_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in rightList.
function rightList_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function rightList_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%% END LISTBOXES %%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%% BEGIN LISTBOX CONTROL BUTTONS %%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in addElement.
function addElement_Callback(hObject, eventdata, handles)

% Determine what remains and what is to be added
leftNames=get(handles.leftList,'String');
leftToAddInd=get(handles.leftList,'Value');
leftToAddNames=leftNames(leftToAddInd);

% Do the job
oldstr=get(handles.rightList,'String');
addstr=leftToAddNames;
verify=ismember(addstr,oldstr);
if isempty(oldstr)
    newstr=[oldstr;addstr];
elseif length(verify)==1
    if ~ismember(addstr,oldstr)
        newstr=[oldstr;addstr];
    else
        newstr=oldstr;
    end
else
    newstr=[oldstr;addstr];
end

% Update the right list...
set(handles.rightList,'String',newstr)
% Sort it if wanted
if handles.sort
    neweststr=sort(newstr);
    set(handles.rightList,'String',neweststr)
end
% Handle multiple selection possibility
if handles.multi
    set(handles.rightList,'Max',length(newstr))
end

% Update the left list by removing elements
remaining=leftNames;
remaining(leftToAddInd)=[];
set(handles.leftList,'String',remaining,'Value',1)
% Sort it if wanted
if handles.sort
    [remainingnew,remainind]=sort(remaining);
    set(handles.leftList,'String',remainingnew,'Value',1)
end
% Handle multiple selection possibility
if handles.multi
    set(handles.leftList,'Max',length(remaining))
end

% Fix the final indices vectors
if ~handles.indflag
    if ~handles.sort
        newindices=handles.leftIndices(leftToAddInd);
        handles.leftIndices(leftToAddInd)=[];
        handles.rightIndices=[handles.rightIndices,newindices];
    else
        newindices=handles.leftIndices(leftToAddInd);
        handles.leftIndices(leftToAddInd)=[];
        handles.leftIndices=handles.leftIndices(remainind);
        handles.rightIndices=sort([handles.rightIndices,newindices]);
    end
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % if size(handles.leftIndices,1)>size(handles.leftIndices,2)
% %     handles.leftIndices=handles.leftIndices';
% %     handles.rightIndices=handles.rightIndices';
% % end
% msgleft=['The left indices are : ',num2str(handles.leftIndices)];
% msgright=['The right indices are : ',num2str(handles.rightIndices)];
% disp(msgleft)
% disp(msgright)
% disp(' ')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Manage Add/Remove buttons
if ~isempty(get(handles.rightList,'String'))
    set(handles.removeElement,'Enable','on')
end
if isempty(get(handles.leftList,'String'))
    set(handles.addElement,'Enable','off')
end

% Update the output strings
handles.leftContents=get(handles.leftList,'String');
handles.rightContents=get(handles.rightList,'String');
guidata(hObject,handles);


% --- Executes on button press in removeElement.
function removeElement_Callback(hObject, eventdata, handles)

% Determine what remains and what is to be added
rightNames=get(handles.rightList,'String');
rightToRemoveInd=get(handles.rightList,'Value');
rightToRemoveNames=rightNames(rightToRemoveInd);

% Do the job
oldstr=get(handles.leftList,'String');
addstr=rightToRemoveNames;
verify=ismember(addstr,oldstr);
if isempty(oldstr)
    newstr=[oldstr;addstr];
elseif length(verify)==1
    if ~ismember(addstr,oldstr)
        newstr=[oldstr;addstr];
    else
        newstr=oldstr;
    end
else
    newstr=[oldstr;addstr];
end

% Update the reft list...
set(handles.leftList,'String',newstr)
% Sort it if wanted
if handles.sort
    neweststr=sort(newstr);
    set(handles.leftList,'String',neweststr)
end
% Handle multiple selection possibility
if handles.multi
    set(handles.leftList,'Max',length(newstr))
end

% Update the right list by removing elements
remaining=rightNames;
remaining(rightToRemoveInd)=[];
set(handles.rightList,'String',remaining,'Value',1)
% Sort it if wanted
if handles.sort
    [remainingnew,remainind]=sort(remaining);
    set(handles.rightList,'String',remainingnew,'Value',1)
end
% Handle multiple selection possibility
if handles.multi
    set(handles.rightList,'Max',length(remaining))
end

% Fix the final indices vectors
if ~handles.indflag
    if ~handles.sort
        newindices=handles.rightIndices(rightToRemoveInd);
        handles.rightIndices(rightToRemoveInd)=[];
        handles.leftIndices=[handles.leftIndices,newindices];
    else
        newindices=handles.rightIndices(rightToRemoveInd);
        handles.rightIndices(rightToRemoveInd)=[];
        handles.rightIndices=handles.rightIndices(remainind);
        handles.leftIndices=sort([handles.leftIndices,newindices]);
    end
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % if size(handles.leftIndices,1)>size(handles.leftIndices,2)
% %     handles.leftIndices=handles.leftIndices';
% %     handles.rightIndices=handles.rightIndices';
% % end
% msgleft=['The left indices are : ',num2str(handles.leftIndices)];
% msgright=['The right indices are : ',num2str(handles.rightIndices)];
% disp(msgleft)
% disp(msgright)
% disp(' ')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Manage Add/Remove buttons
if ~isempty(get(handles.leftList,'String'))
    set(handles.addElement,'Enable','on')
end
if isempty(get(handles.rightList,'String'))
    set(handles.removeElement,'Enable','off')
end

% Update the output strings
handles.leftContents=get(handles.leftList,'String');
handles.rightContents=get(handles.rightList,'String');
guidata(hObject,handles);

%%%%%%%%%%%%%%%%%% BEGIN LISTBOX CONTROL BUTTONS %%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%% BEGIN OPTIONS PANEL %%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in allowMultiSelect.
function allowMultiSelect_Callback(hObject, eventdata, handles)

if get(hObject,'Value')==1
    % Multiple selection allowed, maximum number of selections to length of contents
    handles.multi=true;
    set(handles.leftList,'Max',length(handles.leftContents))
else
    % Mutlple selection not allowed, current selection becomes the first item of possibly
    % a vector of selected items
    handles.multi=false;
    vals=get(handles.leftList,'Value');
    set(handles.leftList,'Value',vals(1),'Max',1)
end
guidata(hObject,handles);


% --- Executes on button press in sortLists.
function sortLists_Callback(hObject, eventdata, handles)

if get(hObject,'Value')==1
    handles.sort=true;
else
    handles.sort=false;
end
guidata(hObject,handles);

%%%%%%%%%%%%%%%%%% END OPTIONS PANEL %%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%% BEGIN CLOSE BUTTONS %%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in okButton.
function okButton_Callback(hObject, eventdata, handles)

uiresume(handles.mainFigure);


% --- Executes on button press in cancelButton.
function cancelButton_Callback(hObject, eventdata, handles)

% Return default values
handles.leftContents=handles.leftListContents;
handles.rightContents=handles.rightListContents;
if ~handles.indflag
    handles.leftIndices=1:length(handles.leftListContents);
    handles.rightIndices=[];
end
guidata(hObject,handles);
uiresume(handles.mainFigure);

%%%%%%%%%%%%%%%%%% END CLOSE BUTTONS %%%%%%%%%%%%%%%%%%%%
