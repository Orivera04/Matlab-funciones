a =  [
1 1 0 0 0 1 1 0 0 0
1 1 0 0 0 1 1 0 0 0
1 0 0 0 0 1 0 0 0 0
1 1 0 0 0 1 1 1 1 1
1 1 0 0 0 1 0 0 0 0
1 1 1 0 0 1 1 0 0 0
1 1 0 1 0 1 0 0 0 0
1 1 0 0 0 1 0 1 0 0
1 1 0 0 0 1 0 1 0 0]*'*'; 
a1 = a(:,1:5);
a2 = a(:,6:10);
b = zeros(size(a1, 1), 1)+32; 
clc
for i =1:80
  home
  eval(['char(a' num2str(mod(i, 2)+1) ')']);
  a1 = [b a1];
  a2 = [b a2];   
  pause(0.3)
end
