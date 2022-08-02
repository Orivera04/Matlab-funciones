function penduloinv2(Q,dQ,L,t)
%   PENDULOINV2 Representacion bidimensional de un pendulo invertido.
%
%   Funcion que representa graficamente un pendulo invertido moviendose segun
%el vector de angulos Q. Las dimensiones se calculan a partir de la distancia L.
%
%penduloinv(Q,dQ,L,t)
%
%
%   Ver tambien: BARCO, CARRO, PENDULO, ROBOT, SATELITE

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

if (size(Q,2)==1)
   Q=Q';
end
if (size(dQ,2)==1)
   dQ=dQ';
end
if (size(t,2)==1)
   t=t';
end

FontSize=12;
Q=-Q+pi/2;

fig=figure;set(fig,'DoubleBuffer','on','Renderer','OpenGL');
title('Pendulo Invertido'),set(get(get(fig,'CurrentAxes'),'Title'),'FontSize',FontSize)

f1=subplot(221);
plot(t,Q,[t(1) t(end)],[Q(end),Q(end)],'k--'),hold on
ylabel('$\theta (rad)$'),set(get(f1,'YLabel'),'FontSize',FontSize,'Interpreter','latex')
title('Posici�n Angular'),set(get(f1,'Title'),'FontSize',FontSize)
xlabel('Tiempo (s)'),set(get(f1,'XLabel'),'FontSize',FontSize)
set(f1,'XLim',[t(1) t(end)])
set(f1,'YLim',[min(Q) max(Q)]*1.1)

f2=subplot(223);
plot(t,dQ,[t(1) t(end)],[dQ(end),dQ(end)],'k--'),hold on
ylabel('$\dot{\theta}(rad/s)$'),set(get(f2,'YLabel'),'FontSize',FontSize,'Interpreter','latex')
title('Velocidad Angular'),set(get(f2,'Title'),'FontSize',FontSize)
xlabel('Tiempo (s)'),set(get(f2,'XLabel'),'FontSize',FontSize)
set(f2,'XLim',[t(1) t(end)])
set(f2,'YLim',[min(dQ) max(dQ)]*1.1)

f3=subplot(122);
set(f3,'XLim',[-1,1]*1.5*L),set(f3,'YLim',[-1,1]*1.5*L)
axis image

aviobj = avifile('penduloinv2.avi');
try
    if (L<=0)
        error('L debe ser mayor de 0')
    end
    % set(gcf,'Render','zbuffer')

    %Aumentando 'Inc' se eliminan cuadros de la animacion, avivando su velocidad.
    Inc=1;
    R=L/10;
    [Cx,Cy]=pol2cart(Q(1),L);
    [Vx,Vy]=pol2cart(Q(1),L-R);
    varilla=line([0,Vx],[0,Vy]);
    set(varilla,'Color','k','LineWidth',2);
    
    f1=subplot(221);
    [Esfera1x,Esfera1y]=pol2cart(0:0.01:2*pi,0.2);
    Punto1=patch(Esfera1x+t(1),Esfera1y+Q(1),'r');
    
    f2=subplot(223);
    [Esfera2x,Esfera2y]=pol2cart(0:0.01:2*pi,0.35);
    Punto2=patch(Esfera2x+t(1),Esfera2y+dQ(1),'r');
    
    f3=subplot(122);
    [Esferax,Esferay]=pol2cart(0:0.01:2*pi,R);
    
    aviobj = set(aviobj,'Compression','none');
    aviobj = set(aviobj,'Fps',20);
    esfera=patch(Esferax+Cx,Esferay+Cy,'b');
    EjeXfijo=line([-1.2,1.2]*L,[0,0]);
    EjeYfijo=line([0,0],[-1.2,1.2]*L);
    set(EjeXfijo,'Color','r','LineStyle','-.');
    set(EjeYfijo,'Color','r','LineStyle','-.');
    texto=strcat('Angulo','  Q = ',num2str(90-Q(1)*180/pi),'�');
    Texto=text(0,1.3*L,texto);
    set(Texto,'HorizontalAlignment','center');
    
    theta=pi/2:(Q(1)-pi/2)/100:Q(1);
    cuerdax=0.5*cos(theta).*(6*pi-0.6.*theta)/(6*pi);
    cuerday=0.5*sin(theta).*(6*pi-0.6.*theta)/(6*pi);
    Cuerda=line(cuerdax,cuerday);
    set(Cuerda,'Color','g','LineWidth',2);

    
    material dull,light
%     pause(1)
    for k=2:Inc:size(Q,2)
        f1=subplot(221);
        set(Punto1,'XData',Esfera1x+t(k),'YData',Esfera1y+Q(k));
        
        f2=subplot(223);
        set(Punto2,'XData',Esfera2x+t(k),'YData',Esfera2y+dQ(k));
    
        f3=subplot(122);
        [Cx,Cy]=pol2cart(Q(k),L);
        [Vx,Vy]=pol2cart(Q(k),L-R);
        set(varilla,'XData',[0,Vx],'YData',[0,Vy]);
        set(esfera,'XData',Esferax+Cx,'YData',Esferay+Cy);
        texto=strcat('�ngulo',' \theta = ',num2str(90-Q(k)*180/pi),'�');
        set(Texto,'String',texto);
        
        theta=pi/2:(Q(k)-pi/2)/200:Q(k);
        cuerdax=0.5*cos(theta).*(6*pi-0.6.*theta)/(6*pi);
        cuerday=0.5*sin(theta).*(6*pi-0.6.*theta)/(6*pi);
        set(Cuerda,'XData',cuerdax,'YData',cuerday);       
        
        drawnow
        aviobj = addframe(aviobj,getframe(fig));
    end
catch
    aviobj = close(aviobj);
    delete('penduloinv2.avi')
end
aviobj = close(aviobj);