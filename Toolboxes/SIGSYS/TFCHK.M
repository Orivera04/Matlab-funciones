function [numc,denc] = tfchk(num,den)
%TFCHK	Check for proper transfer function.
%	[NUMc,DENc] = TFCHK(NUM,DEN) returns equivalent transfer function
%	numerator and denominator where LENGTH(NUMc) = LENGTH(DENc) if
%	the transfer function NUM,DEN are proper.  Prints an error message
%	if not.

%	Clay M. Thompson 6-26-90
%	Copyright (c) 1986-94 by The MathWorks, Inc.
%	$Revision: 1.14 $  $Date: 1994/01/25 17:55:56 $

[nn,mn] = size(num);
[nd,md] = size(den);

% Check for empty matrices
if isempty(num)|isempty(den),
  disp('Warning: Transfer function polynomials are empty.');
  return;
end

% Make sure DEN is a row vector, NUM is assumed to be in rows.
if (~((nd==1)|(md==1))), error('Denominator must be a vector.'); end
if (nd~=1)&(md==1), error('Denominator must be a row vector.'); end

if (mn > md), error('Transfer function not proper.'); end

% Make NUM and DEN lengths equal.
numc=[zeros(nn,md-mn),num];
denc=den;
