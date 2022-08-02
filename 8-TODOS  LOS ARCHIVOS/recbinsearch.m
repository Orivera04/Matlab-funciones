function outind = recbinsearch(vec, key, low, high)
% recbinsearch recursively searches through a vector
% for a key; uses a binary search function
% The min and max of the range are also passed
% Format: recbinsearch(vector, key, rangemin, rangemax)

mid = floor((low + high)/2);

if low > high
    outind = 0;
elseif vec(mid) == key
    outind = mid;
elseif key < vec(mid)
    outind = recbinsearch(vec,key,low,mid-1);
else
    outind = recbinsearch(vec,key,mid+1,high);
end
end
