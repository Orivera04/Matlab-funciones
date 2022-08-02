function gui10

  figure('ColorMap',gray);

  cmenu = uicontextmenu;
  uimenu(cmenu, 'Label', 'Hidden off', 'Callback', @HiddenOff);
  uimenu(cmenu, 'Label', 'Hidden on', 'Callback', @HiddenOn);
  uimenu(cmenu, 'Label', 'Surface', 'Callback', @Surface);

  [X,Y,Z]=peaks(25);
  Surf = surfl(X,Y,Z);
  set(Surf,'FaceColor','w','UIContextMenu',cmenu);

  function HiddenOff(varargin)
    set(Surf,'FaceColor','none');
  end;

  function HiddenOn(varargin)
    set(Surf,'FaceColor','w');
  end;

  function Surface(varargin)
    set(Surf,'FaceColor','flat');
  end;

end
  