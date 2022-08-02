clear b2
clear len
b2=0:.05:5;
for n=1:length(b2)
   b1=b2(n);
   len(n)=quad('spd',0,2*pi);
end
plot(b2,len)