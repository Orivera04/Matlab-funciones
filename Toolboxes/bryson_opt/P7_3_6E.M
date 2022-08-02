% Script p7_3_6e.m; tf and bef on gamma=0;
%
Vf=[.1:.1:1.8];
for i=1:10,
  tf0(i)=sqrt(2*(1+1/Vf(i)^2))-1; bef0(i)=pi;
end
for i=11:18,
  tf0(i)=sqrt(2*(1-1/Vf(i)^2))+1; bef0(i)=0;
end
bef0(10)=pi/2;
