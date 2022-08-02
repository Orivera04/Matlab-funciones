function  prop = aabeta_turnroux(aa) 
%AABETA_TURNROUX calculates the conformational parameter for beta-turn.
%
% Author(s) :  Deleage G., Roux B.
% Reference :  Protein Engineering 1:289-294(1987).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:19:30 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ Beta-turn (Roux)';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	0.788; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                0.965; ...% C	cysteine
                1.197; ...% D	asparatic acid
                1.149; ...% E	glutamic acid
                0.624; ...% F	phenylalanine
                1.860; ...% G	glycine
                0.970; ...% H	histidine
                0.240; ...% I	isoleucine
                NaN;... % J not used 
                1.302; ...% K	lysine
                0.670; ...% L	leucine
                0.436; ...% M	methionine
                1.572; ...% N	asparagine
                NaN;... % O not used 
                1.415; ...% P	proline
                0.997; ...% Q	glutamine
                0.912; ...% R	arginine
                1.316; ...% S	serine
                0.739; ...% T	threonine
                NaN;... % U not used 
                0.387; ...% V	valine
                0.546; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                0.795; ...% Y	tyrosine
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
        prop(n) = aabeta_turnroux(aa(n));
    end
end
