% Prints a box of stars
% How many will be specified by 2 variables
%  for the number of rows and columns
 
rows = 3;
columns = 5;
% loop over the rows
for i=1:rows
    % for every row loop to print *'s and then one \n
    for j=1:columns
        fprintf('*')
    end
    fprintf('\n')
end
