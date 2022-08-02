function outarg = myvecprod(vec)
% myvecprod returns the product of
% the elements in a vector
% Format of call: myvecprod(vector)
 
outarg = 1;
for i = 1:length(vec)
    outarg = outarg * vec(i);
end
end
