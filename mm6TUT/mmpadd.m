function p=mmpadd(a,b)
%MMPADD Polynomial Addition. (MM)
% MMPADD(A,B) adds the polynomials A and B.
%
% See also MMPOLY, MMPSIM, MMPSCALE, MMPSHIFT, MMP2STR.

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/4/95, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<2
	error('Not Enough Input Arguments.')
end
a=a(:).';		% make sure inputs are polynomial row vectors
b=b(:).';
na=length(a);	% find lengths of a and b
nb=length(b);
p=[zeros(1,nb-na) a]+[zeros(1,na-nb) b];  % pad with zeros as necessary
