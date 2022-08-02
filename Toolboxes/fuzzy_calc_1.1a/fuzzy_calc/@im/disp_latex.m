function st=disp_latex(A);
% function st=disp_latex_intu(A);
% latex output for intuitionistic matrix
%
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.



alig=[];
for i=1:length(A.m(1,:))
    alig=[alig 'r'];
%    keyboard
end
stri_start=['\left [\begin {array}{' alig '}'];

for i=1:length(A.m(:,1))
    stri=['<'];
    for j=1:length(A.m(1,:))
                
        s1=sprintf('%8.2f',A.m(i,j));
        s2=sprintf('%6.2f',A.n(i,j));
        s12=[s1 ',' s2];
%(0.00,  0.90)\;\;&    (0.80,  0.00)\\                
        if j<length(A.m(1,:))
        stri=[stri s12 '>\;\;&<'];
        elseif j==length(A.m(1,:))
        stri=[stri s12 '>\\'];
        end
        st(i,1:length(stri))=stri;
    end
    stri;
end
stri_end=['\end {array} \right]'];

disp(stri_start)
disp(st)
disp(stri_end)