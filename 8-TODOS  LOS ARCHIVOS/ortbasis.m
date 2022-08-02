function mat=ortbasis(v)
% mat=ortbasis(v) 
% ~~~~~~~~~~~~~~
% This function generates a rotation matrix
% having v(:)/norm(v) as the third column

v=v(:)/norm(v); mat=[null(v'),v]; 
if det(mat)<0, mat(:,1)=-mat(:,1); end