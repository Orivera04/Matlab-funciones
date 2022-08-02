f = inline('sin(x.^2+p)','x','p');
r = [];
for t = linspace(0,1,10)
 r = [r quadl(f,0,1,[],[],t)];
end;
r