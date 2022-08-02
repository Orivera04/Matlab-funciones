function  prop = aacoilroux(aa) 
%AACOILROUX calculates the conformational parameter for coil.
%
% Author(s) :  Deleage G., Roux B.
% Reference :  Protein Engineering 1:289-294(1987).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:19:33 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ Coil (Deleage & Roux)';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	0.824; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                0.953; ...% C	cysteine
                1.197; ...% D	asparatic acid
                0.761; ...% E	glutamic acid
                0.797; ...% F	phenylalanine
                1.251; ...% G	glycine
                1.068; ...% H	histidine
                0.886; ...% I	isoleucine
                NaN;... % J not used 
                0.897; ...% K	lysine
                0.810; ...% L	leucine
                0.810; ...% M	methionine
                1.167; ...% N	asparagine
                NaN;... % O not used 
                1.540; ...% P	proline
                0.947; ...% Q	glutamine
                0.893; ...% R	arginine
                1.130; ...% S	serine
                1.148; ...% T	threonine
                NaN;... % U not used 
                0.772; ...% V	valine
                0.941; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                1.109; ...% Y	tyrosine
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
        prop(n) = aacoilroux(aa(n));
    end
end
