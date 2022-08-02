function ex_cross
x = rand(1,30);
y = mat2cross(x,6,repmat(6,5,1));
z = cross(y{:});

function z = crossn(varargin)
% z = crossn(x1, ..., xn)
%     produit vectoriel de n-1 vecteurs de dimension n
n = length(varargin);
d = cellfun('length', varargin); 
if any(d ~= n+1)
  error(['les ' num2str(n) ...
         ' vecteurs doivent être tous de taille '...
         num2str(n+1) 'x1']);
end;
x = zeros(n+1);
z = zeros(n+1, 1);
for i = 1:n
  x(:, i)=  varargin{i};
end;
for i = 1:n+1
  x(:, n+1) = zeros(n+1, 1);
  x(i, n+1) = 1;
  z(i) = det(x);
end;     

