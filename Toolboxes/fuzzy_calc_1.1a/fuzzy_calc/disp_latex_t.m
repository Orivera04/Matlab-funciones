function st=disp_latex_t(A);
% function st=disp_latex_t(A);
% latex output for rows, with sign "t" for transpose
% Yordan Kyosev 30.12.2002

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
        stri=[stri s1 ''];
        end
        st(i,1:length(stri))=stri;
    end
    stri;
end
stri_end=['\end {array} \right)^T'];

disp(stri_start)
disp(st)
disp(stri_end)