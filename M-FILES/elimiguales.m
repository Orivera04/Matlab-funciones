function y=elimiguales(x)
%Programa que borra elementos iguales en un vector
n=numel(x);
for i=1:n
    for j=i+1:n
        if x(i)==x(j)
            x(j)=[];
        end
    end
end
y=x;