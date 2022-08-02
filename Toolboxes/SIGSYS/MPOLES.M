function [mults, indx] = mpoles( p, mpoles_tol )
%MPOLES	Identify repeated poles & their multiplicities.
%     [MULTS, IDX] = mpoles( P, TOL )
%        P:     the list of poles
%        TOL:   tolerance for checking when two poles
%                 are the "same"
%        MULTS: list of pole multiplicities
%        IDX:   indices used to sort P
%     NOTE: this is a support function for RESIDUEZ.

%	Example:
%	    input:  P = [1 2 3 2 1 1]
%	    output: MULTS = [1 2 3 1 2 1], IDX = [1 5 6 2 4 3]
%                   P[IDX] = [1 1 1 2 2 3]
%	    Thus, MULTS contains the exponent for each pole in a
%	    partial fraction expansion.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%       $Revision: 1.4 $  $Date: 1994/01/25 17:59:32 $

if( nargin == 1 )
   mpoles_tol = 1.0e-03;   %--- DEFAULT, if not passed by user
end
Lp = length(p);
mults = zeros(Lp,1);
done = zeros(Lp,1);   %--- set to FALSE
indx = [1:Lp]';
ii = 1;
for j = 1:Lp
   if( ~done(j) )
      mults(ii) = 1;
      indx(ii) = j;  ii = ii+1;
      done(j) = 1;
      if( ii > Lp ) break; end
      test = abs( p((j+1):Lp) - p(j) );
      jkl = find( test < mpoles_tol*abs(p(j)) );
      Lj = length(jkl);
      if( Lj > 0 )
         for k = 1:Lj
            jj = jkl(k);
            mults(ii) = 1+k;
            indx(ii) = j+jj;  ii = ii+1;
            done(j+jj) = 1;
         end
      end
   end
end
