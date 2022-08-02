function At=transpose(A);
% function st=disp_intui(A);
% transpose intuitionistic matrix A 
% "A" have to be intuitionististic matrix - "im" object:
%
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.

a.m=(A.m)';
a.n=(A.n)';
At=im(a.m,a.n);