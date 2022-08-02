function sn=term2vec(p,out_length);
% function sn=term2vec(p,out_length);
% converts term to vector with lenthg  out_length
%
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.

sn=zeros(1,out_length);
for i=1:length(p)
            sn(p(i).d)=p(i).n;
end