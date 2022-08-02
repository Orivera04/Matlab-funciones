function  prop = aahphob_janin(aa) 
%AAHPHOB_JANIN calculates free energy of transfer from inside to outside of a globular protein.
%
% Author(s) :  Janin J.
% Reference :  Nature 277:491-492(1979).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:19:43 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ Hydrophobicity (Janin)';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	0.300; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                0.900; ...% C	cysteine
                -0.600; ...% D	asparatic acid
                -0.700; ...% E	glutamic acid
                0.500; ...% F	phenylalanine
                0.300; ...% G	glycine
                -0.100; ...% H	histidine
                0.700; ...% I	isoleucine
                NaN;... % J not used 
                -1.800; ...% K	lysine
                0.500; ...% L	leucine
                0.400; ...% M	methionine
                -0.500; ...% N	asparagine
                NaN;... % O not used 
                -0.300; ...% P	proline
                -0.700; ...% Q	glutamine
                -1.400; ...% R	arginine
                -0.100; ...% S	serine
                -0.200; ...% T	threonine
                NaN;... % U not used 
                0.600; ...% V	valine
                0.300; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                -0.400; ...% Y	tyrosine
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
        prop(n) = aahphob_janin(aa(n));
    end
end
