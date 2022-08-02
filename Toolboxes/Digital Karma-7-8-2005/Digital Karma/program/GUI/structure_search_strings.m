findarea==findarea2
findarea(1,2)==findarea2(1,2) & findarea(2,:)==findarea2(2,:)
length(find((findarea==findarea2)))>=prod(size(matrixpaste))/2

% For partial success this says the number hits must be >= to the right side
% Replace asterisks with search string
length(find(***))>=(prod(size(matrixpaste))/2)

% Ensure its not blank space. Zeros must be less than right side.
% Need both only when doing a partial match
% Input the searching coordinates in the find for partial so you have
% non-zeros in the searching coordinates
& (length(find(findarea))>=3 & length(find(findarea2))>=3)


% Remember everything including foundvalues is transposed during the process
% so reverse all the coordinaes and matrix positions
[foundvalues(1,1),(foundvalues(1,2)+2);(foundvalues(2,1)+2),(foundvalues(2,2)+2);foundvalues(3,1),(foundvalues(3,2)+2)]




%Examples
findarea==findarea2 & length(find(findarea))>=3