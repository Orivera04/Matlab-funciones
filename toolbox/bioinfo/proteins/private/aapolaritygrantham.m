function  prop = aapolaritygrantham(aa) 
%AAPOLARITYGRANTHAM calculates polarity (Grantham).
%
% Author(s) :  Grantham R.
% Reference :  Science 185:862-864(1974).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:20:05 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ Polarity (Grantham)';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	8.100; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                5.500; ...% C	cysteine
                13.000; ...% D	asparatic acid
                12.300; ...% E	glutamic acid
                5.200; ...% F	phenylalanine
                9.000; ...% G	glycine
                10.400; ...% H	histidine
                5.200; ...% I	isoleucine
                NaN;... % J not used 
                11.300; ...% K	lysine
                4.900; ...% L	leucine
                5.700; ...% M	methionine
                11.600; ...% N	asparagine
                NaN;... % O not used 
                8.000; ...% P	proline
                10.500; ...% Q	glutamine
                10.500; ...% R	arginine
                9.200; ...% S	serine
                8.600; ...% T	threonine
                NaN;... % U not used 
                5.900; ...% V	valine
                5.400; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                6.200; ...% Y	tyrosine
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
        prop(n) = aapolaritygrantham(aa(n));
    end
end
