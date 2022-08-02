function  prop = aaaccessibleresidues(aa) 
%AAACCESSIBLERESIDUES calculates the molar fraction (%) of 3220 accessible residues.
%
% Author(s) :  Janin J.
% Reference :  Nature 277:491-492(1979).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:19:18 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ % accessible residues';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	6.600; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                0.900; ...% C	cysteine
                7.700; ...% D	asparatic acid
                5.700; ...% E	glutamic acid
                2.400; ...% F	phenylalanine
                6.700; ...% G	glycine
                2.500; ...% H	histidine
                2.800; ...% I	isoleucine
                NaN;... % J not used 
                10.300; ...% K	lysine
                4.800; ...% L	leucine
                1.000; ...% M	methionine
                6.700; ...% N	asparagine
                NaN;... % O not used 
                4.800; ...% P	proline
                5.200; ...% Q	glutamine
                4.500; ...% R	arginine
                9.400; ...% S	serine
                7.000; ...% T	threonine
                NaN;... % U not used 
                4.500; ...% V	valine
                1.400; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                5.100; ...% Y	tyrosine
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
        prop(n) = aaaccessibleresidues(aa(n));
    end
end
