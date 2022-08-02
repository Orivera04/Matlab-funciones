function out = get(NF, property);
% cgnormfunction\get
%	get(n)	returns list of properties
%  val=get(n,'property') returns the value of the named property of the object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:14:42 $

if nargin == 1
    out.Values = 'double array';
    out.Clips = 'doubles: ClipLow and ClipHigh if set';
    out.x = 'xregpointer to Xexpr';
    out.xName = 'name of Xexpr';
    out.BreakPoints = 'vector of doubles';
    out.BPLocks = 'B P Locks';
    out.VLocks = 'V Locks';
    out.Memory = 'Memory';
    out.Description = 'Description of table';
    out.Input = 'Inputs';
    out.Precision = 'Precision of numbers';
    out.Range = 'Range of table';
    out.axes = 'Axis values (breakpoints)';
    out.axesptrs = 'Axis input ptr';
elseif nargin == 2
    if ~isa(property , 'char')
        error('cgnormfunction\get: Non character array property name.');
    end
    switch lower(property)
        case 'values'
            out = NF.Values;
        case 'clips'
            out = NF.Clips;
        case 'breakpoints'
            out = NF.Breakpoints;
        case 'vlocks'
            out = NF.VLocks;
        case 'x'
            out = NF.Xexpr;
        case 'weights'
            out = NF.Weights;
        case 'sflist'
            out = NF.SFlist;
        case 'memory'
            out = NF.Memory;
            
        case 'xname'
            if ~isempty(NF.Xexpr)
                out = NF.Xexpr.getname;
            else
                out='';
            end
        case 'description'
            out = NF.Description;
        case 'input'
            out = NF.Input;
        case 'precision'
            out = NF.Precision;
        case 'range'
            out = NF.Range;
            if size(out) == [1 2];
                out = [0 inf;out];
            end
        case 'axes'
            s = size(NF.Values);
            try
                out = NF.Xexpr.invert(0:s(1)-1);
            catch
                out = (0:s(1)-1)';
            end
        case 'axesptrs'
            out = NF.Xexpr.get('x');
        case 'allbreakpoints'
            xNormaliser = NF.Xexpr;
            out = xNormaliser.get('allbreakpoints');
        case 'type'
            out = '1D Table';
        otherwise
            error(['cgnormfunction\get: Unknown property name: ''' property '''.']);
    end
else
    error('cgnormfunction\get: Insufficient arguments.');
end


   
