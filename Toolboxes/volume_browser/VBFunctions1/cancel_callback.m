function cancel_callback(varargin)
% Cancels animation  in "sliceomat"

% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hObject=varargin{1};
ud=get(hObject,'UserData')
set(hObject,'userdata',1)
% tag=get(hObject,'Tag')
