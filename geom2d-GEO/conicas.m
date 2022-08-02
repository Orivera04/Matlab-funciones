%Cónicas con ecuación en forma canónica
nombre=input('¿Qué cónica quiere dibujar? ');
disp('Escoja el nombre en el menu');
n=menu('Escoja una cónica','parábola','elipse','hipérbola');
switch n
    case 1
        disp('parábola');
        eje_parabola=input('Dar el eje de la parábola: ');
        if eje_parabola == 'x'
            p=input('Dar el valor de p: ');
            x=0:0.1:5;          
          if p>0
            y1=sqrt(2*p*x);
            y2=-sqrt(2*p*x);
            plot(x,y1);
            hold on
            plot(x,y2);
            hold off
          else
            x1=-x;
            y1=sqrt(2*p*x1);
            y2=-sqrt(2*p*x1);
            plot(x1,y1);
            hold on
            plot(x1,y2);
            hold off
          end
        else
            p=input('Dar el valor de p: ');
            x=-5:0.1:5; 
            y=x.^2/(2*p);
            plot(x,y);
        end
        
    case 2
        disp('elipse')
        a=input('Dar el valor de a: ');
        b=input('Dar el valor de b: ');
        if a>b
            x=-a:0.1:a;
            y1=sqrt((a^2*b^2-b^2*x.^2)/a^2);
            y2=-sqrt((a^2*b^2-b^2*x.^2)/a^2);
            plot(x,y1,x,y2);
            axis equal
        else
            x=-a:0.1:a;
            y1=sqrt((a^2*b^2-b^2*x.^2)/a^2);
            y2=-sqrt((a^2*b^2-b^2*x.^2)/a^2);
            plot(x,y1,x,y2);
            axis equal
        end
    case 3
        disp('hipérbola');
        eje_real=input('Dar eje real de la hipérbola: ');
        a=input('Dar el valor de a: ');
        b=input('Dar el valor de b: ');
        if eje_real=='x'
            x=-(a+5):0.1:-a;
            y1=sqrt((b^2*x.^2-a^2*b^2)/b^2);
            y2=-sqrt((b^2*x.^2-a^2*b^2)/b^2);
            plot(x,y1,x,y2);
            hold on;
            plot(-x,y1,-x,y2);
            hold off
        else
            x=-a:0.1:a;
            y1=sqrt((b^2*x.^2+a^2*b^2)/b^2);
            y2=-sqrt((b^2*x.^2+a^2*b^2)/b^2);
            plot(x,y1,x,y2);
            
           end        
end