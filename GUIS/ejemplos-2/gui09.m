function gui09

  figure;
  cmenu = uicontextmenu;
  [X,Y,Z]=peaks;
  surf(X,Y,Z,'UIContextMenu',cmenu)
  uimenu(cmenu, 'Label', 'Mesh', 'Callback', {@NotImplemented, 'Mesh'});
  uimenu(cmenu, 'Label', 'Surf', 'Callback', {@NotImplemented, 'Surf'});
  uimenu(cmenu, 'Label', 'Surfl', 'Callback', {@NotImplemented, 'Surfl'});


function NotImplemented(h, eventdata, op)

  msgbox(['Operation ' op ' is not implemented'], ...
    'Warning', 'warn', 'modal')    
  