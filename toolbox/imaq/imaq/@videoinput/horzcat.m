function out = horzcat(varargin)
%HORZCAT Horizontal concatenation of image acquisition objects.
%
%    See also IMAQHELP.
%

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:40 $

% Initialize variables.
c=[];

% Loop through each UDD object and concatenate.
for i = 1:nargin
    if ~isempty(varargin{i}),
        % Make sure we are only concatenating image acquisition objects.
        if ~isa(varargin{i},'imaqdevice'),
            errID = 'imaq:horzcat:parentMixedTypes';
            error(errID, imaqgate('privateMsgLookup',errID));
        end
        
        if isempty(c),
            c=varargin{i};
        else
            % Concatenate the UDD object for each.
            try
                % May error with "All rows in the bracketed expression must
                % have the same number of columns."
            	c.uddobject = [c.uddobject imaqgate('privateGetField', varargin{i}, 'uddobject')];
            catch
    			rethrow(lasterror);
			end

            % Concatenate the type for each object.
            appendType = imaqgate('privateGetField', varargin{i}, 'type');
            c.type = {c.type{:} appendType{:}};
        end 
    end
end

% Verify that a matrix of objects was not created.
if (length(c.uddobject) ~= numel(c.uddobject))
    errID = 'imaq:horzcat:noMatrix';
    error(errID, imaqgate('privateMsgLookup',errID));
end

% Output the array of objects.
out = c;
