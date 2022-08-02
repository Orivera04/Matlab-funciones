function index = seqsearch(vec, key)
% seqsearch performs an inefficient sequential search 
% through a vector looking for a key; returns the index
% Format: seqsearch(vector, key)

len = length(vec);
index = 0;
 
for i = 1:len
    if vec(i) == key
        index = i;
    end
end
end
