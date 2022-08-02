function [u,s,zero] = housh(u,j,heps)
%HOUSH	Construct a householder transformation H=I-s*UU'.  Used in TZERO.
%	
%	[U,S,ZERO] = HOUSH(U,J,Heps)

%	Clay M. Thompson  7-23-90
%	Copyright (c) 1986-94 by The MathWorks, Inc.
%	$Revision: 1.5 $  $Date: 1994/01/25 17:55:07 $

%  Constructs a Householder transformation H=I-s*UU' that 'mirrors' a 
%  vector u to the Jth unit vector.  If NORM(U)<Eps then Zero=1 [True]
%
% Reference: Adapted from "Computation of Zeros of Linear Multivariable
%            Systems", A. Emami-Naeini, and P. Van Dooren; Automatica
%            Vol. 18, No. 4, pp. 415-430, 1982.

  s = sum(u.*u);
  alfa = sqrt(s);
  if (alfa<=heps), zero=1; return, end

  zero=0;
  dum = u(j);
  if dum>0, alfa=-alfa; end
  u(j) = u(j)-alfa;
  s = 1 ./(s-alfa*dum);

  u = u(:);	% Make u a column vector.


