function  prop = aabeta_sheetroux(aa) 
%AABETA_SHEETROUX calculates the conformational parameter for beta-sheet.
%
% Author(s) :  Deleage G., Roux B.
% Reference :  Protein Engineering 1:289-294(1987).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:19:27 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ Beta-sheet (Roux)';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	0.709; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                1.191; ...% C	cysteine
                0.541; ...% D	asparatic acid
                0.567; ...% E	glutamic acid
                1.393; ...% F	phenylalanine
                0.657; ...% G	glycine
                0.863; ...% H	histidine
                1.799; ...% I	isoleucine
                NaN;... % J not used 
                0.721; ...% K	lysine
                1.261; ...% L	leucine
                1.210; ...% M	methionine
                0.604; ...% N	asparagine
                NaN;... % O not used 
                0.354; ...% P	proline
                0.840; ...% Q	glutamine
                0.920; ...% R	arginine
                0.928; ...% S	serine
                1.221; ...% T	threonine
                NaN;... % U not used 
                1.965; ...% V	valine
                1.306; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                1.266; ...% Y	tyrosine
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
        prop(n) = aabeta_sheetroux(aa(n));
    end
end
