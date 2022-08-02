clc
clear all
q=1;
vi=500;
vf=750;
while q ~= 4
    q = MENU('El Menu','la por Roco','la por PC','la Harmonica','la Diapason','La Piano','La flauta','Salir');
    switch(q)
        case 1
            [yy,ff]=wavread('layo');
            x=0:1/ff:1/ff*(length(yy)-1);
            a=1;
            for i=vi:vf
                X(a)=x(i);
                Y(a)=yy(i);
                a=a+1;
            end
            fre=linspace(-ff/2,ff/2,length(yy));
            figure(1),plot(fre,abs(fftshift(fft(yy))))
            figure(2),plot(X,Y)
            sound(yy,ff)
        case 2
            [yy,ff]=wavread('laco');
            x=0:1/ff:1/ff*(length(yy)-1);
            a=1;
            for i=vi:vf
                X(a)=x(i);
                Y(a)=yy(i);
                a=a+1;
            end
            fre=linspace(-ff/2,ff/2,length(yy));
            figure(1),plot(fre,abs(fftshift(fft(yy))))
            figure(2),plot(X,Y)
            sound(yy,ff)
        case 3
            [yy,ff]=wavread('la');
            x=0:1/ff:1/ff*(length(yy)-1);
            a=1;
            for i=vi:vf
                X(a)=x(i);
                Y(a)=yy(i);
                a=a+1;
            end
            fre=linspace(-ff/2,ff/2,length(yy));
            figure(1),plot(fre,abs(fftshift(fft(yy))))
            figure(2),plot(X,Y)
            sound(yy,ff)    
        case 4
            [yy,ff]=wavread('lad');
            x=0:1/ff:1/ff*(length(yy)-1);
            a=1;
            for i=vi:vf
                X(a)=x(i);
                Y(a)=yy(i);
                a=a+1;
            end
            fre=linspace(-ff/2,ff/2,length(yy));
            figure(1),plot(fre,abs(fftshift(fft(yy))))
            figure(2),plot(X,Y)
            sound(yy,ff)
            q=3;
        case 5
            [yy,ff]=wavread('lap');
            x=0:1/ff:1/ff*(length(yy)-1);
            a=1;
            for i=vi:vf
                X(a)=x(i);
                Y(a)=yy(i);
                a=a+1;
            end
            fre=linspace(-ff/2,ff/2,length(yy));
            figure(1),plot(fre,abs(fftshift(fft(yy))))
            figure(2),plot(X,Y)
            sound(yy,ff) 
        case 6
            [yy,ff]=wavread('laf');
            x=0:1/ff:1/ff*(length(yy)-1);
            a=1;
            for i=vi:vf
                X(a)=x(i);
                Y(a)=yy(i);
                a=a+1;
            end
            fre=linspace(-ff/2,ff/2,length(yy));
            figure(1),plot(fre,abs(fftshift(fft(yy))))
            figure(2),plot(X,Y)
            sound(yy,ff)
        case 7
            fprintf(' Chao ')
            q=4;
    end
end