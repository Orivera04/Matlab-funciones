function outvec = testvecgtn(vec,n)
% testvecgtn tests whether elements in vector 
%    are greater than n or not
% Format: testvecgtn(vector, n)
 
% Preallocate the vector to logical false
outvec = false(size(vec));
for i = 1:length(vec)
    % Each element in the output vector stores 1 or 0
    if vec(i) > n
        outvec(i) = 1;
    else
        outvec(i) = 0;
    end
end
end
