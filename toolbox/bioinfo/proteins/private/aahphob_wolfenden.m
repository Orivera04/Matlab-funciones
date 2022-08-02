function  prop = aahphob_wolfenden(aa) 
%AAHPHOB_WOLFENDEN calculates the hydration potential (kcal/mole) at 25øC.
%
% Author(s) :  Wolfenden R.V., Andersson L., Cullis P.M., Southgate C.C.F.
% Reference :  Biochemistry 20:849-855(1981).

%   $Revision: 1.1.6.3 $  $Date: 2004/01/24 09:19:56 $
%   Copyright 2003-2004 The MathWorks, Inc.



% no input, return description string 
if nargin == 0, 
prop = 'AAProp_ Hydrophobicity (Wolfenden et al.)';
return
end

% one scalar input, return value 
if numel(aa) == 1, 
ndx = double(lower(aa)) - 96;
data = [ 	1.940; ...% A	alanine
                NaN;... % Asp or Asn	aspartic acid or asparagine
                -1.240; ...% C	cysteine
                -10.950; ...% D	asparatic acid
                -10.200; ...% E	glutamic acid
                -0.760; ...% F	phenylalanine
                2.390; ...% G	glycine
                -10.270; ...% H	histidine
                2.150; ...% I	isoleucine
                NaN;... % J not used 
                -9.520; ...% K	lysine
                2.280; ...% L	leucine
                -1.480; ...% M	methionine
                -9.680; ...% N	asparagine
                NaN;... % O not used 
                0.000; ...% P	proline
                -9.380; ...% Q	glutamine
                -19.920; ...% R	arginine
                -5.060; ...% S	serine
                -4.880; ...% T	threonine
                NaN;... % U not used 
                1.990; ...% V	valine
                -5.880; ...% W	tryptophan
                NaN;... % ANY	Any amino acid
                -6.110; ...% Y	tyrosine
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
        prop(n) = aahphob_wolfenden(aa(n));
    end
end
