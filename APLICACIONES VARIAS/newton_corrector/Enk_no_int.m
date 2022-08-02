function e=Enk_no_int(Z,n,kappa)
%2006/04/04 This equation is used to create the energy of Hydrogen-like
%atom's energy state. Here I don't consider the contribution from other
%electrons.
% The unit is under atomic unit.
c=137.03599905320282423; %Speed of light.
if ( n>=abs(kappa) & n~=kappa)
  e=c^2/sqrt(1+Z^2/c^2/ (n-abs(kappa)+sqrt(kappa^2-Z^2/c^2))^2 );
else
  e=NaN;
end
return