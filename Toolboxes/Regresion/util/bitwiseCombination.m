function [subhandle, count] = bitwiseCombination(n,l,u)
    if (u<l),temp =u; u=l; l=temp; %interchange 
    end
    if (n<1) || (n~=floor(n))
      error 'n must be a positive integer'
    elseif (u>n) || (l<1) || (l~=floor(l)) || (u~=floor(u))
      error 'l/u must be a positive integer, l<=n u<=n'
    end
    subhandle = @choosenext;
    currentSize=l;
    numRemaining = nchoosek(n,currentSize);
    funcHandle=loopchoose(n,currentSize);
    count=0;
    for i=l:u
        count = count + nchoosek(n,i);
    end
    
    function subset = choosenext
        if numRemaining<=0
            if (currentSize>=u)
                subset = [];
                return                
            else
                currentSize = currentSize+1;
                numRemaining = nchoosek(n,currentSize);
                funcHandle=loopchoose(n,currentSize);
            end
        end
        numRemaining = numRemaining-1;
        subset = funcHandle();          
    end

end