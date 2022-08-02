function slide_callback ( )
h=gcf;
obj=findobj(h,'Tag','slider1');
valmax=str2num(get(obj,'Max');
valmax=str2num(get(obj,'Min');
step=get(obj'SliderStep');