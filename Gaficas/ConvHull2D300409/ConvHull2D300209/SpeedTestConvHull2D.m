%%WARNING WORKSPACE WILL BE CLEARED!!!

%THIS IS A SPEED TEST COMPARISON BETWEEN CONVHULL2D AND THE MATLAB NATIVE
%CONVHULL
clc
clearvars
close all

%%%%%%%%%%%%%%%%%%%%%%%
%log10 numbers of points
lengthN = 15; 
Npoints = logspace(1,6,15); 

convhull_times = zeros(lengthN,1); 
chull2d_times = zeros(lengthN,1); 


fprintf('TEST STARTED\n')

for i = 1:lengthN 
    N=ceil(Npoints(i)); 
    x=rand(N,1); 
    y=rand(N,1); 
    
    %run native routine
    tic 
    chull1 = convhull(x,y); 
    convhull_times(i) = toc; 
    
     %run convhull2D
    tic 
    chull=ConvHull2D(x,y); 
    chull2d_times(i) = toc; 
    
    %check results
    if not(unique(chull1)==unique(chull))
        error('Bug Found, Please send a report to the author');
    end
    
    
    %print results
    if convhull_times(i)>chull2d_times(i)
        fprintf('For %7.0f points  ConvHull2D  is %4.1f times faster than convhull\n',N,convhull_times(i)/chull2d_times(i))
    else
        fprintf('For %7.0f points  convhull    is %4.1f times faster than ConvHull2D\n',N,chull2d_times(i)/convhull_times(i))
    end  
    
end 
     
figure() 
semilogx(Npoints,convhull_times,'g-') 
hold on 
semilogx(Npoints,chull2d_times,'b-') 
legend({'Native convhull';'convhull2d'}) 
title('Performance comparison') 
