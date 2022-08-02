function  prop = aahphob_miyazawa(aa) 
%AAHPHOB_MIYAZAWA calculates hydrophobicity scale (contact energy derived from 3D data).
%
% Author(s) :  Miyazawa S., Jernigen R.L.
% Reference :  Macromolecules 18:534-552(1985).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:19:46 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ Hydrophobicity (Miyazawa et al.)';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	5.330; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                7.930; ...% C	cysteine
                3.590; ...% D	asparatic acid
                3.650; ...% E	glutamic acid
                9.030; ...% F	phenylalanine
                4.480; ...% G	glycine
                5.100; ...% H	histidine
                8.830; ...% I	isoleucine
                NaN;... % J not used 
                2.950; ...% K	lysine
                8.470; ...% L	leucine
                8.950; ...% M	methionine
                3.710; ...% N	asparagine
                NaN;... % O not used 
                3.870; ...% P	proline
                3.870; ...% Q	glutamine
                4.180; ...% R	arginine
                4.090; ...% S	serine
                4.490; ...% T	threonine
                NaN;... % U not used 
                7.630; ...% V	valine
                7.660; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                5.890; ...% Y	tyrosine
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
        prop(n) = aahphob_miyazawa(aa(n));
    end
end
