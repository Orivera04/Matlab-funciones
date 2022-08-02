function [ CHECK_Herm_A, CHECK_Unitary_A, str_CHECK_POS_DEF,              ...
           cond_A, cond_A_1,   norm_A, norm_A_1, norm_A_inf,              ...
           CHECK_eig, D,   CHECK_svd, S, DIFF_Unitary_U, DIFF_Unitary_V2, ...
           Sing_sqrt_D_C_S_A, CHECK_eig_C_S_A,   abs_D_Prod, S_Prod,      ...
           S_D_Rel,   HP_A, D_HP_A,   det_A, abs_det_A,                   ...
           str_eigs_svds_Error_Sp3, str_eigs_svds_ALERT_Sp1_b ]           ...
           =  eig_svd_herm_unit_pos_def_2 ( A, k_for_Sparse )
%
% Subject  : Properties of Hermitian, Unitary, Positive Definite
%            and Sparse Matrices
% Release  : R13
% Author   : Sundar Krishnan
% email id : sundark100@yahoo.com
% Date     : Skeleton Pgm in 2002 ; Some Fine Tuning in January-February 2004
%            Change to issparse() in April 2004, Sep 2004
%
% Functional Description :
% ------------------------
% This file contains the details of usage of commands like
% eig & eigs, svd & svds, and explains with many examples
% what a Hermitian Matrix is, what a Unitary Matrix is,
% what is meant by Positive Definite etc.
% Given a matrix A, this pgm also determines the condition, norm, 
% calculates the Singular Values, the Hermitian Part and checks
% if the matrix is Positive Definite.
% The 20 Test Cases of examples in the companion TEST file cover
% real, complex, Hermitian, Unitary, Hilbert, Pascal, Toeplitz, Hankel,
% Twiddle, Sparse and JPEG/MPEG Quantization matrices.
% This programme will be very useful for students who want to understand
% the concepts behind various types of matrices ; they get them
% all at one place - with many numerical examples / cases.
%
% This 2nd version eig_svd_herm_unit_pos_def_2.m is a slightly modified
% version of my earlier 1st version, eig_svd_herm_unit_pos_def_1.m
% The 2 main modification categories are :
% 1) issparse() is preferable to class () as a check for Sparse Matrices.
% This will be essential in R13 since in R13, sparse has changed from a class
% to an attribute.
% 2) eigs and svds default to k = 6 largest magnitude eigenvalues, and hence
% the sizes of V, D and U, S & V2 tend to be of reduced size.
% However, (ironically), if we choose the 'k' parameter in eigs and svds
% as the full size (= size(A, 1)), the eigs and svds calls are treated as
% eig and svd, the non-Sparse, Full Matrix form, and then the whole "charm"
% of Sparse Matrices is lost! So, I have left the try-catch blocks
% still in place.
%
% Just for my records : refer to Sparse_eigs_svds_email_1.m for some
% spot-testing, and my notes on Sparse' eccentricities in
% Sparse_Red_Size_of_D_2.doc.
%
% For a quick start, try the "Usage Eg" below.
%
%                                   ********************
%
% Author's Legal Disclaimer :
% Everyone is free to use this code at his or her own risk provided
% they include my name for this part.
% I am NOT responsible for any legal complications directly
% or indirectly for any direct or indirect use of this code.
%
%                                       &&&&&&&&&&&&
%
% I will be glad though to learn from others of new cases, improvements
% and any errors in this programme or the associated TEST file.
% I would also be extremely thankful to those who could give answers to items
% marked "Open Q1 to Open Q4", "Open Q6 to Open Q9a,b, 
% Q10, Q11, Q12, Q13, Q14" and "ALERT Sp1, Sp2, Error Sp3".
% (Q5a,b,c,d are withdrawn in this 2nd version.)
% 
%                                   ********************
%
% Author's References and Cross-References :
% This file was created by consolidating many of my past files :
% svd_rank_1.m, hermitian_exp_1.m, unitary_exp_1.m,
% vandermonde_polyfit_twiddle_1.m, my hand-written notes
% in my copy of the book :
% Advanced Engineering Mathematics with Matlab by TLH, JD, NR
% (often referred to as AEMM in the code below, eg, AEMM / P193)
% and my hand-written notes in my copy of the book :
% DSP using Matlab by Ingle and Proakis
% (often referred to as DSPIP or Ingle in the code below, eg, Ingle / P224-225)
% Therefore, you may find mention of some of these routines in the code below ;
% they are meant only for the author's cross-references.
% The referred author's files are however, NOT necesary for running,
% nor understanding this pgm.
% Similarly, you may find some cross-refs to approx Line Nos in other routines
% indicated by "~", as for eg, ~ L 472 / ~ L 448 implies :
% "at approx Line No 472 or at approx Line No 448".
% The Line Nos are "approximate (~)" because of any additional stmts / comments
% that I may have added to improve the understanding of that referred routine,
% and this modification could keep changing.
%
% NOTE on no ";" at the end of some stmts :
% Some stmts have been purposely left - without the ending ";"
% to enable display in the Cmd Window.
%
% NOTE on specific values mentioned as Examples at certain intermediate steps :
% One of the most importnat tests is "Sparse Test Case 17", whose results at
% intermediate steps of calculations have been displayed.
% This will help a better understanding of the programme as well as for any
% future diagnosis.
%
%                                   ********************
%
% Col Ref for 80-char marker :
%      10        20        30        40        50        60        70        80
%
% Usage Eg :
% In the associated Test file : eig_svd_herm_unit_pos_def_2_TEST.m,
% there are 20 cases listed out. Two of those cases are repeated below
% for convenience just to give the readers a feel. 
% The complete list of 20 cases are in the TEST file.
% Try running each of these 2 cases by uncommenting the code lines below.
%
% % 1) Real Case with det NOT 0 :
% clear, clc, close all
% 
 M5 = magic (5) ;
 A = M5 ;
% 
% fprintf ( '                          Test Case 1   \n' ) ;
% fprintf ( '                          ***********   \n\n' ) ;
% 
% [ CHECK_Herm_A, CHECK_Unitary_A, str_CHECK_POS_DEF,                ...
%     cond_A, cond_A_1,   norm_A, norm_A_1, norm_A_inf,              ...
%     CHECK_eig, D,   CHECK_svd, S, DIFF_Unitary_U, DIFF_Unitary_V2, ...
%     Sing_sqrt_D_C_S_A, CHECK_eig_C_S_A,   abs_D_Prod, S_Prod,      ...
%     S_D_Rel,   HP_A, D_HP_A,   det_A, abs_det_A,                   ...
%     str_eigs_svds_Error_Sp3, str_eigs_svds_ALERT_Sp1_b ]           ...
%     =  eig_svd_herm_unit_pos_def_2 ( A, size(A, 1) - 2 ) 
%     
%     % det(A)                     % = 5070000
%     % cond_A   = cond (A)        % = 5.4618
%     % cond_A_1 = cond (A, 1)     % = 6.8500
%     
%     % str_CHECK_POS_DEF          % = 'NO '
%      
% %                                     &&&&&&&&&&&&
%
% % 4) General Complex Case 2 with det NOT 0 : (NOT Hermitian, NOT Unitary)
% clear, clc, close all
% 
% % Let us consider A = U_AH (Unitary) in hermitian_exp_1.m,
% % and modify elements in it to make it more general :
% AH = [ 1,        3 -  i,         5i ;
%        3 +  i,   3,        -3 - 2i ;
%          - 5i,  -3 + 2i,    2        ] ;
% 
% [ U_AH, S_AH, V_AH ] = svd (AH) ;
% 
% A = U_AH ;
% 
% % Modify A to make it a more general complex matrix
% A (1, 2) = -7 + 6j ;      
% A (2, 2) =  3 - 5j ;
% 
% fprintf ( '                          Test Case 4   \n' ) ;
% fprintf ( '                          ***********   \n\n' ) ;
% 
% [ CHECK_Herm_A, CHECK_Unitary_A, str_CHECK_POS_DEF,                ...
%     cond_A, cond_A_1,   norm_A, norm_A_1, norm_A_inf,              ...
%     CHECK_eig, D,   CHECK_svd, S, DIFF_Unitary_U, DIFF_Unitary_V2, ...
%     Sing_sqrt_D_C_S_A, CHECK_eig_C_S_A,   abs_D_Prod, S_Prod,      ...
%     S_D_Rel,   HP_A, D_HP_A,   det_A, abs_det_A,                   ...
%     str_eigs_svds_Error_Sp3, str_eigs_svds_ALERT_Sp1_b ]           ...
%     =  eig_svd_herm_unit_pos_def_2 ( A, size(A, 1) - 2 ) 
%     
%     % det(A)                     % = 7.4498 - 3.6664i
%     % abs ( det (A) )            % = 8.3031
%     % cond_A   = cond (A)        % = 14.4288
%     % cond_A_1 = cond (A, 1)     % = 29.8064
%     
%     % str_CHECK_POS_DEF          % = 'NO '
%
% %                                     &&&&&&&&&&&&
%
% 17) Now, try Sparse Test Case 17 for a ride !
%
% 19) Proceed with Test Cases' 19 only if you have good perseverence !
%
% 20) Proceed with Test Cases' 20 only if you have extreme perseverence !
%
% For Test Cases 19 and 20, it may be necessary to run another routine :
% vandermonde_polyfit_twiddle_1.m to get the Sparse Matrices.
% That routine is included in an as-is condition, containing many of my notes
% and further cross-refs.
% It is a wonderful pgm for the exposition of FFT using Sparse Matrices.
% The cross-refs are just for my record ; they are not necessary
% for running this pgm. However, if someone could suggest a better syntax tip
% for tackling high values of 'r' in a dynamic way on the fly (Q2a,b,c),
% it would be highly appreciated.
%
%                                   ********************

% Actual Programme begins here.

% 1) Some Common Calcs :

[rows_A, cols_A] = size ( full (A) ) ;

if rows_A ~= cols_A
    fprintf ( '\n' ) ;
    error ( 'This pgm is designed to run ONLY for SQUARE matrix inputs !' ) ;
    
else
    if nargin == 1      % ie, k_for_Sparse is not given
        % See NOTE on max value of k_for_Sparse with eigs below.
        % The max k we can have for eigs and svds for dealing with
        % it in a true Sparse Matrix computation sense, is to have
        % k = rows_A - 2
        % Refer to eigs.m : number of eigenvalues k must be < n-1
        k_for_Sparse = rows_A - 2 ;
        % Ironically, if we want the computation to take the path
        % of eigs and svds - as a Sparse computation - we will have to
        % deal with reduced sizes of V, D and U, S & V2 !
        % See the ALERT Note on : "ALERT Sp1 NOTE on the Irony of the
        % limitation of Analysis as Sparse Matrix" below.
       
    else
        if k_for_Sparse == rows_A
            fprintf ( '\nNOTE : By choosing the full value for ' ) ;
            fprintf ( 'k_for_Sparse = size(A, 1), \n' ) ;
            fprintf ( 'you will run even Sparse cases as Non-Sparse, ' ) ;
            fprintf ( 'Full Matrix cases !\n\n' ) ;
            
            fprintf ( 'Pause on ... Press any key to continue. \n\n' ) ;
            pause
            %                       OR :
            % fprintf ( '... Pausing for 3 secs ! \n\n' ) ;
            % pause (3)
            
        elseif k_for_Sparse > rows_A
            fprintf ( '\n' ) ;
            error ( 'k_for_Sparse must be <= size(A, 1) !' ) ;
            
        end
            
    end
    
end    % if rows_A ~= cols_A

if issparse (A)
    Full_A = full (A) ;
end

% Some inits below, mainly to avoid the "No assignment on LHS" problem
% for Sparse Matrices :
abs_D_Prod = [] ;
S_Prod = [] ;
S_D_Rel = [] ;

str_eigs_svds_Error_Sp3   = [] ;
str_eigs_svds_ALERT_Sp1_b = [] ;

       
conj_transp_A = A' ;
% NOTE on Unitary vs Hermitian Diff :
% Unitary (Complex) / Orthogonal (Real) is different from
% Hermitian (Complex) / Symmetric (Real).

inv_A = inv (A) ;               % If det = 0 : we will get a Warning here :
                                % Matrix is close to singular or badly scaled.
                                % Results may be inaccurate for inverse.
                                % Eg : RCOND = 1.306145e-017 in TesT Case 2
                                % Eg : RCOND = 8.873390e-019 in TesT Case 11
                                
det_A = det (A)          % [Sparse Test Case 17 : -2.5600e+002 +2.0606e-012i]
abs_det_A = abs ( det_A ) ;

det_inv_A = det ( inv (A) ) ;


det_A * det_inv_A ;             % Should always be 1 when det is NOT 0,
                                % (= 1 even for ill-conditioned matrices)

%                                       &&&&&&&&&&&&

% 1 b) norm :
% Matlab Help says : Default is norm (A, 2) : The largest singular value
% The std norm = norm with p = 2 does not work on Sparse Matrices !
% Error using ==> norm ; use norm( full(S) ) or norm(S, 1) or norm(S, inf).

% NOTE on no ";" at the end of some stmts :
% Some stmts have been purposely left - without the ending ";"
% to enable display in the Cmd Window.

% [Sparse Test Case 17 : 1.4142]
norm_A     = norm ( full(A) ) 

% The 1-norm = max column sum of A, max(sum(abs((A))) [2]
norm_A_1   = norm ( A, 1 ) 

% The inf norm = max row sum of A, max(sum(abs(A')))  [2]
norm_A_inf = norm ( A, inf ) 

% For comparison below with cond : cond (A, p) = norm (A, p) * norm (inv(A), p)
norm_norm_inv_2 = norm_A * norm ( full (inv(A) ) )  % norm with p = 2  [1]
% This does not tally when the det = 0 (Eg, Test 2, Test 11)

% norm with p = 1 for Sparse  [2]
% For comparison with cond_A_1 for Sparse Matrices below
norm_norm_inv_1 = norm_A_1 * norm ( inv(A), 1 ) 

%                                       &&&&&&&&&&&&

% 1 c) Verify the expr : 
% Matlab Help says : norm(A, p) = sum ( abs(A).^p ) ^ (1/p),
% for any p such that 1 <= p <= inf
% But, the above expr fails at 2nd power ^(1/p).
% Open Q8 : So, if I modify the expr as :
% max ( sum ( abs ( full(A) ).^p ) .^ (1/p) )
% it tallies for norm with p = 1 and 2, but does not tally for norm (A, inf)
% Also, p can only be 1, 2, inf or fro.

p = 2 ;     % (This Matlab Help expr does not tally with norm_A for p = 2 !)
CHECK_norm_2_expr   = max (  sum ( abs ( full(A) ).^p ) .^ (1/p)  )     % 

p = 1 ;
CHECK_norm_1_expr   = max (  sum ( abs ( full(A) ).^p ) .^ (1/p)  )     % 

% p = inf ;
% CHECK_norm_inf_expr = max (  sum ( abs ( full(A) ).^p ) .^ (1/p)  ) 
% CHECK_norm_inf_expr will be 1 always

%                                       &&&&&&&&&&&&

% Col Ref for 80-char marker :
%      10        20        30        40        50        60        70        80

% 1 d) cond :
% if strcmpi ( class(A), 'sparse' ) == 1        % OLD in ver 1
if issparse(A)
    
    fprintf ( 'Matrix A is Sparse ! ... Pausing for 2 secs ! \n\n' ) ;
    pause (2)
    
    % 1-norm condition number estimate
    % From Help : condest uses block 1-norm power method of Higham and Tisseur.
    [cond_A_1, v_A] = condest ( A,  max ( size(A) ) ) 
    % For Test 17, v_A.' = 
    %              [ 0 0 0 0 0 0 0  0.5   0 0 0 0 0 0 0  0.4619 - 0.1913i ] ;
    
    % Verify - with 1-norm for Sparse Matrices :    % [0]
    CHECK_condest_v  = ...
        norm ( A * v_A, 1 )  -  norm ( A, 1 ) * norm ( v_A, 1 ) / cond_A_1

    % Verify - with 1-norm for Sparse Matrices :
    CHECK_cond_1 = norm_norm_inv_1  -  cond_A_1
    % [0 - even with t = max ( size(A)]
    
    cond_A = cond_A_1 ;     % For Sparse Matrices, it is 1-norm
    
    % Cleve Moler has explained the significance of cond and norm in
    % Chapter 2 : Linear Equations in his book :
    % Numerical Computing with MATLAB. Expression similar to norm_norm_inv_1
    % and norm_norm_inv_2 can be seen in P19 in Linear_Equations.pdf
    % But it still does NOT answer my Q12 in eig_svd_herm_unit_pos_def_2_TEST.m
    % explained in detail under Test Case 16.
    
else
    % Condition number with respect to inversion
    cond_A = cond (A)           % For normal matrices, p = 2-norm by Default

    % Verify the expr : cond (A, p) = norm (A, p) * norm (inv(A), p)
    % with p = 2-norm for Normal Matrices :
    CHECK_cond_2 = norm_norm_inv_2  -  cond_A
    % This does not tally when the det = 0 (Eg, Test 2)

    
    cond_A_1 = cond (A, 1) 
    
    % Verify the expr : cond (A, p) = norm (A, p) * norm (inv(A), p)
    % with p = 1-norm for Normal Matrices :
    CHECK_cond_1 = norm_norm_inv_1  -  cond_A_1
    
end

%                                       &&&&&&&&&&&&
% Col Ref for 80-char marker :
%      10        20        30        40        50        60        70        80

% pause

% Let us choose long format when :
if abs (det_A) < 10^-8 | cond_A > 10^5
    format long
    det_A                       %
    cond_A                      %
end

%                                   ********************

% 2) Check for Hermitian :
CHECK_Herm_A = conj_transp_A - A ;           % Should be 0 for Hermitian A
% CHECK_Herm_A is also Sparse if A is.

%                                       &&&&&&&&&&&&

% 3) Check for Unitary :
CHECK_Unitary_A = conj_transp_A - inv_A ;    % Should be 0 for Unitary A
% CHECK_Unitary_A is also Sparse if A is.
                                             
%                                       &&&&&&&&&&&&

% 4) eig OR eigs :
% if strcmpi ( class(A), 'sparse' ) == 1     % OLD in ver 1
if issparse(A)
    
    [ V,  D ]     = eigs ( A, k_for_Sparse ) ;
    % See NOTE on max value of k_for_Sparse with eigs below :
    % max k_for_Sparse for eigs = rows_A - 2
    
    % NOTE on max value of k_for_Sparse with eigs :
    % If you try with k_for_Sparse = rows_A on
    % a Nonsymmetric OR a Complex Matrix A :
    % Warning: For Nonsymmetric and Complex problems, must have
    % number of eigenvalues k < n-1.  Using eig(full(A)) instead !!!
    
    % [ V,  D ]     = eigs ( A ) ;    % In ver 1 ; Default "k" in eigs is 6
    
    % ALERT Sp1 NOTE on the Irony of the Limitation of Analysis
    % as Sparse Matrix :
    % ALERT Sp1 for Sparse Test Case 17 :
    % cols have reduced in V : V is 16 x 6 ;
    % both cols and rows have reduced in D : D is 6 x 6 !
    % D has all 6 Diagonal Els = 0.7632 + 1.1906i ; compare with D_f below.
    % (But note that V and D are NOT Sparse.)
    
    % size_A = size (A)             % 16 x 16 for Sparse Test Case 17
    % class (V), class(D)           % double, double for Sparse Test Case 17
    
    [ V_f,  D_f ] = eig ( full ( A ) ) ;
    % Both V_f and D_f are 16 x 16
    % D_f has 1.1607 - 0.8079i  and  0.7632 + 1.1906i
    % alternating along the Diagonal
    % abs( 1.1607 - 0.8079i ) = 1.4142 ;     abs ( 0.7632 + 1.1906i ) = 1.4142
    % Non-zero els of V are : 0.7718 and -0.1240 + 0.6236i ( abs = 0.6358 )
    
    % Even in this 2nd version, we would land in this Alert Sp1-a code !
    if size (D, 2) ~= size (A, 2)
        fprintf ( 'ALERT Sp1_a : Output D of eigs.m has a reduced size ! \n' );
        fprintf ( 'Pause on ... Press any key to continue. \n\n' ) ;
        pause
        
    end
    
else
    [ V,  D ]     = eig ( A ) ;
    
end    % if issparse(A)


% Check if 0 :
CHECK_eig = A * V  -   V * D ;
% Should ALWAYS be 0 - even if det(A) = 0 !  and even when A is Sparse !
% But, CHECK_svd is NOT 0 for Sparse A - see below
                                    
% class(CHECK_eig)
% CHECK_eig is always double even if A is Sparse - because V and D
% are NOT Sparse.

%                                       &&&&&&&&&&&&

% 5) svd OR svds :
% if strcmpi ( class(A), 'sparse' ) == 1        % OLD in ver 1
if issparse(A)
    
    % Even in this 2nd version, we need this try-catch block !
    try    % try-catch 1
        [ U,  S,  V2 ] = svds ( A, k_for_Sparse ) 
        % [ U,  S,  V2 ] = svds ( A )       % in ver 1
        % Default "k" in eigs is 6. But note that U, S and V2 are NOT Sparse.
        
        % ERROR Sp3 in Rel 12 : Failure in eigs.m at ~ L 451 / ~ L 478
        % NOTE on Error (Sp3) in eigs.m at ~ L 478 when svds.m of Rel 12
        % calls eigs.m for the call :
        % eig_svd_herm_unit_pos_def_2 ( Sparse_Dec_Time_16 {1} )
        % My guess : With svds of Rel 12 call, whch = 'LA' in eigs.m.
        % If this error in svds.m is corrected, we will not get this
        % error in eigs.m in Rel 12.
        
        % See Sparse Test Case 17 in the TEST file for details.
        
        % ALERT Sp2 : In Spasre Test Case 19-C, the above svds call does NOT
        % result in an error, but gives NON-SQUARE U and V2 of size 8 x 6 !
        % which means that we cannot have an inverse of U and V2.
        
        % Even in this 2nd version, we would land in this Alert Sp2 code !
        if size (U, 1) ~= size (U, 2)
            fprintf ( 'ALERT Sp2 : svds returned NON-SQUARE U and V2 ' ) ;
            fprintf ( 'for Sparse Matrix A. \n' ) ;
            fprintf ( 'Pause on ... Press any key to continue. \n\n' ) ;
            pause
            
            % Change in ver 2 :
            % If the try succeeds, we will retain the above U,  S,  V2
            % of the Sparse form of A, NOT the Full form as in the Old ver 1 :
            % [ U,  S,  V2 ] = svd ( Full_A ) ;    % In Old ver 1
            
            % In the catch block below, we take the Full form.
        end
                
    catch
        str_eigs_svds_Error_Sp3 = lasterr
        % Error using ==> eigs ;
        % Eigenvalue range sigma must be a valid 2-element string
        
        str_eigs_svds_Error_Sp3 = ...
            horzcat ( str_eigs_svds_Error_Sp3, ...
                ' - when svds.m of Rel 12 calls eigs.m', ...
                ' - probably, because of whch = LA in eigs.m in R12 (?)' ) ;
    
        % See NOTE above :
        % If the error in svds.m is corrected in R12,
        % hopefully, we should not get this Error in eigs.
        
        fprintf ('Reporting ERROR Sp3 : Failure in eigs.m ') ;
        fprintf ('when called from svds ( ) (svds of Rel 12 ?). \n' ) ;
        
        fprintf ('However, proceding with full form of the Matrix ') ;
        fprintf ('and svd ( ) call instead.\n\n') ;
        fprintf ('Pause on ... Press any key to continue. \n\n') ;
        pause
        
        % Since eigs fails, let us calculate svd using the Full form
        % of the matrix :
        [ U,  S,  V2 ] = svd ( Full_A ) ;
        
        % class(U), class(S), class(V2)   % All double for Sparse Test Case 17
        
    end    % try-catch 1
    
else    % For "normal" ie, Non-Sparse matrices
    
    [ U,  S,  V2 ] = svd ( A ) ;
    
end    

% U,  S,  V2


% The foll 3 exprs should be 0 - even if det(A) = 0 !
% BUT NOT if A is taken in the Sparse form :

CHECK_svd = U * S * V2'  -  A ;
% 0 - even if det(A) = 0 ! BUT NOT if A is Sparse

if ~issparse(A)     % U and V2 are Square ONLY if A is NOT Sparse
                    % or, when we convert to Full Form as in the
                    % case of ERROR Sp3 in R12 above
                    
    % Check if U and V2 are Unitary Matrices :
    DIFF_Unitary_U  =   U' - inv (U) ;  % 0 - even if det(A) = 0 !
    DIFF_Unitary_V2 =  V2' - inv (V2) ; % 0 - even if det(A) = 0 !
    
else    % if A is Sparse, U and V2 are not Square
        % provided we do not convert to Full Form as in the
        % case of ERROR Sp3 in R12 above
    DIFF_Unitary_U  = [] ;
    DIFF_Unitary_V2 = [] ;
end

%                                   ********************

% 6) Comparisons of S and D :
abs_D = abs(D) ;
% For the Sparse Test Case 17,
% abs_D is 6 x 6 with all Diag values = 2. See ALERT Sp1 above.
% (actually of size : k_for_Sparse x k_for_Sparse )

S ;    % S with Full_A, is 16 x 16 with all Diag values = 1.4142

% To compare abs_D with S, we need to first get abs_D in decreasing
% order similar to S :
sorted_Diag_abs_D = flipud ( sort ( diag ( abs_D ) ) ) ;
% flipud is reqd because sort is in ascending order.

for i = 1 : length (abs_D)    % not rows_A !
    abs_D (i, i) = sorted_Diag_abs_D (i) ;
end

DIFF_S_absD = S - abs (D)

% Open Q1a : Explain the diff betn abs(D) and S other than the
% descending order in S.
% S is supposed to have only +ive "Singular values".
% And we are comparing with abs of D's "eigenvalues".
% In what way are "Singular values" diff from "eigenvalues" ?
%
% Part Answer : As per : "... Singular Value from MathWorld.htm",
% for a square matrix , the square roots of the eigenvalues of A' * A
% are called "Singular values" (Marcus and Minc 1992, p. 69).

conj_square_A = A' * A ;    % Note that conj_square_A is Sparse if A is Sparse.
                            
% if strcmpi ( class(A), 'sparse' ) == 1        % OLD in ver 1
if issparse(A)  % 3rd call to eigs.m
    [ V_C_S_A,  D_C_S_A ]  =  eigs ( conj_square_A, k_for_Sparse ) ;
    % NOTE for Sparse Test Case 17 :
    % cols have reduced : V_C_S_A is 16 x 6 ; D_C_S_A is 6 x 6 !
    % D_C_S_A has 6 Diagonal Els = 2 ; compare with D_C_S_A_f below.
    % (But note that V_C_S_A and D_C_S_A are NOT Sparse.)

    [ V_C_S_A_f,  D_C_S_A_f ] = eig ( full ( conj_square_A ) ) ;
    % Both V_C_S_A_f and D_C_S_A_f are 16 x 16
    % D_C_S_A_f has all the 16 Diagonal Els = 2
    % V_C_S_A_f has all the 16 Diagonal Els = 1
    
else
    [ V_C_S_A,  D_C_S_A ]  =  eig ( conj_square_A ) ;
end

% Check if 0 :
% Should ALWAYS be 0 - even if det(A) = 0 !, or even if A is Sparse :
CHECK_eig_C_S_A    =  conj_square_A * V_C_S_A     -   V_C_S_A * D_C_S_A ;

% The square roots of the eigenvalues of A' * A
% are called "Singular values" (Marcus and Minc 1992, p. 69).
Sing_sqrt_D_C_S_A  =  sqrtm ( D_C_S_A ) 
% Refer AEMM / P181 for Matlab Matrix functions

% For Sparse Test Case 17 :
% Sing_sqrt_D_C_S_A is 6 x 6 Diag Matrix with Diag Els = 1.4142
% Note that the output S of svds is 6 x 6 Diag Matrix with Diag Els = 1.4142
% - if we succeed in the try block above ;
% in the catch block, we revert to the full form of S with Full_A,
% ie, S is then 16 x 16 Diag Matrix with Diag Els = 1.4142

% if strcmpi ( class(A), 'sparse' ) == 1        % OLD in ver 1
if issparse(A)
    
    % Check if 0 :
    % Should ALWAYS be 0 - even if det(A) = 0 !, or even if A is Sparse :
    CHECK_eig_C_S_A_f   = conj_square_A * V_C_S_A_f  -  V_C_S_A_f * D_C_S_A_f 

    Sing_sqrt_D_C_S_A_f = sqrtm ( D_C_S_A_f ) 
    
else
    Sing_sqrt_D_C_S_A_f = Sing_sqrt_D_C_S_A 
end

% Compare value of norm (Default with p = 2) with the max Singular Value :
% Should be 0 :
CHECK_norm_Singular = norm_A - max ( max ( max (Sing_sqrt_D_C_S_A  ) ) , ...
                                     max ( max (Sing_sqrt_D_C_S_A_f) ) )  % [0]

% pause
% YES, for Non-Sparse matrix A, S tallies with Sing_sqrt_D_C_S_A.
% (only the order is ascending in Sing_sqrt_D_C_S_A, and descending in S) ;
% Open Q1b : but, pl explain the diff betn D and S (or Sing_sqrt_D_C_S_A)
% when the A matrix is purely real ?

%                                       &&&&&&&&&&&&

% 7) Compare the product of the Diag Els of D and S :
D_Prod = 1 ;    S_Prod = 1 ;    

% Because of the reduced size of D and the problem of error in
% eigs via svds (in the case of Sparse Matrix A (Test Case 17) )
% there is a mismatch between the sizes of D and S.
% Hence, I am forced to put the foll code block in a try block !

try    % try-catch 2
            
    for row = 1 : size ( A, 1 )
        D_Prod = D_Prod * D(row, row) ;  % Error : ALERT Sp1_b :
        % D for a Sparse matrix A, has reduced size
        % for eg, in Sparse Test Case 17, D is only 6 x 6 instead of 
        % the expected 16 x 16 for the full form of A.
        S_Prod = S_Prod * S(row, row) ;
    end
    
    format long
    
    abs_D_Prod = abs ( D_Prod )
    % El(s) could be 0 if the rank < full, for eg, when det = 0
    
    S_Prod                      %
    
    DIFF_prod_S_absD = S_Prod - abs_D_Prod ;
    
    format
    
    %                                       &&&&&&&&&&&&

    % Resume the old format if necessary :
    if abs (det_A) < 10^-8 | cond_A > 10^5
        format long
    end
    
    % 8) The foll are various trials on S and D, and
    % with Right and Left Matrix Divs :
    
    % NOTE that if we encountered Error : ALERT Sp1_b above due to
    % D of a reduced size, we will NOT be entering the foll code snippet.
    
    % Author's Ref :
    % My notes for these are in P 224-225 of my copy of the book :
    % DSP using Matlab by Ingle and Proakis
    % (This book is often referred to as DSPIP or Ingle in the code below.)
    
    S_D_Rel{1} = S\D * S/D ;     % = I        % =   inv(S)*D   *    S*inv(D)
    
    %                                          +++++++

    % (Warning for Ill-Conditioned Matrices possible
    % (eg, det = 0, Hilbert, Pascal Matrices) :)
    S_D_Rel{2} = S\D * D\S ;     % NOT = I    % =   inv(S)*D   *    inv(D)*S
    % Try : S_D_Rel {2} after running this pgm.
    
    % NOTE that "\" takes inverse of "ALL whatever" is to the Left of \ !
    % So, S\D * D\S is taken as :  S\ *  D * D  \  S
    %                              -----------
    % = inv (  inv(S) * D * D  )  *  S
    % Check that the foll is 0 :
    S_D_Rel_2_CHECK_3 = S_D_Rel{2}  -  inv ( inv(S) * D * D ) * S ;  % = 0
    
    % Note also that :
    % M5 \ eye(5) and eye(5) / M5 are the same where M5 = magic (5).
    
    abs_S_D_Rel_2 = abs ( S_D_Rel{2} )
    % QA : Is abs_S_D_Rel_2 = I only for Unitary Matrix A ?
    % A : No, It is = I also for Test Case 16 (F_Sp_Time_8) and
    % Test Case 18 (F_Sp_Time_16_1) which are NOT Unitary.
    % Open Q7 : So, how can we predict the type of matrix A
    % (other than Unitary) for which abs_S_D_Rel_2 will be I ?
    
    %                                          +++++++
    
    S_D_Rel{3} = (S\D) * (D\S) ; % = I         % = ( inv(S)*D ) *  ( inv(D)*S )
    
    %                                          +++++++
    
    % surprisingly, also I ! :
    S_D_Rel{4} = S\(D * S)/D ;                 % = inv(S) * ( D * S ) * inv(D)
    
catch
    str_eigs_svds_ALERT_Sp1_b = lasterr
    % Error : Index exceeds matrix dimensions.
    % at : D_Prod = D_Prod * D(row, row) (~ L 666)

    str_eigs_svds_ALERT_Sp1_b = ...
        horzcat ( 'Because of reduced size of D, Error : ', ...
                  str_eigs_svds_ALERT_Sp1_b ) ;
    
    fprintf ( 'ALERT Sp1_b : Failure in eig_svd_herm_unit_pos_def_2 ' ) ;
    fprintf ( 'at ~ L 666  :\n' ) ;
    fprintf ( '     D_Prod = D_Prod * D(row, row) \n' ) ;
    fprintf ( ' Output D of eigs.m - for a Sparse matrix A - ' ) ;
    fprintf ( 'has a reduced size ! \n\n' ) ;
    fprintf ( 'Pause on ... Press any key to continue. \n\n' ) ;

    % Reset the foll in the catch block.
    % Observe that in the initial init, we have made abs_D_Prod,
    % S_Prod, S_D_Rel as null, else, they will not be assigned
    % on the LHS ! for Sparse cases.

    abs_D_Prod = [] ;
    S_Prod = [] ;
    S_D_Rel = [] ;
    
    pause
    
end    % try-catch 2

%                                   ********************

% 9) Positive Definite :
% As per "Positive Definite Matrix from MathWorld.htm" :
% A general complex matrix is positive definite iff its "Hermitian part"
% has all positive eigenvalues.

% Hermitian Part :
HP_A = 0.5 * ( A + A' ) ;        % HP_A is Sparse if A is Sparse

% if strcmpi ( class(HP_A), 'sparse' ) == 1        % OLD in ver 1
if issparse(HP_A)

    fprintf ( 'Hermitian Part Matrix HP_A is Sparse ! ' ) ;
    fprintf ( '... Pausing for 2 secs ! \n\n' ) ;
    pause (2)

    [V_HP_A,   D_HP_A] = eigs (HP_A) ;
    % ALERT Sp1 for Sparse Test Case 17 :
    % cols have reduced : V_HP_A is 16 x 6 ; D_HP_A is 6 x 6 !
    % D_HP_A has all 6 Diagonal Els = 1.1607 ; compare with D_HP_A_f below.
    % (But note that V_HP_A and D_HP_A are NOT Sparse even if HP_A is Sparse.)

    [ V_HP_A_f,  D_HP_A_f ] = eig ( full ( HP_A ) ) ;
    % Both V_HP_A_f and D_HP_A_f are 16 x 16
    % D_HP_A_f has 0.7632 for the first 8 Diag Els, and
    % 1.1607 for the next 8
    % V_HP_A_f is really full ! - with the last row being real,
    % which includes 4 0s.
    
    % So, if we look at d_HP_A below, it shows 6 eigenvalues = 1.1607
    % whereas D_HP_A_f has 0.7632 for the first 8 Diag Els,
    % and 1.1607 for the next 8.
    
else
    [V_HP_A,   D_HP_A] = eig (HP_A) ;
end

d_HP_A = diag (D_HP_A)              %


str_CHECK_POS_DEF = 'NO ' ;

if isreal(d_HP_A) == 0
    str_CHECK_POS_DEF = 'NO ' ;
    % Q : Will this ever happen ? Then, print it out !
    
    fprintf ( '\nCase found when d_HP_A is NOT fully real !!! \n' ) ;
    
else        % all eig values of the "Hermitian part" are real :
    if all (real (d_HP_A) > 0)
        str_CHECK_POS_DEF = 'YES' ;
    else
        str_CHECK_POS_DEF = 'NO ' ;
    end
end

% Open Q2 : As you can see above, I got Positive Definite only for
% Hilbert and Pascal Matrices.
% Get me few egs of other general, non-trivial, (and if possible complex)
% matrices which are Positive Definite.
%           
% Open Q3 : Just as svd generates Unitary matrices U and V2,
% is there any way that we can "generate" general, non-trivial,
% Positive Definite (complex ?) matrices ?
% Ofcourse, exclude the Hilbert and Pascal Matrices.
%
% Open Q6 in eig_svd_herm_unit_pos_def_2_TEST.m :
% So, from above Sparse Tests 17 to 20, we see that except for
% Sparse_Dec_Time {1} for N = 16 (Test 18), all the other Sparse Matrices
% tested above, including the products Sp_Time_8 for N = 8 (r = 3) and
% Sp_Time_16 for N = 16 (r = 4), and also verified in their Full forms :
% F_Sp_Time_8 and F_Sp_Time_16, are NOT Pos-Def.
% How does one explain this ?
% How could one predict that Sparse_Dec_Time {1} for N = 16 would alone
% be Pos-Def - without going through so many tests ?
%
%                                   ********************

% A marker just to show where the output args start, because some stmts above
% have been purposely left - without the ending ";" - for display
% in the Cmd Window.

fprintf ( '                        ********************                \n' ) ;

format

fprintf ( '\n****         Pgm output begins here.             **** \n' ) ;
fprintf ( '****         Press any key to release Pause.     **** \n\n' ) ;

pause    % Guess why this pause is necessary.
         % Clue : Try Test Case 17 by commenting !

%                                   ********************

% As an aside, note that as long as we are operating exclusively with
% Sparse matrices, the result is also sparse. If one of the matrices is
% a Full Matrix, the result is also a Full Matrix.

%                                   ********************

% About the Author : My areas of interest are Video Compression,
% H.264, MPEG, DSP, 3G, Wireless Video Communication, HDTV, ATM and SONET. 
% Ideally, I like to work in the areas of Video Compression by implementing
% something based on H.264, Galois Fields, C64X and Matlab / Mathematica.

% Col Ref for 80-char marker :
%      10        20        30        40        50        60        70        80

%                                   ********************
