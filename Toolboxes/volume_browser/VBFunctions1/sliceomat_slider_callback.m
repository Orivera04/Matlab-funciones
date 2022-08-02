function sliceomat_slider_callback(hObject, eventdata, handles, varargin) %#ok Used in callback
% A slider has been moved; update Act values

%	Get slider values
XSlider=get(handles.sliceomat_xslider,'Value');
YSlider=get(handles.sliceomat_yslider,'Value');
ZSlider=get(handles.sliceomat_zslider,'Value');

%	Update "act" values
set(handles.sliceomat_xact,'String',num2str(XSlider));
set(handles.sliceomat_yact,'String',num2str(YSlider));
set(handles.sliceomat_zact,'String',num2str(ZSlider));

%	Call sliceomat
sliceomat_callback(hObject, eventdata, handles, varargin);
