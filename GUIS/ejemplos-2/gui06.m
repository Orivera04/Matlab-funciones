function gui06
    
  figure('MenuBar','none','Name','Gui06','NumberTitle','off','Position',[200,200,260,100]);

  List = {'January','February','March','April','May','June','July','August',...
    'September','October','November','December'};

  ListBox = uicontrol('Style','ListBox','String',List,'Position',[20,20,100,60],...
    'CallBack', @ListBoxCallBack);

  PopupMenu = uicontrol('Style','PopupMenu','String',List,'Position',[140,60,100,20],...
    'CallBack', @PopupMenuCallBack);

  function ListBoxCallBack(varargin)
    
    List = get(ListBox, 'String');
    Val = get(ListBox, 'Value');
    msgbox(List{Val}, 'Selecting:', 'modal')

  end;
  
  function PopupMenuCallBack(varargin)
  
    List = get(PopupMenu,'String');
    Val = get(PopupMenu,'Value');
    msgbox(List{Val},'Selecting:','modal')

  end;

end

