function [matnumeros,matnombres,matgeneros,matgrupos,matnotas,b]=guardar(mathandles,matnumeros,matnombres,matgeneros,matgrupos,matnotas,band)

number=get(mathandles(1),'String');
name=get(mathandles(2),'String');
valgender=get(mathandles(3),'Value');
strgender=get(mathandles(3),'String');
gender=strgender(valgender,:);
valgroup=get(mathandles(4),'Value');
strgroup=get(mathandles(4),'String');
group=strgroup(valgroup,:);
notas(1)=str2num(get(mathandles(5),'String'));
notas(2)=str2num(get(mathandles(6),'String'));
notas(3)=str2num(get(mathandles(7),'String'));
notas(4)=str2num(get(mathandles(8),'String'));
notas(5)=str2num(get(mathandles(9),'String'));

if band==1
    matnumeros=number;
    matnombres=name;
    matgeneros=gender;
    matgrupos=group;
    matnotas=notas;
    b=2;
else
    matnumeros=strvcat(matnumeros,number);
    matnombres=strvcat(matnombres,name);
    matgeneros=strvcat(matgeneros,gender);
    matgrupos=strvcat(matgrupos,group);
    matnotas=cat(1,matnotas,notas);
    b=2;
end
msgbox('Los datos han sido guardados con exito','¡Successful!','warn');
set(mathandles(1),'String','');
set(mathandles(2),'String','');
set(mathandles(5),'String','');
set(mathandles(6),'String','');
set(mathandles(7),'String','');
set(mathandles(8),'String','');
set(mathandles(9),'String','');
for i=1:13
    switch i
        case 10
            habilitar(mathandles(i),'v','s');
        case 11
            habilitar(mathandles(i),'f','s');
        case 12
            habilitar(mathandles(i),'v','s');
        case 13
        otherwise
            habilitar(mathandles(i),'f','n');
    end
end