function out = get(N, property);
% cgnormaliser\get
%	get(n)	returns list of properties
%  val=get(n,'property') returns the value of the named property of the object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:13:52 $

if nargin == 1
    out.Values = 'double array';
    out.x = 'xregpointer to Xexpr';
    out.xName = 'name of Xexpr';
    out.BreakPoints = 'vector of doubles';
    out.BPLocks = 'B P Locks';
    out.VLocks = 'V Locks';
    out.Flist = 'Flist';
    out.Memory = 'Memory';
    out.Description = 'Description of table';
    out.Input = 'Inputs';
    out.Precision = 'Precision of numbers';
    out.Range = 'Range of table';
    out.Extrapolate = 'Extrapolation flag';
    out.axes = 'Axis values (breakpoints)';
    out.axesptrs = 'Axis input ptr (Xexpr)';
elseif nargin == 2
    if ~isa(property , 'char')
        error('cgnormaliser\get: Non character array property name.');
    end
    switch lower(property)
        case 'values'
            out = N.Values;
        case 'clips'
            out = N.Clips;
        case {'breakpoints','axes'}
            out = N.Breakpoints;
        case 'bplocks'
            out = N.BPLocks;
        case 'vlocks'
            out = N.VLocks;
        case {'x','axesptrs'}
            out = N.Xexpr;
        case 'flist'
            out = N.Flist;
        case 'xname'
            if ~isempty(N.Xexpr)
                out = N.Xexpr.getname;
            else
                out='';
            end
        case 'weights'
            out = N.Weights;
        case 'sflist'
            out = N.SFlist;
        case 'memory'
            out = N.Memory;
        case 'description'
            out = N.Description;
        case 'input'
            out = N.Input;
        case 'precision'
            out = N.Precision;
        case 'range'
            out = N.Range;
        case 'extrapolate'
            out = N.Extrapolate;
        case 'allbreakpoints'
            Val = N.Values;
            BP = N.Breakpoints;
            if isempty(BP) | isempty(Val)
                out = [];
            else
                n = max(Val);
                out = invert(N,[0:n]');
            end
        case 'type'
            out = 'Normalizer';
        otherwise
            error(['cgnormaliser\get: Unknown property name: ''' property '''.']);
    end
else
    error('cgnormaliser\get: Insufficient arguments.');
end

