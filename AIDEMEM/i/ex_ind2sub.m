a = rand(3,5)
[i, j] = find(a>0.5);
a(sub2ind(size(a),i,j))=3
