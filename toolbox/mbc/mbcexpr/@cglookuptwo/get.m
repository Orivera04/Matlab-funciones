function out = get(LT, property);
% cglookuptwo\get
%	get(l)	returns list of properties
%  val=get(l,'property') returns the value of the named property of the object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:11:36 $

if nargin == 1
    out.Values = 'double array';
    out.Clips = 'doubles: ClipLow and ClipHigh if set';
    out.x = 'xregpointer to Xexpr';
    out.xName = 'name of Xexpr';
    out.y = 'xregpointer to Yexpr';
    out.yName = 'name of Yexpr';
    out.BPLocks = 'B P Locks';
    out.VLocks = 'V Locks';
    out.Weights = 'Weights';
    out.SFlist = 'SFlist';
    out.Memory = 'Memory';
    out.Description = 'Description of table';
    out.Input = 'Inputs';
    out.Precision = 'Precision of numbers';
    out.Range = 'Range of table';
    out.axes = 'Axes values {[Xaxis],[Yaxis]}';
    out.axesptrs = 'Axes input ptrs (Xptr,Yptr)';
elseif nargin == 2
    if ~isa(property , 'char')
        error('cglookuptwo\get: Non character array property name.');
    end
    switch lower(property)
        case 'values'
            out = LT.Values;
        case 'clips'
            out = LT.Clips;
        case 'vlocks';
            out = LT.VLocks;
        case 'x'
            out = LT.Xexpr;
        case 'xname'
            if ~isempty(LT.Xexpr)
                out = LT.Xexpr.getname;
            else
                out='';
            end
        case 'y'
            out = LT.Yexpr;
        case 'yname'
            if ~isempty(LT.Yexpr)
                out = LT.Yexpr.getname;
            else
                out='';
            end
        case 'weights'
            out = LT.Weights;
        case 'sflist'
            out = LT.SFlist;
        case 'memory'
            out = LT.Memory;
        case 'description'
            out = LT.Description;
        case 'input'
            out = LT.Input;
        case 'precision'
            out = LT.Precision;
        case 'range'
            out = LT.Range;
        case 'axes'
            s = size(LT.Values);
            try
                X = LT.Xexpr.invert(0:s(2)-1);
                Y = LT.Yexpr.invert(0:s(1)-1);
            catch
                X = (0:s(2)-1);
                Y = (0:s(1)-1);
            end
            out = {X,Y};
        case 'axesptrs'
            ptr1 = LT.Xexpr.get('x');
            ptr2 = LT.Yexpr.get('x');
            out = [ptr1 ptr2];
        case 'type'
            out = '2D Table';
        otherwise
            error(['LookUpOne\get: Unknown property name: ''' property '''.']);
    end
else
    error('cglookuptwo\get: Insufficient arguments.');
end
