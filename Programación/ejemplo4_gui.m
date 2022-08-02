val = str2double(get(handles.edit1,'String'));
% Determine whether val is a number between 0 and 1
if isnumeric(val) & length(val)==1 & ...
    val >= get(handles.slider1,'Min') & ...
    val <= get(handles.slider1,'Max')
    set(handles.slider1,'Value',val);
else
% Increment the error count, and display it
    handles.number_errors = handles.number_errors+1;
    guidata(hObject,handles); % store the changes
    set(handles.edit1,'String',...
    ['You have entered an invalid entry ',...
num2str(handles.number_errors),' times.']);
end