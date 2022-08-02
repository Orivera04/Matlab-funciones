% PLOTVFIELD uses LIC method to visualize a vector field.
% Usage:
% FINALLIC = PLOTVFIELD(VX, VY, ZOOMFACTOR, ITERATIONS, COLORMAP, RECT, METHOD) makes a colored LIC image and returns it in FINALLIC. 
% 
% VX and VY should contain X and Y components of the vector field. They
% should be M x N floating point arrays with equal sizes.
% 
% ZOOMFACTOR should be a floating point number for magnification of an area
% indicated in RECT parameter. If this parameter is not specified, default
% value of 1.0 will be used.
% 
% ITERATIONS is an integer number for the number of iterations used in
% Iterative LIC method. use number 2 or 3 to get a more coherent output
% image.
% 
% COLORMAP is a standard matlab colormap array (an M-by-3 matrix) used by this function to
% convert scalar values to colors.
% 
% RECT is a 4-element vector with the form [XMIN YMIN WIDTH HEIGHT]; these
% values are specified in spatial coordinates of vector field (VX and VY arrays). Input field will first
% cropped to this region then zoomed using ZOOMFACTOR. If this parameter is
% not specified, the entire area of the field will be zoomed.
% 
% METHOD specifies which implementation of LIC should be used. Deafult
% method is using externally implemented Fast LIC method. 
% Use 'ef' for externally implemented Fast LIC method.
% Use 'f' for internally implemented Fast LIC method.
% Use 'r' for internally implemented Regular LIC method.
% 
% Example: 
% 
% LICimage = plot(vx,vy); 
% 
% (vx, vy are M x N matrices)
% This makes a LIC image stores it in LICimage variable.

function finalLIC = plotvfield(vx,vy,zoomFactor, iterations, ColorMap,rect, method)
[width,height] = size(vx);

if nargin<5
    ColorMap  = jet; % Default Colormap
end;

if nargin<7
    method = 'ef'; % Default method is the externally implemented Fast LIC method.
end;

if nargin<4
    iterations  = 1; % Default Number for LIC iterations.
end;

if nargin<3
    zoomFactor  = 1; % Default Number for zoom
end;

if nargin>6
    rect = [1 1 height width]; % Default Rect covers the whole area.
    vx = imcrop(vx,rect); % cropp input vector field to RECT
    vy = imcrop(vy,rect);
end;

if zoomFactor > 1
    vxZoomed = imresize(vx,zoomFactor,'nearest');
    vyZoomed = imresize(vy,zoomFactor,'nearest');
else
    vxZoomed = imresize(vx,zoomFactor,'bicubic');
    vyZoomed = imresize(vy,zoomFactor,'bicubic');
end;

   switch lower(method)
       case('ef')  
           [grayImage, intensityArray] = grayLICExternal(vxZoomed,vyZoomed,iterations); % Use externally implemented Fast LIC
       case('f')
           [grayImage, intensityArray] = grayFastLIC(vxZoomed,vyZoomed,iterations); % Use internally implemented Fast LIC
       case('r')
           [grayImage, intensityArray] = grayLIC(vxZoomed,vyZoomed,iterations); % Use internally implemented Regular LIC
   end;

finalLIC = intensity2color(grayImage, intensityArray, ColorMap);
imshow(finalLIC);
colormap(ColorMap);
finalLIC = quivervfield(vxZoomed,vyZoomed);