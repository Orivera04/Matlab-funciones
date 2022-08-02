function map=rainbow(m)
%RAINBOW Colormap Variant to HSV. (MM)
% RAINBOW(M) Rainbow Colormap with M entries.
%
% Red - Orange - Yellow - Green - Blue - Violet
%
% RAINBOW by itself is the same length as the current colormap.
%
% Apply using: colormap(rainbow)

% D. Hanselman, University of Maine, Orono, ME  04469
% 3/23/95, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<1, m=size(get(gcf,'colormap'),1); end

mp=[
   1   0  0  % red
   1  1/3 0  % orange
   1   1  0  % yellow
   0   1  0  % green
   0   0  1  % blue
   .5   0 .5];% violet

if m<=6, map=mp(1:m,:); return, end

k=ceil(m/5);
mk=5*k+1;
map=zeros(mk,3);
ks=(0:4)*k +1;

for i=0:k-1
   a=(1+cos(pi*i/k))/2; b=1-a;	% cosine interp to maximize rainbow colors
   map(i+ks,:)=a*mp(1:5,:) + b*mp(2:6,:);
end
map=map(1:m,:);
map(end,:)=mp(6,:);
