function z = crvnam(Clist,ct)
%---------------------------------------------------------------------------
%CRVNAM   The string name for the function created with crvfit.
% Sample call
%   z = crvnam(Clist,ct)
% Inputs
%   Clist   coefficient list for the curve
%   ct      curve type
% Return
%   z       string name for the function
%
% NUMERICAL METHODS: MATLAB Programs, (c) John H. Mathews 1995
% To accompany the text:
% NUMERICAL METHODS for Mathematics, Science and Engineering, 2nd Ed, 1992
% Prentice Hall, Englewood Cliffs, New Jersey, 07632, U.S.A.
% Prentice Hall, Inc.; USA, Canada, Mexico ISBN 0-13-624990-6
% Prentice Hall, International Editions:   ISBN 0-13-625047-5
% This free software is compliments of the author.
% E-mail address:      in%"mathews@fullerton.edu"
%
% Algorithm 5.3 (Non-linear Curve Fitting).
% Section	5.2, Curve Fitting, Page 280
%---------------------------------------------------------------------------

A = Clist(1);
B = Clist(2);
C = Clist(3);
D = Clist(4);
L = Clist(5);
if ct==1&B>=0, 
z=['f(x) = ',num2str(A),'/x + ',num2str(B)];end
if ct==1&B<0, 
z=['f(x) = ',num2str(A),'/x - ',num2str(abs(B))];end
if ct==2&C>=0,
z=['f(x) = ',num2str(D),'/(x + ',num2str(C),')'];end
if ct==2&C<0,
z=['f(x) = ',num2str(D),'/(x - ',num2str(abs(C)),')'];end
if ct==3&B>=0,
z=['f(x) = 1/(',num2str(A),' x + ',num2str(B),')'];end
if ct==3&B<0,
z=['f(x) = 1/(',num2str(A),' x - ',num2str(abs(B)),')'];end
if ct==4&B>=0,
z=['f(x) = x/(',num2str(A),' + ',num2str(B),' x)'];end
if ct==4&B<0,
z=['f(x) = x/(',num2str(A),' - ',num2str(abs(B)),' x)'];end
if ct==5&B>=0,
z=['f(x) = ',num2str(A),' ln(x) + ',num2str(B)];end
if ct==5&B<0,
z=['f(x) = ',num2str(A),' ln(x) - ',num2str(abs(B))];end
if ct==6,
z=['f(x) = ',num2str(C),' exp(',num2str(A),' x)'];end
if ct==7,
z=['f(x) = ',num2str(C),' x^',num2str(A)];
end
if ct==8&B>=0,
z=['f(x) = 1/(',num2str(A),' x + ',num2str(B),')^2'];end
if ct==8&B<0,
z=['f(x) = 1/(',num2str(A),' x - ',num2str(abs(B)),')^2'];end
if ct==9,
z=['f(x) = ',num2str(C),' x exp(',num2str(-D),' x)'];end
if ct==10&C>=0,
z=['f(x) = ',num2str(L),'/(1 + ',num2str(C),' exp(',num2str(A),' x))'];end
if ct==10&C<0,
z=['f(x) = ',num2str(L),'/(1 - ',num2str(abs(C)),' exp(',num2str(A),' x))'];end
