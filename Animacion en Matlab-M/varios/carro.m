function carro(Q,X,L,F,Eje,Inc)
%   CARRO Representacion bidimensional de un pendulo invertido montado sobre un carro.
%
%   Funcion que representa graficamente un pendulo invertido moviendose sobre un
% carro segun el vector de angulos Q y el de distancias X. Las dimensiones se calculan
% a partir de la distancia L, longitud de la varilla.
%
%carro(Q,X,L)
%
%carro(Q,X,L,F)
%
%carro(Q,X,L,F,Eje)
%
%%carro(Q,X,L,F,Eje,Inc)
%
% Q -> Angulo de giro. Positivo en sentido horario. 
%
% X -> Distancia del Origen al carro.
%
% L -> Longitud de la varilla.
%
% F -> Vector de fuerzas aplicadas sobre el carro. Sentido positivo hacia la derecha.
%      Opcional. Debe tener las mismas dimensiones de Q.
%
% Eje -> Indica el tama�o del eje X, [Xmin, Xmax]. Opcional.
%        Para dar un valor a Eje sin inicar F usar: carro(Q,X,L,[],Eje)
%
% Inc -> N� imagenes que se saltan al realizar la animacion.
%        Aumentar si la animacion es lenta.
%
%	Si Q y X son vectores de la misma dimension se creara una animacion del pendulo moviendose.
%
%   Ver tambien: BARCO, PENDULO, PENDULOINV, ROBOT, SATELITE

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

if (L<=0)
    error('L debe ser mayor de 0')
end
if (size(Q,2)==1)
   Q=Q';
end
if (size(X,2)==1)
   X=X';
end
if (any(size(Q)~=size(X)))
   error('Q y X deben tener la misma dimensi�n');
end
if (exist('F')&~isempty(F)&any(size(Q)~=size(F)))
   error('Q y F deben tener la misma dimensi�n');
end
if (~exist('Eje')|isempty(Eje))
    Eje=[min(X)-L max(X)+L];
end
if (exist('Eje')&any(size(Eje)~=[1,2]))
   error('Eje debe tener dimensi�n 1x2');
end
set(gcf,'Render','zbuffer')
title('Pendulo invertido sobre Carro')

%Aumentando 'Inc' se eliminan cuadros de la animacion, avivando su velocidad.
if (~exist('Inc')|isempty(Inc)|any(size(Inc)~=[1,1]))
   Inc=1;
end

Q=-Q+pi/2;
R=L/10;
[Cx,Cy]=pol2cart(Q(1),L);
Cx=Cx+X(1);Cy=Cy+L/2+R/2;
[Vx,Vy]=pol2cart(Q(1),L-R);Vx=Vx+X(1);Vy=Vy+L/2+R/2;
Ycarro=[L/2+R,L/2+R,R,R,L/2+R];
carro=patch([X(1),X(1)-L/2,X(1)-L/2,X(1)+L/2,X(1)+L/2],Ycarro,'b');
varilla=line([X(1),Vx],[L/2+R,Vy]);
set(varilla,'Color','k','LineWidth',2);
[Esferax,Esferay]=pol2cart(0:0.01:2*pi,R);
esfera=patch(Esferax+Cx,Esferay+Cy,'b');
rueda1=patch(Esferax-L/2+2*R+X(1),Esferay+R,'k');
rueda2=patch(Esferax+L/2-2*R+X(1),Esferay+R,'k');
if (exist('F')&~isempty(F))
    Flechax_pos=[0,.8,.8,1,.8,.8,0]*L/4-(3*L/4);
    Flechax_neg=[1,.2,.2,0,.2,.2,1]*L/4+L/2;
    Flechax=[Flechax_neg;zeros(1,7);Flechax_pos];
    Flechay=[.1,.1,.2,0,-.2,-.1,-.1]*L/4+L/2;
    flecha=patch(Flechax(sign(F(1))+2,:)+X(1),Flechay,'r');
    texto=strcat('Fuerza = ',num2str(F(1)),' N');
    TextoF=text((Eje(1)+Eje(2))/2,-L/3,texto);
    set(TextoF,'HorizontalAlignment','center');
end
axis([Eje(1),Eje(2),-L,2*L]);title('Pendulo Invertido sobre Carro')
EjeXfijo=line([Eje(1),Eje(2)],[0,0]);
EjeYfijo=line([0,0],[-L/2,2*L]);
EjeMovil=line(X(1)*[1 1],L/2*[3.5 -0.2]+R/2*[1 1]);
set(EjeXfijo,'Color','r','LineStyle','-.');
set(EjeYfijo,'Color','r','LineStyle','-.');
set(EjeMovil,'Color','k','LineStyle','-.');
texto=strcat('Angulo  Q = ',num2str(90-Q(1)*180/pi),'�',' Distancia X = ',num2str(X(1)),' m');
Texto=text((Eje(1)+Eje(2))/2,-L/2,texto);
set(Texto,'HorizontalAlignment','center');
material dull,light
pause(0.2)
for k=2:Inc:size(Q,2)
    [Cx,Cy]=pol2cart(Q(k),L);
    Cx=Cx+X(k);Cy=Cy+L/2+R/2;
    [Vx,Vy]=pol2cart(Q(k),L-R);Vx=Vx+X(k);Vy=Vy+L/2+R/2;
    set(carro,'XData',[X(k),X(k)-L/2,X(k)-L/2,X(k)+L/2,X(k)+L/2],'YData',Ycarro);
    set(varilla,'XData',[X(k),Vx],'YData',[L/2+R,Vy]);
    set(esfera,'XData',Esferax+Cx,'YData',Esferay+Cy);
    set(EjeMovil,'XData',X(k)*[1 1],'YData',L/2*[3.5 -0.2]+R/2*[1 1]);
    set(rueda1,'XData',Esferax-L/2+2*R+X(k),'YData',Esferay+R);
    set(rueda2,'XData',Esferax+L/2-2*R+X(k),'YData',Esferay+R);
    if (exist('F')&~isempty(F))
        set(flecha,'XData',Flechax(sign(F(k))+2,:)+X(k),'YData',Flechay);
        texto=strcat('Fuerza = ',num2str(F(k)),' N');
        set(TextoF,'String',texto);
    end
    texto=strcat('Angulo  Q = ',num2str(90-Q(k)*180/pi),'�',' Distancia X = ',num2str(X(k)),' m');
    set(Texto,'String',texto);
    drawnow
end