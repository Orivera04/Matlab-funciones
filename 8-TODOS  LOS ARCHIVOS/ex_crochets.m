a = ones(1,3);  b = eye(1,3);
pilehoriz = cat(1, a, b)
pilevert  = cat(2, a, b)
pile     =  cat(3, a, b)
aa = eye(2, 3)
bb = [aa aa]
cc = [bb; bb]
dd = {aa, bb, [bb, bb]}
ee = [dd{:}]
