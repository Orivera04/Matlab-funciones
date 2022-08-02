clear P1 P2 P3
% P1.x=[-1 1 1 -1]; P1.y=[-1 -1 1 1]; P1.hole=0;
P1.x=[]; P1.y=[]; P1.hole=0;
P1(2).x=[-1 1 1 -1]*.5; P1(2).y=[-1 -1 1 1]*.5; P1(2).hole=1;

P2.x=[-2 0.8 0.4 -2]; P2.y=[-.5 -.2 0 .5]; P2.hole=0;
P2(2).x=[2 0.8 0.6 1.5]; P2(2).y=[-1 0 0.3 1]; P2(2).hole=0;

% type=0: A-B
% type=1: A.and.B  (Standard)
% type=2: xor(A,B)
% type=3: union(A,B)
type=3;
P3=PolygonClip(P1,P2,type); 

for i=1:3
    eval(['p=P' num2str(i) ';'])
    for np=1:length(p)
        obj=patch(p(np).x,p(np).y,i); 
        if p(np).hole==1; set(obj,'facecolor','w'); end
    end
end
