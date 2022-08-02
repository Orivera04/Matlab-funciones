function out=curl(vec,var)
out=[diff(vec(3),var(2))- diff(vec(2),var(3)),diff(vec(1),var(3))-diff(vec(3),var(1)),diff(vec(2),var(1))-diff(vec(1),var(2))];


