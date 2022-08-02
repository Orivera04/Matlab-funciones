function ex_if(n)

% On ne sait pas si l'exécution se termine
% pour tous les entiers...

fprintf('%d ', n);
if n == 1
  fprintf(' fini\n');
  return;
elseif rem(n,2)
  n = 3*n+1;
else
  n = n/2;
end;
ex_if(n);