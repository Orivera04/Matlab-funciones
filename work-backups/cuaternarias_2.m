function a = cuaternarias(c)
%Combinaciones cuaternarias. c es el cardinal del conjunto
p=1;
for h=1:4
    for k=h+1:5
        for m=k+1:6
            for n=m+1:7
                a(p,1)=h;
                a(p,2)=k;
                a(p,3)=m;
                a(p,4)=n;
                p=p+1;
            end
        end
    end
end
a