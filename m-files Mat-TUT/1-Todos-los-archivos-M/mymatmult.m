% This script demonstrates matrix multiplication
A = [3 8 0; 1 2 5];
B = [1 2 3 1; 4 5 1 2; 0 2 3 0];
 
[m n] = size(A);
[nb p] = size(B);
if n ~= nb
    disp('Cannot perform this matrix multiplication')
else
    % Preallocate C
    C = zeros(m,p);
    % Outer 2 loops iterate through the elements in C
    %   which has dimensions m by p
    for i=1:m
        for j = 1:p
            % Inner loop performs the sum for each
            %  element in C
            mysum = 0;
            for k = 1:n
                mysum = mysum + A(i,k) * B(k,j);
            end
            C(i,j) = mysum;
        end
    end
    % display C
    C
end
