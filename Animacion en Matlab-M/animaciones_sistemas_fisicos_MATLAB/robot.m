function robot(Q,L)
%   ROBOT Representacion bidimensional de un robot de dos grados de libertad.
%
%   Funcion que representa graficamente un robot moviendose segun el vector de angulos Q.
%
%robot(Q,L)
%
% Q -> Angulo de giro de cada articulacion. Positivo en sentido antihorario.
%      Cada columna de de las 2 columnas de Q representa una articulacion.
%
% L -> Vector que define la longitud de cada elemento. Debe tener dimension (1x2)
%
%	Si Q tiene multiples filas se creara una animacion del robot.
%
%   Ver tambien: BARCO, CARRO, PENDULO, PENDULOINV, SATELITE

%                       ########################################################
%                       #                                                      #
%                       #  Funcion creada por D. Antonio Javier Barragan Pi�a  #
%                       #                                                      #
%                       #              Universidad de Huelva, 2002             #
%                       #                                                      #
%                       ########################################################
%
%   Si desea obtener el codigo de esta funcion escriba un correo a: antonio.barragan@diesia.uhu.es
%   Estas funciones pueden ser utilizadas libremente siempre y cuando sea citado su autor.
clf

if ((size(Q,2)~=2)|size(L)~=[1 2])
    error('Las dimensiones de los argumentos no son correctas')
end
set(gcf,'Render','zbuffer'),title('Robot')
axis([-1 1 -1 1]*(L(1)+L(2)+.5));

%Aumentando 'Inc' se eliminan cuadros de la animacion, avivando su velocidad.
Inc=1;

E1=[-.2 L(1)+.2 L(1)+.2 -.2; -.2 -.2 .2 .2];
E2=[-.2 L(2) L(2)+.2 L(2) -.2;-.2 -.2 0 .2 .2; 1 1 1 1 1];
EP1=[cos(Q(1,1)) -sin(Q(1,1));sin(Q(1,1)) cos(Q(1,1))]*E1;
EP2=[cos(Q(1,1)+Q(1,2)) -sin(Q(1,1)+Q(1,2)) cos(Q(1,1))*L(1);sin(Q(1,1)+Q(1,2)) cos(Q(1,1)+Q(1,2)) sin(Q(1,1))*L(1)]*E2;
elemento1=patch(EP1(1,:),EP1(2,:),'b');
elemento2=patch(EP2(1,:),EP2(2,:),'r');
material dull,light,grid
for k=2:Inc:size(Q,1)
    EP1=[cos(Q(k,1)) -sin(Q(k,1));sin(Q(k,1)) cos(Q(k,1))]*E1;
    EP2=[cos(Q(k,1)+Q(k,2)) -sin(Q(k,1)+Q(k,2)) cos(Q(k,1))*L(1);sin(Q(k,1)+Q(k,2)) cos(Q(k,1)+Q(k,2)) sin(Q(k,1))*L(1)]*E2;
    set(elemento1,'XData',EP1(1,:),'YData',EP1(2,:));
    set(elemento2,'XData',EP2(1,:),'YData',EP2(2,:));
    drawnow
 end