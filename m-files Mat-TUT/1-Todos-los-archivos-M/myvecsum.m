function outarg = myvecsum(vec)
% myvecsum returns the sum of the elements in a 
%    vector
% Format of call: myvecsum(vector)
 
outarg = 0;
for i = 1:length(vec)
    outarg = outarg + vec(i);
end
end
