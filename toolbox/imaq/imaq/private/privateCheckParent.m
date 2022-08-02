function out = privateCheckParent(varargin)
%PRIVATECHECKPARENT Determine if image acquisition objects have same parent.
%
%    OUT = PRIVATECHECKPARENT(OBJ1, OBJ2,...) determines if image
%    acquisition objects OBJ1, OBJ2,... have the same parent.
%
%    PRIVATECHECKPARENT is a helper function for IMAQCHILD's 
%    HORZCAT and VERTCAT.
%

%    CP 6-03-98
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:06:08 $


% Initialize variables
out = true;
uddParent = [];
element = varargin{:};

% Obtain the parent of the first object passed.  Then compare the
% remaining object's parents to the first object's parent.
for i = 1:length(element)
    if ~isempty(element{i})
        try
            % Don't bother checking invalid objects.
            if isvalid(element{i}),
                % Get the current parent.
                parent = get(privateGetField(element{i}, 'uddobject'), 'Parent');
                
                % If element{i} is an array of objects, GET will return a cell
                % array of Parent values. We only need one of the Parent values
                % to perform our check.
                if iscell(parent),
                    parent = parent{1};
                end
                
                if isempty(uddParent),
                    % Store the parent to use for next few iterations.
                    uddParent = privateGetField(parent, 'uddobject');
                else                
                    % Determine if the objects have the same parent.
                    if privateGetField(parent, 'uddobject') ~= uddParent,
                        out = false;   
                        return;
                    end
                end
            else
                % Object is invalid.
                out = false;
                return;
            end     
        catch
            out = false;
            return;
        end
    end
end
