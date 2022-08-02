function index = smartseqsearch(vec, key)
% Smarter sequential search; searches a vector
% for a key but ends when it is found
% Format: smartseqsearch(vector, key)
 
len = length(vec);
index = 0;
i = 1;
 
while i < len && vec(i) ~= key
    i = i + 1;
end
 
if vec(i) == key
    index = i;
end
end
