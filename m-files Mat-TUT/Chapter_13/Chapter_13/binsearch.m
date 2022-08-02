function outind = binsearch(vec, key)
% binsearch searches through a sorted vector
% looking for a key using a binary search
% Format: binsearch(sorted vector, key)
 
low = 1;
high = length(vec);
outind = 0;
 
while low <= high && outind == 0 
   mid = floor((low + high)/2);
   if vec(mid) == key
       outind = mid;
   elseif key < vec(mid)
       high = mid - 1;
   else
       low = mid + 1;
   end
end
end
