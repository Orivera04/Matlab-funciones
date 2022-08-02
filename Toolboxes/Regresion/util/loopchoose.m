function subhandle = loopchoose(n,k)

    if (n<1) || (n~=floor(n))
      error 'n must be a positive integer'
    elseif (k>n) || (k<1) || (k~=floor(k))
      error 'k must be a positive integer, k<=n'
    end

    subhandle = @choosenext;
    currentsubset = [];
    return

    function subset = choosenext
        if isempty(currentsubset)
            subset = 1:k;
        else
            if currentsubset(1) == (n-k+1)
                subset = [];
                return
            end
            last = currentsubset(end);
            if last < n
                subset = currentsubset;
                subset(end) = last+1;
            else
                d = diff(currentsubset);
                L = find(d>1,1,'last');
                subset = currentsubset;
                subset(L) = subset(L)+1;
                subset(L+1:end) = subset(L) + (1:(k-L));
            end
        end
        currentsubset = subset;
    end
end


