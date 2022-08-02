% Script e08_2_1.m; min time path to x=y=0 with uc=-Vy/h; note 
% errors in Example statement: should be y=sec(th)-sec(thf),
% 2x=asinh(tan(thf))-asinh(tan(th))-y*tan(th)-T*sec(thf), and
% expressions for x_th, x_thf, and D are corrected below;
%                                                         12/96, 6/9/02
%
c=pi/180; thf=c*240; th1=c*[105 112.5 120:15:240];
for i=1:length(th1), th=th1(i);
   ta=tan(th); se=1/cos(th); taf=tan(thf); sef=1/cos(thf); T(i)=taf-ta;
   y(i)=se-sef; x(i)=(asinh(taf)-asinh(ta)-y(i)*ta-T(i)*sef)/2;
   yth=se*ta; xth=se^2*(sef-se)+(se-abs(se))/2;                
   ythf=-sef*taf; xthf=sef*(taf*ta-sef^2)+(sef+abs(sef))/2;
   D=xth*ythf-xthf*yth; thx(i)=ythf/D; thy(i)=-xthf/D;           
   Tx(i)=-cos(thf); Ty(i)=-ta*cos(thf);
end
thx(11)=NaN; thy(11)=NaN; Tab=[x; y; th1/c; T; thx; thy; Tx; Ty]';
%
% Example point, x=5, y=.2:
thxp=-.0625-(5.1/15)*(.1380-.0625); thyp=.253+(5.1/15)*(.455-.253);
thp=125.1+(1/c)*(thxp*(5-4.56)+thyp*(.5-.2));
%
% Generate data for Table 8.1:
thf=c*240; th1=c*[100:5:235]; 
for i=1:length(th1), th=th1(i); ta=tan(th); se=1/cos(th); 
  taf=tan(thf); sef=1/cos(thf); T(i)=taf-ta; y(i)=se-sef;
  x(i)=(asinh(taf)-asinh(ta)-y(i)*ta-T(i)*sef)/2; yth=se*ta;
  xth=se^2*(sef-se)+(se-abs(se))/2; ythf=-sef*taf; 
  xthf=sef*(taf*ta-sef^2)+(sef+abs(sef))/2; D=xth*ythf-xthf*yth; 
  thx(i)=ythf/D; thy(i)=-xthf/D; Tx(i)=-cos(thf); Ty(i)=-ta*cos(thf);
end
Tab1=[th1/c; x; y; T; Tx; Ty; thx; thy];
