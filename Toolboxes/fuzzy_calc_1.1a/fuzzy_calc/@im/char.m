function st=char(A);
% function st=disp_intui(A);
% displays intuitionistic matrix A formated on the screen
% "A" have to be intuitionististic matrix - im object:
%
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.

for i=1:length(A.m(:,1))
    stri=[];
    for j=1:length(A.m(1,:))
        s1=sprintf('%4.2f',A.m(i,j));
        s2=sprintf('%4.2f',A.n(i,j));
        stri=[stri '<' s1 ', ' s2 '>   '];
        st(i,1:length(stri))=stri;
    end
end

