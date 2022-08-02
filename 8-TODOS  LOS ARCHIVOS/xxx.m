function logresult = xxx(vec)
% QQ for you - what does this do?

logresult = logical(0);
i = 1;
while i <= length(vec) && logresult == 0
    if vec(i) ~= 0
        logresult = logical(1);
    end
    i = i + 1;
end
end
