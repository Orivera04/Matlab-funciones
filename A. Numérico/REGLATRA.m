
% Marjourie de los Angeles Aguirre Arostegui
% Wendy Maria Briones Mena
% Patricia Esperanza Traña Sanchez
% Omar Rafael Perez Sanchbez

% Grupo 2M3-CO

function REGLATRA(fun,liin,lisu,suin,resu)
syms x;
f=get(fun,'String');
Liminf=str2double(get(liin,'String'));
Limsup=str2double(get(lisu,'String'));
Subint=str2num(get(suin,'string'));
Longit=(Limsup-Liminf)/Subint;
vector1=Liminf:Longit:Limsup;
for i=1:Subint
    vector2(i)=subs(f,'x',Liminf+(i-1)*Longit);
end
result=0;
for i=2:Subint-1
    result=result+vector2(i)*Longit;
end
trap1n=vector2(1)*Longit+vector2(Subint)*Longit;
result=(trap1n+result*2)/2;
set(resu,'String',result);