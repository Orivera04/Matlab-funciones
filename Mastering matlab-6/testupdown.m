% testupdown
% script file to test updown implementations

times=zeros(1,3);
Nums=1e5:2e5;     % number to test

tic
updown3           % For Loop implementation
times(1)=toc

tic
updown4           % First vectorization
times(2)=toc

tic
updown5           % Second vectorization
times(3)=toc

relspeed=times/min(times)