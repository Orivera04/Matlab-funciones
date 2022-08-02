function circuito_background ()
ha = axes('units','normalized', 'position',[0 0 1 1]);
[a,map]=imread('circuito.bmp');
image(a);
set(ha,'Xtick',[]);
set(ha,'XtickLabel',{});
set(ha,'Ytick',[]);
set(ha,'YtickLabel',{});
set(ha,'handlevisibility','off', 'visible','off')

