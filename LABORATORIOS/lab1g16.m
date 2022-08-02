%Keith Yasira Aburto Zamora
%Ana Lucia Gutierrez Palacios

clc;
hh= input('de la hora');
min= input('de los minutos');
if (hh>=00)&(hh<=23)&(min>=00)&(min<=59);
    fprintf('%d%d\n', hh,min);
    fprintf('la hora segun el numero de entrada es \n');
    fprintf('hora=%d :%d \n',hh,min);
else
    fprintf('la hora y minuro fuera del rango\n');
end
end