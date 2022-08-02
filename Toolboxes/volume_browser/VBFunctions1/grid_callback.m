function grid_callback(varargin)
% --- Executes on button press in grid.
% hObject    handle to grid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Modified by E. Rietsch: October 15, 2006

% Hint: get(hObject,'Value') returns toggle state of grid

global V3D_HANDLES

%	Find menu item that turns the grid on and off 
tbgrid=findobj(V3D_HANDLES.figure_handle,'type','uimenu','Label','&Grid');

if strcmpi(get(V3D_HANDLES.axis_handle,'XGrid'),'off')
   grid(V3D_HANDLES.axis_handle,'on')
   set(tbgrid,'Checked','on');
   try
      set(varargin{1},'Value',1)
   catch
   end
else
   grid(V3D_HANDLES.axis_handle,'off')
   set(tbgrid,'Checked','off'); 
   try
      set(varargin{1},'Value',0)
   catch
   end
end
