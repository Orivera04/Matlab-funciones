%Transformación de corte  a lo largo de eje x o eje y.
%Matriz de corte a lo largo del eje x: [1 c;0 1]. 
%Matriz de corte a lo largo del eje x: [1 0;c 1]. 
corte_eje=input('corte a lo largo de eje: ');
dot2dot(cuadri);
axis([0 10 0 10])
hold on;
 p=cuadri;
 c= input('valor de c: ');

if corte_eje=='x'
    A=[1 c;0 1]
    matcor=A*p
    dot2dot1(matcor);
    axis([0 10 0 10])
else
    A=[1 0;c 1]
    matcor=A*p
    dot2dot1(matcor)  
    axis([0 10 0 10])
end
  hold off  