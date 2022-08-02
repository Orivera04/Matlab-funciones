%Dilataciones y compresiones a lo largo de y
%Matrix de dilatacion-compresi�n en R2: [1,0;0,c].
%Dilataci�n:0<c<1. Compresi�n:c>1.
c = input('Introduzca el valor de c: '); 
    G = [1,0;0,c]
    X=trian;
    subplot(1,2,1);
    dot2dot(X);
    title('Tri�ngulo original: h=3')
    axis([0 6 0 3*c+3])
    subplot(1,2,2);
    dot2dot(G*X);
    if c==1
        title('Transformaci�n id�ntica');
        axis([0 6 0 3*c+3])
    elseif c<1
        b=3*c;
        title(['Compresi�n a lo largo de y h=',num2str(b)]);
        axis([0 6 0 3*c+3])
    else
       b=3*c; 
    title(['Expansi�n a lo largo de y h=',num2str(b)]);
    axis([0 6 0 3*c+3])
    end
    