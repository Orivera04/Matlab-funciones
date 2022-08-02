function c = multiprod(a, b, rcA, rcB)
%MULTIPROD  Multiplying 1-D or 2-D subarrays contained in two N-D arrays.
%   C = MULTIPROD(A,B) is equivalent  to C = MULTIPROD(A,B,[1 2],[1 2])
%   C = MULTIPROD(A,B,[D1 D2]) is eq. to C = MULTIPROD(A,B,[D1 D2],[D1 D2])
%   C = MULTIPROD(A,B,D1) is equival. to C = MULTIPROD(A,B,D1,D1)
%
%   1) MATRICES BY MATRICES (2-D by 2-D arrays) (*).
%      If SIZE(A) == 2 and SIZE(B) == 2,
%         C = MULTIPROD(A, B, [1 2], [1 2]) is equivalent to C = A * B.
%      When both A and B have N dimensions ("), with N >= 2,
%         C = MULTIPROD(A, B, [D1 D2], [D1 D2]) has N dimensions and 
%         contains the products of the matrices in A by those in B:
%         A (N-D) contains  P-by-Q  matrices along dimensions D1 and D2,
%         B (N-D) contains  R-by-S  matrices along dimensions D1 and D2,
%         C (N-D) contains  P-by-S  matrices along dimensions D1 and D2.
%         Vector inner (1b) or outer (1c) products are performed if P=S=1
%         or Q=R=1, and products involving scalars (1d) if P=Q=1 or R=S=1
%         or P=Q=R=S=1. In the latter case, C = A .* B. (°)
%
%   2) MATRICES BY 1-D ARRAYS (2-D by 1-D arrays) (*).
%      When A has N + 1 ("), and B has N dimensions ('), with N >= 1,
%         C = MULTIPROD(A, B, [D1 D2], D1) contains the products of the
%         matrices contained in A by the 1-D arrays contained in B (°):
%         Array   Dimensions    Size of subarray     Contained along
%         -------------------------------------------------------------
%         A          N + 1       P-by-Q  (2-D)      dimensions D1 & D2
%         B            N           R     (1-D)      dimension  D1
%         C (a)        N           P     (1-D)      dimension  D1
%         C (b)      N + 1       P-by-Q  (2-D)      dimensions D1 & D2
%         -------------------------------------------------------------
%         (a) If the subarrays in B are not scalars (size: R > 1), C has
%             N dimensions. In this case, the 1-D subarrays in B and C are
%             meant to represent column matrices, and Q = R is required.
%         (b) If the subarrays in B are scalars (size: R = 1), C has N + 1
%             dimensions, and Q = R is not required.
%           
%   3) 1-D ARRAYS BY MATRICES (1-D by 2-D arrays). (*)
%      When A has N ('), and B has N + 1 dimensions ("), with N >= 1: 
%         C = MULTIPROD(A, B, D1, [D1 D2]) contains the products of the 
%         1-D arrays contained in A by the matrices contained in B (°):
%         Array   Dimensions    Size of subarray      Contained along
%         -------------------------------------------------------------
%         A            N            Q    (1-D)      dimension  D1
%         B          N + 1       R-by-S  (2-D)      dimensions D1 & D2
%         C (a)        N            S    (1-D)      dimension  D1
%         C (b)      N + 1       R-by-S  (2-D)      dimensions D1 & D2
%         -------------------------------------------------------------
%         (a) If the subarrays in A are not scalars (size: Q > 1), C has 
%             N dimensions. In this case, the 1-D subarrays in A and C are
%             meant to represent row matrices, and Q = R is required.
%         (b) If the subarrays in A are scalars (size: Q = 1), C has N + 1
%             dimensions, and Q = R is not required.
%
%   4) 1-D ARRAYS BY 1-D ARRAYS. (*)
%      Without limitations on the length of A and B along dimension D1:
%         a) C = MULTIPROD(A, B, [D1 0], [0 D1]) returns outer products
%            along dimension D1 of A and B, and is equivalent to 
%            C = OUTER(A, B, D1). If A and B have N dimensions ('), C has
%            N + 1 dimensions ("). See function OUTER for details. (°)
%      When A and B have the same size and any length along dimension D1:
%         b) C = MULTIPROD(A, B, [0 D1], [D1 0]) returns inner (dot)
%            products along dimension D1 of A and B, and is equivalent to
%            C = DOT(A, B, D1). See function DOT for details. (°)
%         c) C = MULTIPROD(A, B, D1, D1) is equivalent to the above syntax
%            (4b).
%      When either A or B has (or both have) length 1 along dimension D1:
%         d) C = MULTIPROD(A, B, D1, D1) returns products of scalars by 
%            N-element vectors (N > 1), or N-element vectors by scalars
%            or scalars by scalars along dimension D1 of A and B. (°)
%      When A and B have the same size, and length 3 along dimension D1:
%         e) C = CROSS(A, B, D1) can be used to perform cross products
%            along dimension D1 of A and B. See function CROSS for details.
%
%   MULTIPROD is a generalization for N-D arrays of MTIMES and the matrix
%   multiplication operator ("*").
%
%   Notes: 
%   (*) N-D arrays can be called SCALARS if all their dimensions have
%       length 1 (1-by-1-by-1), or VECTORS if they have at most one
%       non-singleton dimension (1-by-1-by-P), or MATRICES if N > 1 and
%       they have at most two non-singleton dimensions (1-by-P-by-Q).
%       Some matrices are also vectors and/or scalars, and some vectors are
%       scalars. E.g., 1-by-1 arrays are scalars, vectors and matrices.
%   (") Including trailing singletons up to dimension D2, if they exist.
%   (') Including trailing singletons up to dimension D1, if they exist,
%       and excluding the second dimension in P-by-1 arrays, if D1 = 1. 
%       For instance, with D1 = 1, P-by-1 arrays (column matrices) are 
%       treated as 1-D, with D1 = 2 as 2-D, ...
%   (°) COMMON CONSTRAINTS FOR ALL SYNTAXES (EXCEPT FOR 4e)
%          Products involving 2-D and/or 1-D scalars (1-by-1 matrices or 
%          1-element 1-D arrays) are allowed. Scalars may multiply 1-D or 
%          2-D arrays of any size, except for syntax 4b (in this case, A 
%          and B must have the same size). When scalars are not involved, 
%          the "inner dimensions" must have the same length (Q = R for 
%          syntaxes 1, 2, 3; for 4a, 4b, 4c see functions DOT and OUTER).
%          D1 is allowed to be larger than NDIMS(A) and/or NDIMS(B). 
%          A and B must have the same lengths along all dimensions except
%          for those containing the specified matrices (D1 and D2) or 
%          vectors (D1), unless otherwise specified (syntax 4b).
%          D2 = D1 + 1 is required.  
%
%   Examples:
%       A 5-by-6-by-3-by-2 array may be considered to be a block array
%       containing ten 6-by-3 matrices along dimensions 2 and 3. In this
%       case, its size is so indicated:  5-by-(6-by-3)-by-2 or 5x(6x3)x2.
%
%   1a) If  A is .................... a 5x(6x3)x2 array,
%       and B is .................... a 5x(3x4)x2 array,
%       C = MULTIPROD(A, B, [2 3]) is a 5x(6x4)x2 array.
%
%   1b) If  A is .................... a 5x(1x3)x2 array,
%       and B is .................... a 5x(3x1)x2 array,
%       C = MULTIPROD(A, B, [2 3]) is a 5x(1x1)x2 array, while
%   1c) C = MULTIPROD(B, A, [2 3]) is a 5x(3x3)x2 array.
%
%   1d) If  A is .................... a 5x(6x3)x2 array,
%       and B is .................... a 5x(1x1)x2 array,
%       C = MULTIPROD(A, B, [2 3]) is a 5x(6x3)x2 array.
%
%   2a) If  A is ......................... a 5x(6x3)x2 4-D array,
%       and B is ......................... a 5x(3)x2   3-D array,
%       C = MULTIPROD(A, B, [2 3], [2]) is a 5x(6)x2   3-D array.
%
%   2b) If  A is ......................... a 5x(6x3)x2 4-D array,
%       and B is ......................... a 5x(1)x2   3-D array,
%       C = MULTIPROD(A, B, [2 3], [2]) is a 5x(6x3)x2 4-D array.
%
%   4a) If both A and B are .................. 5x(6)x2   3-D arrays,
%       C = MULTIPROD(A, B, [2 0], [0 2]) is a 5x(6x6)x2 4-D array, while
%   4c) C = MULTIPROD(A, B, 2) is .......... a 5x(1)x2   3-D array.
%
%   See also DOT, OUTER, CROSS, CROSSDIV, MULTITRANSP.

% $ Version: 1.1 $
% CODE      by:                 Paolo de Leva (IUSM, Rome, IT) 2005 Sep 15
%           speed-optimized by: Code author                    2005 Sep 27
% COMMENTS  by:                 Code author                    2005 Sep 15
% OUTPUT    tested by:          Code author                    2005 Sep 27
% -------------------------------------------------------------------------

% Setting RCA and/or RCB if not supplied
if nargin == 2, rcA = [1 2]; rcB = [1 2]; end
if nargin == 3, rcB = rcA; end

% ESC 1 - Special simple case 1a, solved using C = A * B
ndimsA = ndims(a); 
ndimsB = ndims(b);
if ndimsA==2 && ndimsB==2 && isequal(rcA,[1 2]) && isequal(rcB,[1 2])
    c = a * b; return
end

% Checking and evaluating the values of RCA and RCB
siz0A = size(a); % Sizes will be modified later
siz0B = size(b);
[d1, d2, dotOK, addtoA, addtoB, delfromC] = evalRC(rcA, rcB, siz0A, siz0B);

% ESC 2 - Special simple case 4a/b, solved using C = DOT(A, B, D1)
if dotOK
    c = dot(a, b, d1); return
end

% MAIN 1 - Adjusting number of dimensions
%          Both A and B will now become arrays of 2-D matrices
if addtoA(1), a = addsingleton(a, d1); end % Row    or 1x1 matrices in A
if addtoA(2), a = addsingleton(a, d2); end % Column or 1x1 matrices in A
if addtoB(1), b = addsingleton(b, d1); end % Row    or 1x1 matrices in B
if addtoB(2), b = addsingleton(b, d2); end % Column or 1x1 matrices in B
ndimsA = ndims(a); % NOTE - Since trailing singletons are removed,
ndimsB = ndims(b); %        not always NDIMSB = NDIMSA

% MAIN 2 - Computing and checking adjusted sizes (see notes ' and ")
%          The lengths of SIZA and SIZB must be equal to or greater than D2
NsA = d2 - ndimsA; % Number of added trailing singletons
NsB = d2 - ndimsB;
sizA = [size(a) ones(1,NsA)];
sizB = [size(b) ones(1,NsB)];
sA = sizA([1:d1-1, d2+1:end]); % Removing size along dimensions D1 and D2
sB = sizB([1:d1-1, d2+1:end]);
if ~isequal(sA, sB)
   error('MULTIPROD:InputSizeMismatch', ...
        ['A and B must have the same lengths along all dimensions \n' ...
         'except for those containing the matrices or 1-D arrays']);
end
scalarsinA = ( sizA(d1)==1 & sizA(d2)==1 );
scalarsinB = ( sizB(d1)==1 & sizB(d2)==1 );
if sizA(d2)~=sizB(d1) && ~scalarsinA && ~scalarsinB
   error('MULTIPROD:InnerDimensionsMismatch', ...
         'Inner matrix dimensions must agree.');
end

% MAIN 3 - Performing products
if scalarsinA & scalarsinB % 1x1 MATRICES in A and B
    c = a .* b;
elseif scalarsinA % 1x1 MATRICES in A
    % B * A
    c = mbys(b, a, d1);
elseif scalarsinB % 1x1 MATRICES in B
    % A * B
    c = mbys(a, b, d1);
elseif sizB(d2) == 1 % COLUMN (Rx1) MATRICES in B (preferred)
    % A * B
    c = mbyv(a, b, d1);
elseif sizA(d1) == 1 % ROW (1xQ) MATRICES in A (less efficient)
    % C = (B' * A')'
    a = multitransp(a, d1);
    b = multitransp(b, d1);
    c = mbyv(b, a, d1);
    c = multitransp(c, d1);
else % Px1 IN A and 1xS IN B (outer product) or
     % PxQ IN A and RxS IN B (multiple rows and columns; least efficient)
       % Initializing C (Empty matrix, same size as A but zero "columns")
         sizC = sizA;
         sizC(d2) = 0;
         c = rand(sizC);
       % Vectorized indices for B (cell array)
         for d = length(sizB):-1:1
            indices{d} = 1:sizB(d);
         end
       % Building C, column by column (same number of "columns" as B")
         NcolsC = sizB(d2); % 
         for Ncol = 1:NcolsC
            indices{d2} = Ncol;
            column = mbyv(a, b(indices{:}), d1);
            c = cat(d2, c, column);
         end
end

% MAIN 4 - If required, C is turned into an array of vectors (1-D arrays)
if     delfromC(1), c = delsingleton(c, d1); 
elseif delfromC(2), c = delsingleton(c, d2);
end



%--------------------------------------------------------------------------
function c = mbys(a, b, dim)
%MBYS   Products of matrices in A by 1-by-1 matrices in B 
%
%   C = MBYS(A, B, DIM) is an N-D array containing the products of the M
%   matrices contained in A by the M 1-by-1 matrices ("scalars") contained
%   in B. P-by-Q matrices in A, 1-by-1 matrices in B, and P-by-Q matrices
%   in C are constructed along dimensions DIM and DIM+1. A and B must have
%   the same mumber of dimensions (N), and the same lengths in all
%   dimensions except for DIM and DIM+1. SIZE(B,DIM)=SIZE(B,DIM+1)=1 is
%   required.
%
%   Example:
%      If  A is ........... a 5x(6x3)x2 array containing ten 6x3 matrices,
%      and B is ........... a 5x(1x1)x2 array containing ten 1x1 matrices,
%      C = MBYS(A, B, 2) is a 5x(6x3)x2 array containing ten 6x3 matrices,
%      constructed along dimensions DIM and DIM+1, obtained by multiplying
%      the matrices in A by those in B.

% 1 - Cloning B P-by-Q times along its singleton dimensions DIM and DIM+1. 
%        Optimized code for B2 = REPMAT(B, [ONES(1,DIM-1), P, Q]).
%        INDICES is a cell array containing vectorized indices.
P = size(a, dim);
Q = size(a, dim+1);
siz = size(b);
siz = [siz ones(1,dim+1-length(siz))]; % Ones are added if DIM+1 > NDIMS(B)
for d = length(siz):-1:1
    indices{d} = 1:siz(d);
end
indices{dim} = ones(1, P);   % "Cloned" index for dimension DIM
indices{dim+1} = ones(1, Q); % ...and DIM +1
b2 = b(indices{:});          % B2 has same size as A

% 2 - Performing products
c = a .* b2;



%--------------------------------------------------------------------------
function c = mbyv(a, b, dim)
%MBYV   Products of matrices in A by column matrices in B 
%
%   C = MBYV(A, B, DIM) is an N-D array containing the products of the M
%   matrices contained in A by the M column matrices ("vectors") contained
%   in B. P-by-Q matrices in A, Q-by-1 matrices in B, and Q-by-1 matrices
%   in C are constructed along dimensions DIM and DIM+1. A and B must have
%   the same mumber of dimensions (N), and the same lengths in all
%   dimensions except for DIM and DIM+1. Inner matrix dimensions (Q) must
%   agree, and Q>1 is required.
%
%   Example:
%      If  A is ........... a 5x6x3x2 array containing ten 6x3 matrices,
%      and B is ........... a 5x3x1x2 array containing ten 3x1 matrices,
%      C = MBYV(A, B, 2) is a 5x6x1x2 array containing ten 6x1 matrices,
%      constructed along dimensions DIM and DIM+1, obtained by multiplying
%      the matrices in A by those in B.

% 1 - Transposing: Qx1 matrices in B become 1xQ matrices
order = [1:dim-1, dim+1, dim, dim+2:ndims(b)];
b = permute(b, order);

% 2 - Cloning B P times along its singleton dimension DIM.
%        Optimized code for B2 = REPMAT(B, [ONES(1,DIM-1), P]).
%        INDICES is a cell array containing vectorized indices.
P = size(a, dim);
siz = size(b);
siz = [siz ones(1,dim-length(siz))]; % Ones are added if DIM > NDIMS(B)
for d = length(siz):-1:1
    indices{d} = 1:siz(d);
end
indices{dim} = ones(1, P); % "Cloned" index for dimension DIM
b2 = b(indices{:});        % B2 has same size as A

% 3 - Performing dot products along dimension DIM+1
c = dot(a, b2, dim+1);



%--------------------------------------------------------------------------
function b = addsingleton(a, newdim)
%ADDSINGLETON   Adding a singleton dimension to an array.
%   Example:
%      If A is ................. a 5x9x3   array,
%      B = ADDSINGLETON(A, 3) is a 5x9x1x3 array,

if newdim <= ndims(a)
    sizA = size(a);
    sizB = [sizA(1:newdim-1), 1, sizA(newdim:end)];
    b = reshape(a, sizB);
else 
    b = a;
end



%--------------------------------------------------------------------------
function b = delsingleton(a, dim)
%DELSINGLETON   Removing a singleton dimension from an array.
%   Example:
%      If A is ................. a 5x9x1x3 array,
%      B = DELSINGLETON(A, 3) is a 5x9x3   array.

if dim < ndims(a)
    sizA = size(a);
    % Vector SIZB must have at least 2 elements
    sizB = [sizA(1:dim-1), sizA(dim+1:end), 1];
    b = reshape(a, sizB);
else 
    b = a;
end



%--------------------------------------------------------------------------
function  [d1,d2,dotOK,addtoA,addtoB,delfromC] = evalRC(rcA,rcB,sizA,sizB)
%EVALRC   Evaluation of dimension arguments RCA and RCB
%   Possible values for RCA and RCB:
%      [D1 D2], [D1 D2]
%      [D1 D2], [D1]
%      [D1],    [D1 D2]
%      [D1],    [D1]
%      [D1 0],  [0 D1]
%      [0 D1],  [D1 0]

dotOK = false;            % Is C = DOT(A,B,D1) applyable?
addtoA   = [false false]; % Needed to add singletons to A, in D1 and D2?
addtoB   = [false false]; % Needed to add singletons to B, in D1 and D2?
delfromC = [false false]; % Needed to del singletons from C, in D1 and D2?
nA = numel(rcA);
nB = numel(rcB);

% Checking for gross input errors
if nA>2 || nB>2 || isempty(rcA) || isempty(rcB)...
    || rcA(1)<0 || rcB(1)<0 || mod(rcA(1),1)~=0 || mod(rcB(1),1)~=0
    error('MULTIPROD:InvalidDimensionArgument', ...
          ['Dimension arguments, if supplied, must contain one (D1)\n', ...
          'or two (D1 and D2) positive (or equal to zero) integers.']);
end

% 4a/b) SYNTAXES CONTAINING ZEROS (VECTOR INNER ANS OUTER PRODUCTS)
if any(rcA==0) | any(rcB==0)
    % Inner products: C = MULTIPROD(A, B, [0 D1], [D1 0])
    if nA==2 & nB==2 ...
        & rcA(1)==0 & rcA(2) >0 ...
        & rcB(1) >0 & rcB(2)==0
            checkRC = [rcA(2), rcA(2)+1; rcB(1), rcB(1)+1];
            dotOK = true;
    % Outer products: C = MULTIPROD(A, B, [D1 0] [0 D1]) 
    % NOTE: Outer matrix dimensions are allowed to disagree
    elseif nA==2 & nB==2 ...
        & rcA(1) >0 & rcA(2)==0 ...
        & rcB(1)==0 & rcB(2) >0
            checkRC = [rcA(1), rcA(1)+1; rcB(2), rcB(2)+1];
            addtoA   = [false  true]; % Become column or 1x1 matrices
            addtoB   = [true  false]; % Become row    or 1x1 matrices
            delfromC = [false false]; % OK matrices
    else
        error('MULTIPROD:InvalidDimensionArgument', ...
            ['Misused zeros in the third or fourth input argument\n', ...
            '(see help heads 4b and 4c)']);
    end
        
% 1) 2-D ARRAYS BY 2-D ARRAYS: C = MULTIPROD(A, B, [D1 D2], [D1 D2])
elseif nA==2 & nB==2
    checkRC = [rcA; rcB];
    
% 2) 2-D ARRAYS BY 1-D ARRAYS: C = MULTIPROD(A, B, [D1 D2], [D1])
elseif nA==2 & nB==1
    checkRC = [rcA; rcB, rcB+1];
    addtoA   = [false false];
    addtoB   = [false  true]; % Become column or 1x1 matrices
    d1 = rcB;
    if d1>length(sizB) || sizB(d1)==1 % Scalars in B
        delfromC = [false  false];    % OK matrices in C
    else                              % Non-scalars in B
        delfromC = [false  true];     % Become 1-D in C
    end

% 3) 1-D ARRAYS BY 2-D ARRAYS: C = MULTIPROD(A, B, [D1], [D1 D2])
elseif nA==1 & nB==2
    checkRC = [rcA, rcA+1; rcB];
    addtoA   = [true  false]; % Become row or 1x1 matrices
    addtoB   = [false false];
    d1 = rcA;
    if d1>length(sizA) || sizA(d1)==1 % Scalars in A
        delfromC = [false  false];    % OK matrices in C
    else                              % Non-scalars in A
        delfromC = [true  false];     % Become 1-D in C
    end
    
% 4c/d) 1-D ARRAYS BY 1-D ARRAYS: C = MULTIPROD(A, B, [D1], [D1])
elseif nA==1 & nB==1
    checkRC = [rcA, rcA+1; rcB, rcB+1];
    % Products involving scalars 
    d1 = rcA;
    if d1>length(sizA) || sizA(d1)==1 || ...
       d1>length(sizB) || sizB(d1)==1
           addtoA   = [true false]; % Become column or 1x1 matrices
           addtoB   = [true false]; % Become column or 1x1 matrices
           delfromC = [true false]; % Become 1-D
    % Non-scalars by non-scalars
    else
       dotOK = true;
    end
end
   
% Extracting and checking D1 and D2
d1 = checkRC(1,1);
d2 = checkRC(1,2);
if checkRC(2,1) ~= d1
   error('MULTIPROD:InvalidDimensionArgument', ...
       'D1 in the fourth input argument must be equal to D1 in the third');
elseif d2~=(d1+1) || checkRC(2,2)~=(d1+1) 
   error('MULTIPROD:InvalidDimensionArgument', ...
       'Dimension argument(s) D2 must be equal to D1+1');
end
