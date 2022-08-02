

function vert = feassol(A, b)

% Basic feasible solutions vert to the system of constraints 

%                       Ax = b, x >= 0.

% They are stored in columns of the matrix vert.

[m, n] = size(A);
warning off
b = b(:);
vert = [];
if (n >= m)
   t = nchoosek(1:n,m);
   nv = nchoosek(n,m);
   for i=1:nv
      y = zeros(n,1);
      x = A(:,t(i,:))\b;
      if all(x >= 0 & (x ~= inf & x ~= -inf))
         y(t(i,:)) = x;
         vert = [vert y];
      end
   end
else
   error('Number of equations is greater than the number of variables.')
end
if ~isempty(vert)
   vert = delcols(vert);
else
   vert = [];
end




      