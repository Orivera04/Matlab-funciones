load C:\bob\Courses\ma402.02\codes\outsolar;
n = 11;
mtime = 48;
for k = 1:mtime
    start = (k-1)*n*n;
    for l = 1:n
         for j = 1:n
              for i =1:n
                  A(i,j,l) = outsolar(n*(l-1)+i+start,j);
              end
         end
    end       
slice(A,n,[10 6],[4])
colorbar;
section(:,:)=A(:,6,:);
pause;
% mesh(section);
% pause; 
end