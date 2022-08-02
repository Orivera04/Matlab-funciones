function gui11

  figure('MenuBar','none','Name','Gui11',...
    'doublebuffer','on','NumberTitle','off',...
    'Position',[200,200,600,500]);

  Axes = axes('ButtonDownFcn', @ButtonDown,...
    'XLim',[0,1],'YLim',[0,1]);

  Points = line('XData',[],'YData',[],...
    'LineStyle','None','Marker','*',...
    'MarkerFaceColor','b','MarkerEdgeColor','b');

  
  function ButtonDown(varargin)

    p=get(Axes,'CurrentPoint');
    XData=get(Points,'XData');
    YData=get(Points,'YData');
    XData=[XData,p(1,1)];
    YData=[YData,p(1,2)];
    set(Points,'XData',XData,'YData',YData);

  end;

end
