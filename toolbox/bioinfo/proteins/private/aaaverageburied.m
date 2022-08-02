function  prop = aaaverageburied(aa) 
%AAAVERAGEBURIED calculates average area buried on transfer from standard state to folded protein.
%
% Author(s) :  Rose G.D., Geselowitz A.R., Lesser G.J., Lee R.H., Zehfus M.H.
% Reference :  Science 229:834-838(1985).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:19:23 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_  Average area buried';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	86.600; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                132.300; ...% C	cysteine
                97.800; ...% D	asparatic acid
                113.900; ...% E	glutamic acid
                194.100; ...% F	phenylalanine
                62.900; ...% G	glycine
                155.800; ...% H	histidine
                158.000; ...% I	isoleucine
                NaN;... % J not used 
                115.500; ...% K	lysine
                164.100; ...% L	leucine
                172.900; ...% M	methionine
                103.300; ...% N	asparagine
                NaN;... % O not used 
                92.900; ...% P	proline
                119.200; ...% Q	glutamine
                162.200; ...% R	arginine
                85.600; ...% S	serine
                106.500; ...% T	threonine
                NaN;... % U not used 
                141.000; ...% V	valine
                224.600; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                177.700; ...% Y	tyrosine
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
        prop(n) = aaaverageburied(aa(n));
    end
end
