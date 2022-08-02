function sepplot(A,xy,lname,sname)
%SEPPLOT Used by SEPDEMO to show the separators.
% sepplot(A,xy,lname,sname): plot a mesh, a matrix, a tree, a factor,
% highlighting the top-level separator.
%     A:  the matrix
%    xy: the xy coordinates of the mesh
% lname: the text of the name of the permutation (long)
% sname: the text of the name of the permutation (short)

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin<3
   lname = 'Some Ordering';
end;
if nargin<4
   sname = lname;
end;

clf
subplot(2,2,1);

[n,n] = size(A);
[t,q] = etree(A);
A = A(q,q);
xy = xy(q,:);
[t,q] = etree(A);
[x,y,h,s] = treelayout(t,q);

% identify the top-level separator
sepvtx = n-s+1;
sep = sepvtx:n;

% identify the partitions (subtrees)
parts = find (t == sepvtx);
parts = [1 parts+1 n+1];  % identify them by their first vertices


highlight(A,xy,sep);
title('Finite Element Mesh')

subplot(2,2,2);
if s < n
   spypart(A,parts);
else
   spy(A);
end
title(lname)


subplot(2,2,3)
etreeplot(A);
title(['Elim Tree with ' sname])


subplot(2,2,4)
if s < n
   spypart(chol(A),parts);
else
   spy(chol(A));
end
title(['Factor with ' sname]);
