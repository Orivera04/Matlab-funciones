function Conic_Sections
clc
format short
t=linspace(0,2*pi,50);
B=0;
clc
fprintf('Please enter the coefficients for the equation Ax^2 + Cy^2 +Dx + Ey + F = 0, element by element\n')
A=input('A=  ');
C=input('C=  ');
D=input('D=  ');
E=input('E=  ');
F=input('F=  ');
if A==C
    if B==0
        a=-(.5*D/A);
        b=-(.5*E/A);
        r=sqrt((F*-1)/A+a^2+b^2);
        if r<=0
            fprintf('This is a point located at (%.02f,%.02f)\n',a,b)
        else
            x=a+r*cos(t);
            y=b+r*sin(t);
            plotgui
            axis equal
            grid on
            fprintf('The Conic Section is a Circle.\n')
            fprintf('The center of the circle is (%.2f,%.2f)\n',a,b)
            fprintf('The radius of the circle is %.02f\n',r)
        end
    end
elseif B^2-4*A*C<0
    fprintf('The Conic Section is an Ellipse.\n')
    ellipse(A,B,C,D,E,F)

elseif B^2-4*A*C==0
    fprintf('The Conic Section is a Parabola.\n')
    parabola(A,B,C,D,E,F)

elseif B^2-4*A*C>0
    fprintf('The Conic Section is a Hyperbola.\n')
    hyperbola(A,B,C,D,E,F)

end


    function ellipse(A,B,C,D,E,F)
        t=linspace(-pi,pi,100);
        q=(F*-1)+(((.5*(D/A))^2)*A)+(((.5*(E/C))^2)*C);
        a=sqrt(abs(q/A));
        b=sqrt(abs(q/C));
        h=-(.5*D/A);
        k=-(.5*E/C);
        x=h+a*cos(t);
        y=k+b*sin(t);
        plotgui
        axis equal
        grid on
        fprintf('The center is at(%.2f,%.2f)\n',h,k)
        fprintf('The major axis is %0.0f units long\n',2*a)
        fprintf('The minor axis is %0.0f units long\n',2*b)
    end


    function hyperbola(A,B,C,D,E,F)
        e=.1;
        t=linspace(-pi/2+e,pi/2-e);
        t=[t,linspace(pi/2+.1,3*pi*2-e)];
        q=(F*-1)+(((.5*(D/A))^2)*A)+(((.5*(E/C))^2)*C);
        a=sqrt(abs(q/A));
        b=sqrt(abs(q/C));
        h=-(.5*D/A);
        k=-(.5*E/C);
        if A>C
            x=a*sec(t)+h;
            y=b*tan(t)+k;
        else
            x=a*tan(t)+h;
            y=b*sec(t)+k;
        end
        plotgui
        xmin=h-2*a;
        xmax=h+2*a;
        ymin=k-2*b;
        ymax=k+2*b;
        axis([xmin,xmax,ymin,ymax])
        axis equal
        fprintf('The center is at(%.2f,%.2f)\n',h,k)
        
    end


    function parabola(A,B,C,D,E,F)
        if C==0
            d=D/-E;
            f=F/-E;
            s=A/-E;
            m=A/abs(E);
            h=-(.5*(d/s));
            k=(f-(h^2*s));
            xmin=h-5;
            xmax=h+5;
            x=linspace(xmin,xmax);
            y=m*(x-h).^2+k;
            fprintf('The vertex is (%.2f.%.2f).\n',h,k)
        elseif A==0
            m=C/-D;
            n=E/-D;
            p=F/-D;
            q=C/abs(D);
            k=-(.5*(n/m));
            h=(p-(k^2*m));
            ymin=k-5;
            ymax=k+5;
            y=linspace(ymin,ymax);
            x=q*(y-k).^2+h;
            fprintf('The vertex is (%.2f,%.2f).\n',h,k)
        end
        plotgui
        axis equal
        grid on

    end


    function plotgui
        close all
        figure_color=[0.4,0.4,0.5];
        panel_color=[0.4,0.4,0.6];
        buttongroup_color=[0.6,0.6,0.7];

        hfigure=figure('Units','pixels','position',[300 200 675 525],...
            'color',figure_color, 'Toolbar','none','Numbertitle','off','MenuBar','none','Name','Conic Sections');
        
        hAxes=axes('Parent',hfigure,'Units','Pixels',...
            'Position',[50 50 425 425],'XGrid','On','YGrid','On');

        hPanel=uipanel('Parent',hfigure,'Units','Pixels',...
            'Position',[500 50 150 425],'BackgroundColor',panel_color);

        popup_group=uibuttongroup('Parent',hPanel,'Units','Pixels','Position',[10 200 130 215],...
            'Backgroundcolor',buttongroup_color,'SelectionChangeFcn', @slider_callback);

        s1=uicontrol('Style','slider','Parent',popup_group,'Units','Pixels','Position',[5 30 115 20],...
            'BackgroundColor',buttongroup_color,...
            'Tag','GreenSlider', 'Min',0,'Max',1,'Callback', @slider_callback);
        
        s1b=uicontrol('Style','text','Parent',popup_group,'Units','Pixels','Position',[5 50 115 20],...
            'String','Green','HorizontalAlignment','Left','BackgroundColor',buttongroup_color);

        s2=uicontrol('Style','slider','Parent',popup_group,'Units','Pixels','Position',[5 80 115 20],...
            'Tag','RedSlider','BackgroundColor',buttongroup_color,...
            'Min',0,'Max',1,'Callback', @slider_callback);
        
        s2b=uicontrol('Style','text','Parent',popup_group,'Units','Pixels','Position',[5 100 115 20],...
            'String','Red','HorizontalAlignment','Left','BackgroundColor',buttongroup_color);


        s3=uicontrol('Style','slider','Parent',popup_group,'Units','Pixels','Position',[5 130 115 20],...
            'Tag','BlueSlider','BackgroundColor',buttongroup_color,...
            'Min',0,'Max',1,'Callback', @slider_callback);

        s3b=uicontrol('Style','text','Parent',popup_group,'Units','Pixels','Position',[5 150 115 20],...
            'String','Blue','HorizontalAlignment','Left','BackgroundColor',buttongroup_color);



        r1b=uicontrol('Style','text','Parent',popup_group,'Units','Pixels','Position',[5 180 115 20],...
            'String','Color','BackgroundColor',buttongroup_color);

        radiobuttongroup=uibuttongroup('Parent',hPanel,'Units','Pixels','Position',[10 10 130 180],...
            'Backgroundcolor',buttongroup_color,'SelectionChangeFcn',@Linestyle_callback);

        r2=uicontrol('Style','Radio','Parent',radiobuttongroup,'Units','Pixels','Position',[5 140 115 20],...
            'String','Solid','BackgroundColor',buttongroup_color);

        r3=uicontrol('Style','radio','Parent',radiobuttongroup,'Units','Pixels','Position',[5 110 115 20],...
            'String','Dash/Dot','BackgroundColor',buttongroup_color);

        r4=uicontrol('Style','radio','Parent',radiobuttongroup,'Units','Pixels','Position',[5 80 115 20],...
            'String','Dotted','BackgroundColor',buttongroup_color);

        r5=uicontrol('Style','radio','Parent',radiobuttongroup,'Units','Pixels','Position',[5 50 115 20],...
            'String','Dashed','BackgroundColor',buttongroup_color);

        r6=uicontrol('Style','radio','Parent',radiobuttongroup,'Units','Pixels','Position',[5 20 115 20],...
            'String','None','BackgroundColor',buttongroup_color);

        hline=plot(x,y,'color','k');
        xlabel('X-Axis')
        ylabel('Y-Axis')
        title('Conic Sections')
        
        
        function Linestyle_callback(hObject,eventdata)
            linestyle=get(eventdata.NewValue,'String');

            switch linestyle
                case 'Dashed'
                    set(hline,'Linestyle','--')
                case 'Dash/Dot'
                    set(hline,'Linestyle','-.')
                case 'Dotted'
                    set(hline,'Linestyle',':')
                case 'Solid'
                    set(hline,'Linestyle','-')
                case 'None'
                    set(hline,'Linestyle','none')
            end
        end
        
        
        function slider_callback(hObject,eventdata)
            linecolor=get(hline,'Color');
            slidertag=get(hObject,'Tag');
            switch slidertag
                case 'RedSlider'
                    linecolor(1)=get(hObject,'Value');
                    set(hline,'Color',linecolor)
                case 'GreenSlider'
                    linecolor(2)=get(hObject,'Value');
                    set(hline,'Color',linecolor)
                case 'BlueSlider'
                    linecolor(3)=get(hObject,'Value');
                    set(hline,'Color',linecolor)
            end
        end

    end
end