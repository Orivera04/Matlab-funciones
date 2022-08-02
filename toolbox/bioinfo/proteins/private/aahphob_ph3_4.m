function  prop = aahphob_ph3_4(aa) 
%AAHPHOB_PH3_4 calculates hydrophobicity indices at ph 3.4 determined by HPLC.
%
% Author(s) :  Cowan R., Whittaker R.G.
% Reference :  Peptide Research 3:75-80(1990).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:19:49 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ Hphob. HPLC pH3.4';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	0.420; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                0.840; ...% C	cysteine
                -0.510; ...% D	asparatic acid
                -0.370; ...% E	glutamic acid
                1.740; ...% F	phenylalanine
                0.000; ...% G	glycine
                -2.280; ...% H	histidine
                1.810; ...% I	isoleucine
                NaN;... % J not used 
                -2.030; ...% K	lysine
                1.800; ...% L	leucine
                1.180; ...% M	methionine
                -1.030; ...% N	asparagine
                NaN;... % O not used 
                0.860; ...% P	proline
                -0.960; ...% Q	glutamine
                -1.560; ...% R	arginine
                -0.640; ...% S	serine
                -0.260; ...% T	threonine
                NaN;... % U not used 
                1.340; ...% V	valine
                1.460; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                0.510; ...% Y	tyrosine
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
        prop(n) = aahphob_ph3_4(aa(n));
    end
end
