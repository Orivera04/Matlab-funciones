%Capitalizacion
anio=1977;
capital=2000;
fprintf('\n');
disp('año   capital')
while anio <= 1995
    fprintf('%4.0f  %6.2f\n',anio,capital);
    capital=capital + 0.06*capital;
    anio = anio + 1;
end