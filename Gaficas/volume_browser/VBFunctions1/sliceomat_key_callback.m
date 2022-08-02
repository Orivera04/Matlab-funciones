function sliceomat_key_callback(h,eventdata,handles,varargin)
% ein Act-Wert wurde manuell eingegeben -> Position der Slider aktualisieren

% Auslesen der Limits und Act-Werte
XAct=str2num(get(handles.sliceomat_xact,'String')); %#ok More than one value possible
YAct=str2num(get(handles.sliceomat_yact,'String')); %#ok More than one value possible
ZAct=str2num(get(handles.sliceomat_zact,'String')); %#ok More than one value possible
XMax=str2num(get(handles.sliceomat_xmax,'String')); %#ok More than one value possible
XMin=str2num(get(handles.sliceomat_xmin,'String')); %#ok More than one value possible
YMax=str2num(get(handles.sliceomat_ymax,'String')); %#ok More than one value possible
YMin=str2num(get(handles.sliceomat_ymin,'String')); %#ok More than one value possible
ZMax=str2num(get(handles.sliceomat_zmax,'String')); %#ok More than one value possible
ZMin=str2num(get(handles.sliceomat_zmin,'String')); %#ok More than one value possible

% Testen der Act-Werte ob innerhalb der Limits, ggf anpassen
if XAct<XMin 
   XAct=XMin;
end
if YAct<YMin
   YAct=YMin;
end
if ZAct<ZMin
   ZAct=ZMin;
end

if XAct>XMax
   XAct=XMax; 
end
if YAct>YMax 
   YAct=YMax; 
end
if ZAct>ZMax
    ZAct=ZMax; 
end

% Slider + Act-Werte im GUI Aktualisieren
set(handles.sliceomat_xslider,'Value',XAct);
set(handles.sliceomat_yslider,'Value',YAct);
set(handles.sliceomat_zslider,'Value',ZAct);
set(handles.sliceomat_xact,'String',num2str(XAct));
set(handles.sliceomat_yact,'String',num2str(YAct));
set(handles.sliceomat_zact,'String',num2str(ZAct));

% Aufruf Funktion Slicomat
sliceomat_callback(h, eventdata, handles, varargin);
