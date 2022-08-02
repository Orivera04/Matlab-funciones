% Script para calcular y representar el centro de masas de un
% sistema de partículas

n = input('Número de partículas: ');
mt = 0;
mx = 0;
my = 0;
mz = 0;
for i=1:n
   fprintf(1,'Partícula %d\n',i);
   x (i)= input ('Coordenada x: ');
   y (i)= input ('Coordenada y: ');
   z (i)= input ('Coordenada z: ');
   m (i)= input ('Masa: ');
   mt = mt + m(i);
   mx = mx + x(i)*m(i);
   my = my + y(i)*m(i);
   mz = mz + z(i)*m(i);
end

xcm = mx / mt;
ycm = my / mt;
zcm = mz / mt;

% Dibuja la posición de las partículas y su centro de masas
figure(1)
clf
hold on
for i = 1:n
   plot3 (x(i),y(i),z(i),'bo');
   text (x(i)+.1,y(i)+.1,z(i)+.1,num2str(m(i)));
end
plot3 (xcm,ycm,zcm,'rx');
text (xcm+.1,ycm+.1,zcm+.1,num2str(mt));
grid on
hold off

