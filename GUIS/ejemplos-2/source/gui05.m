function gui05
  
  figure('MenuBar','none','Name','Gui05','NumberTitle','off','Position',[200,200,280,170]);

  CheckBox1 = uicontrol('Style','CheckBox','String','First','Position',[30,100,60,20],...
    'CallBack', @CheckBox1Selected);

  Text1 = uicontrol('Style','Text','String','First is unselected','Position',[130,100,120,20],...
    'HorizontalAlignment','left');

  CheckBox2 = uicontrol('Style','CheckBox','String','Second','Position',[30,60,60,20],...
    'CallBack', @CheckBox2Selected);

  Text2 = uicontrol('Style','Text','String','Second is unselected','Position',[130,60,120,20],...
    'HorizontalAlignment','left');

  function CheckBox1Selected(h, eventdata)

    if get(CheckBox1,'Value')==0
      set(Text1,'String','First is unselected');
    else
      set(Text1,'String','First is selected');
    end;    

  end;    
    
  function CheckBox2Selected(h, eventdata)

    if get(CheckBox2,'Value')==0
      set(Text2,'String','Second is unselected');
    else
      set(Text2,'String','Second is selected');
    end;    

  end;    

end