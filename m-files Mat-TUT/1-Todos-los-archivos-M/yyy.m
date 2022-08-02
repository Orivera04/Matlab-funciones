function logresult = yyy(vec)
% QQ for you - what does this do?

count = 0;
for i = 1:length(vec)
    if vec(i) ~= 0
        count = count + 1;
    end
end
 
if count == length(vec)
    logresult = logical(1);
else
    logresult = logical(0);
end
end
