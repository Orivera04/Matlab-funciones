  function [xx,yy]=arrow2(inicio,final,escala)  
%  ARROWH  Determina los datos para dibujar una l�nea 
%          con una flecha apuntando de inicio a final.
%
%          Ejemplo de uso: >>[xx,yy]=arrowh(inicio,final,escala)
%
%              inicio es el punto x,y donde comienza la l�nea.
%              final es  el puntot x,y donde termina la l�nea.
%              escala es un argumento opcional que escalar�  
%                     el tama�o de la punta de la flecha.
%              Usando plot(xx,yy) en la rutina de llamada se dibuja el 
%              vector.
%
%  By: David R. Hill, MATH Department, Temple University
%      Philadelphia, Pa., 19122        Email: hill@math.temple.edu

%  This routine is derived from arrow2.m by
%       8/4/93    Jeffery Faneuff
%       Copyright (c) 1988-93 by the MathWorks, Inc.
%
%  Traducci�n de la ayuda.  R. Briones. Depto. Lenguajes y Simulaci�n
%                           UNI. Managua, Nicaragua.
                 
if nargin==2
  xl = get(gca,'xlim');
  yl = get(gca,'ylim');
  xd = xl(2)-xl(1);       % Esto fija la escala para el tama�o de la flecha
  yd = yl(2)-yl(1);       % permitiendo que la flecha aparezca en la 
  escala = (xd + yd) / 2;  % proporci�n correcta en el eje actual.
end

xdif = final(1) - inicio(1);
ydif = final(2) - inicio(2);

theta = atan(ydif/xdif); % El �ngulo debe estar de acuerdo con la pendiente

if(xdif>=0)
  escala = -escala;
end

xx = [inicio(1), final(1),(final(1)+0.02*escala*cos(theta+pi/4)),NaN,final(1),... 
(final(1)+0.02*escala*cos(theta-pi/4))]';
yy = [inicio(2), final(2), (final(2)+0.02*escala*sin(theta+pi/4)),NaN,final(2),... 
(final(2)+0.02*escala*sin(theta-pi/4))]';


