function varargout = matrices_gui(varargin)
% matrices_gui Application M-file for matrices_gui.fig
%    FIG = matrices_gui launch matrices_gui GUI.
%    matrices_gui('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 18-Dec-2002 09:39:20


if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

	if nargout > 0
		varargout{1} = fig;
	end
	set(handles.Map,'Value',12);
	darstellungen_draw(handles);


elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
	catch
		disp(lasterr);
	end

end


%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.

% --------------------------------------------------------------------
% Wird beim Auswählen eines Elements aus der Matrixliste aktiviert
function varargout = Matrizen_Callback(h, eventdata, handles, varargin)
if get(handles.darstellungen,'Value') == 1
    darstellungen_draw(handles);
else
    analysen_draw(handles);
end
% --------------------------------------------------------------------
% Wird bei Veränderung der Dimension aktiviert
function varargout = Dimension_Callback(h, eventdata, handles, varargin)

if get(handles.darstellungen,'Value') == 1
    darstellungen_draw(handles);
else
    analysen_draw(handles);
end
% --------------------------------------------------------------------
% Holt sich das ausgewähle Element aus dem Farbschema
function varargout = Map_Callback(h, eventdata, handles, varargin)

mapcontents = get(handles.Map,'String');
map = mapcontents{get(handles.Map,'Value')};
colormap(map);
% --------------------------------------------------------------------
% Wird bei der Auswahl der Anzeige der Nichtnullelemente aktiviert
function varargout = showmarks_Callback(h, eventdata, handles, varargin)

if get(handles.darstellungen,'Value') == 1
    darstellungen_draw(handles);
end
% --------------------------------------------------------------------
% Wird beim Verändern der Markierungsgrösse aktiviert
function varargout = marksize_Callback(h, eventdata, handles, varargin)

if get(handles.darstellungen,'Value') == 1
    darstellungen_draw(handles);
end
%--------------------------------------------------------------------
% Schaltet in den Darstellungsmodus um
function varargout = darstellungen_Callback(h, eventdata, handles, varargin)
if get(handles.analysen,'Value') == 1
	set(handles.analysen,'Value',0);
	darstellungen_draw(handles);
end
%--------------------------------------------------------------------
% Schaltet in den Analysenmodus um
function varargout = analysen_Callback(h, eventdata, handles, varargin)
if get(handles.darstellungen,'Value') == 1
	set(handles.darstellungen,'Value',0);
    analysen_draw(handles);
end
% --------------------------------------------------------------------
% Berechnung der vollbesetzten Matrix A 
% Darstellung von A mit evtl. Anzeige der Nichtnullelemente
% Bestimmung der Dimension der Poisson-Matrix
function struktur_draw(handles)
contents = get(handles.Matrizen,'String');
type = contents{get(handles.Matrizen,'Value')};
mapcontents = get(handles.Map,'String');
map = mapcontents{get(handles.Map,'Value')};
if strcmp(type,'poisson')
    dim = round(sqrt(str2double(get(handles.Dimension,'String'))));
else
    dim = str2double(get(handles.Dimension,'String'));
end

axes(handles.bild1);
A = full(gallery(type,dim));
imagesc(A);
hold on;
if get(handles.showmarks,'Value') == 1
  get(handles.marksize,'Value');
  spy(A,'ks',str2double(get(handles.marksize,'String')));
end
xlabel('');
axis equal; axis tight;
colormap(map);
colorbar
hold off;
%--------------------------------------------------------------------
% Bestimmung der Inversen der Matrix A
% Darstellung vonA^(-1) mit evtl. Anzeige der Nichtnullelemente
% Bestimmung der Dimension der Poisson-Matrix
function inverse_draw(handles)
contents = get(handles.Matrizen,'String');
type = contents{get(handles.Matrizen,'Value')};
mapcontents = get(handles.Map,'String');
map = mapcontents{get(handles.Map,'Value')};
if strcmp(type,'poisson')
    dim = round(sqrt(str2double(get(handles.Dimension,'String'))));
else
    dim = str2double(get(handles.Dimension,'String'));
end

axes(handles.bild2);
A = inv(full(gallery(type,dim)));
imagesc(A);
hold on;
if get(handles.showmarks,'Value') == 1
  get(handles.marksize,'Value');
  spy(A,'ks',str2double(get(handles.marksize,'String')));
end
xlabel('');
axis equal; axis tight;
colormap(map);
colorbar
hold off;
%--------------------------------------------------------------------
% Berechnung der LR-Zerlegung von A
% Darstellung von L mit evtl. Anzeige der Nichtnullelemente
% Bestimmung der Dimension der Poisson-Matrix
function l_matrix_draw(handles)
contents = get(handles.Matrizen,'String');
type = contents{get(handles.Matrizen,'Value')};
mapcontents = get(handles.Map,'String');
map = mapcontents{get(handles.Map,'Value')};
if strcmp(type,'poisson')
    dim = round(sqrt(str2double(get(handles.Dimension,'String'))));
else
    dim = str2double(get(handles.Dimension,'String'));
end

axes(handles.bild3);
[L,R]=lu(full(gallery(type,dim)));
imagesc(L);
hold on;
if get(handles.showmarks,'Value') == 1
  get(handles.marksize,'Value');
  spy(L,'ks',str2double(get(handles.marksize,'String')));
end
xlabel('');
axis equal; axis tight;
colormap(map);
colorbar
hold off;
%--------------------------------------------------------------------
% Berechnung der LR-Zerlegung von A
% Darstellung von R mit evtl. Anzeige der Nichtnullelemente
% Bestimmung der Dimension der Poisson-Matrix
function r_matrix_draw(handles)
contents = get(handles.Matrizen,'String');
type = contents{get(handles.Matrizen,'Value')};
mapcontents = get(handles.Map,'String');
map = mapcontents{get(handles.Map,'Value')};
if strcmp(type,'poisson')
    dim = round(sqrt(str2double(get(handles.Dimension,'String'))));
else
    dim = str2double(get(handles.Dimension,'String'));
end
[L,R]=lu(full(gallery(type,dim)));
axes(handles.bild4)
imagesc(R);
hold on;
if get(handles.showmarks,'Value') == 1
  get(handles.marksize,'Value');
  spy(R,'ks',str2double(get(handles.marksize,'String')));
end
xlabel('');
axis equal; axis tight;
colormap(map);
colorbar
hold off;
%---------------------------------------------------------------------
% Berechnung der vollbesetzten Matrix A
% Darstellung der Matrixelemente von A als Text
% Bestimmung der Dimension der Poisson-Matrix
function matrix_draw(handles)
contents = get(handles.Matrizen,'String');
type = contents{get(handles.Matrizen,'Value')};
mapcontents = get(handles.Map,'String');
map = mapcontents{get(handles.Map,'Value')};
if strcmp(type,'poisson')
    dim = round(sqrt(str2double(get(handles.Dimension,'String'))));
else
    dim = str2double(get(handles.Dimension,'String'));
end

A = full(gallery(type,dim));

if strcmp(type,'poisson')
	dim = dim^2;
end

axes(handles.bild1);
plot(1,1,'w.');
cla;
hold on;
if dim<=10
	for k=1:dim
		for l=1:dim
			text(k,l,num2str(A(k,l),2),'HorizontalAlign','center','FontSize', ...
					 8);
		end
	end
	hold off;
else
	text(dim/2+1,dim/2,'Zu viele Werte für Detailansicht.','HorizontalAlign', ...
			 'center','FontSize', 10);
end
set(gca,'XLim',[0.5 dim+0.5]);
set(gca,'YLim',[0.5 dim+0.5]);
set(gca,'XTick',[]);
set(gca,'YTick',[]);
set(gca,'YDir','reverse');

% --------------------------------------------------------------------
% Berechnung der Eigenwerte und Eigenvectoren von A
% Darstellung der grössten und kleinsten Eigenwerte
% Bestimmung der Dimension der Poisson-Matrix
function eigenwerte_draw(handles);
contents = get(handles.Matrizen,'String');
type = contents{get(handles.Matrizen,'Value')};
if strcmp(type,'poisson')
    dim = round(sqrt(str2double(get(handles.Dimension,'String'))));
    dimscale(1:dim-1) = (2:dim).^2;
else
    dim = str2double(get(handles.Dimension,'String'));
	dimscale(1:dim-1) = 2:dim;
end

for k = 2:dim
    eigenwerte = eig(full(gallery(type,k)));
    max_eigenwerte(k-1) = max(eigenwerte);
    min_eigenwerte(k-1) = min(eigenwerte);
end

axes(handles.bild2);
plot(dimscale, max_eigenwerte,'-b.');
hold on;
plot(dimscale, min_eigenwerte,'-k.');
hold off;

% ------------------------------------------------------------------
% Berechnung und Darstellung der Kondition von A (in der Euklidischen Norm)
% Bestimmung der Dimension der Poisson-Matrix
function kondition_draw(handles)
contents = get(handles.Matrizen,'String');
type = contents{get(handles.Matrizen,'Value')};
if strcmp(type,'poisson')
    dim = round(sqrt(str2double(get(handles.Dimension,'String'))));
else
    dim = str2double(get(handles.Dimension,'String'));
end

for k = 2:dim
      c(k-1) = cond(full(gallery(type,k)));
end

axes(handles.bild3);
plot(2:dim,c,'-b.');
%--------------------------------------------------------------------
% Berechnung und Darstellung der Anzahl der Nichtnullelemente von A, L und R
% Bestimmung der Dimension der Poisson-Matrix
function nichtnull_draw(handles)
contents = get(handles.Matrizen,'String');
type = contents{get(handles.Matrizen,'Value')};
if strcmp(type,'poisson')
    dim = round(sqrt(str2double(get(handles.Dimension,'String'))));
else
    dim = str2double(get(handles.Dimension,'String'));
end

for k = 2:dim
    [L,R]=lu(full(gallery(type,k)));
    a_1(k-1) = nnz(full(gallery(type, k)));
    a_2(k-1) = nnz(L);
    a_3(k-1) = nnz(R);
end
axes(handles.bild4);
plot(2:dim,a_1,'-k.');
hold on
plot(2:dim,a_2,'-b.');
hold on
plot(2:dim,a_3,'-r.');
hold off
%--------------------------------------------------------------------
% Anzuzeigender Text der Matrixdarstellungen wird gesetzt
% Matrixdarstellungen, d.h. die Funktionen zur Struktur, Inverse, 
% L-Matrix und R-Matrix werden aufgerufen und ausgeführt
function darstellungen_draw(handles)
if get(handles.darstellungen,'Value') == 1
    set(handles.text1,'String','Struktur')
    set(handles.text1,'Visible','On')
    struktur_draw(handles);
    set(handles.text2,'String','Inverse')
    set(handles.text2,'Visible','On')
    inverse_draw(handles);
    set(handles.text3,'String','L-Matrix')
    set(handles.text3,'Visible','On')
    l_matrix_draw(handles);
    set(handles.text4,'String','R-Matrix')
    set(handles.text4,'Visible','On')
    r_matrix_draw(handles);
end
%---------------------------------------------------------------------
% Anzuzeigender Text der Matrixanalysen wird gesetzt
% Matrixanalysen, d.h. die Funktionen zur Matrix, Eigenwerte, Kondition
% und Nichtnullelemente werden aufgerufen und ausgeführt
function analysen_draw(handles)
if get(handles.analysen,'Value') == 1
    set(handles.text1,'String','Matrix')
    set(handles.text1,'Visible','On')
    matrix_draw(handles);
    set(handles.text2,'String','Eigenwerte')
    set(handles.text2,'Visible','On')
    eigenwerte_draw(handles);
    set(handles.text3,'String','Kondition')
    set(handles.text3,'Visible','On')
    kondition_draw(handles);
    set(handles.text4,'String','Nichtnullelemente')
    set(handles.text4,'Visible','On')
    nichtnull_draw(handles);
end




