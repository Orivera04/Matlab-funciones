function  prop = aahphob_mobility(aa) 
%AAHPHOB_MOBILITY calculates mobilities of amino acids on chromatography paper (RF).
%
% Author(s) :  Aboderin A.A.
% Reference :  Int. J. Biochem. 2:537-544(1971).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:19:47 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ Hydrophobicity (Aboderin)';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	5.100; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                0.000; ...% C	cysteine
                0.700; ...% D	asparatic acid
                1.800; ...% E	glutamic acid
                9.600; ...% F	phenylalanine
                4.100; ...% G	glycine
                1.600; ...% H	histidine
                9.300; ...% I	isoleucine
                NaN;... % J not used 
                1.300; ...% K	lysine
                10.000; ...% L	leucine
                8.700; ...% M	methionine
                0.600; ...% N	asparagine
                NaN;... % O not used 
                4.900; ...% P	proline
                1.400; ...% Q	glutamine
                2.000; ...% R	arginine
                3.100; ...% S	serine
                3.500; ...% T	threonine
                NaN;... % U not used 
                8.500; ...% V	valine
                9.200; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                8.000; ...% Y	tyrosine
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
        prop(n) = aahphob_mobility(aa(n));
    end
end
