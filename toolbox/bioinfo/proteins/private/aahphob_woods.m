function  prop = aahphob_woods(aa) 
%AAHPHOB_WOODS calculates the hydrophilicity (Hopp & Woods).
%
% Author(s) :  Hopp T.P., Woods K.R.
% Reference :  Proc. Natl. Acad. Sci. U.S.A. 78:3824-3828(1981).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:19:57 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ Hydrophobicity (Hopp & Woods) ';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	-0.500; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                -1.000; ...% C	cysteine
                3.000; ...% D	asparatic acid
                3.000; ...% E	glutamic acid
                -2.500; ...% F	phenylalanine
                0.000; ...% G	glycine
                -0.500; ...% H	histidine
                -1.800; ...% I	isoleucine
                NaN;... % J not used 
                3.000; ...% K	lysine
                -1.800; ...% L	leucine
                -1.300; ...% M	methionine
                0.200; ...% N	asparagine
                NaN;... % O not used 
                0.000; ...% P	proline
                0.200; ...% Q	glutamine
                3.000; ...% R	arginine
                0.300; ...% S	serine
                -0.400; ...% T	threonine
                NaN;... % U not used 
                -1.500; ...% V	valine
                -3.400; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                -2.300; ...% Y	tyrosine
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
        prop(n) = aahphob_woods(aa(n));
    end
end
