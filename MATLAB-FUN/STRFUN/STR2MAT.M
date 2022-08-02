function s=str2mat(t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11)
%STR2MAT Form text matrix from individual strings.
%	S = STR2MAT(T1,T2,T3,..) forms the matrix S containing the text
%	strings T1,T2,T3,... as rows.  Automatically pads each string with
%	spaces in order to form a valid matrix.  Up to 10 text strings 
%	can be used to form S.  Each text parameter, Ti, can itself be a 
%	string matrix.  This allows the creation of arbitarily large
%	string matrices.

%	Clay M. Thompson  3-20-91
%	Copyright (c) 1984-94 by The MathWorks, Inc.

nstrings = nargin;

% Determine the largest string size.
nrows = zeros(1,11); ncols = zeros(1,11);
for i=1:nargin
  sizecall = ['size(t',int2str(i),')'];
  [m,n] = eval(sizecall);
  nrows(i) = max(1,m);
  ncols(i) = n;
end

% Now form the string matrix.
s = []; space = ' '; len = max(ncols);
if len == 0,
  t1 = ' ';
  ncols(1) = 1;
  len = 1;
end;

for i=1:nargin
  j = int2str(i);  
  formcall = ['[s;[t',j,',space*ones(nrows(',j,'),len-ncols(',j,'))]]'];
  s = eval(formcall);
end

