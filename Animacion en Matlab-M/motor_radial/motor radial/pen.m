function [ppx,ppy]=pen(pm,tb,rb)
%rb=10;
f=0;
for i=1:6
    pp(i,:)=pm+rb*[-cos(tb+f),sin(tb+f)];
    f=f+72*pi/180;
end

ppx=pp(:,1);
ppy=pp(:,2);
ppx(1)=0;
ppy(1)=0;
ppx(6)=0;
ppy(6)=0;