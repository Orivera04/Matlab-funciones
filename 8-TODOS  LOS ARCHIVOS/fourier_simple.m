	                            % GRAPH OF FOURIER SERIES.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                              %
%                                    AHMED TAWFEEK MARMOUSH                                    %                       
%                  2nd year Electrical & Power Engineering departement                         %                                 
%                                          GROUP(1)                                            %
%                                           SEC(1)                                             %
%                                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear %CLEAR ALL OLD VARIABLES

clc   %CLEAR THE SCREEN

t=linspace(-3,3,200);   % setting the values of time

y=0;

for n=1:2:50
    
    y=y+((2/(n*pi))*sin(n*pi*t));    %DEFINE THE EQUATION
    
    
    if n==1
        
        y1=y+.5;
        
        subplot(2,2,1);
        
        plot(t,y1,'r') %PLOT THE IST HARMONIC IN THE CORNER 1
        
        grid on
        
        title('1st harmonic') %PUT THE TITLE OF THE GRAPH
        
        xlabel('t(sec)') %PUT THE TITLE OF X AXIS
        
        ylabel('f(t)')%PUT THE TITLE OF Y AXIS
    end
    
    if n==3
        
         y1=y+.5;
        
        subplot(2,2,2);
        
        plot(t,y1,'b')
        
        grid on
        
        title('3rd harmonic')
        
        xlabel('t(sec)')
        
        ylabel('f(t)')
    end
    
    if n==15
        
         y1=y+.5;
         
        subplot(2,2,3);
        
        plot(t,y1)
        
        grid on
        
        title('21 harmonic')
        
        xlabel('t(sec)')
        
        ylabel('f(t)')
    end
    
    if n==49
        
         y1=y+.5;
        
        subplot(2,2,4);
        
        plot(t,y1)
        
       grid on 
       
       title('49 harmonic')
       
       xlabel('t(sec)')
        
        ylabel('f(t)')
       
    end
    
end