function uipelda(command)
% function uipelda
%
% Példa grafikus MATLAB felhasználói felület létrehozására
% Csak 4.2, vagy magasabb verzióval mûködõképes

% © Simon Gyula, 1998; program a Grafikai felhasznaloi fel"uletek c. reszhez

vers=version; vers=str2num(vers(1:3));
if vers < 4.2 
   error('4.2, vagy magasabb verzió kell...')
end

if nargin==0 % inicializálás
   if vers < 5
      f=findobj('Tag', 'uicontrol_demo_fig');
   else
      % megtalálja a rejtett ablakot is:
      f=findobj(allchild(0), 'flat', 'Tag', 'uicontrol_demo_fig');
   end
   if ~isempty(f)
      % Ha már létezik az ablak, akkor csak elõrehozzuk
      figure(f)
   else % Ha nem létezik az ablak, akkor létrehozzuk
      f=figure('Name',       'Uicontrol példa', ...
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
      % Létrejött az axes a megfelelõ axis és xlabel beállításokkal.
      % Most készítünk egy üres vonal (line) objektumot, az ábrát 
      % ennek segítségével fogjuk rajzolni.
      h_line=line('Parent',  h_axes, ...
         'ButtonDownFcn',    'uipelda(''click_on_line'')',...
         'Tag',              'demo_line');
      % A kezelõszervek (uicontrol objektumok) létrehozása
      h_pop=uicontrol('Parent', f, ...
         'Style', 'popupmenu', ...
         'Units', 'pixels', ...
         'Position', [380 250 110 20], ...
         'String', 'Piros|Sárga|Zöld',...
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
      
      h_mainmenu=uimenu(f, 'Label', 'Függvén&y');
      h_menu1=uimenu(h_mainmenu, 'Label', 'Si&n',...
         'callback', 'uipelda(''fcn1'')', ...
         'UserData', 'fcn_menu_group', ...
         'Checked', 'on', ...
         'Tag', 'menu_fcn1');
      
      h_menu2=uimenu(h_mainmenu, 'Label', 'Sin&c', ...
         'callback', 'uipelda(''fcn2'')', ...
         'UserData', 'fcn_menu_group', ...
         'Tag', 'menu_fcn2');
      
      % Az ablak háttérszínét azonosra állítjuk a kezelõszervekével
      BackGrColor=get(h_rb2, 'BackgroundColor');
      set(f, 'Color', BackGrColor);
      
      uipelda('slider') % Az editbox és az ábra inicializálása
      uipelda('popup')  % A szín beállítása
      
      % Az alábbi funkciók csak az 5.1 verziótól kezdve mûködnek
      if vers >= 5
         set(f, 'ResizeFcn', 'uipelda(''resize'')') % egyszerû resize
         set(f, 'HandleVisibility', 'Callback') % GUI rejtés
      end
   end % inicialiálás vége
elseif findstr(command, 'popup')   
   % ___Színválasztó popupmenu callback___
   % Beállítja vonalat és a saját háttérszínét a popup állása szerint
   h_color=findobj('Tag', 'color_pop');
   h_line=findobj('Tag', 'demo_line');
   ColVect='ryg'; Color=ColVect(get(h_color, 'Value'));
   set(h_line, 'Color', Color), set(h_color, 'BackgroundColor', Color)
   
elseif findstr(command, 'fcn')   
   % ___Függvényválasztó rádiógomb/menu callback___
   % Valamennyi (jelenleg 2 db), a csoportba tartozó rádiógombot
   % kiengedett állapotba hozza (Value=0), csak a hívó objektumot
   % állítja megnyomott állapotba (Value=1).(A csoportot az 
   % azonos értékû UserData azonosítja.) 
   % Hasonlóan a menük Checked tulajdonságát is állítja.
   % Újrarajzolja az ábrát.
   h_selected_rb=findobj('Tag', ['rb_' command]);
   h_selected_menu=findobj('Tag', ['menu_' command]);
   h_all_radio=findobj('UserData', 'fcn_radio_group');
   h_all_menu=findobj('UserData', 'fcn_menu_group');
   set(h_all_radio, 'Value', 0); set(h_selected_rb, 'value', 1)
   set(h_all_menu, 'Checked', 'off'); set(h_selected_menu, 'Checked', 'on')
   uipelda('redraw')
   
elseif strcmp(command, 'slider')
   % ___Frekvenciabeállító slider callback___
   % Beállítja az editbox értékét a slider helyzetének megfelelõen, 
   % majd újrarajzolja az ábrát
   h_freq_slider=findobj('Tag', 'freq_slider'); 
   h_freq_edit=findobj('Tag', 'freq_edit'); 
   freq=get(h_freq_slider, 'Value'); % frekvencia=slider helyzet
   set(h_freq_edit, 'String', num2str(freq)) 
   uipelda('redraw')
   
elseif strcmp(command, 'edit')
   % ___Frekvenciabeállító editbox callback___
   % Ellenõrzi a bevitt értéket, korrigál, ha szükséges, beállítja
   % a slider helyzetetét az editbox értékének megfelelõen, majd 
   % újrarajzolja az ábrát
   h_freq_slider=findobj('Tag', 'freq_slider');
   h_freq_edit=findobj('Tag', 'freq_edit');
   freq=str2num(get(h_freq_edit, 'String'));
   if isempty(freq), freq=0; end % nem szám !!!
   if freq<0, freq=0; elseif freq>10, freq=10; end
   set(h_freq_edit, 'String', num2str(freq))
   set(h_freq_slider, 'Value', freq)
   uipelda('redraw')
   
elseif strcmp(command, 'click_on_line')
   % ___Kattintás a vonalra___ 
   % A kurzor kör alakúvá válik és létrehoz egy text objektumot 
   % a kattintás pozíciója mellé, ahova az egér felengedéséig a 
   % WindowButtonMotionFcn ki fogja írna az aktuális kurzorpoziciót. 
   % Inicializálja a WindowButtonMotionFcn-t és a WindowButtonUpFcn-t.
   CurrPoint=get(gca, 'CurrentPoint'); 
   x=CurrPoint(1,1); y=CurrPoint(1,2);
   text(x, y, sprintf('  (%1.3g, %1.3g)', x, y),...
      'color', [1 0 1], 'Tag', 'text_position')
   set(gcf, 'Pointer', 'circle',...
      'WindowButtonMotionfcn', 'uipelda(''mouse_motion'')', ...
      'WindowButtonUpFcn', 'uipelda(''mouse_release'')')
   
elseif strcmp(command, 'mouse_motion')
   % ___Egér mozgatása a vonalra klikkelés után (lenyomott egérrel)___
   % Megkeresi a click_on_line által létrehozott text objektumot és
   % beleírja az aktuális kurzorpozíciót.
   CurrPoint=get(gca, 'CurrentPoint');
   x=CurrPoint(1,1); y=CurrPoint(1,2);
   h_text=findobj('Tag', 'text_position');
   set(h_text, 'string',  sprintf('  (%1.3g, %1.3g)', x, y))
   
elseif strcmp(command, 'mouse_release')
   % ___Egér felengedése___
   % Visszaállítja a kurzort nyíl alakúra, törli a 
   % WindowButtonMotionFcn és a WindowButtonUpFcn bejegyzéseket, 
   % valamint a pozíció szöveget.
   set(gcf, 'Pointer', 'arrow', 'WindowButtonUpFcn', '', ...
      'WindowButtonMotionFcn', '')
   h_text=findobj('Tag', 'text_position'); delete(h_text)
   
elseif strcmp(command, 'click_on_axes')
   % ___Axes-re kattintás___
   % A kurzor kereszt alakúra vált, az axes cián színû lesz, 
   % aktiválódik a zoom funkció, majd az egér felengedése után
   % visszavált a kurzor és az axes színe.
   set(gcf, 'Pointer', 'crosshair')
   set(gca, 'Color', 'c')
   zoom down; % zoom indítása, az egér felengedése után tér vissza
   set(gca, 'Color', 'w')
   set(gcf, 'Pointer', 'arrow')
   
elseif strcmp(command, 'redraw')
   % ___Ábra újrarajzolása___
   % A beállított frekvencia és függvénytípus szerint átírja a vonal 
   % XData és YData tulajdonságait, valamint az ábra címét.
   h_freq =findobj('Tag', 'freq_slider');
   h_radio=findobj('UserData', 'fcn_radio_group', 'Value', 1);
   h_line=findobj('Tag', 'demo_line');

   freq=get(h_freq, 'value');
   Fcn=get(h_radio, 'string');
   
   t=[0:.01:1]; y=eval([lower(Fcn) '(2*freq*pi*t)']);
   set(h_line, 'XData', t, 'YData', y)
   title(sprintf('%s(2*pi*f*t)', Fcn))
   
elseif strcmp(command, 'resize')
   % ___Ábra átméretezése___
   % Az axes objektumot függõleges irányban nyújtja
   % az ablak méretének megfelelõen. A többi objektum 
   % áthelyzésének megvalósítását az olvasóra bízzuk.
   f =findobj('Tag', 'uicontrol_demo_fig'); 
   ax=findobj('Tag', 'demo_axes');
   figpos=get(f, 'Position');
   axpos= get(ax,'Position'); axpos(4)=figpos(4)-130;
   set(ax, 'Position', axpos)
end