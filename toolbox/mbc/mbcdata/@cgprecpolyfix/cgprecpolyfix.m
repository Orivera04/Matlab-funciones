function POLYFIXPREC = cgprecpolyfix(NumCoeff, DenCoeff, PhysRange, ...
    varargin)

%CGPRECPOLYFIX/CGPRECPOLYFIX   Constructor for the
%   cgprecpolyfix class.
%
%   POLYFIXPREC = CGPRECPOLYFIX(NumCoeff, DenCoeff, PhysRange, FIXPREC)
%   constructs a cgprecpolyfix object POLYFIXPREC with a mapping from
%   physical values to hardware values specified by a ratio of polynomials
%   with coefficients NumCoeff (numerator) and DenCoeff (denominator), a
%   range PhysRange of admissible physical values and a parent cgprecfix
%   object FIXPREC.
%
%   POLYFIXPREC = CGPRECPOLYFIX constructs a cgprecpolyfix object
%   with default properties of NumCoeff = 1, DenCoeff = 1, PhysRange =
%   [-Inf Inf] and a default parent cgprecfix object.
%
%   POLYFIXPRC = CGPRECPOLYFIX(NumCoeff, DenCoeff) constructs a
%   cgprecpolyfix object with a default PhysRange = [-Inf Inf] and a
%   default parent cgprecfix object.
%
%   POLYFIXPREC = CGPRECPOLYFIX(NumCoeff, DenCoeff, PhysRange) constructs
%   a cgprecpolyfix object with a parent cgprecfix object FIXPREC.
%
%   POLYFIXPREC = CGPRECPOLYFIX(NumCoeff, DenCoeff, PhysRange, bits, ...
%   signed, ptpos, PREC) first constructs a parent cgprecfix object
%   cgprecfix(bits, signed, ptpos, PREC) and then uses this cgprecfix
%   object and to construct a cgprecpolyfix object.  POLYFIXPREC = ...
%   CGPRECPOLYFIX(NumCoeff, DenCoeff, PhysRange, bits, signed, ptpos, ...
%   Name) is similar.
%
%   See also  CGPRECFIX, CGPREC

% ---------------------------------------------------------------------------
% Description : Constructor for the cgprecpolyfix class.
% Inputs      : NumCoeff    - numerator coefficients for the ratio of
%                             polynomials that defines the mapping between
%                             physical values and hardware values
%               DenCoeff    - denominator coefficients for the ratio of
%                             polynomials that defines the mapping between
%                             physical values and hardware values
%               PhysRange   - physical range (dbl,1x2)
% Opt Inputs  : FIXPREC     - cgprecfix object specifying the bits,
%                             un/signed, the fixed point position and the
%                             admissible physical range
%               bits        - bits in the mantissa (int)
%               signed      - sign flag to denote unsigned (0) or signed (1)
%               ptpos       - fixed point position (int)
%               PREC        - cgprec object
%               Name        - name used to construct a cgprec object
%                             (char)
% Outputs     : POLYFIXPREC - cgprecpolyfix object specifying physical to
%                             hardware mapping function
% ---------------------------------------------------------------------------

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:55:09 $

% Define object structure
POLYFIXPRECStruct = struct('NumCoeff',[],...
    'DenCoeff',[],...
    'PhysRange',[]);

% Error check on NumCoeff, DenCoeff
if nargin==0
    % NumCoeff, DenCoeff not specified, use the default values
    NumCoeff = [1 0];
    DenCoeff = [0 1];
elseif (nargin==1)
    % Too few input arguments
    error([mfilename ': too few input arguments']);
elseif nargin>1
    % try to use NumCoeff, TableHWData if valid
    NumCoeff = i_check(NumCoeff, 'NumCoeff');
    DenCoeff = i_check(DenCoeff, 'DenCoeff');
end % if    
% Force NumCoeff, DenCoeff to be the same length by adding leading zeros
NumCoeff = [zeros(1,length(DenCoeff)-length(NumCoeff)), NumCoeff];
DenCoeff = [zeros(1,length(NumCoeff)-length(DenCoeff)), DenCoeff];
% Error check on PhysRange
if nargin<=2
    % PhysRange not specified, use the default value
    PhysRange = i_check([], 'PhysRange');
elseif nargin>2
    % try to use PhysRange if valid
    PhysRange = i_check(PhysRange, 'PhysRange');
end % if    
% Error check on varargin (bits, signed, ptpos, cgprec object or comment)
if nargin<4
    % There are no extra inputs, construct a default cgprecfix object
    FIXPREC = cgprecfix;
elseif nargin==4
    if isa(varargin{1}, 'cgprecfix')
        % There is one extra input that is a cgprecfix object
        FIXPREC = varargin{1};
    else
        % The extra input is not a valid cgprecfix object
        error([mfilename ': FIXPREC is not of type cgprecfix']);
    end % if
elseif nargin==6
    % There are three extra inputs that are bits, signed and ptpos.
    % Construct a cgprecfix object using cgprecfix constructor with the
    % extra arguments varargin as the constructor inputs.  Note that
    % cgprecfix and cgprec have built-in error checking.
    FIXPREC = cgprecfix(varargin{1},varargin{2},varargin{3});
else
    % There are four extra inputs that are bits, signed, ptpos and PREC/Name.
    % Construct a cgprecfix object using cgprecfix constructor with the
    % extra arguments varargin as the constructor inputs.  Note that
    % cgprecfix and cgprec have built-in error checking.
    FIXPREC = cgprecfix(varargin{1},varargin{2},varargin{3},varargin{4});
end % if

% Assebmle object structure
POLYFIXPRECStruct.NumCoeff  = NumCoeff;
POLYFIXPRECStruct.DenCoeff  = DenCoeff;
POLYFIXPRECStruct.PhysRange = PhysRange;

% Create object class
POLYFIXPREC = class(POLYFIXPRECStruct,'cgprecpolyfix',FIXPREC);

% ---------------------------------------------------------------------------

function out = i_check(in, VarName)

% Check input variables

switch VarName,
case {'NumCoeff','DenCoeff'}
    if ~isnumeric(in)
        % NumCoeff, DenCoeff is nonnumeric
        error([mfilename ': nonnumeric ' VarName]);
    elseif ~isreal(in)
        % NumCoeff, DenCoeff is not real
        error([mfilename ': ' VarName ' must be real']);
    elseif size(in,1)~=1
        % NumCoeff, DenCoeff must be a row vector
        out = 1;
    else
        % TablePhysData, TableHWData is valid
        out = in;
    end % if
case 'PhysRange',
    if isnumeric(in)&isreal(in)&(size(in,1)==1)&(size(in,2)==2)
        % PhysRange is a real 1x2 array, sort in ascending order
        out = sort(in);
    else
        % PhysRange is not a real 1x2 array, use default value
        out = [-Inf Inf];
    end % if
end % switch