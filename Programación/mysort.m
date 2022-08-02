function outv = mysort(vec)
% mysort sorts a vector using the selection sort
% Format: mysort(vector)
 
% Loop through the elements in the vector to end-1
for i = 1:length(vec)-1
    low = i;  % stores the index of the smallest
    %Select the smallest number in the rest of the vector
    for j=i+1:length(vec)
        if vec(j) < vec(low)
            low = j;
        end
    end
    % Exchange elements
    temp = vec(i);
    vec(i) = vec(low);
    vec(low) = temp;
end
outv = vec;
end
