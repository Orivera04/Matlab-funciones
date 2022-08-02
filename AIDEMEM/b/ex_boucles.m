a = eye(3);  b =  [2 7 9 3].^2;  j=0; k=0;  l=0;
for i = a
  fprintf('** '); fprintf('%2d', i); fprintf(' **');  
end; fprintf('\n');
for i = b
   fprintf('%3d', i);   
end;  fprintf('\n');
for i = 1:5 
  i = 6; fprintf('%3d', i);
end; fprintf('\n');
for j = 1:5;
  fprintf('%2d', j); 
  if j == 3, break; end; 
end; fprintf(' **');
while 1
  k = k+1; fprintf('%2d', k); 
  if k == 3, break; end; 
end; fprintf(' **');
l = 0; while (l ~= 3)
  l = l+1; fprintf('%2d', l);
end; fprintf('\n');