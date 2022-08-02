% INTENSITY2COLOR  is an internal command of the toolbox. It adds color to LIC intensity image according to magnitude
% of vectors in the vector field. Returned colors are histogram equalized.
% Usage:
% RGBIMAGE = INTENSITY2COLOR (LICIMAGE,INTENSITY, COLORMAP)
% RGBIMAGE returns the colored LIC image.
% 
% LICIMAGE is a M x N array containing the intensity LIC image.
% 
% INTENSITY is a M x N array containing the magnitude of vectors in the
% field.
% 
% COLORMAP is a standard matlab colormap array (an M-by-3 matrix) used by this function to
% convert scalar values to colors.

function RGBImage = intensity2color(LICImage,intensity, ColorMap)
grayImage = LICImage;
HSVImage = ones([size(grayImage),3]);
intensity = intensity / max(max(intensity)); % Normalizing the Intensity

if nargin<3
    ColorMap  = jet; % Default Colormap
end;

valueImage = round(histeq(imadjust(intensity,stretchlim(intensity),[0,1])) * length(ColorMap)); % Enhancing Contrast and Histogram Equalization

HSVImage = rgb2hsv(ind2rgb(valueImage, ColorMap)); % Changing the intensity image to HSV color-space
HSVImage(:,:,3) = grayImage; % Putting LIC image into Value axis of ooutput image 
RGBImage = hsv2rgb(HSVImage); % Converting image back to RGB color-space
