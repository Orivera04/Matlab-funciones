function ex_global1

persistent c
global a

if isempty(c), c=1; end;
c = c+1; a = a+1;
fprintf('a et c dans ex_global1 : %d, %d\n', a, c);
