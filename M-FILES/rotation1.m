%                               431-400 Year Long Project 
%                           LA1 - Medical Image Processing 2003
%  Supervisor     :  Dr Lachlan Andrew
%  Group Members  :  Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
%                    Lee Siew Teng   102519  s.lee1@ugrad.unimelb.edu.au
%                    Loh Jien Mei    103650  j.loh1@ugrad.unimelb.edu.au
% 
%  File and function name : rotation
%  Version                : 1.0
%  Date of completion     : 5 September 2003
%  Written by    :   Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
%
%  Inputs        :
%           input_XY    -   The X and Y coordinates to be rotated. [X,Y]
%           center      -   A 1D matrix with 2 formats either 
%                           [centerX,centerY] or [centerX;centerY]
%                           this is the center of rotation
%           anti-clockwise_angle - The angle of rotation about the center 
%                                  from which the new coordinates will be produced.
%           'degree','radians' (Optional)
%                       -   Description of what the "anti-clockwise_angle" is.
%                           Default = 'degree'
%
%  Outputs       :   
%           rotated_coords     - The rotated coordinates "input_XY" about "center" 
%                                by angle "anti-clockwise_angle". [X,Y]
%
%  Description   :
%       Rotates the input_XY coordinates by a given angle about a center.
%
%  To Run >>    final_coords = rotation(input_XY,center,anti-clockwise_angle,varargin)
%
%  Example>>    X = [1:1:10]'; Y = [2;4;1;2;5;7;2;7;8;3];
%               final_coords = rotation([X,Y],[0,0],90);
%               figure;
%               plot(X,Y,'b+-');
%               hold on;
%               plot(final_coords(:,1),final_coords(:,2),'r*-');
%
% See "test_rotation.m" for more examples
                
function rotated_coords = rotation(input_XY,center,anti_clockwise_angle,varargin)
degree = 1; %Radians : degree = 0; Default is calculations in degrees

% Process the inputs
if length(varargin) ~= 0
    for n = 1:1:length(varargin)
        if strcmp(varargin{n},'degree') 
            degree = 1;
        elseif strcmp(varargin{n},'radians')
            degree = 0;
        end
    end
    clear n;
end
[r,c] = size(input_XY);
if c ~= 2
    error('Not enough columns in coordinates XY ');
end
[r,c] = size(center);
if (r~=1 & c==2) | (r==1 & c~=2)
    error('Error in the size of the "center" matrix');
end

% Format the coordinate of the center of rotation
center_coord = input_XY;
center_coord(:,1) = center(1);
center_coord(:,2) = center(2);

% Turns the angles given to be such that the +ve is anti-clockwise and -ve is clockwise
anti_clockwise_angle = -1*anti_clockwise_angle;
% if in degrees, convert to radians because that's what the built-in functions use. 
if degree == 1 
    anti_clockwise_angle = deg2rad(anti_clockwise_angle);
end

%Produce the roation matrix
rotation_matrix = [cos(anti_clockwise_angle),-1*sin(anti_clockwise_angle);...
                   sin(anti_clockwise_angle),cos(anti_clockwise_angle)];
%Calculate the final coordinates
rotated_coords = ((input_XY-center_coord) * rotation_matrix)+center_coord;

