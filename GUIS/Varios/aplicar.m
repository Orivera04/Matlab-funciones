function aplicar(mathandles)
texto=get(mathandles(1),'String');
valneg=get(mathandles(2),'Value');
valcur=get(mathandles(3),'Value');
valalinea=get(mathandles(4),'Value');
valtamanio=get(mathandles(5),'Value');
set(mathandles(9),'String',texto);
set(mathandles(9),'FontSize',valtamanio);
if valneg==1
    set(mathandles(9),'FontWeight','bold');
else
    set(mathandles(9),'FontWeight','normal');
end
if valcur==1
    set(mathandles(9),'FontAngle','italic');
else
    set(mathandles(9),'FontAngle','normal');
end
switch valalinea
    case 1
        set(mathandles(9),'HorizontalAlignment','left');
    case 2
        set(mathandles(9),'HorizontalAlignment','center');
    case 3
        set(mathandles(9),'HorizontalAlignment','right');
end
if (get(mathandles(6),'Value'))==1
    set(mathandles(9),'FontName','Times New Roman');
elseif (get(mathandles(7),'Value'))==1
    set(mathandles(9),'FontName','Arial');
elseif (get(mathandles(8),'Value'))==1
    set(mathandles(9),'FontName','Wingdings');
end
