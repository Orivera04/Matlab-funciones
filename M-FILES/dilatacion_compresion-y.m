%Dilataciones y compresiones a lo largo de y
%Matrix de dilatacion-compresi�n en R2: [1,0;0,c].
%Dilataci�n:0<c<1. Compresi�n:c>1.
c = input('Introduzca el valor de c: '); 
    G = [1,0;0,c]
    X=trian;
    subplot(1,2,1);
    dot2dot(X);
    title('Tri�ngulo original')
    axis([0 10 0 10])
    subplot(1,2,2);
    dot2dot(G*X);
    if c==1
        title('Transformaci�n id�ntica')
    elseif c<1
        title('Compresi�n a lo largo de y')
    else
    title('Expansi�n a lo largo de y')
    end
    axis([0 10 0 10])