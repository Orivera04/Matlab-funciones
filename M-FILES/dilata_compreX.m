%Dilataciones y compresiones a lo largo del eje x
%Matrix de dilatacion-compresión en R2: [1,0;0,c].
%Dilatación:0<c<1. Compresión:c>1.
c = input('Introduzca el valor de c: '); 
    G = [c,0;0,1]
    X=trian;
    subplot(1,2,1);
    dot2dot(X);  %grid on
    title('Triángulo original: b=5')
    axis([0 c*10+5 0 6])
    subplot(1,2,2);
    dot2dot(G*X);
    grid on
    if c==1
        title('Transformación idéntica');
        axis([0 c*10+5 0 6])
    elseif c<1
        b=5*c;
        title(['Compresión a lo largo de x: b=',num2str(b)]);
        axis([0 c*10+5 0 6])
    else
    b=5*c;   
    title(['Expansión a lo largo de x: b=',num2str(b)]);
    axis([0 c*10+5 0 6])
    end
    grid on
    