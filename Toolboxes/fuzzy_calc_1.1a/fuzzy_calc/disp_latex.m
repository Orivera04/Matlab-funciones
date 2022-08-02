function st=disp_latex(A);
% function st=disp_latex(A);
% latex output for matrix
% Yordan Kyosev 2003


alig=[];
for i=1:length(A(1,:))
    alig=[alig 'r'];
%    keyboard
end
stri_start=['\left (\begin {array}{' alig '}'];

for i=1:length(A(:,1))
    stri=[];
    for j=1:length(A(1,:))
        s1=sprintf('%6.1f',A(i,j));
        if j<length(A(1,:))
        stri=[stri s1 '&'];
        elseif j==length(A(1,:))
        stri=[stri s1 '\\'];
        end
        st(i,1:length(stri))=stri;
    end
    stri;
end
stri_end=['\end {array} \right)'];

disp(stri_start)
disp(st)
disp(stri_end)