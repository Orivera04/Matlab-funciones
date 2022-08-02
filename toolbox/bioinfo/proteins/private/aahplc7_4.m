function  prop = aahplc7_4(aa) 
%AAHPLC7_4 calculates the retention coefficient in HPLC, pH 7.4.
%
% Author(s) :  Meek J.L.
% Reference :  Proc. Natl. Acad. Sci. USA 77:1632-1636(1980).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:19:59 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ HPLC retention, pH 7.4 (Meek)';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	0.500; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                -6.800; ...% C	cysteine
                -8.200; ...% D	asparatic acid
                -16.900; ...% E	glutamic acid
                13.200; ...% F	phenylalanine
                0.000; ...% G	glycine
                -3.500; ...% H	histidine
                13.900; ...% I	isoleucine
                NaN;... % J not used 
                0.100; ...% K	lysine
                8.800; ...% L	leucine
                4.800; ...% M	methionine
                0.800; ...% N	asparagine
                NaN;... % O not used 
                6.100; ...% P	proline
                -4.800; ...% Q	glutamine
                0.800; ...% R	arginine
                1.200; ...% S	serine
                2.700; ...% T	threonine
                NaN;... % U not used 
                2.700; ...% V	valine
                14.900; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                6.100; ...% Y	tyrosine
                NaN;... % Glu or Gln	glutamic acid or glutamine
];

try
    prop = data(ndx);
catch
    prop = NaN;
end

% one vector input, call recursively for single values 
else
   prop = zeros(numel(aa),1);
    for n = 1:numel(aa),
        prop(n) = aahplc7_4(aa(n));
    end
end
