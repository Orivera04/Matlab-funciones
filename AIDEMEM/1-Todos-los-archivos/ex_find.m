a = rand(3,3)
a1 = a;
[i,j]=find(a1 > 0.5);
for k = 1:length(i)    % méthode très inefficace
  a1(i(k),j(k)) = 1;
end;
a1
a1 = a(:);
a1(find(a1 > 0.5))=1;  % méthode lourde
a1 = reshape(a1,3,3)

a1(a1 > 0.5)=1         % meilleure méthode
