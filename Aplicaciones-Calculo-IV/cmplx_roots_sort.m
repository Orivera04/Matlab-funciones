function [Poly_Rts, no_Real_Rts, no_Cmplx_Rts] = ...
    cmplx_roots_sort ( Poly_Rts, str_Rev )
%
% Sundar Krishnan (sundark100@yahoo.com)
% Release  : R14, R13, R12
% Date     : June-July 2005
%
% Functional Description :
% ------------------------
% Imagine a function that can pair the Complex Conjugate Roots
% of a Polynomial, and also tell us how many Roots are Real,
% and how many are Complex.
% The immediate answer will be that oh, we already have
% Matlab's standard cplxpair. But, I have observed that
% as the degree of a Polynomial increases, the results obtained by
% Matlab's roots has so much variation that the standard cplxpair
% will result in an error !
% The standard Matlab roots () function does not return
% n exactly identical roots if the input Polynomial has
% n Repeated Roots, specially when n is above 10.
% So, firstly, we need to modify the tolerances of cplxpair.
% cplxpair_Mod is a modified version of the Standard R14 Matlab's cplxpair.
%
% There are three additional requirements :
% 2) After reading TrigonometryAnglesPi7.html in MathWorld,
% I realised that :
% If the coeffs of a Poly are reversed, and then if the resulting roots
% of this modified Poly are reversed in order, we get an exact
% Identity = 1 relationship between the 2 sets of roots.
%
% For eg, if one of the roots of a Poly_N = [ 8, -4, -4, 1 ]
% is -cos(2*pi/7), then the corresponding Reciprocal Root
% will be -sec(2*pi/7), which can be obtained as the corresponding root
% of Poly_R = [ 1, -4, -4, 8 ] which is Poly_N with coeffs
% reversed in order.
% So, we need a function which can also reverse the pairing order.
%
% 3) The third reason is that we would like to have the Pure Real Roots
% listed in the beginning, and then the Complex (Conjugate-Paired) Roots
% for both the NORmal and the REVerse sorting cases.
%
% 4) The fourth reason is to obtain the number of Real and Complex Roots.
%
% In the Default "Forward" Dir, the Real Roots are first sorted,
% and then, the Complex Roots are sorted by their absolute magnitude.
% If the 'REV' option is chosen, the Real Roots are again first sorted,
% but now in Reverse order, and then, the Complex Roots are sorted
% in the Reverse order of their absolute magnitude.
% Thus, in both cases, we will have the Real Roots listed first.
%
% Because of the usage of cplxpair_Mod (a modified version of cplxpair),
% this Programme will work correctly only if the Complex Roots are
% in Conjugate Pairs.
%
% 5) There is in fact, a fifth reason :
% that is when we need to know the multiplicity of the roots
% as is required when we need to raise a Polynomial to Fractional Powers.
% This roots' multiplicity need is fulfilled by a more Detailed Programme :
% cmplx_roots_sort_Det.m, which in addition to the number
% of Real and Complex Roots, also gives the multiplicity of each root.
% cmplx_roots_sort_Det.m calls this Programme cmplx_roots_sort.m
% which in turn calls cplxpair_Mod.m.
% Also, when cplxpair_Mod fails for Non-Conjugate Complex Roots,
% cmplx_roots_sort_Det.m deals with such cases by considering
% them as individual roots, the code being in the catch section
% of thetry-catch block.
% cmplx_roots_sort_Det.m was developed as a sequel to this Programme.
%
% If this suite of Programmes (in this zip file) don't work for you
% directly when downloaded into an independent directory, you could
% try loading these files in the Matlab dir : ...\toolbox\matlab\specfun
%
%                               &&&&&&&&&&&&&&&&&
%
% Author's Legal Disclaimer :
% ---------------------------
% I share my code, developed with lots of efforts, and often based
% on lots of studies, in good faith.
% Everyone is free to use this code at their own risk provided
% they include my name for this part in their works.
% However, I am still learning many facets of this subject ;
% there may be still some open unanswered technical questions for me
% on this subject and possibly in this programme.
% I am NOT responsible for any technical or legal complications
% directly or indirectly, arising out of any direct or indirect use
% of my codes or my interpretations.
% Any apparent TECHNICAL fault in interpreting any external references, 
% or others' replies in any Public User Group Forums, is my own, 
% not theirs. However, I am NOT LEGALLY responsible for any of my
% technical or other interpretation of others' comments in ANY Forum.
%
%                               &&&&&&&&&&&&&&&&&
%
% % Usage Egs :
% % Case 1 for :
% Poly_N = [ 43    82    90    64    73    82    58 ] 
% Num_Roots = roots ( Poly_N ) 
% Recipr_Roots = roots ( fliplr( Poly_N ) ) 
% 
% [Rts_N, no_Real_Rts, no_Cmplx_Rts] = cmplx_roots_sort ( Num_Roots ) 
% [Rts_R, no_Real_Rts, no_Cmplx_Rts] = ...
%     cmplx_roots_sort ( Recipr_Roots, 'REV' ) 
% Rts_N .* Rts_R    % SHOULD BE all 1  ie, Recipr_Roots = 1./Num_Roots
%
%       OR with Num_Roots and Recipr_Roots given directly :
%
% [Rts_N, no_Real_Rts, no_Cmplx_Rts] = ...
%     cmplx_roots_sort ( [ 0.5582 + 0.8057i,  0.5582 - 0.8057i, ...
% -0.5631 + 0.9537i,  -0.5631 - 0.9537i, ...
% -0.9487 + 0.4946i,  -0.9487 - 0.4946i ], 'NOR' )
%
% [Rts_R, no_Real_Rts, no_Cmplx_Rts] = ...
%     cmplx_roots_sort ( [ 0.5810 + 0.8386i,  0.5810 - 0.8386i, ...
% -0.8289 + 0.4321i,  -0.8289 - 0.4321i, ...
% -0.4590 + 0.7775i,  -0.4590 - 0.7775i ], 'REV' )
%
% Rts_N .* Rts_R    % SHOULD BE all 1  ie, Recipr_Roots = 1./Num_Roots
%
%
% % Construct Poly_R and verify :
% Poly_R = 1 ;
% for i = 1 : length (Rts_R)
%     Poly_R = conv ( Poly_R, [1, -Rts_R(i)] ) ;
% end
% Poly_R    % This is a monic Polynomial.
% Poly_R = Poly_R * Poly_N(end)
% % This should tally with reversed coeffs of Poly_N
% Poly_R - fliplr( Poly_N )    % order of 1e-12
%
%                                   ^^^^^^^^^^
%
% % Case 2 for :
% Poly_N = [ -3    82    -90    64    -73    -82    58   -99 ] ;
% Num_Roots = roots ( Poly_N ) 
% Recipr_Roots = roots ( fliplr( Poly_N ) ) 
%
% [Rts_N, no_Real_Rts, no_Cmplx_Rts] = cmplx_roots_sort ( Num_Roots ) 
% [Rts_R, no_Real_Rts, no_Cmplx_Rts] = ...
%     cmplx_roots_sort ( Recipr_Roots, 'REV' ) 
% Rts_N .* Rts_R    % SHOULD BE all 1  ie, Recipr_Roots = 1./Num_Roots
%
% % Construct Poly_R and verify :
% Poly_R = 1 ;
% for i = 1 : length (Rts_R)
%     Poly_R = conv ( Poly_R, [1, -Rts_R(i)] ) ;
% end
% Poly_R    % This is a monic Polynomial.
% Poly_R = Poly_R * Poly_N(end)
% % This should tally with reversed coeffs of Poly_N
% Poly_R - fliplr( Poly_N )    % order of 1e-12
%
%                                   ^^^^^^^^^^
%
% % Case 3 for :
% Poly_N = [ 0.1897    0.6145    0.1934    0.5077   0.6822    1.6924 ]
% Num_Roots = roots ( Poly_N ) 
% Recipr_Roots = roots ( fliplr( Poly_N ) ) 
%
% [Rts_N, no_Real_Rts, no_Cmplx_Rts] = cmplx_roots_sort ( Num_Roots ) 
% [Rts_R, no_Real_Rts, no_Cmplx_Rts] = ...
%     cmplx_roots_sort ( Recipr_Roots, 'REV' ) 
% Rts_N .* Rts_R    % SHOULD BE all 1  ie, Recipr_Roots = 1./Num_Roots
%
% % Construct Poly_R and verify :
% Poly_R = 1 ;
% for i = 1 : length (Rts_R)
%     Poly_R = conv ( Poly_R, [1, -Rts_R(i)] ) ;
% end
% Poly_R    % This is a monic Polynomial.
% Poly_R = Poly_R * Poly_N(end)
% % This should tally with reversed coeffs of Poly_N
% Poly_R - fliplr( Poly_N )    % order of 1e-14
%
%                                   ^^^^^^^^^^
%
% Many more Usage Examples can be seen in Constants_AlgNo_Cycl.m
%
%                              *******************

% 1) Inits :
if nargin < 2
    str_Rev = 'NOR' ;    % Default is 'NORMAL' ordering of roots.
end

%                               &&&&&&&&&&&&&&&&&

% 2) Convert the roots to a Col Vector :
Poly_Rts = Poly_Rts (:) ;

%                               &&&&&&&&&&&&&&&&&

% 3) Separate the Real and Complex Roots :
Poly_Rts_Real = [ ] ;
Poly_Rts_Cmplx = [ ] ;

for index = 1 : length (Poly_Rts)
    if isreal (Poly_Rts(index))
        Poly_Rts_Real  = [ Poly_Rts_Real,  Poly_Rts(index) ] ;
    else
        Poly_Rts_Cmplx = [ Poly_Rts_Cmplx, Poly_Rts(index) ] ;
    end
end

%                               &&&&&&&&&&&&&&&&&

% 4) Pair the Complex Roots into Complex Conjugate Pairs.
% Note that if the Complex Roots are not "suitably paired"
% for cplxpair_Mod, it may result in an error.
Poly_Rts_Cmplx = cplxpair_Mod ( Poly_Rts_Cmplx ) ;

Poly_Rts_Cmplx_Abs = abs ( Poly_Rts_Cmplx ) ;
[Poly_Rts_Cmplx_Abs, ind_Cmplx] = sort ( Poly_Rts_Cmplx_Abs ) ;

[Poly_Rts_Real_Abs, ind_Real] = sort( abs( Poly_Rts_Real ) ) ;

%                               &&&&&&&&&&&&&&&&&

% 5) Choice of sorting :
% For 'NOR(MAL)'_Roots : Normal Sorted Order with Real first,
% then Complex Roots :
Poly_Rts_Real  = Poly_Rts_Real(ind_Real) ;
Poly_Rts_Cmplx = Poly_Rts_Cmplx(ind_Cmplx) ;

% For Reciprocal ie, 'REV(ERSE)' Roots :
% Here is where we reverse the sorted order
% within Real and within Complex, respectively :
if ~any ( str_Rev ~= 'REV' )
    Poly_Rts_Real  = fliplr( Poly_Rts_Real ) ;
    Poly_Rts_Cmplx = fliplr( Poly_Rts_Cmplx ) ;
end

Poly_Rts = [ Poly_Rts_Real, Poly_Rts_Cmplx ] ;

%                               &&&&&&&&&&&&&&&&&

% 5) Count the no of Real and Complex Roots.
no_Real_Rts  = length (Poly_Rts_Real)  ;
no_Cmplx_Rts = length (Poly_Rts_Cmplx) ;

% cmplx_roots_sort_Det.m gives the multiplicity of each root also,
% in addition to the number of Real and Complex Roots.

%                              *******************
