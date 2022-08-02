
%% WARNIGN WORKSPACE WILL BE CLEARED
%% this test will take approximatively one minute
clc
clearvars
close all



np=4:.5:6;%points to run the test =10^np(i)

dimvect=2:5;%dimesion of points/Warning for high dimensions it will take a long time
%Rememeber that for dimensions >5 QuickHull uses the normal convhull, so it has non sense 
% to run a test in higher dimension


%vectors for plot
tplotquicker=zeros(length(np),1);
tplotnormal=zeros(length(np),1);





for d=1:length(dimvect)
    for j=1:length(np)
     

        N=round(10^np(j));%number of points
        dim=dimvect(d);%dimesnions


        P=rand(N,dim);



        %run the test

        %quicker
        tic
        tess1=QuickerHull(P);
        quickertime=toc;

        %normal
        tic
        tess2=convhulln(P);
        normaltime=toc;

        tplotquicker(j)=quickertime;
        tplotnormal(j)=normaltime;

        %check the results
        %points of the convex hull are unique but the way to triangulate them is not
        if not(isequal(unique(tess1),unique(tess2)));
            beep
            error('Bug Found please send a report to the author');
        end



    end

    figure;
    hold on
    plot(np,tplotnormal,'-r',np,tplotquicker,'b-')
    legend('Normal','Quicker')
    title(['Time comparison in ',num2str(dim),'D Space'],'fontsize',13);
    xlabel('log10 Numbers of points')
    ylabel('Time [s]')
     
end









