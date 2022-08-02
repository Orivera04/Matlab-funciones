function vfield_color(image,x,y,u,v,scale,cmap)
%VFIELD_COLOR  Plot 2-D velocity vectors with colors defined by a colormap.
%
%   Syntax:
%      HANDLE = VFIELD(X,Y,U,V,SCALE,CMAP)
%
%
%   Inputs:
%
%      X, Y     Arrows origin, N-D arrays
%      U, V     Current components, N-D arrays
%      SCALE    Scalar value to set vector lengths
%      CMAP     Colormap, N x 3 array of RGB values
%
%
%   Example:
%             image = zeros(100);
%             x = (rand(1,50) .* 80) + 10;
%             y = (rand(1,50) .* 80) + 10;
%             u = rand(1,50) .* 100;
%             v = rand(1,50) .* 100;
%             cmap = jet(64);
%             scale = 10;
%             vfield_color(image,x,y,u,v,scale,cmap)
%
% See also QUIVER, FEATHER, VFIELD

if nargin < 7
    cmap = colormap('jet');
end

%normalize vector components
speed = sqrt(u.^2+v.^2); % matrix of magnitudes of data
s_min = min(speed);
s_max = max(speed);
u_norm = u./speed;
v_norm = v./speed;

h=imagesc([1,size(image,2)],[1,size(image,1)],ones(size(image)));
axis image
set(h,'visible','off');

colormap(cmap);
caxis([0 s_max]);
cm = colormap;
cm_length = length(cm);

range = s_max - s_min;
cm_stepsize = range/cm_length;

hold on
for count1=1:length(x)
    if ~isnan(speed(count1))
        cm_index = floor(...
            (speed(count1) - s_min) / ( cm_stepsize )...
            ) + 1;
        try %need this in case s_min is zero
            mc = cm(cm_index,:);
        catch
            mc = cm(cm_index-1,:);
        end
        vfield(...
            x(count1),y(count1),...
            scale.*u_norm(count1),scale.*v_norm(count1),...
            'tr','4',...
            'fi',16,...
            'fill',1,...
            'color',mc,...
            'z',20);  
    end
end
hold off