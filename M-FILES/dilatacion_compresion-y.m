%Dilataciones y compresiones a lo largo de y
%Matrix de dilatacion-compresión en R2: [1,0;0,c].
%Dilatación:0<c<1. Compresión:c>1.
c = input('Introduzca el valor de c: '); 
    G = [1,0;0,c]
    X=trian;
    subplot(1,2,1);
    dot2dot(X);
    title('Triángulo original')
    axis([0 10 0 10])
    subplot(1,2,2);
    dot2dot(G*X);
    if c==1
        title('Transformación idéntica')
    elseif c<1
        title('Compresión a lo largo de y')
    else
    title('Expansión a lo largo de y')
    end
    axis([0 10 0 10])