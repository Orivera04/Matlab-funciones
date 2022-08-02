function exclusion_mutua(opcion,mathandles)
switch opcion
    case 1
        set(mathandles(6),'Value',1);
        set(mathandles(7),'Value',0);
        set(mathandles(8),'Value',0);
    case 2
        set(mathandles(6),'Value',0);
        set(mathandles(7),'Value',1);
        set(mathandles(8),'Value',0);
    case 3
        set(mathandles(6),'Value',0);
        set(mathandles(7),'Value',0);
        set(mathandles(8),'Value',1);
end