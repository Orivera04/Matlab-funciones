% Sums only positive numbers from file
% Reads from the file into a matrix and then
%   calculates and prints the sum of only the
%   positive numbers from each row

load datavals.dat
[r c] = size(datavals);

for i = 1:r
    sumrow = 0;
    for j = 1:c
        if datavals(i,j) >= 0
            sumrow = sumrow + datavals(i,j);
        end
    end
    fprintf('The sum for row %d is %d\n',i,sumrow)
end
