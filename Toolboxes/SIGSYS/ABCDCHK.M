function msg = abcdchck(a,b,c,d)
%ABCDCHK Checks dimensional consistency of A,B,C,D matrices.
%	MSG = ABCDCHK(A,B,C,D) checks the consistency of the dimensions 
%	of A,B,C,D.  Returns the empty matrix if they are, or an
%	an error message string if they are not.
%
%	Valid systems with empty matrices are allowed.  

% 	J.N. Little 3-24-85
%	Copyright (c) 1986-94 by The MathWorks, Inc.
%	$Revision: 1.13 $  $Date: 1994/01/25 17:54:11 $
%	Revised 2-25-88 JNL, 6-26-90 CMT, 2-14-91 ACWG

msg = [];
[ma,na] = size(a);
if (ma ~= na)
	msg = 'The A matrix must be square';
end
if (nargin > 1)
	[mb,nb] = size(b);
	if (ma ~= mb)&nb
	msg = 'The A and B matrices must have the same number of rows.';
	end
	if (nargin > 2)
		[mc,nc] = size(c);
		if (nc ~= ma)&mc
 	msg = 'The A and C matrices must have the same number of columns.';
		end
		if (nargin > 3)
			[md,nd] = size(d);
			if ((ma+mb+mc) == 0), return, end
			if (md ~= mc)&(nd | nb)
	msg = 'The C and D matrices must have the same number of rows.';
			end
			if (nd ~= nb)&(md | mc)
	msg = 'The B and D matrices must have the same number of columns.';
			end
		end
	end
end
