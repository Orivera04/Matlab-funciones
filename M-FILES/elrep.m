function rep=elrep(x)
%Programa que cuenta elementos iguales en un vector
n=numel(x);conta=0;
for i=1:n
    for j=i+1:n
        if x(i)==x(j)
            conta=1;
        end
    end
end
rep=conta;