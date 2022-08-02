function barco(Q,R,D,d)
%   BARCO Representacion bidimensional de un barco con una masa para el control de balanceo.
%
%   Funcion que representa graficamente un barco moviendose segun el vector de angulos Q.
%Las dimensiones se calculan a partir de R; siendo esta la distancia que separa al centro
%de giro del centro de gravedad del barco, y D la distancia entre el centro de gravedad y
%la horizontal sobre la que se desplaza la masa de control.
%
%barco(Q,R)
%
%barco(Q,R,D,d)
%
% Q -> Angulo de giro sobre la vertical. Positivo en sentido horario.
%
% R -> Distancia desde el centro de giro al centro de gravedad del barco.
%
% D -> Distancia del centro de gravedad a la horizontal donde se situa la masa de control.
%      Opcional.(D < R)
%
% d -> Distancia de desplazamiento de la masa de control. Sentido positivo hacia la derecha.
%      Opcional.
%
%   Si se omiten 'D' o 'd' no se dibujara la masa de control.
%
%	Si Q y d son vectores de la misma dimension se creara una animacion del barco moviendose
%  segun los valores de dichas variables.
%
% Ejemplo: barco([0:0.1:6],6,4,[0:0.1:6])
%
%   Ver tambien: CARRO, PENDULO, PENDULOINV, ROBOT, SATELITE

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

DibujarMasa=(exist('d')&exist('D'));
if (size(Q,2)==1)
   Q=Q';
end
if (DibujarMasa & size(d,2)==1)
   d=d';
end
if (DibujarMasa & any(size(Q)~=size(d)))
   error('Q y d deben tener la misma dimensi�n');
end
set(gcf,'Render','zbuffer'),axis([-1,1,-1,1]*3*R);axis equal,axis off

%Aumentando 'Inc' se eliminan cuadros de la animacion, avivando su velocidad.
Inc=1;

L1=3*R/2;
L2=3*R/2*sqrt(2);
beta=pi/4;
[P1x,P1y]=pol2cart(Q(1)+pi,R);
[P2x,P2y]=pol2cart(Q(1)+pi,L1);
[P3x,P3y]=pol2cart(Q(1)-pi/2-beta,L2);
[P4x,P4y]=pol2cart(Q(1)-pi/2+beta,L2);
[P5x,P5y]=pol2cart(Q(1),L1);
[P6x,P6y]=pol2cart(Q(1),R);
[P7x,P7y]=pol2cart(pi/4+Q(1),R*sqrt(2));
[P8x,P8y]=pol2cart(3*pi/4+Q(1),R*sqrt(2));
Arco=[];
pasoArco=((Q(1)-pi/2+beta)-(Q(1)-pi/2-beta))/10;
for i=(Q(1)-pi/2-beta):pasoArco:(Q(1)-pi/2+beta)
   [xa,ya]=pol2cart(i,L2);
	Arco=[Arco,[xa;ya]];
end
X=[P1x,P2x,P3x,Arco(1,:),P4x,P5x,P6x,P7x,P8x];
Y=[P1y,P2y,P3y,Arco(2,:),P4y,P5y,P6y,P7y,P8y];
barco=patch(X,Y,'b');
texto=strcat('Q = ',num2str(Q(1)*180/pi),'�');
title('Barco')
if (DibujarMasa)
    title('Barco con Masa de Control')
    L3=sqrt(d(1)^2+(R+D)^2);
	gamma=-pi/2+Q(1)+atan(d(1)/(3*R/2));
	[Cmx,Cmy]=pol2cart(gamma,L3);
	[Pm1x,Pm1y]=pol2cart(pi/4+Q(1),R/4);
	[Pm2x,Pm2y]=pol2cart(3*pi/4+Q(1),R/4);
	[Pm3x,Pm3y]=pol2cart(-3*pi/4+Q(1),R/4);
	[Pm4x,Pm4y]=pol2cart(-pi/4+Q(1),R/4);
	Xm=[Pm1x,Pm2x,Pm3x,Pm4x];Xm=Xm+Cmx*ones(size(Xm));
	Ym=[Pm1y,Pm2y,Pm3y,Pm4y];Ym=Ym+Cmy*ones(size(Ym));
    masa=patch(Xm,Ym,'r');
    texto=strcat(texto,'  d = ',num2str(d(1)));
end
EjeXfijo=line([-3*R,3*R],[0,0]);
EjeYfijo=line([0,0],[-3*R,3*R]);
set(EjeXfijo,'Color','r','LineStyle','-.');
set(EjeYfijo,'Color','r','LineStyle','-.');
EjeX=line([-1,1]*2.5*R*cos(Q(1)),[-1,1]*2.5*R*sin(Q(1)));
EjeY=line([-1,1]*2.5*R*cos(Q(1)+pi/2),[-1,1]*2.5*R*sin(Q(1)+pi/2));
set(EjeX,'Color','k','LineStyle','-.');
set(EjeY,'Color','k','LineStyle','-.');
Texto=text(0,1.8*R,texto);
set(Texto,'HorizontalAlignment','center');
axis([-1,1,-1,1]*3*R)
material dull,light
pause(0.2)
for k=2:Inc:size(Q,2)
	[P1x,P1y]=pol2cart(Q(k)+pi,R);
    [P2x,P2y]=pol2cart(Q(k)+pi,L1);
	[P3x,P3y]=pol2cart(Q(k)-pi/2-beta,L2);
	[P4x,P4y]=pol2cart(Q(k)-pi/2+beta,L2);
	[P5x,P5y]=pol2cart(Q(k),L1);
	[P6x,P6y]=pol2cart(Q(k),R);
	[P7x,P7y]=pol2cart(pi/4+Q(k),R*sqrt(2));
	[P8x,P8y]=pol2cart(3*pi/4+Q(k),R*sqrt(2));
	Arco=[];
	for i=(Q(k)-pi/2-beta):0.1:(Q(k)+beta-pi/2)
	   [xa,ya]=pol2cart(i,L2);
	   Arco=[Arco,[xa;ya]];
	end
	X=[P1x,P2x,P3x,Arco(1,:),P4x,P5x,P6x,P7x,P8x];
	Y=[P1y,P2y,P3y,Arco(2,:),P4y,P5y,P6y,P7y,P8y];
    set(barco,'XData',X,'YData',Y);
	texto=strcat('Q = ',num2str(Q(k)*180/pi),'�');   
   if (DibujarMasa)
       L3=sqrt(d(k)^2+(R+D)^2);
	   gamma=-pi/2+Q(k)+atan(d(k)/(3*R/2));
	   [Cmx,Cmy]=pol2cart(gamma,L3);
       [Pm1x,Pm1y]=pol2cart(pi/4+Q(k),R/4);
       [Pm2x,Pm2y]=pol2cart(3*pi/4+Q(k),R/4);
	   [Pm3x,Pm3y]=pol2cart(-3*pi/4+Q(k),R/4);
	   [Pm4x,Pm4y]=pol2cart(-pi/4+Q(k),R/4); 
	   Xm=[Pm1x,Pm2x,Pm3x,Pm4x];Xm=Xm+Cmx*ones(size(Xm));
	   Ym=[Pm1y,Pm2y,Pm3y,Pm4y];Ym=Ym+Cmy*ones(size(Ym));
       set(masa,'XData',Xm,'YData',Ym);
       texto=strcat(texto,'  d = ',num2str(d(k)));
   end
   set(EjeX,'XData',[-1,1]*2.5*R*cos(Q(k)),'YData',[-1,1]*2.5*R*sin(Q(k)));
   set(EjeY,'XData',[-1,1]*2.5*R*cos(Q(k)+pi/2),'YData',[-1,1]*2.5*R*sin(Q(k)+pi/2));
   set(Texto,'String',texto);
   drawnow
end