%Suma de números consecutivos
syms k;
sum=char((symsum(k,1,10)));
a = 1:5; s=[sprintf('%3d +',a),]; s(end)=[];
disp([s,'= ',suma])


