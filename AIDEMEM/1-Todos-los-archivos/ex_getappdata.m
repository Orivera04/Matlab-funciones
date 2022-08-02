h=figure('number', 'off', 'name', 'mes_donnees');
x = linspace(0,6,100);
y = sin(x);
setappdata(h,'mes_donnees',{'\bfje les dépose ici', x, y});

c = getappdata(h)
plot(c.mes_donnees{2},c.mes_donnees{3})
title(c.mes_donnees{1},'fonts', 18);
