%NUMEROS COMPLEJOS
clc
fprintf('Convierta los valores complejos de los problemas a forma polar.\n');
fprintf('Luego verifique sus respuestas usando funciones MATLAB.\n\n');
fprintf('1.)    3 - i2                    2.)    -i\n\n');
fprintf('3.)    -2                        4.)    0.5 + i\n\n');
fprintf('Presione una tecla para continuar...\n\n');
pause
clc
% 1.***************************************************************************
fprintf('>> 1.) 3 - i2\n\n');
fprintf('r = (3² + 2²)½ =     %f\n\n',sqrt(3^2+2^2));
fprintf('Ø = arctan(-2/3) =    %f\n\n',atan(-2/3));
fprintf('abs (x) =            %f\n\n',abs(3-i*2));
fprintf('angle (x) =          %f\n\n',angle(3-i*2));
fprintf('Presione una tecla para continuar...\n\n');
pause
clc
% 2.***************************************************************************
fprintf('>> 2.) -i\n\n');
fprintf('r = (0² + (-1)²)½ =     %f\n\n',sqrt(0^2+(-1)^2));
fprintf('Ø = arctan(-1/0) =    %f\n\n',atan((-1)/0));
fprintf('abs (x) =            %f\n\n',abs(0-i));
fprintf('angle (x) =          %f\n\n',angle(0-i));
fprintf('Presione una tecla para continuar...\n\n');
pause
clc
% 3.***************************************************************************
fprintf('>> 3.) -2\n\n');
fprintf('r = (-2² + 0²)½ =    %f\n\n',sqrt((-2)^2+0^2));
fprintf('Ø = arctan(0/-2) =    %f\n\n',atan(0/(-2)));
fprintf('abs (x) =            %f\n\n',abs(-2+1*0));
fprintf('angle (x) =          %f\n\n',angle((-2)+i*0));
fprintf('Presione una tecla para continuar...\n\n');
pause
clc
% 4.***************************************************************************
fprintf('>> 4. 0.5 + i\n\n');
fprintf('r = (0.5² + 1²)½ =     %f\n\n',sqrt(0.5^2+1^2));
fprintf('Ø = arctan(1/0.5) =    %f\n\n',atan(1/0.5));
fprintf('abs (x) =            %f\n\n',abs(0.5+i));
fprintf('angle (x) =          %f\n\n',angle(0.5+i));
fprintf('Presione una tecla para terminar...\n\n');
pause
clc
%*******************************************************************************************
%*******************************************************************************************
fprintf('Convierta los valores exponenciales complejos de los problemas a forma rectangular.\n');
fprintf('Luego verifique sus respuestas usando funciones MATLAB.\n\n');
fprintf('1.)    e^i                            2.)    e^i*0.75*Pi\n\n');
fprintf('3.)    0.5e^i*2.3                     4.)    3.5e^i*3*Pi\n\n');
fprintf('Presione una tecla para continuar...\n\n');
pause
clc
% 1.***************************************************************************
fprintf('>> 1.)   e^i\n\n');
fprintf('a = r cos(Ø) =     %f\n\n',1*cos(1));
fprintf('b = r sin(Ø) =     %f\n\n',1*sin(1));
fprintf('abs (x) =          %f\n\n',abs((1*cos(1))+i*(1*sin(1))));
fprintf('angle (x) =        %f\n\n',angle((1*cos(1))+i*(1*sin(1))));
fprintf('Presione una tecla para continuar...\n\n');
pause
clc
% 2.***************************************************************************
fprintf('>> 2.)   e^i*0.75*Pi\n\n');
fprintf('a = r cos(Ø) =     %f\n\n',1*cos(0.75*pi));
fprintf('b = r sin(Ø) =     %f\n\n',1*sin(0.75*pi));
fprintf('abs (x) =          %f\n\n',abs((1*cos(0.75*pi))+i*(1*sin(0.75*pi))));
fprintf('angle (x) =        %f Pi\n\n',angle((1*cos(0.75*pi))+i*(1*sin(0.75*pi)))/pi);
fprintf('Presione una tecla para continuar...\n\n');
pause
clc
% 3.***************************************************************************
fprintf('>> 3.)   0.5e^i*2.3\n\n');
fprintf('a = r cos(Ø) =     %f\n\n',0.5*cos(2.3));
fprintf('b = r sin(Ø) =     %f\n\n',0.5*sin(2.3));
fprintf('abs (x) =          %f\n\n',abs((0.5*cos(2.3))+i*(0.5*sin(2.3))));
fprintf('angle (x) =        %f\n\n',angle((0.5*cos(2.3))+i*(0.5*sin(2.3))));
fprintf('Presione una tecla para continuar...\n\n');
pause
clc
% 4.***************************************************************************
fprintf('>> 4.)   3.5e^i*3*Pi\n\n');
fprintf('a = r cos(Ø) =     %f\n\n',3.5*cos(3*pi));
fprintf('b = r sin(Ø) =     %f\n\n',3.5*sin(3*pi));
fprintf('abs (x) =          %f\n\n',abs((3.5*cos(3*pi))+i*(3.5*sin(3*pi))));
fprintf('angle (x) =        %f Pi\n\n',angle((3.5*cos(3*pi))+i*(3.5*sin(3*pi))));
fprintf('Presione una tecla para continuar...\n\n');
pause
clc
%*******************************************************************************************
%*******************************************************************************************
%GRAFICA POLAR
fprintf('Presione una tecla para ver la gráfica polar\n\n');
pause
theta=0:2*pi/100:2*pi;
r=theta/(2*pi);
polar(theta,r),title('Grafica polar');
pause;
close