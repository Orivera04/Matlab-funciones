nn = []; 
dd = [];
for prec = 10.^(-[1, 6, 8, 11, 12, 14])
  [n, d] = rat(pi,prec);
  nn = [nn n];  
  dd = [dd d];
end;
fprintf('%d/%d ', [nn; dd])
fprintf('\n');
format long
pi
format rat
pi