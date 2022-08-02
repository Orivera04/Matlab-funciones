N = 200;a = zeros(N,N);for i=1:N  for j=1:N    if j>=i      a(i,j) = sum(i:j);    end  endend
