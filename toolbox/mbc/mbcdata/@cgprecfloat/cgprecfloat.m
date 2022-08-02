function FLOATPREC = cgprecfloat(mbits, ebits, PhysRange, varargin)
%CGPRECFLOAT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:54:52 $

%CGPRECFLOAT/CGPRECFLOAT   Constructor for the cgprecfloat class.
%
%   FLOATPREC = CGPRECFLOAT(mbits, ebits, PhysRange, PREC) constructs a
%   cgprecfloat (signed floating point) object FLOATPREC with mbits bits
%   in the mantissa, ebits bits in the exponent, a range PhysRange of
%   admissible physical values and a parent cgprec object PREC.
%
%   FLOATPREC = CGPRECFLOAT constructs a cgprecfloat object with
%   default properties of mbits = 52, ebits = 11, PhysRange = [-Inf Inf]
%   and a default parent cgprec object (IEEE double precision)
%
%   FLOATPREC = CGPRECFLOAT(str) where str is either 'double' or 'single'
%   creates an IEEE double or single floating point cgprecfloat object.
%
%   FLOATPREC = CGPRECFLOAT(mbits, ebits) constructs a cgprecfloat
%   object with mbits bits in the mantissa, ebits bits in the exponent,
%   default properties of PhysRange = [-Inf Inf] and a default parent
%   cgprec object. 
%
%   FLOATPREC = CGPRECFLOAT(mbits, ebits, PhysRange) constructs a
%   cgprecfloat object with mbits bits in the mantissa, ebits bits in the
%   exponent, a range PhysRange of admissible physical values and a default
%   parent cgprec object.
%
%   FLOATPREC = CGPRECFLOAT(mbits, ebits, PhysRange, Comment) first
%   constructs a cgprec object cgprec(Comment), and then constructs a
%   child cgprecfloat object of this cgprec object with mbits bits in
%   the mantissa, ebits bits in the exponent and a range PhysRange of
%   admissible physical values.
%
%   See also  CGPRECFIX, CGPREC

% ---------------------------------------------------------------------------
% Description : Constructor for the cgprecfloat class.
% Inputs      : mbits     - bits in the mantissa (int)
%               ebits     - bits in the exponent (int)
%               PhysRange - physical range (dbl,1x2)
% Opt inputs  : PREC      - cgprec object
%               Comment   - comment used to construct a cgprec object
%                           (char)
% Outputs     : FLOATPREC - cgprecfloat object
% ---------------------------------------------------------------------------

% Define object structure
FLOATPRECStruct = struct('mbits',[],...
    'ebits',[],...
    'PhysRange',[]);

% Error check on mbits, ebits
if nargin==0
    % mbits, ebits not specified, use the default values
    mbits = 52;
    ebits = 11;
elseif nargin==1
    if ischar(mbits)
        switch mbits
        case 'double'
            mbits = 52; ebits =11;
        case 'single'
            mbits = 23; ebits = 8;
        end
    else
        % Too few input arguments
        error([mfilename ': incorrect arguments']);
    end
elseif nargin>1
    % try to use mbits, ebits if valid
    mbits = i_check(mbits, 'mbits');
    ebits = i_check(ebits, 'ebits');
end % if    
% Error check on PhysRange
if nargin<3
    % PhysRange not specified, use the default value
    PhysRange = i_check([], 'PhysRange');
else
    % Try to use PhysRange if valid
    PhysRange = i_check(PhysRange, 'PhysRange');
end
% Error check on varargin (cgprec object or comment)
if nargin<4
    % Information about cgprec object not specified, use the default value
    PREC = cgprec;
else
    if isa(varargin{1}, 'cgprec')
        % Extra input argument is a cgprec object
        PREC = varargin{1};
    else
        % Try to use extra input as a comment with which to construct a
        % cgprec object if valid
        PREC = cgprec(varargin{1});
    end % if
end

% Assebmle object structure
FLOATPRECStruct.mbits     = mbits;
FLOATPRECStruct.ebits     = ebits;
FLOATPRECStruct.PhysRange = PhysRange;

% Create object class
FLOATPREC = class(FLOATPRECStruct,'cgprecfloat',PREC);

% ---------------------------------------------------------------------------

function out = i_check(in, VarName)

% Check input variables

switch VarName,
case {'mbits','ebits'},
    if isnumeric(in)&isreal(in)&(length(in)==1)
        % mbits, ebits is a real scalar
        if in>=0.5
            % mbits, ebits is valid after rounding
            out = round(in);
        else
            % mbits, ebits must be greater than 1, use default value
            out = 1;
        end % if
    else
        % mbits, ebits is not a real scalar, use default value
        out = 1;
    end % if
case {'PhysRange'},
    if isnumeric(in)&isreal(in)&(size(in,1)==1)&(size(in,2)==2)
        % PhysRange is a real 1x2 array, sort in ascending order
        out = sort(in);
    else
        % PhysRange is not a real 1x2 array, use default value
        out = [-Inf Inf];
    end % if
end % switch