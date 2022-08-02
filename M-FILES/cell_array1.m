%Ejemplo de cell array
e=cell(3,1);
for i=1:3
        e{i}=[i i+1];
end
celldisp(e)