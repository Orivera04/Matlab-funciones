function gui03

  figure('MenuBar','none','Name','Gui03','NumberTitle','off','Position',[200,200,180,150]);

  Txt = uicontrol('Style','Text','Position',[20,100,60,20]);

  June = uicontrol('Style','PushButton','String','June','Position',[20,60,60,20],...
    'CallBack', @JunePressed);

  July = uicontrol('Style','PushButton','String','July','Position',[20,20,60,20],...
    'CallBack', @JulyPressed);

  ToggleButton = uicontrol('Style','ToggleButton','String','Off','Position',[100,60,60,20],...
    'CallBack', @ToggleButtonPressed);

  uicontrol('Style','PushButton','String','Close','Position',[100,20,60,20],...
    'CallBack','close');

  function JunePressed(h, eventdata)
    set(Txt, 'String', 'June');
  end;  
    
  function JulyPressed(h, eventdata)
    set(Txt, 'String', 'July');
  end;  
    
  function ToggleButtonPressed(h, eventdata)

    if get(ToggleButton, 'Value') == 0
      set(ToggleButton, 'String', 'Off');
    else
      set(ToggleButton, 'String', 'On');
    end;  
  end;  

end