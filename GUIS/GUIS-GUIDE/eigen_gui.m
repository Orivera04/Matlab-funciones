function varargout = eigen_gui(varargin)
% This GUI demonstrates the iterative methods to find eigenvalues of a
% given matrix with given initial vector.
%
% Please start with 'eigen_gui' at command window. 
%
% Three methods are implemented for eigenvalues approximation
%
% 1) Power Method
% 2) Inverse Power Method
% 3) QR-Iteration
% 
%  Entered matrix A has to be non-singular and square.


% Author : Mirza Faisal Baig
% Version: 1.0
% Date   :   October 28, 2003
%
% Variable definitions within GUIDE:
%
% A            : Text box. User defined matrix.
% x_init       : Text box. User defined initial guess (starting point).
% tol          : Text box. User defined tolerence.
% max_iter     : Text box. Maximum number of iterations defined by the user.
% lembda_shift : Text box. Shift factor
% neu          : Found eigenvalues vector
% calculate    : Push Button. To calculate the display the eigenvalues
% clear        : Push Button. To start over and clear the plot figure
% info         : Push Button. To display help
% close        : Push Button. To close the application


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @eigen_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @eigen_gui_OutputFcn, ...
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes just before eigen_gui is made visible.
function eigen_gui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
movegui(hObject,'onscreen')
movegui(hObject,'center')
set(handles.lembda_shift,'Enable','Inactive');
set(handles.lembda_shift,'Backgroundcolor',[0.753 0.753 0.753]);
set(handles.shift_text,'Enable','Inactive');
set(handles.shift_text,'Foregroundcolor',[0.502 0.502 0.502]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs from this function are returned to the command line.
function varargout = eigen_gui_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes during object creation, after setting all properties.
function a_matrix_CreateFcn(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function a_matrix_Callback(hObject, eventdata, handles)
cla;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes during object creation, after setting all properties.
function xinit_CreateFcn(hObject, eventdata, handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function xinit_Callback(hObject, eventdata, handles)
cla;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes on button press in next_iter.
function find_eigen_Callback(hObject, eventdata, handles)
format long
cla;
A = str2num(get(handles.a_matrix,'String'));           % To read matrix A
size_A = size(A);                                      % Size of matrix A
%To check if matrix A is non-singular and square
if det(A)==0 
    errordlg('Matrix A is singular ','Error','modal')  % Display error message if A is singlar
    return                                             % Stop program execution
elseif size_A(1)~= size_A(2)
    errordlg('Matrix A is not square','Error','modal') % Display error message if A is not square
    return                                             % Stop program execution 
end

x_init = str2num((get(handles.xinit,'String')));       % To read inital x vector
tol = str2num(get(handles.tol,'String'));              % To read tolerence value

max_iter = str2num(get(handles.iter,'String'));
if get(handles.power_method,'Value') == 1                          % Power method
    [neu,k] = power_method(A,x_init,tol,max_iter);
    set(handles.eig_result,'String',num2str(neu(end)));            % Write the resulting eigenvalues
elseif get(handles.inv_power_method,'Value') == 1                  % Inverse Power method
    lembda_shift = str2num(get(handles.lembda_shift,'String'));    % To read shift value
    [neu,k] = inv_power_method(A,x_init,lembda_shift,tol,max_iter);
    set(handles.eig_result,'String',num2str(neu(end)));            % Write the resulting eigenvalues
elseif get(handles.qr_iteration,'Value') == 1                      % QR-Iteration
    [neu,k] = qr_iteration(A,tol,max_iter);
    set(handles.eig_result,'String',num2str(neu(end,:)'));         % Write the resulting eigenvalues
end

set(handles.plot_result,'HandleVisibility','ON')
plot(neu,'s-','linewidth',2),

if min(min(neu)) < 0 
    ylimlower = min(min(neu))*(1+0.02);
else
    ylimlower = min(min(neu))*(1-0.02);
end
if max(max(neu)) < 0 
    ylimupper = max(max(neu))*(1-0.01);
else
    ylimupper = max(max(neu))*(1+0.01);
end
axis([1 k ylimlower ylimupper])
if k > max_iter
    msgbox('Maximum Numer of Iterations reached!!!!','Message','help','modal')% Display message
end
format short


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tol_CreateFcn(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tol_Callback(hObject, eventdata, handles)
cla;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function clear_Callback(hObject, eventdata, handles)
cla;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function close_Callback(hObject, eventdata, handles)
clear all
close(gcbf)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function info_Callback(hObject, eventdata, handles)
open('eigengui_help.html')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function power_method_Callback(hObject, eventdata, handles)
cla;
set(handles.lembda_shift,'Enable','Inactive');
set(handles.lembda_shift,'Backgroundcolor',[0.753 0.753 0.753]);
set(handles.shift_text,'Enable','Inactive');
set(handles.shift_text,'Foregroundcolor',[0.502 0.502 0.502]);
set(handles.inv_power_method,'Value',0)
set(handles.qr_iteration,'Value',0)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function inv_power_method_Callback(hObject, eventdata, handles)
cla;
set(handles.lembda_shift,'Enable','ON');
set(handles.lembda_shift,'Backgroundcolor',[1 1 1]);
set(handles.shift_text,'Enable','ON');
set(handles.shift_text,'Foregroundcolor',[0 0 0]);
set(handles.power_method,'Value',0)
set(handles.qr_iteration,'Value',0)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function qr_iteration_Callback(hObject, eventdata, handles)
cla;
set(handles.lembda_shift,'Enable','Inactive');
set(handles.lembda_shift,'Backgroundcolor',[0.753 0.753 0.753]);
set(handles.shift_text,'Enable','Inactive');
set(handles.shift_text,'Foregroundcolor',[0.502 0.502 0.502]);
set(handles.inv_power_method,'Value',0)
set(handles.power_method,'Value',0)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Power method
function [neu,k] = power_method(A,x_init,tol,max_iter)
k = 1;
neu_0 = x_init'*A*x_init;
stop_flag = 0;
while stop_flag == 0,
    y = A*x_init;
    x_init = y/norm(y);
    neu(k) = x_init'*A*x_init;
    if abs(norm(neu(k)-neu_0)/norm(neu_0))<= tol
        stop_flag = 1;
    end
    neu_0=neu(k);
    k = k+1;
    if k > max_iter
        break
    end
end
neu = [neu_0 neu];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inverse Power Mothod
function [neu,k] = inv_power_method(A,x_init,lembda_shift,tol,max_iter);
neu_0 = x_init'*A*x_init;
stop_flag = 0;
k = 1;
while stop_flag == 0,
    temp_matrix = inv(A-lembda_shift*eye(size(A)));
    y = temp_matrix*x_init;
    x_init = y/norm(y);
    neu(k) = x_init'*temp_matrix*x_init;
    if abs(norm(neu(k)-neu_0)/norm(neu_0))<= tol
        stop_flag = 1;
    end
    neu_0=neu(k);
    k = k+1;
    if k > max_iter
        break
    end
end
neu = [neu_0 neu];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QR-Iteration Method
function [neu,k] = qr_iteration(A,tol,max_iter)
k = 1;
neu_0 = diag(A);
stop_flag = 0;

while stop_flag == 0;
    [Q,R] = qr(A);
    A = R*Q;
    neu(:,k) = diag(A);
    if abs(norm(neu(:,k)-neu_0)/norm(neu_0))<= tol
        stop_flag = 1;
    end
    neu_0=neu(:,k);
    k = k+1;
    if k > max_iter
        break
    end
end
neu = [neu_0 neu];
neu = neu';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function iter_CreateFcn(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function iter_Callback(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function lembda_shift_CreateFcn(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function lembda_shift_Callback(hObject, eventdata, handles)
cla;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function eig_result_CreateFcn(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function eig_result_Callback(hObject, eventdata, handles)


