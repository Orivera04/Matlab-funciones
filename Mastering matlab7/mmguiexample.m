function mmguiexample
%MMGUIEXAMPLE Example GUI in Mastering MATLAB 7

% Build GUI

set(0,'Units','pixels');
Ssize = get(0,'ScreenSize'); % get screen size so gui can be centered

H.gui = dialog('WindowStyle','normal',... % Figure object with good
               'Resize','on',...          % properties for a gui
               'Name','MMGuiExample',...  % Add modifications
               'Units','pixels',...
               'Position',[(Ssize(3)-310)/2 (Ssize(4)-150)/2 310 150]);

DefOutPos = get(H.gui,'OuterPosition'); % undocumented figure property
set(H.gui,'UserData',DefOutPos) % store default outer position here

Hm = uimenu('Parent',H.gui,'Label','MenuExample'); % create top level menu
uimenu('Parent',Hm,... % add 'Close' menu item to top level menu
       'Label','Close',...
       'Callback','close(gcbf)'); % simple string callback

H.Hslider = uicontrol('Style','slider',... % horizontal slider
                      'Parent',H.gui,...
                      'Units','pixels',...
                      'Position',[10 10 270 20],...
                      'Min',20,'Max',Ssize(3)-DefOutPos(3)-20,...
                      'Value',DefOutPos(1),...
                      'Callback',{@local_Hslider,H});

H.Vslider = uicontrol('Style','slider',... % vertical slider
                      'Parent',H.gui,...
                      'Units','pixels',...
                      'Position',[280 30 20 100],...
                      'Min',20,'Max',Ssize(4)-DefOutPos(4)-20,...
                      'Value',DefOutPos(2),...
                      'Callback',{@local_Vslider,H});

H.Update = uicontrol('Style','pushbutton',... % Update pushbutton
                     'Parent',H.gui,...
                     'Units','pixels',...
                     'Position',[50 70 80 30],...
                     'String','Update',...
                     'Callback',{@local_Update,H});

H.Default = uicontrol('Style','pushbutton',... % Default pushbutton
                      'Parent',H.gui,...
                      'Units','pixels',...
                      'Position',[145 70 80 30],...
                      'String','Default',...
                      'Callback',{@local_Default,H});
%--------------------------------------------------------
% Subfunction callbacks
%--------------------------------------------------------
function local_Hslider(cbo,eventdata,h)
% Callback for horizontal slider
% Move gui figure horizontally
% Slider value contains desired outer left position

SliderValue = get(cbo,'Value');
pos = get(h.gui,'OuterPosition');
set(h.gui,'OuterPosition',[SliderValue pos(2:4)])

%--------------------------------------------------------
function local_Vslider(cbo,eventdata,h)
% Callback for vertical slider
% Move gui figure vertically
% Slider value contains desired outer bottom position

SliderValue = get(cbo,'Value');
pos = get(h.gui,'OuterPosition');
set(h.gui,'OuterPosition',[pos(1) SliderValue pos(3:4)])

%--------------------------------------------------------
function local_Update(cbo,eventdata,h)
% Callback for Update pushbutton
% Update slider values to reflect current GUI position
% This button is only needed if the user drags the GUI
%  window manually with the mouse

OutPos = get(h.gui,'OuterPosition');
set(h.Hslider,'Value',OutPos(1))
set(h.Vslider,'Value',OutPos(2))

%--------------------------------------------------------
function local_Default(cbo,eventdata,h)
% Callback for Default pushbutton
% Return GUI position vector to default value

defoutpos = get(h.gui,'UserData'); % retrieve default outer position
set(h.gui,'OuterPosition',defoutpos)
set(h.Hslider,'Value',defoutpos(1))
set(h.Vslider,'Value',defoutpos(2))