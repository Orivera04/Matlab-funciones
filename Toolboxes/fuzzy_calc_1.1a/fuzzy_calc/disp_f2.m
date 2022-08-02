function s=disp_f2(s,A);
% displays String s as title
% and matrix A, formated
%disp('      ')
if s~=''
disp(s)
end
for i=1:length(A(:,1))
    s = sprintf('%6.2f',A(i,:))
%    disp(s);
end
