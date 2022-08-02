function [U,S,V] = svdvpa(A)
%SVDVPA Variable precision singular value decomposition (obsolete).
%
%	The statement on page 1-45 of the Symbolic Math Toolbox User's Guide
%	that "Only the variable precision numeric computation of the singular
%	value decomposition is available in the toolbox" is already out of date.
%	A new function, SINGVALS, computes symbolic singular values, although
%	the formulas that result are often too long to be of much use.
%	SINGVALS can also compute variable precision singular values.
%
%	As a result, SVDVPA has been superseded by SINGVALS.  The recommended
%	replacements are:
%
%	    S = SINGVALS(VPA(A))       replaces   S = SVDVPA(A)
%	    [U,S,V] = SINGVALS(VPA(A)) replaces   [U,S,V] = SVDVPA(A)
%
%	See also SINGVALS.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.5 $  $Date: 1994/01/24 22:37:13 $

if nargout < 3
   U = singvals(vpa(A));
else
   [U,S,V] = singvals(vpa(A));
end
