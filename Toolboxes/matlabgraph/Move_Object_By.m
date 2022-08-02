function Move_Object_By(h, xDist, yDist)
% 
% Move_Object_By(h, xDist, yDist)
%
% Moves an object by an an x and y offset value
%
% Inputs
%         h     - Is a handle to the graphics object 
%         xDist - The x distance to move the object by
%         yDist - The y distance to move the object by
%        
% Output
%       
%
% Date - 8 Jan 2003
% Author by Maj Thomas Rathbun

% loop over the array of handles
for j=1:length(h)
    
    % get one handle
    handle = h(j);

    % different objects have different types of properties for moving
    try
        
        % get old value and add new value and send to object
        oldX = get(handle,'XData');
        oldX = oldX + xDist;
        set(handle,'XData',oldX);
        oldY = get(handle,'YData');
        oldY = oldY + yDist;
        set(handle,'YData',oldY);
    catch
        p = get(handle,'Position');
        % there are two different positions, one with 3 and one with 4
        try
            set(handle,'Position',[p(1)+xDist,p(2)+yDist,p(3),p(4)]);
        catch
            set(handle,'Position',[p(1)+xDist,p(2)+yDist,p(3)]);
        end
    end
end

drawnow;