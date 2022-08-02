%                               431-400 Year Long Project
%                           LA1 - Medical Image Processing 2003
%  Supervisor     :  Dr Lachlan Andrew
%  Group Members  :  Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
%                    Lee Siew Teng   102519  s.lee1@ugrad.unimelb.edu.au
%                    Loh Jien Mei    103650  j.loh1@ugrad.unimelb.edu.au
%
%  File and function name : plot_line.m
%  Version                : 2.0
%  Date of completion     : 14 July 2003
%  Written by    :   Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
% 
% Inputs :
%     X               -   The X coordinates of a point along this line
%     Y               -   The Y coordinates of a point along this line
%     Gradient        -   The gradient of the desired line. Also accepts a
%                         gradient of infinity (Gradient == inf) for vertical lines
%     lower_leftX,lower_leftY,upper_rightX,upper_rightY
%                     - Coordinates of the area desired to have the line in
%     Mode (Optional) -   There are 2 modes of output
%                         'accurate' (Default)
%                              - produces the coordinates that represents the lines
%                                as closely as possible.
%                         'connected'
%                              - Ensures a continuously connected line as 'accurate'
%                                need not produce a connected line depending on the
%                                gradient
% Outputs :
%     output_coord    -   Results in a [M x 2] matrix :
%                         The coordinates desired:
%                                      X coordinates are output_coord(:,1) and
%                                      Y coordinates are output_coord(:,2)
% 
% Description :
% 		To calculate the coordinates needed to draw a line given the details of
% 	the line and its limits, for use by the 'plot' function or for matrices
% 		Uses the "Bresenham's line algorithm for 1st quadrant" on Page 74,
% 	Chapter 2, "Procedural Elements for Computer Graphics, Second Edition"
% 	by David F. Rogers, UniM Engin 006.6 ROGE, Produces a digital integer
% 	approximation of a line that is suitable for plotting in a matrix
%
% Usage >> output_coord = plot_line(X,Y,Gradient,...
%                                   lower_leftX,lower_leftY,...
%                                   upper_rightX,upper_rightY)
%                               or
%          output_coord = plot_line(X,Y,Gradient,...
%                                   lower_leftX,lower_leftY,...
%                                   upper_rightX,upper_rightY,...
%                                   'accurate')
%                               or
%          output_coord = plot_line(X,Y,Gradient,...
%                                   lower_leftX,lower_leftY,...
%                                   upper_rightX,upper_rightY,...
%                                   'connected')
%
%          plot(output_coord(:,1),output_coord(:,2),'r*-');

function output_coord = plot_line(X,Y,Gradient,...
                                  lower_leftX,lower_leftY,...
                                  upper_rightX,upper_rightY,...
                                  varargin)
% ===================================================================
% Default output
% ===================================================================
coordX = [];
coordY = [];

% ===================================================================
% Checks the parameters given
% ===================================================================
if (lower_leftX > upper_rightX) | (lower_leftY > upper_rightY)
    error('lower_left coordinates greater then upper_right coordinates');
end
% Ensures that all parameters are not complex numbers
if (isreal(X) == 0) |...
   (isreal(Y) == 0) |...
   (isreal(Gradient) == 0) |...
   (isreal(lower_leftX) == 0) |...
   (isreal(lower_leftY) == 0) |...
   (isreal(upper_rightX) == 0) |...
   (isreal(upper_rightY) == 0) 
    error('Complex numbers given');
end
% Checks for the presence of mode indicators
mode = 'accurate'; %Default
for v = 1:1:length(varargin)
    if (strcmp(varargin{v},'accurate') == 1) | ...
       (strcmp(varargin{v},'connected') == 1)
        mode = varargin{v};
	end
end

% ===================================================================
% Calculations start here
% ===================================================================

if Gradient == 0
	% Quickly calculates the coordinates for a horizontal line    
    if (lower_leftY <= Y) & (Y <= upper_rightY)
        coordX = [lower_leftX:1:upper_rightX]'; 
        coordY = coordX;
        coordY(:) = X;
	end
elseif isinf(Gradient)
	% Quickly calculates the coordinates for a vertical line    
    if (lower_leftX <= X) & (X <= upper_rightX)
        coordY = [lower_leftY:1:upper_rightY]';
        coordX = coordY;
        coordX(:) = X;
    end
else
    present_in_box = 'Yes';
	% Checks to see if the line is present in the desired coordinate box of limits
    y_intercept = Y - (Gradient*X);
	% Calculates the position of the line along the box border
    upX = (upper_rightY - y_intercept)/Gradient;
    downX = (lower_leftY - y_intercept)/Gradient;
    leftY = (Gradient*lower_leftX) + y_intercept;
    rightY = (Gradient*upper_rightX) + y_intercept;
    if not(((lower_leftX <= upX)    & (upX <= upper_rightX))   | ...
		   ((lower_leftX <= downX)  & (downX<= upper_rightX))  | ...
		   ((lower_leftY <= leftY)  & (leftY <= upper_rightY)) | ...
		   ((lower_leftY <= rightY) & (rightY <= upper_rightY))  ...
          )
		% Checks to see if the line is present in the area of interest
		% If not, then we save time in calculation
		% If it is present, then we save time especially if the starting 
        % point is not in and far from the area of interest by calculating 
        % only the points that are of interest
        present_in_box = 'No';
    elseif Gradient > 0
        %Calculate the parameters for the Bresenham algorithm
        if(lower_leftX <= downX) & (downX <= upper_rightX)
            x = downX;
            y = lower_leftY;
        elseif (lower_leftY <= leftY) & (leftY <= upper_rightY)
            x = lower_leftX;
            y = leftY;
        else
             error('Error in calculations');
        end
        x_limit = upper_rightX;
        y_limit = upper_rightY;
    else
        %Calculate the parameters for the Bresenham algorithm
        if (lower_leftX <= upX) & (upX <= upper_rightX)
            x = upX;
            y = upper_rightY;
        elseif (lower_leftY <= leftY) & (leftY <= upper_rightY)
            x = lower_leftX;
            y = leftY;
        else
            error('Error in calculations: Gradient < 0');
        end
        x_limit = upper_rightX;
        y_limit = lower_leftY;
    end
    
    if strcmp(present_in_box,'Yes') == 1
		% For faster calculation by avoiding the repeated calls to 'strcmp'
        if strcmp(mode,'connected') == 1
            mode = 1;
        else 
            mode = 0;
        end
        
		% ==============================================================
		% The Bresenham algorithm for positive Gradient
		% ==============================================================
        if Gradient > 0
			error = Gradient-(1/2);		
            while x <= x_limit
                coordX = [coordX(:); x];
                coordY = [coordY(:); y];
                while error > 0        
                    y = y + 1;
                    error = error - 1;
                    if mode == 1
                        coordX = [coordX(:); x];
                        coordY = [coordY(:); y];
                    end
                    if y > y_limit
                        break;
                    end
                end
                error = error + Gradient;
                x = x + 1;
                if y > y_limit
                    break;
                end
			end
        else
		% ==============================================================
		% The Bresenham algorithm for negative Gradient
		% ==============================================================
			error = Gradient+(1/2);		
            while x <= x_limit
                coordX = [coordX(:); x];
                coordY = [coordY(:); y];
                while error < 0        
                    y = y - 1;
                    error = error + 1;
                    if mode == 1
                        coordX = [coordX(:); x];
                        coordY = [coordY(:); y];
                    end
                    if y < y_limit
                        break;
                    end
                end
                error = error + Gradient;
                x = x + 1;
                if y < y_limit
                    break;
                end
			end
        end
    end
end

% ===================================================================
% Format the output
% ===================================================================
output_coord = [coordX,coordY];
