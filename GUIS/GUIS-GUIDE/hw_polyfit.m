function varargout = hw_polyfit(varargin)
%     HW_POLYFIT: A GUI interface for curve fitting using MATLAB function
%                 POLYFIT.
%
%     This GUI gives control to the user for selection of the following features
%
%     ==>  degree of polynomial for cure fitting
%     ==>  number of points to be used for fitting
%     ==>  x- and y-axes limits
%     ==>  selection of points on the figure
%     
%     After making required selections, clicking on bush button
%     called "Select Points" will start point selection procedure and will
%     wait until user clicks on the figure to select points (on the figure area only).
%     Selected points are displayed with small red circles. 
%    
%     The bush button "FIT", could be used to plot the approximated curve
%     on the figure. If no points are selected, clicking on this button
%     will result in an error message. Also, user should be careful about the
%     selection of degree of polynomial and number of selected points,
%     i.e., number of points should be greater than the degree of
%     polynomial, else warning message will appear. 
%
%     "Clear", bush button clear the figure. "INFO" displays help,
%     and "CLOSE" exits program.

% Author : Mirza Faisal Baig
% Version: 1.0
% Date   : April 30, 2003


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @hw_polyfit_OpeningFcn, ...
                   'gui_OutputFcn',  @hw_polyfit_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes just before hw_polyfit is made visible.
function hw_polyfit_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hw_polyfit (see VARARGIN)

%handles.x_selected = 0;
%handles.y_selected = 0;
%handles.N = 0;

% Choose default command line output for hw_polyfit
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
movegui(hObject,'onscreen')
movegui(hObject,'center')
set(handles.degreepoly,'value',2);
set(handles.noofpoints,'value',5);
%set(handles.axes3)
% UIWAIT makes hw_polyfit wait for user response (see UIRESUME)
% uiwait(handles.figure1);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs from this function are returned to the command line.
function varargout = hw_polyfit_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes during object creation, after setting all properties.
function degreepoly_CreateFcn(hObject, eventdata, handles)
% hObject    handle to degreepoly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes on selection change in degreepoly.
function degreepoly_Callback(hObject, eventdata, handles)
% hObject    handle to degreepoly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = get(hObject,'String') returns degreepoly contents as cell array
%        contents{get(hObject,'Value')} returns selected item from degreepoly
%global x_selected y_selected
%cla;%to clear the figure



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes on button press in clearfigure.
function clearfigure_Callback(hObject, eventdata, handles)
% hObject    handle to clearfigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x_selected y_selected 
cla;%to clear the figure

% To clear the selected points also
%handles.x_selected = [];
%handles.y_selected = [];
x_selected = [];
y_selected = [];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Executes on button press in info.
function info_Callback(hObject, eventdata, handles)
% hObject    handle to info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpwin('hw_polyfit.m')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Executes on button press in selectpoints.
function selectpoints_Callback(hObject, eventdata, handles)
% hObject    handle to selectpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x_selected y_selected N 
N = (get(handles.noofpoints,'Value')); % to read the number of points from the GUI
%To read the limits of the axes from the GUI and convert them to numbers
xmin = str2num(get(handles.x_min,'String')); 
xmax = str2num(get(handles.x_max,'String'));
ymin = str2num(get(handles.y_min,'String'));
ymax = str2num(get(handles.y_max,'String'));
cla; %to clear figure
degree_poly = get(handles.degreepoly,'value');%degree of the polynomial
%to set x- and y-axis limits
set_x_limits(handles);
set_x_limits(handles);

%To select and plot the points on the figure
hold on
for i = 1:N
    [x_selected(i),y_selected(i)] = ginput(1);
    plot(x_selected(i),y_selected(i),'ro')
end
hold off 
%To sort the selected points, this gives user to select points in any order
[x_selected,index] = sort(x_selected);
y_selected = y_selected(index); % to be consistent with x-axis selected points
%handles.x_selected = x_selected;
%handles.y_selected = y_selected;
%handles.N = N;
%save temp1.mat handles


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Executes on button press in fitcurve.
function fitcurve_Callback(hObject, eventdata, handles)
global x_selected y_selected N coeff
cla;%to clear figure
%x_selected = handles.x_selected
%y_selected = handles.y_selected
%N = handles.N
degree_poly = get(handles.degreepoly,'value');%degree of the polynomial

%To check if the points are selected or not
if isempty(x_selected)==1 |  isempty(y_selected)==1
    errordlg('No points selected !!!','Error','modal')
end

%maximum x- and y-axis values to be used for positioning of the equation display on the plot
xmax = str2num(get(handles.x_max,'String'));
ymax = str2num(get(handles.y_max,'String'));

%to compute x values from minimum selected point to the maximum
x_new = x_selected(1):0.05:x_selected(N);

%function polyfit is used to find the coefficient of the estimated equation
coeff = polyfit(x_selected,y_selected,degree_poly);

%handles.coeff = coeff;
%to evalute y values for the estimated equation
y_new = polyval(coeff,x_new);

%to plot the selected points

hold on
for i = 1:N
    plot(x_selected(i),y_selected(i),'ro')
end
plot(x_new,y_new,'b')% to plot the estimated curve
%title(['y = ' char1(coeff)],'fontsize',10)

%equation display 
equation_text_display(handles);
hold off

%To display the waring dialog if degree of polynomial  is >= number of points
if degree_poly >= N
    warndlg('Polynomial is not unique; degree >= number of data points!!!','Warning','modal')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Executes during object creation, after setting all properties.
function noofpoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noofpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Executes on selection change in noofpoints.
function noofpoints_Callback(hObject, eventdata, handles)
% hObject    handle to noofpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = get(hObject,'String') returns noofpoints contents as cell array
%        contents{get(hObject,'Value')} returns selected item from noofpoints
global x_selected y_selected
cla;%to clear the figure

% To clear the selected points also
%handles.x_selected = [];
%handles.y_selected = [];
x_selected = [];
y_selected = [];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Executes during object creation, after setting all properties.
function x_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x_min_Callback(hObject, eventdata, handles)
% hObject    handle to x_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of x_min as text
%        str2double(get(hObject,'String')) returns contents of x_min as a double

%function to set limits of x-axis
set_x_limits(handles);

%equation display 
%equation_text_display(handles);
fitcurve_Callback(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes during object creation, after setting all properties.
function y_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y_min_Callback(hObject, eventdata, handles)
% hObject    handle to y_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of y_min as text
%        str2double(get(hObject,'String')) returns contents of y_min as a double

%function to set limits of y-axis
set_y_limits(handles);

%equation display 
%equation_text_display(handles);
fitcurve_Callback(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes during object creation, after setting all properties.
function y_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y_max_Callback(hObject, eventdata, handles)
% hObject    handle to y_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of y_max as text
%        str2double(get(hObject,'String')) returns contents of y_max as a double

%function to set limits of y-axis
set_y_limits(handles);

%equation display 
%equation_text_display(handles);
fitcurve_Callback(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Executes during object creation, after setting all properties.
function x_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x_max_Callback(hObject, eventdata, handles)
% hObject    handle to x_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of x_max as text
%        str2double(get(hObject,'String')) returns contents of x_max as a double
%global coeff
%function to set limits of x-axis
set_x_limits(handles);

%equation display 
%equation_text_display(handles);
fitcurve_Callback(hObject, eventdata, handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Executes on button press in close.
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all
close(gcbf)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function to change the x-axis limits
function set_x_limits(handles)
xmin = str2num(get(handles.x_min,'String'));
xmax = str2num(get(handles.x_max,'String'));
set(handles.axes1,'Xlim',[xmin xmax]) %to set the x-axis limits immidiately
%equation_text_display(handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function to change the y-axis limits
function set_y_limits(handles)
ymin = str2num(get(handles.y_min,'String'));
ymax = str2num(get(handles.y_max,'String'));
set(handles.axes1,'Ylim',[ymin ymax]) %to set the y-axis limits immidiately
%equation_text_display(handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function to change the y-axis limits
function equation_text_display(handles)
global coeff
%handles.coeff
xmin = str2num(get(handles.x_min,'String'));
xmax = str2num(get(handles.x_max,'String'));
ymin = str2num(get(handles.y_min,'String'));
ymax = str2num(get(handles.y_max,'String'));
text(xmax/2,ymax-0.5,['y = ',char1(coeff)],'color','blue','FontSize',10,'HorizontalAlignment','center')


%Function to create polynomial from coeff, to be diaplyed on the figure
function res = char1(coeff) 
if all(coeff == 0) 
     res = '0'; 
else 
     length_coeff = length(coeff) - 1; 
     res = []; 
     for temp_coeff = coeff; 
         if temp_coeff ~= 0; 
             if ~isempty(res) 
                  if temp_coeff > 0 
                      res = [res ' + ']; 
                  else 
                      res = [res ' - ']; 
                      temp_coeff = -temp_coeff; 
                  end 
             end 
             if temp_coeff ~= 1 | length_coeff == 0 
                  res = [res num2str(temp_coeff,2)]; 
                  if length_coeff > 0 
                      res = [res '']; 
                  end 
             end 
             if length_coeff >= 2 
                  res = [res 'x^' int2str(length_coeff)]; 
             elseif length_coeff == 1 
                  res = [res 'x']; 
             end 
         end 
         length_coeff = length_coeff - 1; 
     end 
end 
