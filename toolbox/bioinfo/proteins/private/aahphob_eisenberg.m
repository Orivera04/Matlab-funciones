function  prop = aahphob_eisenberg(aa) 
%AAHPHOB_EISENBERG calculates normalized consensus hydrophobicity scale.
%
% Author(s) :  Eisenberg D., Schwarz E., Komarony M., Wall R.
% Reference :  J. Mol. Biol. 179:125-142(1984).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:19:40 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ Hydrophobicity (Eisenberg et al.) ';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	0.620; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                0.290; ...% C	cysteine
                -0.900; ...% D	asparatic acid
                -0.740; ...% E	glutamic acid
                1.190; ...% F	phenylalanine
                0.480; ...% G	glycine
                -0.400; ...% H	histidine
                1.380; ...% I	isoleucine
                NaN;... % J not used 
                -1.500; ...% K	lysine
                1.060; ...% L	leucine
                0.640; ...% M	methionine
                -0.780; ...% N	asparagine
                NaN;... % O not used 
                0.120; ...% P	proline
                -0.850; ...% Q	glutamine
                -2.530; ...% R	arginine
                -0.180; ...% S	serine
                -0.050; ...% T	threonine
                NaN;... % U not used 
                1.080; ...% V	valine
                0.810; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                0.260; ...% Y	tyrosine
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
        prop(n) = aahphob_eisenberg(aa(n));
    end
end
