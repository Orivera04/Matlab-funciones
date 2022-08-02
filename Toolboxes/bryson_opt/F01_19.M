% Script f01_19.m; allowable axial stress for square 
% column vs. slenderness ratio;        12/92, 4/1/02
%
% Short column:
z=[.02:.02:1]; N=length(z); un=ones(1,N); s=un-z/2;
%
% Long column:
z1=[1:.02:2]; N1=length(z1); un1=ones(1,N1);
s1=un1./(2*z1); 
%
figure(1); clf; subplot(211),
plot(z,s,'b',z1,s1,'b',1,.5,'o'); 
grid; axis([0 2 0 1]); ylabel('P/\sigma b^2'); 
xlabel('z=(6/\pi^2)(\sigma/E)(L/b)^2'); 
text(.38,.58,'Short column'); 
text(1.42,.46,'Long column (Euler)');
print -deps2 \book_do\figures\f01_19
