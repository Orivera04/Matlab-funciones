function sliceomat_alpha_callback(h, eventdata, handles, varargin) %#ok Used in callback
% Transparenz wurde geändert 

%	Establish if single value has been selected and slices needs to be activated/deactivated
if get(handles.sliceomat_alpha,'Value')==1
   set(handles.sliceomat_alpha_single,'visible','on');    
else
   set(handles.sliceomat_alpha_single,'visible','off');
end

%	Call sliceomat
sliceomat_callback(h, eventdata, handles, varargin);
