% Script p4_4_03.m; min distance to a point on a sphere; th=latitude,
% ph=longitude, t=distance along the path;       12/96, 1/98, 6/25/98
%
c=pi/180; th0=35.7*c; thf=40.7*c; phf=2*pi-c*(139.7+73.8);
p0=[69.94*c 1.7041]; optn=optimset('Display','Iter','MaxIter',100); 
p=fsolve('geot_f',p0,optn,th0,thf,phf); thm=p(1); tf=p(2);
t=tf*[0:.025:1]; un=ones(1,41); ct=cos(thm); s=sin(thm); 
al=asin(sin(th0)/s); th=asin(s*(sin(t+al*un)));
for i=1:41,
 if t(i)<(pi/2)-al, be(i)=acos(ct/cos(th(i)));
 else be(i)=-acos(ct/cos(th(i))); end;
 b=atan(ct*tan(t(i)+al)); d=atan(ct*tan(al));
 if b>0, ph(i)=b-d; else ph(i)=b-d+pi; end
end;  
%
figure(1); clf; subplot(211), plot(ph/c,th/c,0,th0/c,'ro',phf/c,...
   thf/c,'ro',76,70,'ro'); grid; axis([0 150 30 75]);
ylabel('Latitude \theta (deg)'); text(10,35,'Tokyo');
text(125,35,'New York'); text(60,64,'Prudhoe Bay, Alaska');
subplot(212); plot(ph/c,be/c); grid; 
xlabel('Diff. Long. \phi-\phi_0(deg)'); ylabel('Heading \beta (deg)');
	
	