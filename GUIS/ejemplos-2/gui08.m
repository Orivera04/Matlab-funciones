function gui08

  fig = figure('MenuBar','none','Name','Gui08','NumberTitle','off');

  m = uimenu('Label','&File');
  uimenu(m,'Label','New','Callback','gui08');
  uimenu(m,'Label','New Figure','Callback','figure');
  uimenu(m,'Label','Quit','Callback','close',...
    'Separator','on','Accelerator','Q');

  m = uimenu('Label','&Edit');
  uimenu(m,'Label','&Undo');
  uimenu(m,'Label','&Redo');
  uimenu(m,'Label','&Find','Separator','on');
  uimenu(m,'Label','&Replace');

  m = uimenu('Label','&Help');
  uimenu(m,'Label','Help',...
    'Callback', @NotImplemented);
  uimenu(m,'Label','About','Separator','on',...
    'Callback', @About);

function About(varargin)
  msgbox('This is a demo program','About','help','modal')    

function NotImplemented(varargin)
  msgbox('Operation is not implemented','Warning','warn','modal')    
  