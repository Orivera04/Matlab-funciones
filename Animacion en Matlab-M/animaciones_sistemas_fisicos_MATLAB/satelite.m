function satelite(Q,U)
%   SATELITE Representacion bidimensional de un satelite.
%
%   Funcion que representa graficamente un satelite que gira sobre si mismo segun el vector de angulos Q.
%
%satelite(Q)
%
%satelite(Q,U)
%
% Q -> Angulo de giro. Sentido positivo hacia la derecha. 
%
% U -> Vector de actuaciones de los impulsores. En sentido positivo hace girar al satelite en
%      sentido antihorario.
%      Opcional. Debe tener las mismas dimensiones de Q.
%
%	Si Q es un vector se creara una animacion del satelite moviendose.
%
%   Ver tambien: BARCO, CARRO, PENDULO, PENDULOINV, ROBOT

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

% Redondeo de U
clf

U(find(abs(U)<1e-5))=0;

gris=[.5,.5,.5];
gris2=[.7,.7,.7];

if (size(Q,2)==1)
   Q=Q';
end
if (exist('U')&any(size(Q)~=size(U)))
   error('Q y U deben tener la misma dimensi�n');
end
if (exist('U')&size(U,2)==1)
   U=U';
end
set(gcf,'Render','zbuffer'),axis([-1,1,-1,1]*3.5),axis equal,axis off
title('Satelite')

%Aumentando 'Inc' se eliminan cuadros de la animacion, avivando su velocidad.
Inc=1;

[Sx,Sy]=pol2cart(0:0.1:2*pi,1);
EjeXfijo=line([-1 1]*3.5,[0,0]);
EjeYfijo=line([0,0],[-1 1]*3.5);
set(EjeXfijo,'Color','r','LineStyle','-.');
set(EjeYfijo,'Color','r','LineStyle','-.');
EjeXmovil=line([-1,1]*3.2*cos(Q(1)),[-1,1]*3.2*sin(Q(1)));
EjeYmovil=line([-1,1]*3.2*cos(Q(1)+pi/2),[-1,1]*3.2*sin(Q(1)+pi/2));
set(EjeXmovil,'Color','k','LineStyle','-.');
set(EjeYmovil,'Color','k','LineStyle','-.');
panelx=[-.01 -.01 -.3 -.3 .3 .3 .01 .01];panely=[0 .5 .5 2 2 .5 .5 0];
[QP,RP]=cart2pol(panelx,panely+1);
[Px1,Py1]=pol2cart(QP+Q(1),RP);
panel1=patch(Px1,Py1,gris);
set(panel1,'LineWidth',2);
[Px2,Py2]=pol2cart(QP+Q(1)+pi,RP);
panel2=patch(Px2,Py2,gris);
set(panel2,'LineWidth',2);
texto=strcat('Angulo =',num2str(Q(1)*180/pi),'º');
if (exist('U'))
    Xtemp=[.32 .3 .32 .34 .32 .34 .36 .34 .36 .38 .36 .38 .4 .38 .4 .41 .41 .41 .42 .44 .42 .44 .46 .44 .46 .48 .46 .48 .50 .48 .5 .52 .5];
    Ytemp=[0 .2 0 0 .2 0 0 .2 0 0 .2 0 0 .2 0 0 .2 0 0 .2 0 0 .2 0 0 .2 0 0 .2 0 0 .2 0];
    XFuego1a=Xtemp+1;YFuego1a=Ytemp+.2;XFuego1b=-Xtemp-1;YFuego1b=-Ytemp-.2;
    [QF1a,RF1a]=cart2pol(XFuego1a,YFuego1a);[QF1b,RF1b]=cart2pol(XFuego1b,YFuego1b);
    XFuego2a=Xtemp+1;YFuego2a=-Ytemp-.2;XFuego2b=-Xtemp-1;YFuego2b=Ytemp+.2;
    [QF2a,RF2a]=cart2pol(XFuego2a,YFuego2a);[QF2b,RF2b]=cart2pol(XFuego2b,YFuego2b);
    texto=strcat(texto, ' Actuacion =',num2str(U(1)),' Nm^2');
    if (U(1)>0)
        [XF1a,YF1a]=pol2cart(QF1a+Q(1),RF1a);[XF1b,YF1b]=pol2cart(QF1b+Q(1),RF1b);        
        Fuego1=line(XF1a,YF1a);set(Fuego1,'Color','r'),Fuego2=line(XF1b,YF1b);set(Fuego2,'Color','r')
    elseif (U(1)<0)
        [XF2a,YF2a]=pol2cart(QF2a+Q(1),RF2a);[XF2b,YF2b]=pol2cart(QF2b+Q(1),RF2b);
        Fuego1=line(XF2a,YF2a);set(Fuego1,'Color','r'),Fuego2=line(XF2b,YF2b);set(Fuego2,'Color','r')
    else
        Fuego1=line(0,0);set(Fuego1,'Color','r'),Fuego2=line(0,0);set(Fuego2,'Color','r')
    end
end
Texto=text(0,3.5,texto);
set(Texto,'HorizontalAlignment','center');
Impulsory=[0,.1,.1,.01,.05,.05,.2,.2,.05,.05,-.05,-.05,-.2,-.2,-.05,-.05,-.01,-.1,-.1];
Impulsorx1=[0,0,.2,.3,.3,.39,.3,.5,.41,.5,.5,.41,.5,.3,.39,.3,.3,.2,0]+1;
Impulsorx2=[0,0,-.2,-.3,-.3,-.39,-.3,-.5,-.41,-.5,-.5,-.41,-.5,-.3,-.39,-.3,-.3,-.2,0]-1;
[Q1,R1]=cart2pol(Impulsorx1,Impulsory);
[Q2,R2]=cart2pol(Impulsorx2,Impulsory);
[I1x,I1y]=pol2cart(Q1+Q(1),R1);
[I2x,I2y]=pol2cart(Q2+Q(1),R2);
impulsor1=patch(I1x,I1y,gris2);
impulsor2=patch(I2x,I2y,gris2);
satelite=patch(Sx,Sy,gris);
material dull,light
pause(0.2)
for k=2:Inc:size(Q,2)
    set(EjeXmovil,'XData',[-1,1]*3.2*cos(Q(k)),'YData',[-1,1]*3.2*sin(Q(k)));
    set(EjeYmovil,'XData',[-1,1]*3.2*cos(Q(k)+pi/2),'YData',[-1,1]*3.2*sin(Q(k)+pi/2));
    [Px1,Py1]=pol2cart(QP+Q(k),RP);
    set(panel1,'XData',Px1,'YData',Py1);
    [Px2,Py2]=pol2cart(QP+Q(k)+pi,RP);
    set(panel2,'XData',Px2,'YData',Py2);
    texto=strcat('Angulo =',num2str(Q(k)*180/pi),'�');
    if (exist('U'))
        texto=strcat(texto, ' Actuacion =',num2str(U(k)),' Nm^2');
        if (U(k)>0)
            [XF1a,YF1a]=pol2cart(QF1a+Q(k),RF1a);[XF1b,YF1b]=pol2cart(QF1b+Q(k),RF1b);        
            set(Fuego1,'XData',XF1a,'YData',YF1a);set(Fuego2,'XData',XF1b,'YData',YF1b)
        elseif (U(k)<0)
            [XF2a,YF2a]=pol2cart(QF2a+Q(k),RF2a);[XF2b,YF2b]=pol2cart(QF2b+Q(k),RF2b);
            set(Fuego1,'XData',XF2a,'YData',YF2a);set(Fuego2,'XData',XF2b,'YData',YF2b);
        else
            set(Fuego1,'XData',0,'YData',0),set(Fuego2,'XData',0,'YData',0)
        end
    end
    [I1x,I1y]=pol2cart(Q1+Q(k),R1);
    [I2x,I2y]=pol2cart(Q2+Q(k),R2);
    set(impulsor1,'XData',I1x,'YData',I1y);
    set(impulsor2,'XData',I2x,'YData',I2y);
    set(Texto,'String',texto);
    drawnow
end