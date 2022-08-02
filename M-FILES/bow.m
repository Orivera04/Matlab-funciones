function MAP=bow(N)
%   Colormap for scientific applications
%   should show a maximal local color/intensity contrast
%   and possibly homogeneously distributed colors for linear
%   varying data. This is only an attempt, not any objective 
%   solution, which would need thousands of independent tests,
%   because there are no two persons with identical color visions.
%       
%Call:
%  MAP=bow(N)
%Input:
%       N = (optional) number of duplications of colormap length, 
%       N = 1 or 2 gives sufficiently smooth colors      
%Output:
%       MAP = colormap 
% DEMO
%   Z=peaks;
%   surf(Z)
%   shading interp
%   view(0,90)
%   colormap bow(2)
%   colorbar
%   axis off
%   axis tight
%   figure(gcf)
%   
%Vassili Pastushenko	Sep. 2004
%==============================
MAP=[
            0            0            0
      0.42105            0      0.15789
      0.63158            0      0.36842
      0.84211            0      0.63158
            1            0            1
      0.78947            0      0.89474
      0.63158            0      0.84211
      0.42105            0          0.8
      0.15789            0         0.87
            0            0            1
            0      0.31579      0.94737
            0      0.47368            1
            0      0.63158            1
            0      0.78947            1
            0            1            1
            0            1      0.84211
            0      0.94737      0.68421
            0      0.84211      0.52632
            0      0.78947      0.31579
            0         0.87      0.10526
            0            1            0
          0.4         0.97            0
      0.52632            1            0
      0.73684            1            0
            1            1            0
            1      0.86957            0
            1      0.69565            0
      0.95652      0.52174            0
      0.91304      0.34783            0
      0.91304      0.17391            0
            1            0            0
            1      0.36842      0.31579
            1      0.52632      0.47368
            1      0.68421      0.63158
            1      0.84211      0.78947
            1            1            1
        ];
t=31:36;
AD=interp1(t,MAP(t,:),[32.5 34.5 36]);
MAP=[MAP([1,3:31],:);AD];
MAP=intercolor(MAP);
RED=MAP(14:20,:);
t=(0:6)/6;
IN=interp1(t,RED,(0:5)/5);
MAP=[MAP(1:13,:);IN;MAP(21:end,:)];
MAP(14:17,:)=[.3 0 .83; .2 0  .875;0.1 0 .935;0 0 1];

if nargin>0
    for i=1:N
        MAP=intercolor(MAP);
    end
end

function col=intercolor(c)
%
%Call:
%
%Input:
%
%Output:
% 
%
%Vassili Pastushenko	Jul	2004
%==============================
DEG=2;
LEN=size(c(:,1));
t=1:LEN;
tt=1:.5:LEN;
col=interp1(t,c.^DEG,tt).^(1/DEG);
col(col>1)=1;
col(col<0)=0;
