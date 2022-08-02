%This function generates the Sierpinski Sponge.
% n=level of iterations
function Sponge(n)
if (n==0)
   vertices=[0 0 0;1 0 0;1 1 0;0 1 0;0 0 1;1 0 1;1 1 1;0 1 1];
   faces=[1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;1 2 3 4;5 6 7 8];
   patch('Vertices',vertices,'Faces',faces,'FaceVertexCData',hsv(6),'FaceColor','flat')
   good_axis
else
   levelcontrol=10^n;
   L=(levelcontrol/(3^n));  
   l=ceil(L);
   carp(0,0,0,levelcontrol,0,0,levelcontrol,levelcontrol,0,0,levelcontrol,0,0,0,levelcontrol,levelcontrol,0,levelcontrol,levelcontrol,levelcontrol,levelcontrol,0,levelcontrol,levelcontrol,l)
   good_axis;
end
%--------------------------------------------------------------------------
function carp(x1,y1,z1,x4,y4,z4,x52,y52,z52,x49,y49,z49,x13,y13,z13,x16,y16,z16,x64,y64,z64,x61,y61,z61,limit)
if(abs(x1-x4)>limit|abs(x16-x4)>limit|abs(x16-x13)>limit|abs(x13-x1)>limit|abs(x1-x49)>limit|abs(x61-x49)>limit|abs(x61-x13)>limit|abs(x64-x16)>limit|abs(x64-x52)>limit|abs(x52-x4)>limit|abs(x64-x61)>limit|abs(x52-x49)>limit|...
      abs(y1-y4)>limit|abs(y16-y4)>limit|abs(y16-y13)>limit|abs(y13-y1)>limit|abs(y1-y49)>limit|abs(y61-y49)>limit|abs(y61-y13)>limit|abs(y64-y16)>limit|abs(y64-y52)>limit|abs(y52-y4)>limit|abs(y64-y61)>limit|abs(y52-y49)>limit|...
      abs(z1-z4)>limit|abs(z16-z4)>limit|abs(z16-z13)>limit|abs(z13-z1)>limit|abs(z1-z49)>limit|abs(z61-z49)>limit|abs(z61-z13)>limit|abs(z64-z16)>limit|abs(z64-z52)>limit|abs(z52-z4)>limit|abs(z64-z61)>limit|abs(z52-z49)>limit)
   
   a=abs((x4-x1)/3);
   b=abs((y49-y1)/3);
   c=abs((z13-z1)/3);
   
   x2=x1+a;    y2=y1;      z2=z1;                  
   x3=x1+2*a;  y3=y1;      z3=z1;
   x5=x1;      y5=y1;      z5=z1+c;
   x6=x1+a;    y6=y1;      z6=z1+c;
   x7=x1+2*a;  y7=y1;      z7=z1+c;
   x8=x4;      y8=y1;      z8=z1+c;
   x9=x1;      y9=y1;      z9=z1+2*c;
   x10=x1+a;   y10=y1;     z10=z1+2*c;
   x11=x1+2*a; y11=y1;     z11=z1+2*c;
   x12=x4;     y12=y1;     z12=z1+2*c;
   x14=x1+a;   y14=y1;     z14=z13;
   x15=x1+2*a; y15=y1;     z15=z13;
   x17=x1;     y17=y1+b;   z17=z1;
   x18=x1+a;   y18=y1+b;   z18=z1;
   x19=x1+2*a; y19=y1+b;   z19=z1;
   x20=x4;     y20=y1+b;   z20=z1;
   x21=x1;     y21=y1+b;   z21=z1+c;
   x22=x1+a;   y22=y1+b;   z22=z1+c;
   x23=x1+2*a; y23=y1+b;   z23=z1+c;
   x24=x4;     y24=y1+b;   z24=z1+c;
   x25=x1;     y25=y1+b;   z25=z1+2*c;
   x26=x1+a;   y26=y1+b;   z26=z1+2*c;
   x27=x1+2*a; y27=y1+b;   z27=z1+2*c;
   x28=x4;     y28=y1+b;   z28=z1+2*c;
   x29=x1;     y29=y1+b;   z29=z13;
   x30=x1+a;   y30=y1+b;   z30=z13;
   x31=x1+2*a; y31=y1+b;   z31=z13;
   x32=x4;     y32=y1+b;   z32=z13;
   x33=x1;     y33=y1+2*b; z33=z1;
   x34=x1+a;   y34=y1+2*b; z34=z1;
   x35=x1+2*a; y35=y1+2*b; z35=z1;
   x36=x4;     y36=y1+2*b; z36=z1;
   x37=x1;     y37=y1+2*b; z37=z1+c;
   x38=x1+a;   y38=y1+2*b; z38=z1+c;
   x39=x1+2*a; y39=y1+2*b; z39=z1+c;
   x40=x4;     y40=y1+2*b; z40=z1+c;
   x41=x1;     y41=y1+2*b; z41=z1+2*c;
   x42=x1+a;   y42=y1+2*b; z42=z1+2*c;
   x43=x1+2*a; y43=y1+2*b; z43=z1+2*c;
   x44=x4;     y44=y1+2*b; z44=z1+2*c;
   x45=x1;     y45=y1+2*b; z45=z13;
   x46=x1+a;   y46=y1+2*b; z46=z13;
   x47=x1+2*a; y47=y1+2*b; z47=z13;
   x48=x4;     y48=y1+2*b; z48=z13;
   x50=x1+a;   y50=y49;    z50=z1;
   x51=x1+2*a; y51=y49;    z51=z1;
   x53=x1;     y53=y49;    z53=z1+c;
   x54=x1+a;   y54=y49;    z54=z1+c;
   x55=x1+2*a; y55=y49;    z55=z1+c;
   x56=x4;     y56=y49;    z56=z1+c;
   x57=x1;     y57=y49;    z57=z1+2*c;
   x58=x1+a;   y58=y49;    z58=z1+2*c;
   x59=x1+2*a; y59=y49;    z59=z1+2*c;
   x60=x4;     y60=y49;    z60=z1+2*c;
   x62=x1+a;   y62=y49;    z62=z13;
   x63=x1+2*a; y63=y49;    z63=z13;
   
   carp(x1,y1,z1,x2,y2,z2,x18,y18,z18,x17,y17,z17,x5,y5,z5,x6,y6,z6,x22,y22,z22,x21,y21,z21,limit);
   carp(x2,y2,z2,x3,y3,z3,x19,y19,z19,x18,y18,z18,x6,y6,z6,x7,y7,z7,x23,y23,z23,x22,y22,z22,limit);
   carp(x3,y3,z3,x4,y4,z4,x20,y20,z20,x19,y19,z19,x7,y7,z7,x8,y8,z8,x24,y24,z24,x23,y23,z23,limit);
   carp(x17,y17,z17,x18,y18,z18,x34,y34,z34,x33,y33,z33,x21,y21,z21,x22,y22,z22,x38,y38,z38,x37,y37,z37,limit);
   carp(x19,y19,z19,x20,y20,z20,x36,y36,z36,x35,y35,z35,x23,y23,z23,x24,y24,z24,x40,y40,z40,x39,y39,z39,limit);
   carp(x33,y33,z33,x34,y34,z34,x50,y50,z50,x49,y49,z49,x37,y37,z37,x38,y38,z38,x54,y54,z54,x53,y53,z53,limit);
   carp(x34,y34,z34,x35,y35,z35,x51,y51,z51,x50,y50,z50,x38,y38,z38,x39,y39,z39,x55,y55,z55,x54,y54,z54,limit);
   carp(x35,y35,z35,x36,y36,z36,x52,y52,z52,x51,y51,z51,x39,y39,z39,x40,y40,z40,x56,y56,z56,x55,y55,z55,limit);
   carp(x5,y5,z5,x6,y6,z6,x22,y22,z22,x21,y21,z21,x9,y9,z9,x10,y10,z10,x26,y26,z26,x25,y25,z25,limit);
   carp(x7,y7,z7,x8,y8,z8,x24,y24,z24,x23,y23,z23,x11,y11,z11,x12,y12,z12,x28,y28,z28,x27,y27,z27,limit);
   carp(x37,y37,z37,x38,y38,z38,x54,y54,z54,x53,y53,z53,x41,y41,z41,x42,y42,z42,x58,y58,z58,x57,y57,z57,limit);
   carp(x39,y39,z39,x40,y40,z40,x56,y56,z56,x55,y55,z55,x43,y43,z43,x44,y44,z44,x60,y60,z60,x59,y59,z59,limit);
   carp(x9,y9,z9,x10,y10,z10,x26,y26,z26,x25,y25,z25,x13,y13,z13,x14,y14,z14,x30,y30,z30,x29,y29,z29,limit);
   carp(x10,y10,z10,x11,y11,z11,x27,y27,z27,x26,y26,z26,x14,y14,z14,x15,y15,z15,x31,y31,z31,x30,y30,z30,limit);
   carp(x11,y11,z11,x12,y12,z12,x28,y28,z28,x27,y27,z27,x15,y15,z15,x16,y16,z16,x32,y32,z32,x31,y31,z31,limit);
   carp(x25,y25,z25,x26,y26,z26,x42,y42,z42,x41,y41,z41,x29,y29,z29,x30,y30,z30,x46,y46,z46,x45,y45,z45,limit);
   carp(x27,y27,z27,x28,y28,z28,x44,y44,z44,x43,y43,z43,x31,y31,z31,x32,y32,z32,x48,y48,z48,x47,y47,z47,limit);
   carp(x41,y41,z41,x42,y42,z42,x58,y58,z58,x57,y57,z57,x45,y45,z45,x46,y46,z46,x62,y62,z62,x61,y61,z61,limit);
   carp(x42,y42,z42,x43,y43,z43,x59,y59,z59,x58,y58,z58,x46,y46,z46,x47,y47,z47,x63,y63,z63,x62,y62,z62,limit);
   carp(x43,y43,z43,x44,y44,z44,x60,y60,z60,x59,y59,z59,x47,y47,z47,x48,y48,z48,x64,y64,z64,x63,y63,z63,limit);
else
   fillcub(x1,y1,z1,x4,y4,z4,x52,y52,z52,x49,y49,z49,x13,y13,z13,x16,y16,z16,x64,y64,z64,x61,y61,z61);
end
%--------------------------------------------------------------------------
function fillcub(a1,b1,c1,a2,b2,c2,a3,b3,c3,a4,b4,c4,a5,b5,c5,a6,b6,c6,a7,b7,c7,a8,b8,c8)
verticesA=[a1,b1,c1;a2,b2,c2;a3,b3,c3;a4,b4,c4;a5,b5,c5;a6,b6,c6;a7,b7,c7;a8,b8,c8];
faces=[1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;1 2 3 4;5 6 7 8];
patch('Vertices',verticesA,'Faces',faces,'FaceVertexCData',hsv(6),'FaceColor','flat');
hold on;
%--------------------------------------------------------------------------
function good_axis
axis equal
view(3)
set(gca,'Visible','off')