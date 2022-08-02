function gui07(arg)

  figure('MenuBar','none','Name','Gui07','NumberTitle','off','Position',[200,200,260,60]);

  Edit = uicontrol('Style','Edit','String','50','Position',[20,20,100,20],...
    'CallBack', @EditCallBack, 'HorizontalAlignment','left');

  Slider = uicontrol('Style','Slider','Position',[140,20,100,20],...
    'CallBack', @SliderCallBack, 'Value',50,...
    'Min',0,'Max',100);

  
  function EditCallBack(varargin)
    
    num = str2num(get(Edit,'String'));
    if length(num) == 1 & num <=100 & num >=0
      set(Slider,'Value',num);
    else
      msgbox('The value should be a number in the range [0,100]','Error','error','modal');
    end  
  end;
    
  function SliderCallBack(varargin)
    
    num = get(Slider, 'Value');
    set(Edit, 'String', num2str(num));
    
  end;

end