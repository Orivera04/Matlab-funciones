for i=1:nc
     
   plot(-100,-100)
    hold on
    plot(BX,BY,'k')%Bloc
    plot(100,100)
    plot(CX1(i,:),CY1(i,:))%CUADRADO 1
    plot(CX1(i,:),CY1(i,:))%CUADRADO 1
    plot(CX2(i,:),CY2(i,:))%CUADRADO 2
    plot(CX3(i,:),CY3(i,:))%CUADRADO 3
    plot(CX4(i,:),CY4(i,:))%CUADRADO 4
    plot(CX5(i,:),CY5(i,:))%CUADRADO 5

    plot(Px(i,:),Py(i,:),'o')%PENTAGONO

    
     plot(X0(i,:),Y0(i,:),'o')%FIGURA 0 manivela 2 puntos
     plot(X1(i,:),Y1(i,:),'o')%FIGURA 1 pasador biela princ piston 2 puntos 
     plot(X2(i,:),Y2(i,:),'o')%FIGURA 2 pasador biela princ piston 2 puntos  
     plot(X3(i,:),Y3(i,:),'o')%FIGURA 3 pasador biela princ piston 2 puntos 
     plot(X4(i,:),Y4(i,:),'o')%FIGURA 4 pasador biela princ piston 2 puntos 
     plot(X5(i,:),Y5(i,:),'o')%FIGURA 5 pasador biela princ piston 2 puntos 
     
     plot(BX0(i,:),BY0(i,:),'m')

     plot(BPX(i,:),BPY(i,:),'r')%biela maestra
     plot(BX2(i,:),BY2(i,:))
     plot(BX3(i,:),BY3(i,:))
     plot(BX4(i,:),BY4(i,:))
     plot(BX5(i,:),BY5(i,:))
     
    hold off
          M(i) = getframe;
          
%      number = num2str(i);    % names for the current image (Note the need
%      extension = '.bmp';     % for a directory called "images"
%      filename = [number,extension];
%      imwrite(P,eval('filename'),'bmp') % Finally write individual images
%           
%           
%           
          
          
       end
       movie(M)
  movie2avi(M,'motor_radial.avi')