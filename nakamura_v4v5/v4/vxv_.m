% vxv_(a,b) computes vector product of vector a and vector b.
% Used in L10_8; Example 10.12
function c=vxv_(a,b) 
c=[a(2)*b(3)-a(3)*b(2);
 -a(1)*b(3)+a(3)*b(1);
 a(1)*b(2)-a(2)*b(1)];
