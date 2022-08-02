function printpackages(packstruct)
% printpackages prints a table showing all
% values from a vector of 'packages' structures
% Format: printpackages(package structure)
 
fprintf('\nItem #  Cost  Price  Code\n\n')
no_packs = length(packstruct);
for i = 1:no_packs
    fprintf('%6d %6.2f %6.2f %3c\n', ...
        packstruct(i).item_no, ...
        packstruct(i).cost, ...
        packstruct(i).price, ...
        packstruct(i).code)
end
end