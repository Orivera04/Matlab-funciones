function [T_W, WN, r, new_N, Sparse_Dec_Time, Sparse_Dec_Freq, ...
          WDIN_Eqvt, WDON_Eqvt] = vandermonde_polyfit_twiddle_1 ( N, varargin )
%
% Subject  : FFT Twiddle Factors through Sparse Matrices
% Author   : Sundar Krishnan
% email id : sundark100@yahoo.com
% Date     : 2002, January-February 2004
%
% Brief Description :
% -------------------
% This pgm can be used to generate Sparse Matrices for running
% Sparse Test Cases in eig_svd_herm_unit_pos_def_2.m and
% eig_svd_herm_unit_pos_def_2_TEST.m
% It is a wonderful pgm for the exposition of FFT using Sparse Matrices.
%
% For a quick start, try the "Usage Eg" below.
%
% Author's Legal Disclaimer :
% Everyone is free to use this code at his or her own risk provided
% they include my name for this part.
% I am NOT responsible for any legal complications directly
% or indirectly for any direct or indirect use of this code.
%
% Any cross-references mentioned below are only for/from the
% author's own notes. The cross-referred files are not necessary
% for running this program.
%
%                                       &&&&&&&&&&&&
%
% Detailed Functional Description :
% ---------------------------------
% T_W is the Basic Undecimated FFT Matrix which is calculated using vander ( ).
% Sparse_Dec_Time and Sparse_Dec_Freq are cell arrays containing
% 'r' Sparse matrices each of size N x N.
% Currently, we are only calculating Sparse_Dec_Time, NOT Sparse_Dec_Freq.
%
% One way to calculate the Time-Decimation Matrix WDIN is to refer
% to WDI_Time.m : [ WDIN ] = WDI_Time ( N ) which calculates WDIN recursively.
% There is also a note in WDI_Time.m which shows how the WDI16 results
% can be compared with results of this pgm.
%
% In this pgm, we have 2 other ways of calculating WDIN :
% The first of these 2 ways (the second way) is to derive this
% Time-Decimation Matrix WDIN on the basis of the Undecimated T_W
% obtained by running this pgm, and then perform the eqvt of bit-reversal
% on the columns of T_W.
%
% The second of these 2 ways (the third way) is to derive this
% Time-Decimated Twiddle Matrix WDIN as a product of 'r' stages
% Sparse Matrices, whose full form is given by WDIN_Eqvt in this pgm.
%
%                                       &&&&&&&&&&&&
%
% Reference :
% -----------
% I read about the Sparse Technique in FFT for the first time
% (Q1 : still I don't have the PROOF) in the downloaded paper
% by Paul Heckbert :
% http://www.cs.cmu.edu/afs/andrew/scs/cs/15-463/pub/www/notes/fourier/
% fourier.pdf
% saved in C:\...\Matlab_Misc_Dnloads\Gen_Matlab_Notes\Paul_Heckbert_FFT.pdf.
% Also refer :
% http://www-2.cs.cmu.edu/afs/cs/project/anim-ph/463.95/pub/www/notes.toc.html
% Both these refs were given to us by Bhooshan Iyer.
%
% See also eig_svd_herm_unit_pos_def_2.m and eig_svd_herm_unit_pos_def_2_TEST.m
%
% See also my notes in FFT_spasmous_1.m to see how fft of a col vector = a1,
% and fft2 of a sq matrix = a2, can be computed from T_W :
% FFT1_a1  =  T_W * a1           % We already know this - this is obvious.
% FFT2_a2  =  T_W * a2  * T_W    % Observe the 2nd post-multiplication by T_W.
%
%                                       &&&&&&&&&&&&
%
% Usage Eg :
% ----------
% [T_W, WN, r, new_N, Sparse_Dec_Time, Sparse_Dec_Freq, ...
%  WDIN_Eqvt, WDON_Eqvt] = vandermonde_polyfit_twiddle_1 ( 8 ) ;
%
% [T_W, WN, r, new_N, Sparse_Dec_Time, Sparse_Dec_Freq, ...
%  WDIN_Eqvt, WDON_Eqvt] = vandermonde_polyfit_twiddle_1 ( 16 ) ;
%
% Syntax Tip : Do not run this pgm with ... ( 8, varargin ) ;
% ??? Attempt to execute SCRIPT varargin as a function.
% Today, there is nothing for varargin. varargin is for future.
%
% NOTE on NO 80-char Line restriction :
% The 80-char line restriction is NOT observed below at many places
% in this file because wrapping distorts the good-reading of this file.
%
%                                   ********************
%
% Misc Notes / Tips :
% -------------------
% vander ( ) :
% Given a col (or row) vector X = [ x1, x2, x3, ... xn ]'
% ...\toolbox\matlab\elmat\vander (x) returns a matrix A
% whose columns are powers of the vector X
% A (i, j) = x(i)^(n-j).
% Refer NRC / P90 and  dft_twiddle_factors_matrices.m
%
% NRC / P91 : Vandermonde systems are notoriously ill-conditioned
% by their very nature.
% Open Q12 in eig_svd_herm_unit_pos_def_2_TEST.m :
% But for Test Cases 16 / 19E, 19D and 20F, 20E,
% we do NOT get a high condition value ?
% Refer to my analysis with det(A), cond_A and cond_A_1
% in that file under Test Case 16.
%
% Look at Stage4 for more on the Sparse way.
%
% Look at the usage of cond and norm under Verification :
% if r-2 > 0 for N = 8, r = 3
%
% Refer to my first Twiddle Factors' pgm : dft_twiddle_factors_matrices.m
% Also refer to other eg of vandermonde in rs_raid_alg_vander_1.m
%
%                                       &&&&&&&&&&&&

% Egs of vander ( [ ... ] ) :
% vander ( [ 1 1 1 ] )
%      1     1     1
%      1     1     1
%      1     1     1

% vander ( [ 1 2 3 4 ] )
%      1     1     1     1
%      8     4     2     1
%     27     9     3     1
%     64    16     4     1     
     
%                                       &&&&&&&&&&&&

% % First a test for W8 : ( I have also tested for W4.)
% 
% clc
% W8 = exp ( - j*2*pi / 8 )      % 0.7071 - 0.7071i
% 
% % from power p = 0 to 8-1 = 7 ; NOTE .' is reqd for true transpose !
% W = [ W8^0  W8^1  W8^2  W8^3  W8^4  W8^5  W8^6  W8^7 ].'
% 
% T_W = vander (W)
% 
% % Q3 : It seems that we need to fliplr to get the "correct" Vandermonde Matrix
% % with 1s in the 1st col and 1st row as given in NRC / P90 ??
% % T_W is the Basic Undecimated Matrix.
% T_W = fliplr (T_W)
% 
% cond (T_W)      % = 1
% 
% inv (T_W) - (1/8) .* conj (T_W)  % gives 0 - OK
% 
% % Now, we proceed below with a general solution.

%                                   ********************

% Actual Programme begins here.

% N = 8  ;
% N = 16 ;

clc

T_W = ones (N, N) ;
W   = ones (1, N) ;

% Nth root of Unity :
WN = exp ( - j*2*pi / N ) ;

% from power p = 0 to N-1 (for eg, p = 0 to 7 for N = 8);
% NOTE .' is reqd for true transpose !
for p = 0 : N-1
    W(p+1) = (WN^p) .' ;
    % This Transpose may not be necessary, so it turns out !
end

W ;

T_W = vander (W) ;           % Fulcrum 1

% Q3 : It seems that we need to fliplr to get the "correct" Vandermonde Matrix
% with 1s in the 1st col and 1st row as given in NRC / P90 ??
T_W = fliplr (T_W) ;

cond_T_W = cond (T_W) ;     % = 1

inv (T_W) - (1/N) .* conj (T_W) ;   % gives 0 - OK

%                                       &&&&&&&&&&&&

% Further, to be in line with RSCode_CS-96-332.pdf,
% we need to rotate the matrix :    % Ignore for now.
% flipud ( vander ( [ 1 2 3 4] )' )

%                                   ********************

% Now, let us turn our attn to Sparse Matrix solution as given
% in the paper by Paul Heckbert.

% 'r' is the no of Sparse Matrices such that 2^r = N
% (for eg, for N = 8, we need r = 3 Sparse Matrices.)
% Note that in that paper in P9, the Left-most matrix on the
% RHS Sparse matrices signifies r = 1st stage,
% and the Right-most matrix on the RHS Sparse matrices
% signifies r = 3rd stage !

r = nextpow2 (N) ;   % nextpow2(N) returns the first r such that 2^r >= abs(N).

N = 2^r ;            % the corrected N which is a power of 2

Sparse_Dec_Time = cell ( 1, r ) ;

Sparse_Dec_Freq = cell ( 1, r ) ;

%                                          ++++++

% For working with cells, we have 2 ways :

% a) Content Indexing : where a single cell can be assigned ;
% we need { } on LHS and optionally, [] on RHS :
for col = 1 : r
    Sparse_Dec_Time {1, col} = sparse (N, N) ;
    Sparse_Dec_Freq {1, col} = sparse (N, N) ;
    % With ( ) on LHS, we get an Error :
    % Conversion to cell from sparse is not possible.
    % For eg, Sparse_Dec_Freq {1, 2}  gives : All zero sparse: 8-by-8
end

% % b) Cell Indexing : where we can assign multiples cells ;
% % we need ( ) on LHS and { } on RHS :
% col = 1 : r     % So, a vector for LHS
% Sparse_Dec_Time (1, col) = { sparse(N, N),  sparse(N, N),  sparse(N, N) }
% % The above stmt works for r = 3, but 
% % Q2-a : How do we modify above when r is a var on the fly as N varies ?
% % If someone can give me a clue, this pgm can be made very efficient
% % and compact.

%                                          ++++++

% The product of the individual Sparse Matrices of this cell should yield
% eqvt to : WDI8_3 * WDI8_2 * WDI8_1 * = WDI8
% of dft_twiddle_factors_matrices.m, the Time-Decimated matrix.

% The foll loop is expanded only for r = 4.
% Since r can be very high, for eg, r = 12 for N = 4096,
% I think we need to have a better way.
% Q2-b : Who can suggest a better way of syntax handling for this ?

for col = r : -1 : 1
    
    % Stage 1 is the col = (last) rth Sparse Matrix ;
    % it oscillates betn 0 and -1.
    % (the last RHS matrix on the RHS - eqvt to WDI8_1 ) :
    % It repeats for every 2 x 2 matrix along the diagonal as follows :
    if col == r
        for s1rc = 1 : N
            if mod ( s1rc, 2 ) ~= 0        % odd rows [/ cols]
                Sparse_Dec_Time { 1, col } ( s1rc, s1rc )     = 1 ;
                Sparse_Dec_Time { 1, col } ( s1rc, s1rc + 1 ) = 1 ;
                Sparse_Dec_Time { 1, col } ( s1rc + 1, s1rc ) = 1 ;
            else                        % even rows [/ cols]
                Sparse_Dec_Time { 1, col } ( s1rc, s1rc )   = -1 ;
            end
        end
        
        % c1 {1, 1} = [M5]                      % class ( c1 {1,1} ) = double
        % c1 {1, 1} = [sparse(M5)]              % class ( c1 {1,1} ) = sparse
        
    end

    % Stage 2 is the (col = r - 1)th Sparse Matrix ;
    % it oscillates betn 0, -j, -1 and j.
    % (eqvt to WDI8_2 ) :
    % It repeats for every 4 x 4 matrix along the diagonal as follows :
    %
    % NOTE on NO 80-char Line restriction :
    % The 80-char line restriction is NOT observed below at many places
    % in this file because wrapping distorts the good-reading of this file.

    if col == r - 1
        
        for s2rc = 1 : N
            if     mod ( s2rc, 4 ) == 1     % = 1, 5,  9, 13, 17, 21, 25, 29, ...
                Sparse_Dec_Time { 1, col } ( s2rc, s2rc )         = 1  ;    % eqvt to (1,1),  (5,5) ... =  1
                Sparse_Dec_Time { 1, col } ( s2rc, s2rc + 2 )     = 1  ;    % eqvt to (1,3),  (5,7) ... =  1
                
            elseif mod ( s2rc, 4 ) == 2     % = 2, 6, 10, 14, 18, 22, 26, 30, ...
                Sparse_Dec_Time { 1, col } ( s2rc, s2rc )         = 1  ;    % eqvt to (2,2),  (6,6) ... =  1
                Sparse_Dec_Time { 1, col } ( s2rc, s2rc + 2 )     = -j ;    % eqvt to (2,4),  (6,8) ... = -j
                
            elseif mod ( s2rc, 4 ) == 3     % = 3, 7, 11, 15, 19, 23, 27, 31, ...
                Sparse_Dec_Time { 1, col } ( s2rc, s2rc - 2 )     = 1  ;    % eqvt to (3,1),  (7,5) ... =  1
                Sparse_Dec_Time { 1, col } ( s2rc, s2rc )         = -1 ;    % eqvt to (3,3),  (7,7) ... = -1
                
            elseif mod ( s2rc, 4 ) == 0     % = 4, 8, 12, 16, 20, 24, 28, 32, ...
                Sparse_Dec_Time { 1, col } ( s2rc, s2rc - 2 )     = 1  ;    % eqvt to (4,2),  (8,6) ... =  1
                Sparse_Dec_Time { 1, col } ( s2rc, s2rc )         = j  ;    % eqvt to (4,4),  (8,8) ... =  j
                
            end
        end
        
    end     % if col == r - 1

%                                          ++++++
    
% Col Ref for 80-char marker :
%      10        20        30        40        50        60        70        80
% NOTE : Certain lines have been left deliberately with > 80 chars in order to
% facilitate better understanding of the expressions.

%                                          ++++++

    % Stage 3 is the (col = r - 2)th Sparse Matrix ; oscillates betn 0 to WN^7 ) :
    % It repeats for every 8 x 8 matrix along the diagonal as follows :
    % This will be required if N >= 8.
    % (As the Stages increase, we have more cases to deal with when we go this long way.
    %  For eg, for Stage 3, we have to deal with 2^3 = 8 cases !)
    if col == r - 2
        
        for s3rc = 1 : N
            
            if     mod ( s3rc, 8 ) == 1     % s3rc = 1, 9,  17, 25,  ...
                Sparse_Dec_Time { 1, col } ( s3rc, s3rc )         = 1  ;    % eqvt to (1,1),  (9 ,9 ) ... = 1
                Sparse_Dec_Time { 1, col } ( s3rc, s3rc + 4 )     = 1  ; % = WN^0  ;    % eqvt to (1,5),  (9 ,13) ... = WN^0
                
            elseif mod ( s3rc, 8 ) == 2     % s3rc = 2, 10, 18, 26,  ...
                Sparse_Dec_Time { 1, col } ( s3rc, s3rc )         = 1  ;    % eqvt to (2,2),  (10,10) ... = 1
                Sparse_Dec_Time { 1, col } ( s3rc, s3rc + 4 )     = WN^1  ;    % eqvt to (2,6),  (10,14) ... = WN^1
                
            elseif mod ( s3rc, 8 ) == 3     % s3rc = 3, 11, 19, 27,  ...
                Sparse_Dec_Time { 1, col } ( s3rc, s3rc )         = 1  ;    % eqvt to (3,3),  (11,11) ... = 1
                Sparse_Dec_Time { 1, col } ( s3rc, s3rc + 4 )     = WN^2  ;    % eqvt to (3,7),  (11,15) ... = WN^2
                
            elseif mod ( s3rc, 8 ) == 4     % s3rc = 4, 12, 20, 28,  ...
                Sparse_Dec_Time { 1, col } ( s3rc, s3rc )         = 1  ;    % eqvt to (4,4),  (12,12) ... = 1
                Sparse_Dec_Time { 1, col } ( s3rc, s3rc + 4 )     = WN^3  ;    % eqvt to (4,8),  (12,16) ... = WN^3


            elseif mod ( s3rc, 8 ) == 5     % s3rc = 5, 13, 21, 29,  ...
                Sparse_Dec_Time { 1, col } ( s3rc, s3rc - 4 )     = 1  ;    % eqvt to (5,1),  (13,9 ) ... = 1
                Sparse_Dec_Time { 1, col } ( s3rc, s3rc )         = -1 ; % = WN^4)  ;    % eqvt to (5,5),  (13,5 ) ... = WN^4

            elseif mod ( s3rc, 8 ) == 6     % s3rc = 6, 14, 22, 30,  ...
                Sparse_Dec_Time { 1, col } ( s3rc, s3rc - 4 )     = 1  ;    % eqvt to (6,2),  (14,10) ... = 1
                Sparse_Dec_Time { 1, col } ( s3rc, s3rc )         = WN^5  ;    % eqvt to (6,6),  (14,6 ) ... = WN^5

            elseif mod ( s3rc, 8 ) == 7     % s3rc = 7, 15, 23, 31,  ...
                Sparse_Dec_Time { 1, col } ( s3rc, s3rc - 4 )     = 1  ;    % eqvt to (5,1),  (15,11) ... = 1
                Sparse_Dec_Time { 1, col } ( s3rc, s3rc )         = WN^6  ;    % eqvt to (7,7),  (15,7 ) ... = WN^6

            elseif mod ( s3rc, 8 ) == 0     % s3rc = 8, 16, 24, 32,  ...
                Sparse_Dec_Time { 1, col } ( s3rc, s3rc - 4 )     = 1  ;    % eqvt to (5,1),  (16,12) ... = 1
                Sparse_Dec_Time { 1, col } ( s3rc, s3rc )         = WN^7  ;    % eqvt to (8,8),  (16,8 ) ... = WN^7
                
            end
        end
        
    end     % if col == r - 2

    
    % Stage 4 is the (col = r - 3)th Sparse Matrix ; oscillates betn 0 to WN^15 ) :
    % It repeats for every 16 x 16 matrix along the diagonal as follows :
    % This will be required if N >= 16.
    % NOTE : For this Stage, I have used the Sparse technique further, and so, the code is so short !
    if col == r - 3
        
        Stg4_WN = [ ] ;
        
        for i = 1 : 8
            Stg4_WN_Top     =  cat ( 2, Stg4_WN, WN^(i-1) ) ;       % = WN^0 to WN^7
            Stg4_WN_Bottom  =  cat ( 2, Stg4_WN, WN^(i-1 + 8) ) ;   % = WN^8 to WN^15
        end
        
        Stg4_Left_8         =  sparse ( [1:8], [1:8], 1 ) ;
        Stg4_Top_Right_8    =  sparse ( [1:8], [1:8], Stg4_WN_Top ) ;
        Stg4_Bottom_Right_8 =  sparse ( [1:8], [1:8], Stg4_WN_Bottom ) ;
        
        % Note : cat is not defined for Sparse
                
        Stg4_Basic_16 = [ Stg4_Left_8,  Stg4_Top_Right_8 ;
                          Stg4_Left_8,  Stg4_Bottom_Right_8 ] ;
                          
        for j = 1 : N / 16
            Sparse_Dec_Time {1, col} ...
                ( [ (j-1)*16 + 1 : j*16 ] ,  [ (j-1)*16 + 1 : j*16 ] ) = Stg4_Basic_16 ;
        end
            
        % full ( Sparse_Dec_Time {1, col} )     % for test only
                
    end     % if col == r - 3
    
end     % for col = r : -1 : 1

% Col Ref for 80-char marker :
%      10        20        30        40        50        60        70        80

% As we go for higher stages, specially as r is a dynamic variable,
% we need to improve further by changing the above hard-coded values
% like 8, 16 etc as functions of r.
% Q2-c : Who can suggest a better way of syntax-handling for this ?
%
% However, the full extent of Sparse technique is already established above.
% I do not think, we can further shorten by going anymore in the Sparse way.
% Or can we ?

%                                   ********************

% Now, verify :

% When N = 2, ie, r = 1 :
check_Stage_1_last_r   = full ( Sparse_Dec_Time { 1, r } ) ;

% Compare with Time-Decimated matrix WDIN
WDIN_Eqvt = check_Stage_1_last_r ;
% WDI2 - WDIN_Eqvt  % should give all 0s in the W/s.

WDON_Eqvt = check_Stage_1_last_r .' ;
% WDO2 - WDON_Eqvt  % should give all 0s in the W/s.

% Use condest for Sparse Matrices :
cond_WDIN_Eqvt = condest ( WDIN_Eqvt )         % = 2
cond_WDON_Eqvt = condest ( WDON_Eqvt )         % = 2

cond_Sparse_Dec_Time_Stage_1 = condest ( Sparse_Dec_Time { 1, r } )     % = 2


cond_WDIN_Eqvt_full = cond ( full ( ( WDIN_Eqvt ) ) )        % = 1
cond_WDON_Eqvt_full = cond ( full ( ( WDON_Eqvt ) ) )        % = 1

cond_Sparse_Dec_Time_Stage_1_full = cond ( full ( ( Sparse_Dec_Time { 1, r } ) ) ) % = 1


% When N = 4, ie, r = 2 :
if r-1 > 0          % actually : if r == 2
    check_Stage_2_last_rm1 = full ( Sparse_Dec_Time { 1, r-1 } ) ;  % rm1 => r minus 1
    
    % Compare with Time-Decimated matrix WDIN
    WDIN_Eqvt = full ( Sparse_Dec_Time { 1, r-1 } * Sparse_Dec_Time { 1, r } ) ;
    % WDI4 - WDIN_Eqvt  % should give all 0s in the W/s.
    
    WDON_Eqvt = full ( Sparse_Dec_Time { 1, r } .'  *  Sparse_Dec_Time { 1, r-1 } .' ) ;
    % WDO4 - WDON_Eqvt  % should give all 0s in the W/s.

    % Use condest for Sparse Matrices :    
    cond_WDIN_Eqvt = condest ( WDIN_Eqvt )         % = 4        = 1 for full matrix
    cond_WDON_Eqvt = condest ( WDON_Eqvt )         % = 4        = 1 for full matrix

    cond_Sparse_Dec_Time_Stage_2 = condest ( Sparse_Dec_Time { 1, r - 1 } )
    % = 2        = 1 for full matrix

    
    cond_WDIN_Eqvt_full = cond ( full ( ( WDIN_Eqvt ) ) )        % = 1
    cond_WDON_Eqvt_full = cond ( full ( ( WDON_Eqvt ) ) )        % = 1

    cond_Sparse_Dec_Time_Stage_2_full = ...
        cond ( full ( ( Sparse_Dec_Time { 1, r - 1 } ) ) )       % = 1
    
end


% When N = 8, ie, r = 3 :
if r-2 > 0          % actually : if r == 3
    check_Stage_3_last_rm2 = full ( Sparse_Dec_Time { 1, r-2 } ) ;
    
    % Compare with Time-Decimated matrix WDIN    
    WDIN_Eqvt = full ( Sparse_Dec_Time { 1, r-2 } * Sparse_Dec_Time { 1, r-1 } * ...
                       Sparse_Dec_Time { 1, r } ) ;
    % WDI8 - WDIN_Eqvt  % should give all 0s in the W/s.
    
    % Q : How will the Sparse Matrices be for the Freq-Decimated case ?
    % A : WDON = WDIN .'  is tested in dft_twiddle_factors_matrices.m
    %     So, WDO8  =  WDI8_1 .'  *  WDI8_2 .'  *  WDI8_3 .'
    WDON_Eqvt = full ( Sparse_Dec_Time { 1, r } .'  *  Sparse_Dec_Time { 1, r-1 } .' ...
                    *  Sparse_Dec_Time { 1, r-2 } .' ) ;
    % WDO8 - WDON_Eqvt  % should give all 0s in the W/s.
    
    % Note that any operation betn 2 Sparse matrices like Sparse x Sparse
    % or Sparse + Sparse is also Sparse.
    % But if in the chain of opeartions, we have even one non-sparse matrix,
    % the ans is non-sparse.
    
    %                                          ++++++

    % cond :
    % Use condest for Sparse Matrices :
    cond_WDIN_Eqvt = condest ( WDIN_Eqvt )         % = 8        = 1 for full matrix
    % But see norm below - 8 is preserved !
    
    cond_WDON_Eqvt = condest ( WDON_Eqvt )         % = 8        = 1 for full matrix

    cond_Sparse_Dec_Time_Stage_3 = condest ( Sparse_Dec_Time { 1, r-2 } ) 
    % = 2        = 1 for full matrix
    
    
    cond_WDIN_Eqvt_full = cond ( full ( ( WDIN_Eqvt ) ) )        % = 1
    cond_WDON_Eqvt_full = cond ( full ( ( WDON_Eqvt ) ) )        % = 1

    cond_Sparse_Dec_Time_Stage_3_full = cond ( full ( ( Sparse_Dec_Time { 1, r-2 } ) ) )
    % = 1

    % Open Q4 in eig_svd_herm_unit_pos_def_2_TEST.m :
    % Pl explain this diff in the cond betn Sparse and Full forms.
    
    %                                          ++++++
    
    % norm :
    % cond(X, p) = norm (X, p) * norm (inv(X), p)
    % The std norm = norm with p = 2 does not work on Sparse Matrices !
    % Error using ==> norm ; use norm(full(S)) or norm(S,1) or norm(S,inf).
    norm_WDIN_Eqvt = norm ( full ( ( WDIN_Eqvt ) ) )         % = sqrt (8)
    norm_WDON_Eqvt = norm ( full ( ( WDON_Eqvt ) ) )         % = sqrt (8)

    norm_Sparse_Dec_Time_Stage_3 = norm ( full ( ( Sparse_Dec_Time { 1, r-2 } ) ) )
    % = sqrt (2)
    
    
    norm_Inv_WDIN_Eqvt = norm ( full ( ( inv ( WDIN_Eqvt ) ) ) )    % = 1 / sqrt (8)
    norm_Inv_WDON_Eqvt = norm ( full ( ( inv ( WDON_Eqvt ) ) ) )    % = 1 / sqrt (8)

    norm_Inv_Sparse_Dec_Time_Stage_3 = ...
        norm ( full ( ( inv ( Sparse_Dec_Time { 1, r-2 } ) ) ) )    % = 1 / sqrt (2)
    
end


% When N = 16, ie, r = 4 :
if r-3 > 0          % actually : if r == 4
    check_Stage_4_last_rm3 = full ( Sparse_Dec_Time { 1, r-3 } ) ;
    
    % pause
    
    % Compare with Time-Decimated matrix WDIN    
    WDIN_Eqvt = full ( Sparse_Dec_Time { 1, r-3 } * Sparse_Dec_Time { 1, r-2 } ...
                    *  Sparse_Dec_Time { 1, r-1 } * Sparse_Dec_Time { 1, r } ) ;
    % WDI16 - WDIN_Eqvt  % should give all 0s in the W/s.
    
    % Refer to WDI_Time.m  :  [ WDIN ] = WDI_Time ( N ) ;
    % for notes on how that WD16 can be compared with results of this pgm.

    
    % Q : How will the Sparse Matrices be for the Freq-Decimated case ?
    % A : WDON = WDIN .'  is tested in dft_twiddle_factors_matrices.m
    %     So, WDO8  =  WDI8_1 .'  *  WDI8_2 .'  *  WDI8_3 .'
    WDON_Eqvt = full ( Sparse_Dec_Time { 1, r } .'  ...
                    *  Sparse_Dec_Time { 1, r-1 } .' ...
                    *  Sparse_Dec_Time { 1, r-2 } .' ...
                    *  Sparse_Dec_Time { 1, r-3 } .' ) ;
    % WDO16 - WDON_Eqvt  % should give all 0s in the W/s.

end    % for col = r : -1 : 1

%                                          ++++++

new_N = N ;

%                                   ********************

% Open Q6 in eig_svd_herm_unit_pos_def_2_TEST.m :
% So, from above Sparse Tests 17 to 20, we see that except for
% Sparse_Dec_Time {1} for N = 16 (Test 18), all the other Sparse Matrices
% tested above, including the products Sp_Time_8 for N = 8 (r = 3)
% and Sp_Time_16 for N = 16 (r = 4), and also verified in their Full forms :
% F_Sp_Time_8 and F_Sp_Time_16, are NOT Pos-Def.
% How does one explain this ?
% How could one predict that Sparse_Dec_Time {1} for N = 16 would alone
% be Pos-Def - without going through so many tests ?

%                                   ********************

% Col Ref for 80-char marker :
%      10        20        30        40        50        60        70        80

%                                   ********************
