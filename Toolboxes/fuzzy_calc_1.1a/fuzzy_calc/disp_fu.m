function st=disp_fu(A);
% displays String s as title
% and matrix A, formated
for i=1:length(A(:,1))
    s=sprintf('%10.4f',A(i,:));
    st(i,1:length(s))=s; 
end
