function pos=posicion2(P,Q,R)
%Posicion de un punto R a la izquierda o a la derecha del segmento PQ
%pos1:'R esta a la izquierda de PQ'
%pos2:'R esta a la derecha de PQ'
%pos3:'R esta sobre PQ'
%pos4:'R está al lado de PQ=P=Q
global pos
x1=P(1);
y1=P(2);
x2=Q(1);
y2=Q(2);
x3=R(1);
y3=R(2);
if x1==x2
    if y1==y2
        %disp('P=Q, introduzca puntos distintos');
        pos=4;
    elseif x3<x1&y1<y2
            pos=1;
    elseif x3<x1&y1>y2
            pos=2;        
    elseif x3>x1&y1<y2
            pos=2;
    elseif x3>x1&y1>y2
            pos=1;        
    elseif x3==x1
            pos=3;
    end
elseif y1==y2
        if y3>y1&x1>x2
            pos=2;
        elseif y3>y1&x1<x2
            pos=1;
        elseif y3<y1&x1>x2
            pos=1;
        elseif y3<y1&x1<x2 
            pos=2;
        elseif y3==y1
            pos=3;
        end
elseif y3>((y2-y1)*x3+x2*y1-x1*y2)/(x2-x1)
            if x2>x1
            pos=1;
            else
            pos=2;
            end
elseif y3<((y2-y1)*x3+x2*y1-x1*y2)/(x2-x1)
            if x2>x1
            pos=2;
            else
            pos=1;
            end
elseif y3==((y2-y1)*x3+x2*y1-x1*y2)/(x2-x1)
            pos=3;
end;
            
        
        
        