% GRAYLIC is an internal command of the toolbox. It uses Regular LIC method implemented in internal Matlab commands 
% to generate an intensity image.
% Usage:
% [LICIMAGE, INTENSITY,NORMVX,NORMVY] = GRAYLIC(VX, VY, ITERATIONS);
% VX and VY should contain X and Y components of the vector field. They
% should be M x N floating point arrays with equal sizes.
%
% ITERATIONS is an integer number for the number of iterations used in
% Iterative LIC method. use number 2 or 3 to get a more coherent output
% image.
%
% LICIMAGE returns an M x N floating point array containing LIC intensity image 
% INTENSITY returns an M x N floating point array containing magnitude of vector in the field 
% NORMVX and NORMVY contain normalized (each vector is normalized to have
% the length of 1.0) components of the vector field

function [LICImage, intensity,normvx,normvy] = grayLIC(vx,vy, iterations);
[width,height] = size(vx);
LIClength = round(max([width,height]) / 10);
LIClength = 50;
noiseImage = zeros(width, height);
LICImage = zeros(width, height);
intensity = ones(width, height); % array containing vector intensity

% Making white noise
rand('state',0) % reset random generator to original state
for i = 1:width 
    for j = 1:height
        noiseImage(i,j)= rand;
    end;
end;

% Normalize vector field
normvx = zeros(width, height);
normvy = zeros(width, height);
for i = 1:width 
    for j = 1:height
        l = sqrt( vx(i,j)^2 + vy(i,j)^2);
        intensity(i,j) = l;
        if l > 0
            normvx(i,j) = vx(i,j) / l;
            normvy(i,j) = vy(i,j) / l;
        end;
    end;
end;

% Making LIC Image
for m = 1:iterations
for i = 1:width 
    for j = 1:height
        stepCount = 1;
        sum = 0;
        x = i; y = j;
        
        for k = 1:LIClength * 10 % forward integration
            xPast = x;
            yPast = y;
            
            x = x + normvx(round(x),round(y));
            if x < 1  break;end;
            if x > width break; end;
            
            y = y + normvy(round(xPast),round(y));
            if y < 1  break;end;
            if y > height break; end;
                
            if (round(x) ~= round(xPast)) | (round(y) ~= round(yPast)) 
                stepCount = stepCount + 1;
                sum = sum + noiseImage(round(x),round(y));
            end;
          if stepCount > LIClength 
              break;
          end;
          
        end;
        
        x = i; y = j;
        
        for k = 1:LIClength * 10 % backward integration
            xPast = x;
            yPast = y;
            x = x - normvx(round(x),round(y));
            if x < 1  break;end;
            if x > width break; end;
            
            y = y - normvy(round(x),round(y));
            if y < 1  break;end;
            if y > height break; end;
            if (round(x) ~= round(xPast)) | (round(y) ~= round(yPast)) 
                stepCount = stepCount + 1;
                sum = sum + noiseImage(round(x),round(y));
            end;
          if stepCount > LIClength * 2 
              break;
          end;
        end;
        LICImage(i,j) = sum / stepCount;
    end;
end;
     
LICImage = imadjust(LICImage); % Adjust the value range
noiseImage = LICImage;
end;
%imshow(LICImage);
%figure, imshow(imadjust(LICImage,[],[],2));
%figure, imhist(imadjust(LICImage));