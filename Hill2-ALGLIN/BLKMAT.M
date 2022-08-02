function v=blkmat(m,n)                    %last updated 1/17/96
%BLKMAT  Generate a matrix of blanks of size m by n.
%
%        Use in the form   ==>  blkmat(m,n)   <==
%
%     By: David R. Hill, MATH DEPT, Temple University,
%         Philadelphia, Pa. 19122   Email: hill@math.temple.edu
v=[];
for i=1:m
    v=[v;blanks(n)];
end

