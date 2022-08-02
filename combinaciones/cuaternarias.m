function a = cuaternarias(c)
%Combinaciones cuaternarias. c es el cardinal del conjunto C.
p=1;
for h=1:c-3
    for k=h+1:c-2
        for m=k+1:c-1
            for n=m+1:c
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