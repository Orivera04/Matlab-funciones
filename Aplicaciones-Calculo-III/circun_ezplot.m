%Dibujo de circunferencia con ezplot y con opción a cambio de color.
h=ezplot('x^2+y^2-9');
color=input('color= ');
try
    set(h,'EdgeColor',color)
    set(h,'FaceColor',color)
catch
    set(h,'Color',color)
end    