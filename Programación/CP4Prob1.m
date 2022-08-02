%CP 4, Problema 1
clc
fprintf('X\t');
for i=1:10
    fprintf('%d \t',i);
end
fprintf('\n');
for i=1:5
    fprintf('%d',i);
    for j=1:10
        fprintf('\t%d',i*j);
    end
    fprintf('\n');
end