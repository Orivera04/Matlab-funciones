function A = upper(a)
%UPPER	Convert string to upper case.
%	A = upper(a) converts any lower case characters in a to
%	the corresponding upper case character and leaves all
%	other characters unchanged.
%
%	See also LOWER.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Character sets supported:
%	                   Mac  : Standard Roman
%	                   PC   : Windows Latin-1
%                          UNIX : ISO Latin-1 (ISO 8859-1)
%	                   VMS  : ISO Latin-1 (ISO 8859-1)

if isempty(a),
        A=a;
        return;
end
oldflops = flops;
c = computer;
if ~isstr(a)
    A = a;
else
	A = a;
	if strcmp(c(1:2),'PC'),
		mask = ((A > 223) & (A < 240)) | ((A > 239) & (A < 247)) | ...
		       ((A > 247) & (A < 255)) | ((A > 96) & (A < 123));
		mask2 = (A == 154) | (A == 156);
		mask3 = (A == 255);
		A(mask) = A(mask) - 32;
		A(mask2) = A(mask2) - 16;
		A(mask3) = A(mask3) - 96;
	elseif strcmp(c(1:2),'MA'),
		tr = [   138   -10
		         140   -11
		         141   -11
		         142   -11
		         150   -18
		         154   -21
		         159   -25
		         190   -16
		         191   -16
		         136    67
		         139    65
		         155    50
		         207    -1
		         216     1
		         137    92
		         144    86
		         135    96
		         145    87
		         143    90
		         146    88
		         148    87
		         149    87
		         147    90
		         151    87
		         153    86
		         152    89
 		         156    96
 		         158    85
		         157    87];
		[c,d] = size(tr);
		for j = 1:c,
			mask = (A == tr(j,1));
			A(mask) = A(mask) + tr(j,2);
		end
		mask =  ((A > 96) & (A < 123));
		A(mask) = A(mask) - 32;
	else,
		mask = ((A > 223) & (A < 240)) | ((A > 239) & (A < 247)) | ...
               ((A > 247) & (A < 255)) | ((A > 96) & (A < 123));
		A(mask) = A(mask)-32;
	end 
end
A = setstr(A);
flops(oldflops);
