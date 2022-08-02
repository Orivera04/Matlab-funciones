function A = lower(a)
%LOWER	Convert string to lower case.
%	b = lower(A) converts any upper case characters in A to
%	the corresponding lower case character and leaves all
%	other characters unchanged.
%
%	See also UPPER.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
% Character sets supported:
%	                   Mac  : Standard Roman
%	                   PC   : ANSI
%	                   Other: ISO_8859_1

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
		mask = ((A > 191) & (A < 208)) | ((A > 207) & (A < 215)) | ...
		       ((A > 215) & (A < 223)) | ((A > 64) & (A < 91));
		mask2 = (A == 138) | (A == 140);
		mask3 = (A == 159);
		A(mask) = A(mask) + 32;
		A(mask2) = A(mask2) + 16;
		A(mask3) = A(mask3) + 96;
	elseif strcmp(c(1:2),'MA'),
		tr = [128 10
		      129 11
 		      130 11
		      131 11
		      132 18 
		      133 21
		      134 25
		      174 16
		      175 16
		      203 -67
		      204 -65
		      205 -50
		      206 1
		      217 -1
		      229 -92
		      230 -86
		      231 -96
		      232 -87
		      233 -90 
		      234 -88
		      235 -87
		      236 -87
		      237 -90
		      238 -87
		      239 -86
		      241 -89
		      242 -86
		      243 -85
		      244 -87];
		[c,d] = size(tr);
		for j = 1:c,
			mask = (A == tr(j,1));
			A(mask) = A(mask) + tr(j,2);
		end
		mask =  ((A > 64) & (A < 91));
		A(mask) = A(mask) + 32;
	else,
		mask = ((A > 191) & (A < 208)) | ((A > 207) & (A < 215)) | ...
               ((A > 215) & (A < 223)) | ((A > 64) & (A < 91));
		A(mask) = A(mask) + 32;
	end 
end
A = setstr(A);
flops(oldflops);



