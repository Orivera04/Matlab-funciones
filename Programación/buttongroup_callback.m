% buttongroup_callback
function buttongroup_callback(hObject,eventdata,handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h=gcbo; % Handle do objeto que chamou a funcao
sel = get(hObject,'SelectedObject'); % Obtem o handle do sub-item
switch get(sel,'Tag') % Tag
    case 'radiobutton1'
       msgbox('Botao 1');
    case 'radiobutton2'
       msgbox('Botao 2');
end