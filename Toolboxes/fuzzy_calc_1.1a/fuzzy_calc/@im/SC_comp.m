function Comp=sc_comp(A,B)
% function Comp=sc_comp(A,B)
% S -C "Standard - Costandard" composition of two intuinitionistic matrices
% A and B
%
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.

%Comp.m=fuzzy_maxmin(A.m,B.m);
%Comp.n=fuzzy_minmax(A.n,B.n);
%disp_intui(Comp)
Comp_.m=fuzzy_maxmin(A.m,B.m);
Comp_.n=fuzzy_minmax(A.n,B.n);
Comp=im(Comp_.m,Comp_.n);