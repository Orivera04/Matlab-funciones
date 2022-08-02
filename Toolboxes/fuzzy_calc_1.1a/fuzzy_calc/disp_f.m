function disp_f(s,A);
% displays String s as title
% and matrix A, formated
disp('      ')
disp(s)
for i=1:length(A(:,1))
    s = sprintf('%10.4f',A(i,:));
    disp(s);
end
