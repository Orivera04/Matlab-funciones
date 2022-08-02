function FIXPREC = cgprecfix(bits, signed, ptpos, varargin)
%CGPRECFIX

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:54:44 $

%CGPRECFIX/CGPRECFIX   Constructor for the cgprecfix class.
%
%   FIXPREC = CGPRECFIX(bits, signed, ptpos, PREC) constructs a
%   cgprecfix (fixed point) object FIXPREC with size bits, fixed point
%   position ptpos (measured positive to the left) and a parent cgprec
%   object PREC. The value of signed denotes whether the values are unsigned
%   (0) or signed (1).  The constructor then calculates additional
%   properties: the achievable hardware resolution HWResolution and hardware
%   range HWRange.  The cgprecfix object can be used as the parent of a
%   cgprecpolyfix or cgpreclookupfix object.
%
%   FIXPREC = CGPRECFIX constructs a cgprecfix object with default
%   properties of bits = 1, signed = 0, ptpos = 0, PhysRange = [-Inf Inf]
%   and a default parent cgprec object.
%
%   FIXPREC = CGPRECFIX(bits, signed, ptpos) constructs a cgprecfix
%   object with size bits, sign flag signed, fixed point position ptpos,
%   default properties of PhysRange = [-Inf Inf] and a default parent
%   cgprec object.
%
%   FIXPREC = CGPRECFIX(bits, signed, ptpos, Name) first
%   constructs a cgprec object cgprec(Name), and then constructs a
%   child cgprecfix object of this cgprec object with size bits, sign
%   flag signed and fixed point position ptpos.
%
%   See also  CGPRECFLOAT, CGPREC

% ---------------------------------------------------------------------------
% Description : Constructor for the cgprecfix class.
% Inputs      : bits      - bits in the mantissa (int)
%               signed    - sign flag to denote unsigned (0) or signed (1)
%               ptpos     - fixed point position (int)
% Opt inputs  : PREC      - cgprec object
%               Name      - name used to construct a cgprec object
%                           (char)
% Outputs     : FIXPREC   - cgprecfix object
% ---------------------------------------------------------------------------

% Define object structure
FIXPRECStruct = struct('bits',[],...
    'signed',[],...
    'ptpos',[],...
    'HWResolution',[],...
    'HWRange',[]);

% Error check on bits, signed, ptpos
if nargin==0
    % bits, signed, ptpos not specified, use the default values
    bits   = i_check([], 'bits');
    signed = i_check([], 'signed');
    ptpos  = i_check([], 'ptpos');
elseif (nargin==1)|(nargin==2)
    % Too few input arguments
    error([mfilename ': too few input arguments']);
elseif nargin>2
    % try to use bits, signed, ptpos if valid
    bits   = i_check(bits, 'bits');
    signed = i_check(signed, 'signed');
    ptpos  = i_check(ptpos, 'ptpos');
end % if    
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
FIXPRECStruct.bits         = bits;
FIXPRECStruct.signed       = signed;
FIXPRECStruct.ptpos        = ptpos;
FIXPRECStruct.HWResolution = 1/(2^ptpos);
if signed==0
    % unsigned
    FIXPRECStruct.HWRange = [0 2^bits-1]/(2^ptpos);
else
    % signed
    FIXPRECStruct.HWRange = [1-2^(bits-1) 2^(bits-1)]/(2^ptpos);
end

% Create object class
FIXPREC = class(FIXPRECStruct,'cgprecfix',PREC);

% ---------------------------------------------------------------------------

function out = i_check(in, VarName)

% Check input variables

switch VarName,
case 'bits',
    if isnumeric(in)&isreal(in)&(length(in)==1)
        % bits is a real scalar
        if in>=0.5
            % bits is valid after rounding
            out = round(in);
        else
            % bits must be greater than 1, use default value
            out = 32;
        end % if
    else
        out = 32;
    end % if
case 'signed',
    if isnumeric(in)&isreal(in)&(length(in)==1)
        % signed is a real scalar
        if in>=0
            % signed is valid after rounding
            out = sign(in);
        else
            % signed must be greater than 1, use default value
            out = 0;
        end % if
    else
        % signed is not a real scalar, use default value
        out = 1;
    end % if
case 'ptpos',
    if isnumeric(in)&isreal(in)&(length(in)==1)
        % ptpos is a real scalar and is valid after rounding
        out = round(in);
    else
        % ptpos is not a real scalar, use default value
        out = 0;
    end % if
end % switch