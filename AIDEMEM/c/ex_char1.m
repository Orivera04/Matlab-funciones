a  = reshape(char([32:127, 160:255]),8,24 )';
b  = [0:11]*8+32;
b = [b, b+128];
c = 0:7;

fprintf('    ');
fprintf('%4d',c);
fprintf('\n')
for i=1:length(b)
  fprintf('%4d',b(i));
  fprintf('%4c',a(i,:));
  fprintf('\n');
end;
