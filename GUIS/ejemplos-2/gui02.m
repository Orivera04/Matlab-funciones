function gui02

  figure('MenuBar','none','Name','Gui02','NumberTitle','off','Position',[200,200,100,140]);

  uicontrol('Style','PushButton','String','Push','Position',[20,100,60,20],...
    'CallBack',@PushButtonPressed);

  uicontrol('Style','ToggleButton','String','Toggle','Position',[20,60,60,20],...
    'CallBack',@ToggleButtonPressed);

  uicontrol('Style','PushButton','String','Close','Position',[20,20,60,20],...
    'CallBack','close');

function PushButtonPressed(h, eventdata)

  disp('You are pressed a push button');

function ToggleButtonPressed(h, eventdata)

  disp('You are pressed a toggle button');

