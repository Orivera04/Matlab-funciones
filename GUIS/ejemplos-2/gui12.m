function gui12

  fig = figure('MenuBar', 'none', 'Name', 'Gui12', ...
    'DoubleBuffer', 'on', 'NumberTitle', 'off', ...
    'WindowButtonUpFcn', @ButtonUp, ...
    'Position', [200, 200, 600, 500]);

  ax = axes('ButtonDownFcn',@NewPoint,...
    'XLim', [0, 1], 'YLim', [0, 1]);

  cmenu = uicontextmenu;
  uimenu(cmenu, 'Label', 'Delete', 'Callback', @DeletePoint);

  pnts = line('XData', [], 'YData', [], ...
    'ButtonDownFcn', @ButtonDown, ...
    'LineStyle','None', ...
    'Marker', '*', ...
    'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b', ...
    'UIContextMenu', cmenu);

  function NewPoint(h, eventdata)

    if isequal(get(fig, 'SelectionType'), 'normal')
      p = get(ax, 'CurrentPoint');

      XData = get(pnts, 'XData');
      YData = get(pnts, 'YData');
      XData = [XData, p(1,1)];
      YData = [YData, p(1,2)];
      set(pnts, 'XData', XData, 'YData', YData);
    end;

  end;

  function ButtonDown(h, eventdata)
   
    p = get(ax, 'CurrentPoint');
    p = p(1, 1:2);
    XData = get(pnts, 'XData');
    YData = get(pnts, 'YData');

    moving_point = FindPoint(p, XData, YData);

    set(fig, 'WindowButtonMotionFcn', @MovePoint, ...
      'Pointer', 'Circle');

    function MovePoint(h, eventdata)
     
      p = get(ax, 'CurrentPoint');
      p = p(1, 1:2);

      XData(moving_point) = p(1);
      YData(moving_point) = p(2);
      set(pnts, 'XData', XData, 'YData', YData);

    end;
  end;

  function ButtonUp(h, eventdata)
   
    set(fig, 'WindowButtonMotionFcn', '', ...
      'Pointer', 'Arrow');

  end;


  function DeletePoint(h, eventdata)
   
    p = get(ax,'CurrentPoint');
    p = p(1, 1:2);
    XData = get(pnts, 'XData');
    YData = get(pnts, 'YData');

    i = FindPoint(p, XData, YData);
    XData(i) = [];
    YData(i) = [];
    set(pnts, 'XData', XData, 'YData', YData);

  end;

  function i = FindPoint(p, XData, YData);

    [m, i] = min((XData - p(1)).^2 + (YData - p(2)).^2);

  end;

end



