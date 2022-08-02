function uipelda(command)
% function uipelda
%
% P�lda grafikus MATLAB felhaszn�l�i fel�let l�trehoz�s�ra
% Csak 4.2, vagy magasabb verzi�val m�k�d�k�pes

% � Simon Gyula, 1998; program a Grafikai felhasznaloi fel"uletek c. reszhez

vers=version; vers=str2num(vers(1:3));
if vers < 4.2 
   error('4.2, vagy magasabb verzi� kell...')
end

if nargin==0 % inicializ�l�s
   if vers < 5
      f=findobj('Tag', 'uicontrol_demo_fig');
   else
      % megtal�lja a rejtett ablakot is:
      f=findobj(allchild(0), 'flat', 'Tag', 'uicontrol_demo_fig');
   end
   if ~isempty(f)
      % Ha m�r l�tezik az ablak, akkor csak el�rehozzuk
      figure(f)
   else % Ha nem l�tezik az ablak, akkor l�trehozzuk
      f=figure('Name',       'Uicontrol p�lda', ...
         'Numbertitle',      'off', ...
         'Units',            'pixels', ...
         'Position',         [100 100 500 300], ...
         'Tag',              'uicontrol_demo_fig'); 
      h_axes=axes('Parent',  f, ...
         'Units',            'pixels', ...
         'Position',         [40 100 300 170], ...
         'Color',            'w', ...
         'Box',              'on', ...
         'ButtonDownFcn',    'uipelda(''click_on_axes'')', ...
         'Tag',              'demo_axes');
      axis([0 1 -1.1 1.1]); 
      xlabel('t', 'units', 'normalized', 'position', [1.05,-0.05]); 
      % L�trej�tt az axes a megfelel� axis �s xlabel be�ll�t�sokkal.
      % Most k�sz�t�nk egy �res vonal (line) objektumot, az �br�t 
      % ennek seg�ts�g�vel fogjuk rajzolni.
      h_line=line('Parent',  h_axes, ...
         'ButtonDownFcn',    'uipelda(''click_on_line'')',...
         'Tag',              'demo_line');
      % A kezel�szervek (uicontrol objektumok) l�trehoz�sa
      h_pop=uicontrol('Parent', f, ...
         'Style', 'popupmenu', ...
         'Units', 'pixels', ...
         'Position', [380 250 110 20], ...
         'String', 'Piros|S�rga|Z�ld',...
         'Callback', 'uipelda(''popup'')', ...
         'Tag', 'color_pop');
      h_freq_slider=uicontrol('Parent', f, ...
         'Style', 'slider', ...
         'Units', 'pixels', ...
         'Position', [40 10 300 20], ...
         'Min', 0, ...
         'Max', 10, ...
         'Value', 5, ...
         'Callback', 'uipelda(''slider'')', ...
         'Tag', 'freq_slider');
      h_text=uicontrol('Parent', f, ...
         'Style', 'text', ...
         'Units', 'pixels', ...
         'Position', [40 35 20 20], ...
         'String', 'f=');
      h_editbox=uicontrol('Parent', f, ...
         'Style', 'edit', ...
         'Units', 'pixels', ...
         'Position', [65 35 70 20], ...
         'Callback', 'uipelda(''edit'')', ...
         'Tag', 'freq_edit');
      h_frame=uicontrol('Parent', f, ...
         'Style', 'frame', ...
         'Units', 'pixels', ...
         'Position', [380 160 110 70]);
      h_rb1=uicontrol('Parent', f, ...
         'Style', 'radiobutton', ...
         'Units', 'pixels', ...
         'Position', [390 200 90 20], ...
         'string', 'Sin', ...
         'Value', 1, ...
         'Callback', 'uipelda(''fcn1'')', ...
         'UserData', 'fcn_radio_group', ...
         'Tag', 'rb_fcn1');
      h_rb2=uicontrol('Parent', f, ...
         'Style', 'radiobutton', ...
         'Units', 'pixels', ...
         'Position', [390 170 90 20], ...
         'string', 'Sinc', ...
         'Value', 0, ...
         'Callback', 'uipelda(''fcn2'')', ...
         'UserData', 'fcn_radio_group', ...
         'Tag', 'rb_fcn2');
      
      h_mainmenu=uimenu(f, 'Label', 'F�ggv�n&y');
      h_menu1=uimenu(h_mainmenu, 'Label', 'Si&n',...
         'callback', 'uipelda(''fcn1'')', ...
         'UserData', 'fcn_menu_group', ...
         'Checked', 'on', ...
         'Tag', 'menu_fcn1');
      
      h_menu2=uimenu(h_mainmenu, 'Label', 'Sin&c', ...
         'callback', 'uipelda(''fcn2'')', ...
         'UserData', 'fcn_menu_group', ...
         'Tag', 'menu_fcn2');
      
      % Az ablak h�tt�rsz�n�t azonosra �ll�tjuk a kezel�szervek�vel
      BackGrColor=get(h_rb2, 'BackgroundColor');
      set(f, 'Color', BackGrColor);
      
      uipelda('slider') % Az editbox �s az �bra inicializ�l�sa
      uipelda('popup')  % A sz�n be�ll�t�sa
      
      % Az al�bbi funkci�k csak az 5.1 verzi�t�l kezdve m�k�dnek
      if vers >= 5
         set(f, 'ResizeFcn', 'uipelda(''resize'')') % egyszer� resize
         set(f, 'HandleVisibility', 'Callback') % GUI rejt�s
      end
   end % iniciali�l�s v�ge
elseif findstr(command, 'popup')   
   % ___Sz�nv�laszt� popupmenu callback___
   % Be�ll�tja vonalat �s a saj�t h�tt�rsz�n�t a popup �ll�sa szerint
   h_color=findobj('Tag', 'color_pop');
   h_line=findobj('Tag', 'demo_line');
   ColVect='ryg'; Color=ColVect(get(h_color, 'Value'));
   set(h_line, 'Color', Color), set(h_color, 'BackgroundColor', Color)
   
elseif findstr(command, 'fcn')   
   % ___F�ggv�nyv�laszt� r�di�gomb/menu callback___
   % Valamennyi (jelenleg 2 db), a csoportba tartoz� r�di�gombot
   % kiengedett �llapotba hozza (Value=0), csak a h�v� objektumot
   % �ll�tja megnyomott �llapotba (Value=1).(A csoportot az 
   % azonos �rt�k� UserData azonos�tja.) 
   % Hasonl�an a men�k Checked tulajdons�g�t is �ll�tja.
   % �jrarajzolja az �br�t.
   h_selected_rb=findobj('Tag', ['rb_' command]);
   h_selected_menu=findobj('Tag', ['menu_' command]);
   h_all_radio=findobj('UserData', 'fcn_radio_group');
   h_all_menu=findobj('UserData', 'fcn_menu_group');
   set(h_all_radio, 'Value', 0); set(h_selected_rb, 'value', 1)
   set(h_all_menu, 'Checked', 'off'); set(h_selected_menu, 'Checked', 'on')
   uipelda('redraw')
   
elseif strcmp(command, 'slider')
   % ___Frekvenciabe�ll�t� slider callback___
   % Be�ll�tja az editbox �rt�k�t a slider helyzet�nek megfelel�en, 
   % majd �jrarajzolja az �br�t
   h_freq_slider=findobj('Tag', 'freq_slider'); 
   h_freq_edit=findobj('Tag', 'freq_edit'); 
   freq=get(h_freq_slider, 'Value'); % frekvencia=slider helyzet
   set(h_freq_edit, 'String', num2str(freq)) 
   uipelda('redraw')
   
elseif strcmp(command, 'edit')
   % ___Frekvenciabe�ll�t� editbox callback___
   % Ellen�rzi a bevitt �rt�ket, korrig�l, ha sz�ks�ges, be�ll�tja
   % a slider helyzetet�t az editbox �rt�k�nek megfelel�en, majd 
   % �jrarajzolja az �br�t
   h_freq_slider=findobj('Tag', 'freq_slider');
   h_freq_edit=findobj('Tag', 'freq_edit');
   freq=str2num(get(h_freq_edit, 'String'));
   if isempty(freq), freq=0; end % nem sz�m !!!
   if freq<0, freq=0; elseif freq>10, freq=10; end
   set(h_freq_edit, 'String', num2str(freq))
   set(h_freq_slider, 'Value', freq)
   uipelda('redraw')
   
elseif strcmp(command, 'click_on_line')
   % ___Kattint�s a vonalra___ 
   % A kurzor k�r alak�v� v�lik �s l�trehoz egy text objektumot 
   % a kattint�s poz�ci�ja mell�, ahova az eg�r felenged�s�ig a 
   % WindowButtonMotionFcn ki fogja �rna az aktu�lis kurzorpozici�t. 
   % Inicializ�lja a WindowButtonMotionFcn-t �s a WindowButtonUpFcn-t.
   CurrPoint=get(gca, 'CurrentPoint'); 
   x=CurrPoint(1,1); y=CurrPoint(1,2);
   text(x, y, sprintf('  (%1.3g, %1.3g)', x, y),...
      'color', [1 0 1], 'Tag', 'text_position')
   set(gcf, 'Pointer', 'circle',...
      'WindowButtonMotionfcn', 'uipelda(''mouse_motion'')', ...
      'WindowButtonUpFcn', 'uipelda(''mouse_release'')')
   
elseif strcmp(command, 'mouse_motion')
   % ___Eg�r mozgat�sa a vonalra klikkel�s ut�n (lenyomott eg�rrel)___
   % Megkeresi a click_on_line �ltal l�trehozott text objektumot �s
   % bele�rja az aktu�lis kurzorpoz�ci�t.
   CurrPoint=get(gca, 'CurrentPoint');
   x=CurrPoint(1,1); y=CurrPoint(1,2);
   h_text=findobj('Tag', 'text_position');
   set(h_text, 'string',  sprintf('  (%1.3g, %1.3g)', x, y))
   
elseif strcmp(command, 'mouse_release')
   % ___Eg�r felenged�se___
   % Vissza�ll�tja a kurzort ny�l alak�ra, t�rli a 
   % WindowButtonMotionFcn �s a WindowButtonUpFcn bejegyz�seket, 
   % valamint a poz�ci� sz�veget.
   set(gcf, 'Pointer', 'arrow', 'WindowButtonUpFcn', '', ...
      'WindowButtonMotionFcn', '')
   h_text=findobj('Tag', 'text_position'); delete(h_text)
   
elseif strcmp(command, 'click_on_axes')
   % ___Axes-re kattint�s___
   % A kurzor kereszt alak�ra v�lt, az axes ci�n sz�n� lesz, 
   % aktiv�l�dik a zoom funkci�, majd az eg�r felenged�se ut�n
   % visszav�lt a kurzor �s az axes sz�ne.
   set(gcf, 'Pointer', 'crosshair')
   set(gca, 'Color', 'c')
   zoom down; % zoom ind�t�sa, az eg�r felenged�se ut�n t�r vissza
   set(gca, 'Color', 'w')
   set(gcf, 'Pointer', 'arrow')
   
elseif strcmp(command, 'redraw')
   % ___�bra �jrarajzol�sa___
   % A be�ll�tott frekvencia �s f�ggv�nyt�pus szerint �t�rja a vonal 
   % XData �s YData tulajdons�gait, valamint az �bra c�m�t.
   h_freq =findobj('Tag', 'freq_slider');
   h_radio=findobj('UserData', 'fcn_radio_group', 'Value', 1);
   h_line=findobj('Tag', 'demo_line');

   freq=get(h_freq, 'value');
   Fcn=get(h_radio, 'string');
   
   t=[0:.01:1]; y=eval([lower(Fcn) '(2*freq*pi*t)']);
   set(h_line, 'XData', t, 'YData', y)
   title(sprintf('%s(2*pi*f*t)', Fcn))
   
elseif strcmp(command, 'resize')
   % ___�bra �tm�retez�se___
   % Az axes objektumot f�gg�leges ir�nyban ny�jtja
   % az ablak m�ret�nek megfelel�en. A t�bbi objektum 
   % �thelyz�s�nek megval�s�t�s�t az olvas�ra b�zzuk.
   f =findobj('Tag', 'uicontrol_demo_fig'); 
   ax=findobj('Tag', 'demo_axes');
   figpos=get(f, 'Position');
   axpos= get(ax,'Position'); axpos(4)=figpos(4)-130;
   set(ax, 'Position', axpos)
end