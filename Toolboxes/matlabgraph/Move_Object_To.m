function Move_Object_To(h, x, y)
% 
% Move_Object_To(h, x, y)
%
% Moves an object to a specific location, not valid for arcs and 
%       polygons
%
% Inputs
%        h     - Is a handle to the graphics object
%        x     - X coordinate to move to
%        y     - Y coordinate to move to
% Output
%        None
%
% Date - 8 Jan 2003
% Author - Maj Thomas Rathbun

% if h is an array move all objects by the same amount
for j=1:length(h)
    % separate out handle
    handle = h(j);

    % there are three different properties that may be involved with moving
    % try XData and YData first
    try
        % set new value
        set(handle,'XData',x);
        set(handle,'YData',y);
    catch
        % if not Xdata try position
        p = get(handle,'Position');
        
        % try four value positon
        try
            % set new position
            set(handle,'Position',[x,y,p(3),p(4)]);
        catch
            % use three value position
            set(handle,'Position',[x,y,p(3)]);
        end
    end
end
