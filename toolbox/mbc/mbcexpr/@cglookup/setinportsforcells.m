function ret = setinportsforcells(obj, varargin)
%SETINPORTSFORCELLS Set inport values to match table cell breakpoints
%
%  OK = SETINPORTSFORCELLS(OBJ) sets the values of the inports to the table
%  OBJ so that the inputs to each axis of the table evaluate to the
%  breakpoints.
%
%  OK = SETINPORTSFORCELLS(OBJ, ROWS, COLS, ...) sets the inports so that
%  the tables axes will evaluate to hit the specified breakpoints.
%
%  For example:
%    OK = setinportsforcells(obj, [1 3], [5 7 9]) will set the axes so that
%    the 1st and 3rd rows and 5th, 7th and 9th columns of the table will be
%    picked out.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:12:12 $ 

ret = false;

if ~hasinportperaxis(obj)
    return
end

sz = getTableSize(obj);
if ~all(sz)
    return
end


if nargin==1
    pInputs = getinputs(obj);
    objInputs = info(pInputs);
    if ~iscell(objInputs)
        [vals, ret] = findoutput(objInputs, 0:sz(1)-1);
    else
        ret = true;
        for n = 1:length(pInputs)
            [vals, ok] = findoutput(objInputs{n}, 0:sz(n)-1);
            ret = ret && ok;
        end
    end

else
    if length(sz)~=length(varargin)
        error('mbc:cglookup:InvalidArgument', ...
            'You must specify a list of cells for each table dimension');
    end

    pInputs = getinputs(obj);
    objInputs = info(pInputs);
    if ~iscell(objInputs)
        [vals, ret] = findoutput(objInputs, 0:sz(1)-1);
    else
        ret = true;
        for n = 1:length(pInputs)
            [vals, ok] = findoutput(objInputs{n}, varargin{n}-1);
            ret = ret && ok;
        end
    end

end
