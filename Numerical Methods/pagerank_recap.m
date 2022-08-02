%% Page Rank Chapter Recap
% This is an executable program that illustrates the statements
% introduced in the Page Rank Chapter of "Experiments in MATLAB".
% You can access it with
%
%    pagerank_recap
%    edit pagerank_recap
%    publish pagerank_recap
%
%  Related EXM programs
%
%  surfer
%  pagerank

%% Sparse matrices
   n = 6
   i = [2 6 3 4 4 5 6 1 1]
   j = [1 1 2 2 3 3 3 4 6]
   G = sparse(i,j,1,n,n)
   spy(G)

%% Page Rank
   p = 0.85;
   delta = (1-p)/n;
   c = sum(G,1);
   k = find(c~=0);
   D = sparse(k,k,1./c(k),n,n);
   e = ones(n,1);j
   I = speye(n,n);
   x = (I - p*G*D)\e;
   x = x/sum(x)

%% Conventional power method
   z = ((1-p)*(c~=0) + (c==0))/n;
   A = p*G*D + e*z;
   x = e/n;
   oldx = zeros(n,1);
   while norm(x - oldx) > .01
      oldx = x;
      x = A*x;
   end
   x = x/sum(x)

%% Sparse power method
   G = p*G*D;
   x = e/n;
   oldx = zeros(n,1);
   while norm(x - oldx) > .01
      oldx = x;
      x = G*x + e*(z*x);
   end
   x = x/sum(x)

%% Inverse iteration
   x = (I - A)\e;
   x = x/sum(x)
   
%% Bar graph
   bar(x)
   title('Page Rank')
