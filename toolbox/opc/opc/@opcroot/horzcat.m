function c = horzcat(varargin)
%HORZCAT Horizontal concatenation of OPC Toolbox objects.
%   Concatenation of OPC Toolbox objects has the following restrictions:
%   - Objects must be the same class. For example, you cannot concatenate 
%     an opcda object with a dagroup object.
%   - DAGROUP and DAITEM objects must have the same parent.
%   - Matrices are not supported. For example, horizontal concatenation of
%     column vectors results in an error.
%
%   See also OPCROOT/VERTCAT.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.3 $  $Date: 2004/02/01 22:06:39 $

c = [];
className = '';
parent = [];
for k=1:nargin
    if ~isempty(varargin{k}),
        % Must have same class
        if isempty(className),
            % Need to get a class name
            className = class(varargin{k});
            if ~strcmp(className, 'opcda')
                parent = get(varargin{k}(1), 'Parent');
            end
        elseif ~strcmp(class(varargin{k}), className),
            rethrow(mkerrstruct('opcroot:horzcat:classmismatch'));
        end
        % Cannot have matrices of objects. IOW no column vectors here
        % NOTE: We check nargin because the syntax HORZCAT(a) is valid!
        if (nargin>1) && (size(varargin{k},1)>1)
            rethrow(mkerrstruct('opcroot:horzcat:matrixdisallowed'));
        end
        % If DAGROUP or DAITEM, must have same parent
        if ~strcmp(className, 'opcda'),
            if ~isequal(get(varargin{k}(1), 'Parent'), parent),
                rethrow(mkerrstruct('opcroot:horzcat:parentdifferent'));
            end
        end

        % Passed. Now concatenate it
        if isempty(c)
            c = varargin{k};
        else
            try
                c.uddobject(1,end+1:end+length(varargin{k})) = getudd(varargin{k});
            catch
                rethrow(mkerrstruct(lasterror));
            end
        end
    end
end
