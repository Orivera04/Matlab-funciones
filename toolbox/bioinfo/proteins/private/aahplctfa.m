function  prop = aahplctfa(aa) 
%AAHPLCTFA calculates the retention coefficient in TFA.
%
% Author(s) :  Browne C.A., Bennett H.P.J., Solomon S.
% Reference :  Anal. Biochem. 124:201-208(1982).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:20:01 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ TFA retention';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	7.300; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                -9.200; ...% C	cysteine
                -2.900; ...% D	asparatic acid
                -7.100; ...% E	glutamic acid
                19.200; ...% F	phenylalanine
                -1.200; ...% G	glycine
                -2.100; ...% H	histidine
                6.600; ...% I	isoleucine
                NaN;... % J not used 
                -3.700; ...% K	lysine
                20.000; ...% L	leucine
                5.600; ...% M	methionine
                -5.700; ...% N	asparagine
                NaN;... % O not used 
                5.100; ...% P	proline
                -0.300; ...% Q	glutamine
                -3.600; ...% R	arginine
                -4.100; ...% S	serine
                0.800; ...% T	threonine
                NaN;... % U not used 
                3.500; ...% V	valine
                16.300; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                5.900; ...% Y	tyrosine
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
        prop(n) = aahplctfa(aa(n));
    end
end
