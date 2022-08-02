function outmin = myminvec(vec)
% myminvec returns the minimum value in a vector
% Format: myminvec(vector)
 
outmin = vec(1);
for i = 2:length(vec)
    if vec(i) < outmin
        outmin = vec(i);
    end
end
end
