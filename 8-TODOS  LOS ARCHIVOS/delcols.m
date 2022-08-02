
function d = delcols(d)

% Delete duplicated columns of the matrix d.

d = union(d',d','rows')';
n = size(d,2);
j = [];
for k =1:n
   c = d(:,k);
   for l=k+1:n
      if norm(c - d(:,l),'inf') <= 100*eps
         j = [j l];
      end
   end
end
if ~isempty(j)
   j = sort(j);
   d(:,j) = [];
end

