x = [7266 12399 10862  9066  1647 11125 12658]; 
disp(char(x))
y =  { 'a',  'bb', 'dddd'}; 
yy =  char(y);
for i = 1:length(y),
  fprintf('**%s**  ==%s==\n', yy(i, :), y{i})
end;    fprintf('\n'); 
whos