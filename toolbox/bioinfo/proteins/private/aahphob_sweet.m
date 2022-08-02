function  prop = aahphob_sweet(aa) 
%AAHPHOB_SWEET calculates optimized matching hydrophobicity (OMH).
%
% Author(s) :  Sweet R.M., Eisenberg D.
% Reference :  J. Mol. Biol. 171:479-488(1983).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:19:53 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ Hydrophobicity (Sweet et al.)';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	-0.400; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                0.170; ...% C	cysteine
                -1.310; ...% D	asparatic acid
                -1.220; ...% E	glutamic acid
                1.920; ...% F	phenylalanine
                -0.670; ...% G	glycine
                -0.640; ...% H	histidine
                1.250; ...% I	isoleucine
                NaN;... % J not used 
                -0.670; ...% K	lysine
                1.220; ...% L	leucine
                1.020; ...% M	methionine
                -0.920; ...% N	asparagine
                NaN;... % O not used 
                -0.490; ...% P	proline
                -0.910; ...% Q	glutamine
                -0.590; ...% R	arginine
                -0.550; ...% S	serine
                -0.280; ...% T	threonine
                NaN;... % U not used 
                0.910; ...% V	valine
                0.500; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                1.670; ...% Y	tyrosine
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
        prop(n) = aahphob_sweet(aa(n));
    end
end
