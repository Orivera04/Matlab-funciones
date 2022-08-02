function penduloinv(Q,L)
%   PENDULOINV Representacion bidimensional de un pendulo invertido.
%
%   Funcion que representa graficamente un pendulo invertido moviendose segun
%el vector de angulos Q. Las dimensiones se calculan a partir de la distancia L.
%
%penduloinv(Q,L)
%
% Q -> Angulo de giro. Positivo en sentido horario. 
%
% L -> Longitud de la varilla.
%
%	Si Q es un vector se creara una animacion del pendulo moviendose.
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

fig=figure;set(fig,'DoubleBuffer','on','Renderer','OpenGL');
aviobj = avifile('penduloinv.avi');
try
    aviobj = set(aviobj,'Compression','none');
    if (L<=0)
        error('L debe ser mayor de 0')
    end
    if (size(Q,2)==1)
       Q=Q';
    end
    % set(gcf,'Render','zbuffer')
    title('Pendulo Invertido')

    %Aumentando 'Inc' se eliminan cuadros de la animacion, avivando su velocidad.
    Inc=1;

    Q=-Q+pi/2;
    R=L/10;
    [Cx,Cy]=pol2cart(Q(1),L);
    [Vx,Vy]=pol2cart(Q(1),L-R);
    varilla=line([0,Vx],[0,Vy]);
    set(varilla,'Color','k','LineWidth',2);
    [Esferax,Esferay]=pol2cart(0:0.01:2*pi,R);
    esfera=patch(Esferax+Cx,Esferay+Cy,'b');
    EjeXfijo=line([-1.2,1.2]*L,[0,0]);
    EjeYfijo=line([0,0],[-1.2,1.2]*L);
    set(EjeXfijo,'Color','r','LineStyle','-.');
    set(EjeYfijo,'Color','r','LineStyle','-.');
    texto=strcat('Angulo','  Q = ',num2str(90-Q(1)*180/pi),'�');
    Texto=text(0,1.3*L,texto);
    set(Texto,'HorizontalAlignment','center');
    axis([-1,1,-1,1]*1.5*L),title('Pendulo Invertido')
    material dull,light
    pause(0.2)
    for k=2:Inc:size(Q,2)
        [Cx,Cy]=pol2cart(Q(k),L);
        [Vx,Vy]=pol2cart(Q(k),L-R);
        set(varilla,'XData',[0,Vx],'YData',[0,Vy]);
        set(esfera,'XData',Esferax+Cx,'YData',Esferay+Cy);
        texto=strcat('Angulo','  Q = ',num2str(90-Q(k)*180/pi),'�');
        set(Texto,'String',texto);
        drawnow
        aviobj = addframe(aviobj,getframe(gca));
    end
catch
    aviobj = close(aviobj);
    delete('penduloinv.avi')
end
aviobj = close(aviobj);