function disp_f2(s,A);
% displays String s as title
% and matrix A, formated
disp('      ')
disp(s)
for i=1:length(A(:,1))
    s = sprintf('%4.1f',A(i,:));
    disp(s);
end
