function p = ge(v,w)
% "greater than or equal " for two terms
% p =1 if  v <= w
% p =0 if  v >= w
% p =-1 if  not comparable   
% 
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.


p=le(w,v);