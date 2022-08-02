function LOOKUPFIXPREC = cgpreclookupfix(TablePhysData, TableHWData, ...
    PhysRange, varargin)

%CGPRECLOOKUPFIX/CGPRECLOOKUPFIX   Constructor for the
%   cgpreclookupfix class.
%
%   LOOKUPFIXPREC = CGPRECLOOKUPFIX(TablePhysData, TableHWData, ...
%   PhysRange, FIXPREC) constructs a cgpreclookupfix object LOOKUPFIXPREC
%   with a mapping from physical values to hardware values specified by a
%   lookup table [TablePhysData, TableHWData], a range PhysRange of
%   admissible physical values and a parent cgprecfix object FIXPREC.
%
%   LOOKUPFIXPREC = CGPRECLOOKUPFIX constructs a cgpreclookupfix object
%   with default properties of TablePhysData = [0 1], TableHWData = [0 1],
%   PhysRange = [-Inf Inf] and a default parent cgprecfix object.
%
%   LOOKUPFIXPREC = CGPRECLOOKUPFIX(TablePhysData, TableHWData) constructs
%   a cgpreclookupfix object with a default PhysRange = [-Inf Inf] and a
%   default parent cgprecfix object.
%
%   LOOKUPFIXPREC = CGPRECLOOKUPFIX(TablePhysData, TableHWData, ...
%   PhysRange) constructs a cgpreclookupfix object with a parent
%   cgprecfix object FIXPREC.
%
%   LOOKUPPREC = CGPRECLOOKUPFIX(TablePhysData, TableHWData, ...
%   PhysRange, bits, signed, ptpos, PREC) first constructs a parent
%   cgprecfix object cgprecfix(bits, signed, ptpos, PREC) and then uses
%   this cgprecfix object and to construct a cgpreclookupfix object
%   LOOKUPPREC = CGPRECLOOKUPFIX(TablePhysData, TableHWData, ...
%   PhysRange, bits, signed, ptpos, Name) is similar.
%
%   See also  CGPRECFIX, CGPREC

% ---------------------------------------------------------------------------
% Description : Constructor for the cgpreclookupfix class.
% Inputs      : TablePhysData - physical values column of the lookup table
%                               that defines the mapping between physical
%                               values and hardware values
%               TableHWData   - hardware values column of the lookup table
%                               that defines the mapping between physical
%                               values and hardware values
%               PhysRange     - physical range (dbl,1x2)
% Opt Inputs  : FIXPREC       - cgprecfix object specifying the bits,
%                               un/signed, the fixed point position and the
%                               admissible physical range
%               bits          - bits in the mantissa (int)
%               signed        - sign flag to denote unsigned (0) or signed
%                               (1)
%               ptpos         - fixed point position (int)
%               PREC          - cgprec object
%               Name          - name used to construct a cgprec object
%                               (char)
% Outputs     : LOOKUPFIXPREC - cgpreclookupfix object specifying table
%                               data, interpolation method and the admissible
%                               physical range
% ---------------------------------------------------------------------------

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:55:01 $

% Define object structure
LOOKUPFIXPRECStruct = struct('TablePhysData',[],...
    'TableHWData',[],...
    'PhysRange',[]);

% Error check on TablePhysData, TableHWData
if nargin==0
    % TablePhysData, TableHWData not specified, use the default values
    TablePhysData = i_check([], 'TablePhysData');
    TableHWData   = i_check([], 'TableHWData');
elseif nargin==1
    % Too few input arguments
    error([mfilename ': too few input arguments']);
elseif nargin>1
    % try to use TablePhysData, TableHWData if valid
    TablePhysData = i_check(TablePhysData, 'TablePhysData');
    TableHWData   = i_check(TableHWData, 'TableHWData');
    if ~all(size(TablePhysData)==size(TableHWData))
        error([mfilename ': sizes of TablePhysData and TableHWData are incompatible'])
    end % if
end % if    
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
LOOKUPFIXPRECStruct.TablePhysData = TablePhysData;
LOOKUPFIXPRECStruct.TableHWData   = TableHWData;
LOOKUPFIXPRECStruct.PhysRange     = PhysRange;

% Create object class
LOOKUPFIXPREC = class(LOOKUPFIXPRECStruct,'cgpreclookupfix',FIXPREC);

% ---------------------------------------------------------------------------

function out = i_check(in, VarName)

% Check input variables

switch VarName,
case {'TablePhysData','TableHWData'},
    if ~isnumeric(in)
        % TablePhysData, TableHWData is nonnumeric
        error([mfilename ': nonnumeric ' VarName]);
    elseif ~isreal(in)
        % TablePhysData, TableHWData is not real
        error([mfilename ': ' VarName ' must be real']);
    elseif length(in)<=1
        % TablePhysData, TableHWData is too small, use default value
        out = [0 1];
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