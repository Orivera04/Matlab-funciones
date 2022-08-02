%BEAMPLT.M
%
%To produce a plot of the beam pattern given as a function of angle
%for either
%      (a) several different numbers of hydrophones at fixed spacing,
%or    (b) several different hydrophone spacings with a fixed number of
%          hydrophones.
%
%                   Andrew Knight, June 1991
%
Npts = 200;
theta=linspace(0,pi/2,Npts);
b=zeros(4,Npts);
k = menu('BEAMPLT.M: Which would you like',...
   'different numbers of hydrophones',...
   'different hydrophone spacings');
disp(' ')
if k==1
   disp('Beam patterns for the following numbers of hydrophones:')
   n = [2 5 10 20];
   disp(n)
   dol = 0.5;
   disp(['(Spacing = ' num2str(dol) ' wavelengths)'])
   for i=1:4,b(i,:)=beam(n(i),dol,theta);end
else
   disp('Beam patterns for the following hydrophone spacings (/lambda):')
   dol = 0.15 + [.2 .4 .6 .8];
   disp(dol)
   n = 6;
   disp(['(Number of hydrophones = ' int2str(n) ')'])
   for i=1:4,b(i,:)=beam(n,dol(i),theta);end
end

%   Plotting:
clg
hold off
axis([0 90 -4 0])
semilogy(theta*180/pi,b)
xlabel('theta (degrees)')
ylabel('response')
title('BEAMPLT.M')
ans = input('Print current plot ? ','s');
if ans=='y'|ans=='Y'
   print
end
axis([0 1 0 1])
polar(theta,b);grid
title('BEAMPLT.M: Beam pattern')
disp('Type "print" if you want a printout')

