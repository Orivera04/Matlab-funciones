function c = atan(a)
% ATAN for adiff objects. 

c = adiff(acos(a.x),rowmult(1./sqrt(1+a.x.^2), a.dx),a.root);
