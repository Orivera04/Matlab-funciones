%Transformación de corte  a lo largo de eje x o eje y.
%Matriz de corte a lo largo del eje x: [1 c;0 1]. 
%Matriz de corte a lo largo del eje x: [1 0;c 1]. 
corte_eje=input('corte a lo largo de eje: ');
dot2dot(trian);
axis([0 10 0 10])
hold on;
if corte_eje=='x'
    c= input('valor de c: ');
    matcor=[1 c;0 1]*trian;
    dot2dot1(matcor);
    axis([0 10 0 10])
else
       c= input('valor de c: ');
    matcor=[1 0;c 1]*trian;
    dot2dot1(matcor)  
end