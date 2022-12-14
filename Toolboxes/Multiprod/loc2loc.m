function bP = loc2loc(aP, gOa, gRa, gOb, gRb, dim) 
%LOC2LOC  Transformation from a local reference system to another.
%   bP = LOC2LOC(aP, gOa,gRa, gOb,GRb) is equivalent to
%   bP = LOC2LOC(aP, gOa,gRa, gOb,GRb, DIM), where DIM is the first
%   dimension of length 3 in arrays aP, gOa, gRa, gOb, GRb.
%
%   bP = LOC2LOC(aP, gOa,gRa, gOb,GRb, DIM) is an array of vectors
%   representing the position of a point P in local reference system B,
%   computed by transforming the array of vectors aP. Arrays aP, bP, gOa,
%   and gOb must have the same size S. The size of gRa and gRb, if the
%   length of their dimension DIM + 1 is not considered, must be equal to
%   S. For instance, if aP is M-by-3 and DIM = 2, gRa must be M-by-3-by-3.
%
%   aP    Position(s) of point P in local reference system A.
%   gOa   Position(s) of the origin of A in the global reference system.
%   gRa   Orientation(s)            of A in the global reference system.
%   gOb   Position(s) of the origin of B in the global reference system.
%   gRb   Orientation(s)            of B in the global reference system.
%   DIM   The dimension along which positnion vectors are contained in 
%         arrays aP, bP, gOa, gOb.
%
%   Array     Dimensions (*)     Containing              Along dimension(s)
%   -----------------------------------------------------------------------
%   aP, bP         N             3-D position vectors           DIM
%   gOa, gOb       N             3-D position vectors           DIM
%   gRa, gRb     N + 1        3-by-3 orient. matrices       DIM and DIM + 1
%   -----------------------------------------------------------------------
%   (*) N is the number of dimensions in aP, bP, gOa, gOb. If they are
%       3-by-1 arrays, they are treated as 1-D arrays (N = 1 is assumed, 
%       DIM = 1 is required), and gRa and gRb must be single 3-by-3 
%       orientation matrices. 
%
%   See also REFSYS, MULTIPROD, MULTITRANSP.

% $ Version: 1.0 $
% CODE      by:                 Paolo de Leva (IUSM, Rome, IT) 2005 Oct 8
% COMMENTS  by:                 Code author                    2005 Oct 8
% OUTPUT    tested by:          Code author                    2005 Oct 8
% -------------------------------------------------------------------------

% In GRF
gBA = -gOb + gOa;

% Transformation from GRF to B
bRg = multitransp(gRb, dim);
bA  = multiprod(bRg, gBA, [dim dim+1], [dim]); % Rotation

% Transformation from A to B
bRa = multiprod(bRg, gRa, [dim dim+1]); % Concatenating rotations
bAP = multiprod(bRa, aP,  [dim dim+1], [dim]); % Rotation

% In B
bP = bA + bAP;
