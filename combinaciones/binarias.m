function a = binarias(c)
%Combinaciones ternarias. c es el cardinal del conjunto C.
p=1;
for h=1:c-1
    for k=h+1:c
          a(p,1)=h;
          a(p,2)=k;
          p=p+1;
    end
end
a