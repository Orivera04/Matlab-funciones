figure('MenuBar','none','Name','Gui01','NumberTitle','off','Position',[200,200,100,140]);

uicontrol('Style','PushButton','String','Push','Position',[20,100,60,20],...
  'CallBack','disp(''You are pressed a push button'')');

uicontrol('Style','ToggleButton','String','Toggle','Position',[20,60,60,20],...
  'CallBack','disp(''You are pressed a toggle button'')');

uicontrol('Style','PushButton','String','Close','Position',[20,20,60,20],...
  'CallBack','close');
