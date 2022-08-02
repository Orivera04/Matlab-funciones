function c=mmmod(n,nmin,nmax)
%MMMOD Modulus Integer Count. (MM)
% MMMOD(N,MAX) returns an array the same size as N containing the
% modulus of N between 1 and MAX inclusive.
% MMMOD(N,MIN,MAX) or MMMOD(N,[MIN MAX]) returns an array the same
% size as N containing the modulus of N between MIN and MAX inclusive.
% For example: 
%              N = [-4 -3 -2 -1  0  1  2  3  4  5  6]
% MMMOD(N, 3)    = [ 2  3  1  2  3  1  2  3  1  2  3]
% MMMOD(N, 0, 4) = [ 1  2  3  4  0  1  2  3  4  0  1]
% MMMOD(N,-4, 1) = [-4 -3 -2 -1  0  1 -4 -3 -2 -1  0]
% MMMOD(N, 3, 7) = [ 6  7  3  4  5  6  7  3  4  5  6]

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 11/6/98, 4/3/99, 7/13/99, 9/5/99
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if any(fix(n)~=n)
   error('N Must Contain Integers.')
end
if nargin==2
   if length(nmin)==2
      tmp=nmin;
   elseif length(nmin)==1
      tmp=[1 nmin(1)];
   else
      error('Second Argument Must Have One or Two Elements.')
   end
elseif nargin==3
   tmp=[nmin,nmax];
else
   error('Unknown Calling Syntax.')
end
nm=min(tmp);
nx=max(tmp);
if nm==nx
   error('MIN and MAX Must be Distinct.')
elseif fix(nm)~=nm | fix(nx)~=nx
   error('MIN and MAX Must be Integers.')
end
c=mod(n-nm,nx-nm+1)+nm;
