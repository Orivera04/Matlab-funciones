% GRAYFASTLIC is an internal command of the toolbox. It uses Fast LIC method implemented in internal Matlab commands 
% to generate an intensity image.
% Usage:
% [LICIMAGE, INTENSITY,NORMVX,NORMVY] = GRAYFASTLIC(VX, VY, ITERATIONS);
% VX and VY should contain X and Y components of the vector field. They
% should be M x N floating point arrays with equal sizes.
%
% ITERATIONS is an integer number for the number of iterations used in
% Iterative LIC method. use number 2 or 3 to get a more coherent output
% image.
%
% LICIMAGE returns an M x N floating point array containing LIC intensity image 
% INTENSITY returns an M x N floating point array containing magnitude of vector in the field 
% NORMVX and NORMVY contain normalized (each vector is normalized to have the length of 1.0) components of the vector field

function [LICImage, intensity,normvx,normvy] = grayFastLIC(vx, vy, iterations);
[width,height] = size(vx);
LIClength = round(max([width,height])/ 10);

maxFieldLineLength = max([width,height]) / 2; % maximum length of each calculated field line
linePointf = -ones(maxFieldLineLength + 2,2);
linePointb = -ones(maxFieldLineLength + 2,2);
noiseImage = zeros(width, height);
intensity = ones(width, height); % array containing vector intensity

% making white noise
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
for p = 1:iterations
LICImage = -ones(width, height);
    for i = 1:width 
    for j = 1:height
    if LICImage (i,j) == -1
        stepCountf = 1;
        x = i; y = j;
        linePointf(1,1) = round(x);
        linePointf(1,2) = round(y);
        
        for k = 1:maxFieldLineLength * 10 % forward integration
            xPast = x;
            yPast = y;
            
            x = x + normvx(round(x),round(y)) ;
            if x < 1  break;end;
            if x > width break; end;
            
            y = y + normvy(round(x),round(y)) ;
            if y < 1  break;end;
            if y > height break; end;
                
            if (round(x) ~= round(xPast)) | (round(y) ~= round(yPast)) 
                stepCountf = stepCountf + 1;
             
                linePointf(stepCountf,1) = round(x);
                linePointf(stepCountf,2) = round(y);
        end;
          if stepCountf > maxFieldLineLength    break;
          if (k>10) && (round(x) == i) && (round(y) ==j) break; end;
          end;
          
        end;
        
        x = i; y = j;
        stepCountb = 1;
        linePointb(1,1) = round(x);
        linePointb(1,2) = round(y);
        
        for k = 1:maxFieldLineLength * 10 % backward integration
            xPast = x;
            yPast = y;
            x = x - normvx(round(x),round(y));
            if x < 1  break;end;
            if x > width break; end;
            
            y = y - normvy(round(x),round(y));
            if y < 1  break;end;
            if y > height break; end;
            if (round(x) ~= round(xPast)) || (round(y) ~= round(yPast)) 
                stepCountb = stepCountb + 1;
            
                linePointb(stepCountb,1) = round(x);
                linePointb(stepCountb,2) = round(y);
            end;
          if stepCountb > maxFieldLineLength  
              break;
          end;
         if (k>10) && (round(x) == i) && (round(y) ==j) break; end;
        end;
          
       linePoints = cat(1,flipud(linePointb(1 : stepCountb,:)),linePointf(1 : stepCountf,:));
       lineLength = size(linePoints);
       
       for m = 1:min(lineLength(1), LIClength) % calculate the incomplete portion on begiining of the line
       sumStart = max(1, m - LIClength);
       sumEnd = min (lineLength(1), m + LIClength);
       LICImage(linePoints(m,1) , linePoints(m,2)) = 0;
       for n = sumStart:sumEnd
           LICImage(linePoints(m,1) , linePoints(m,2)) = LICImage(linePoints(m,1) , linePoints(m,2)) + noiseImage(linePoints(n,1) , linePoints(n,2));
       end;
       LICImage(linePoints(m,1) , linePoints(m,2)) = LICImage(linePoints(m,1) , linePoints(m,2)) / (sumEnd - sumStart); 
       end;
    
       for m = max(lineLength(1) - LIClength, 1):lineLength(1) % calculate the incomplete portion on end of the line
       sumStart = max(1, m - LIClength);
       sumEnd = min (lineLength(1), m + LIClength);
       LICImage(linePoints(m,1) , linePoints(m,2)) = 0;
       for n = sumStart:sumEnd
           LICImage(linePoints(m,1) , linePoints(m,2)) = LICImage(linePoints(m,1) , linePoints(m,2)) + noiseImage(linePoints(n,1) , linePoints(n,2));
       end;
       LICImage(linePoints(m,1) , linePoints(m,2)) = LICImage(linePoints(m,1) , linePoints(m,2)) / (sumEnd - sumStart); 
       end;
       
       if lineLength(1) > 2 * LIClength
           for m = (LIClength + 1): (lineLength(1) - LIClength)
               LICImage(linePoints(m,1) , linePoints(m,2)) = (LICImage(linePoints(m - 1,1) , linePoints(m - 1,2)) * LIClength * 2 - noiseImage(linePoints(m - LIClength,1) , linePoints(m  - LIClength,2)) + noiseImage(linePoints(m + LIClength,1) , linePoints(m  + LIClength,2))) / (LIClength * 2);
           end;
       end;      
          
    end;
end;
end;
     
LICImage = imadjust(LICImage); % Adjust the value range
noiseImage = LICImage;
end;