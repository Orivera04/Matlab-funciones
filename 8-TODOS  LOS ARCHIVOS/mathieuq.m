function csf=mathieuq(kf,m,q,xr,csf,varargin);
%     ===============================================================
%     Purpose: Compute Mathieu functions cem(x,q)and sem(x,q)
%  
%     Input :  KF  --- Function code
%     KF=1 for computing cem(x,q)
%     KF=2 for computing sem(x,q)
%     m   --- Order of Mathieu functions
%     q   --- Parameter of Mathieu functions
%     x   --- Argument of Mathieu functions(in radian)
%     Output:  CSF --- cem(x,q)or sem(x,q)
%    
%     Routines called:
%(1)CVA2 for computing the characteristic values
%(2)FCOEF for computing the expansion coefficients
%     ===============================================================
kd=[];a=[];fg=[];
lq=length(q);
 fg=zeros(lq,251);
eps=1.0d-14;
if(kf == 1&m == 2.*fix(m./2))kd=1; end;
if(kf == 1&m ~= 2.*fix(m./2))kd=2; end;
if(kf == 2&m ~= 2.*fix(m./2))kd=3; end;
if(kf == 2&m == 2.*fix(m./2))kd=4; end;

for k=1:lq
[kd,m,q(k),a(k)]=cva2(kd,fix(m),q(k),a);
  if(q(k) <= 1.0d0);
     qm(k)=7.5+56.1.*sqrt(q(k))-134.7.*q(k)+90.7.*sqrt(q(k)).*q(k);
     else;
        qm(k)=17.0+3.1.*sqrt(q(k))-.126.*q(k)+.0037.*sqrt(q(k)).*q(k);
  end;
km(k)=fix(qm(k)+0.5.*fix(m));
end

for k=1:lq
    a;

[kd,m,q(k),a(k),fg([k],:)]=fcoef(kd,fix(m),q(k),a(k));
end

ic=fix(fix(m)./2)+1;

%====================================================
%computate the angle mathieu function
%====================================================

csf=zeros(1,lq);
for vm=1:lq
 for  k=1:km(vm);
   if(kd == 1);

       csf(vm)=csf(vm)+fg(vm,k).*cos((2.*k-2).*xr);
   elseif(kd == 2);
       csf(vm)=csf(vm)+fg(vm,k).*cos((2.*k-1).*xr);
    elseif(kd == 3);
       csf(vm)=csf(vm)+fg(vm,k).*sin((2.*k-1).*xr);
     elseif(kd == 4);
       csf(vm)=csf(vm)+fg(vm,k).*sin(2.*k.*xr);
     end;
   if(k >= ic&abs(fg(vm,k))< abs(csf(vm)).*eps)
       break; 
   end;
 end;
end;
return;
end

function [kd,m,q,a,fc]=fcoef(kd,m,q,a,fc,varargin);
%     =====================================================
%     Purpose: Compute expansion coefficients for Mathieu
%     functions and modified Mathieu functions
%     Input :  m  --- Order of Mathieu functions
%     q  --- Parameter of Mathieu functions
%     KD --- Case code
%     KD=1 for cem(x,q,m = 0,2,4,...)
%     KD=2 for cem(x,q,m = 1,3,5,...)
%     KD=3 for sem(x,q,m = 1,3,5,...)
%     KD=4 for sem(x,q,m = 2,4,6,...)
%     A  --- Characteristic value of Mathieu
%     functions for given m and q
%     Output:  FC(k)--- Expansion coefficients of Mathieu
%     functions(k= 1,2,...,KM)
%     FC(1),FC(2),FC(3),... correspond to
%     A0,A2,A4,... for KD=1 case, A1,A3,
%     A5,... for KD=2 case, B1,B3,B5,...
%     for KD=3 case and B2,B4,B6,... for
%     KD=4 case
%     =====================================================
for  i=1:251;
fc(i)=0.0d0;
end;  i=251+1;
if(q <= 1.0d0);
qm=7.5+56.1.*sqrt(q)-134.7.*q+90.7.*sqrt(q).*q;
else;
qm=17.0+3.1.*sqrt(q)-.126.*q+.0037.*sqrt(q).*q;
end;
km=fix(qm+0.5.*fix(m));
for  k=1:km+1;
fc(k)=0.0d0;
end;  k=km+1+1;
if(q == 0.0d0);
if(kd == 1);
fc((m+2)./2)=1.0d0;
if(m == 0)fc(1)=1.0d0./sqrt(2.0d0); end;
elseif(kd == 4);
fc(m./2)=1.0d0;
else;
fc((m+1)./2)=1.0d0;
end;
return;
end;
kb=0;
s=0.0d0;
f=1.0d-100;
u=0.0d0;
fc(km)=0.0d0;
ifoo=1;
while(ifoo == 1);
if(kd == 1);
for  k=km:-1:3;
v=u;
u=f;
f=(a-4.0d0.*k.*k).*u./q-v;
if(abs(f)< abs(fc(k+1)));
kb=k;
fc(1)=1.0d-100;
sp=0.0d0;
f3=fc(k+1);
fc(2)=a./q.*fc(1);
fc(3)=(a-4.0d0).*fc(2)./q-2.0d0.*fc(1);
u=fc(2);
f1=fc(3);
for  i=3:kb;
v=u;
u=f1;
f1=(a-4.0d0.*(i-1.0d0).^2).*u./q-v;
fc(i+1)=f1;
if(i == kb);
f2=f1;
end;
if(i ~= kb)sp=sp+f1.*f1; end;
end;  i=kb+1;
sp=sp+2.0d0.*fc(1).^2+fc(2).^2+fc(3).^2;
ss=s+sp.*(f3./f2).^2;
s0=sqrt(1.0d0./ss);
for  j=1:km;
if(j <= kb+1);
fc(j)=s0.*fc(j).*f3./f2;
else;
fc(j)=s0.*fc(j);
end;
end;  j=km+1;
ifoo=0;
break;
%GO TO 85
else;
fc(k)=f;
s=s+f.*f;
end;
end;
if(ifoo == 0)break; end;
fc(2)=q.*fc(3)./(a-4.0d0-2.0d0.*q.*q./a);
fc(1)=q./a.*fc(2);
s=s+2.0d0.*fc(1).^2+fc(2).^2;
s0=sqrt(1.0d0./s);
for  k=1:km;
fc(k)=s0.*fc(k);
end;  k=km+1;
elseif(kd == 2|kd == 3);
ifoo2=1;
for  k=km:-1:3;
v=u;
u=f;
f=(a-(2.0d0.*k-1).^2).*u./q-v;
if(abs(f)>= abs(fc(k)));
fc(k-1)=f;
s=s+f.*f;
else;
kb=k;
f3=fc(k);
ifoo2=0;
break;
end;
end;
if(ifoo2 == 1);
fc(1)=q./(a-1.0d0-(-1).^fix(kd).*q).*fc(2);
s=s+fc(1).*fc(1);
s0=sqrt(1.0d0./s);
for  k=1:km;
fc(k)=s0.*fc(k);
end;  k=km+1;
break;
%GO TO 85
end;
fc(1)=1.0d-100;
fc(2)=(a-1.0d0-(-1).^fix(kd).*q)./q.*fc(1);
sp=0.0d0;
u=fc(1);
f1=fc(2);
for  i=2:kb-1;
v=u;
u=f1;
f1=(a-(2.0d0.*i-1.0d0).^2).*u./q-v;
if(i ~= kb-1);
fc(i+1)=f1;
sp=sp+f1.*f1;
else;
f2=f1;
end;
end;  i=kb-1+1;
sp=sp+fc(1).^2+fc(2).^2;
ss=s+sp.*(f3./f2).^2;
s0=1.0d0./sqrt(ss);
for  j=1:km;
if(j < kb);
fc(j)=s0.*fc(j).*f3./f2;
end;
if(j >= kb);
fc(j)=s0.*fc(j);
end;
end;  j=km+1;
elseif(kd == 4);
ifoo2=1;
for  k=km:-1:3;
v=u;
u=f;
f=(a-4.0d0.*k.*k).*u./q-v;
if(abs(f)>= abs(fc(k)));
fc(k-1)=f;
s=s+f.*f;
else;
kb=k;
f3=fc(k);
ifoo2=0;
break;
end;
end;
if(ifoo2 == 1);
fc(1)=q./(a-4.0d0).*fc(2);
s=s+fc(1).*fc(1);
s0=sqrt(1.0d0./s);
for  k=1:km;
fc(k)=s0.*fc(k);
end;  k=km+1;
break;
%GO TO 85
end;
fc(1)=1.0d-100;
fc(2)=(a-4.0d0)./q.*fc(1);
sp=0.0d0;
u=fc(1);
f1=fc(2);
for  i=2:kb-1;
v=u;
u=f1;
f1=(a-4.0d0.*i.*i).*u./q-v;
if(i ~= kb-1);
fc(i+1)=f1;
sp=sp+f1.*f1;
else;
f2=f1;
end;
end;  i=kb-1+1;
sp=sp+fc(1).^2+fc(2).^2;
ss=s+sp.*(f3./f2).^2;
s0=1.0d0./sqrt(ss);
for  j=1:km;
if(j < kb);
fc(j)=s0.*fc(j).*f3./f2;
end;
if(j >= kb);
fc(j)=s0.*fc(j);
end;
end;  j=km+1;
end;
ifoo=0;
end;
if(fc(1)< 0.0d0);
for  j=1:km;
fc(j)=-fc(j);
end;  j=km+1;
end;
return;
end
function [kd,m,q,a]=cva2(kd,m,q,a,varargin);
%     ======================================================
%     Purpose: Calculate a specific characteristic value of
%     Mathieu functions
%     Input :  m  --- Order of Mathieu functions
%     q  --- Parameter of Mathieu functions
%     KD --- Case code
%     KD=1 for cem(x,q,m = 0,2,4,...)
%     KD=2 for cem(x,q,m = 1,3,5,...)
%     KD=3 for sem(x,q,m = 1,3,5,...)
%     KD=4 for sem(x,q,m = 2,4,6,...)
%     Output:  A  --- Characteristic value
%     Routines called:
%(1)REFINE for finding accurate characteristic
%     value using an iteration method
%(2)CV0 for finding initial characteristic
%     values using polynomial approximation
%(3)CVQM for computing initial characteristic
%     values for q ? 3*m
%(3)CVQL for computing initial characteristic
%     values for q ? m*m
%     ======================================================
q1=[];a1=[];q2=[];a2=[];qq=[];iflag=[];
if(m <= 12|q <= 3.0.*m|q > m.*m);
[kd,m,q,a]=cv0(fix(kd),fix(m),q,a);
if(q ~= 0.0d0);
[kd,m,q,a]=refine(fix(kd),fix(m),q,a,1);
end;
else;
ndiv=10;
delta=(fix(m)-3.0).*fix(m)./ndiv;
if((q-3.0.*m)<=(m.*m-q));
while (1);
nn=fix((q-3.0.*fix(m))./delta)+1;
delta=(q-3.0.*fix(m))./nn;
q1=2.0.*fix(m);
[m,q1,a1]=cvqm(fix(m),q1,a1);
q2=3.0.*fix(m);
[m,q2,a2]=cvqm(fix(m),q2,a2);
qq=3.0.*fix(m);
for  i=1:nn;
qq=qq+delta;
a=(a1.*q2-a2.*q1+(a2-a1).*qq)./(q2-q1);
iflag=1;
if(i == nn)iflag=-1; end;
[kd,m,qq,a,iflag]=refine(fix(kd),fix(m),qq,a,iflag);
q1=q2;
q2=qq;
a1=a2;
a2=a;
end;  i=nn+1;
if(iflag == -10);
ndiv=ndiv.*2;
delta=(fix(m)-3.0).*fix(m)./ndiv;
break;
end;
end;
else;
while (1);
nn=fix((fix(m).*fix(m)-q)./delta)+1;
delta=(fix(m).*fix(m)-q)./nn;
q1=fix(m).*(fix(m)-1.0);
[kd,m,q1,a1]=cvql(fix(kd),fix(m),q1,a1);
q2=fix(m).*fix(m);
[kd,m,q2,a2]=cvql(fix(kd),fix(m),q2,a2);
qq=fix(m).*fix(m);
for  i=1:nn;
qq=qq-delta;
a=(a1.*q2-a2.*q1+(a2-a1).*qq)./(q2-q1);
iflag=1;
if(i == nn)iflag=-1; end;
[kd,m,qq,a,iflag]=refine(fix(kd),fix(m),qq,a,iflag);
q1=q2;
q2=qq;
a1=a2;
a2=a;
end;  i=nn+1;
if(iflag == -10);
ndiv=ndiv.*2;
delta=(fix(m)-3.0).*fix(m)./ndiv;
break;
end;
end;
end;
end;
return;
end
function [kd,m,q,a,iflag]=refine(kd,m,q,a,iflag,varargin);
%     =====================================================
%     Purpose: calculate the accurate characteristic value
%     by the secant method
%     Input :  m --- Order of Mathieu functions
%     q --- Parameter of Mathieu functions
%     A --- Initial characteristic value
%     Output:  A --- Refineed characteristic value
%     Routine called:  CVF for computing the value of F for
%     characteristic equation
%     ========================================================
x0=[];mj=[];f0=[];x1=[];f1=[];x=[];f=[];
eps=1.0d-14;
mj=10+fix(m);
x0=a;
[kd,m,q,x0,mj,f0]=cvf(fix(kd),fix(m),q,x0,mj,f0);
x1=1.002.*a;
[kd,m,q,x1,mj,f1]=cvf(fix(kd),fix(m),q,x1,mj,f1);
for  it=1:100;
mj=mj+1;
x=x1-(x1-x0)./(1.0d0-f0./f1);
[kd,m,q,x,mj,f]=cvf(fix(kd),fix(m),q,x,mj,f);
if(abs(1.0-x1./x)< eps|f == 0.0)break; end;
x0=x1;
f0=f1;
x1=x;
f1=f;
end;
a=x;
return;
end
function [kd,m,q,a,mj,f]=cvf(kd,m,q,a,mj,f,varargin);
%     ======================================================
%     Purpose: Compute the value of F for characteristic
%     equation of Mathieu functions
%     Input :  m --- Order of Mathieu functions
%     q --- Parameter of Mathieu functions
%     A --- Characteristic value
%     Output:  F --- Value of F for characteristic equation
%     ======================================================
b=a;
ic=fix(fix(m)./2);
l=0;
l0=0;
j0=2;
jf=ic;
if(kd == 1)l0=2; end;
if(kd == 1)j0=3; end;
if(kd == 2|kd == 3)l=1; end;
if(kd == 4)jf=ic-1; end;
t1=0.0d0;
for  j=mj:-1:ic+1;
t1=-q.*q./((2.0d0.*j+l).^2-b+t1);
end;  j=ic+1-1;
if(m <= 2);
t2=0.0d0;
if(kd == 1&m == 0);
t1=t1+t1;
end;
if(kd == 1&m == 2);
t1=-2.0.*q.*q./(4.0-b+t1)-4.0;
end;
if(kd == 2&m == 1)t1=t1+q; end;
if(kd == 3&m == 1)t1=t1-q; end;
else;
if(kd == 1)t0=4.0d0-b+2.0d0.*q.*q./b; end;
if(kd == 2)t0=1.0d0-b+q; end;
if(kd == 3)t0=1.0d0-b-q; end;
if(kd == 4)t0=4.0d0-b; end;
t2=-q.*q./t0;
for  j=j0:jf;
t2=-q.*q./((2.0d0.*j-l-l0).^2-b+t2);
end;  j=jf+1;
end;
f=(2.0d0.*ic+l).^2+t1+t2-b;
return;
end
function [kd,m,q,a0]=cv0(kd,m,q,a0,varargin);
%     =====================================================
%     Purpose: Compute the initial characteristic value of
%     Mathieu functions for m ? 12  or q ? 300 or
%     q ? m*m
%     Input :  m  --- Order of Mathieu functions
%     q  --- Parameter of Mathieu functions
%     Output:  A0 --- Characteristic value
%     Routines called:
%(1)CVQM for computing initial characteristic
%     value for q ? 3*m
%(2)CVQL for computing initial characteristic
%     value for q ? m*m
%     ====================================================
q2=q.*q;
if(m == 0);
if(q <= 1.0);
a0=(((.0036392.*q2-.0125868).*q2+.0546875).*q2-.5).*q2;
elseif(q <= 10.0);
a0=((3.999267d-3.*q-9.638957d-2).*q-.88297).*q +.5542818;
else;
[kd,m,q,a0]=cvql(fix(kd),fix(m),q,a0);
end;
elseif(m == 1);
if(q <= 1.0&kd == 2);
a0=(((-6.51e-4.*q-.015625).*q-.125).*q+1.0).*q+1.0;
elseif(q <= 1.0&kd == 3);
a0=(((-6.51e-4.*q+.015625).*q-.125).*q-1.0).*q+1.0;
elseif(q <= 10.0& kd == 2);
a0=(((-4.94603d-4.*q+1.92917d-2).*q-.3089229).*q+1.33372).*q+.811752;
elseif(q <= 10.0&kd == 3);
a0=((1.971096d-3.*q-5.482465d-2).*q-1.152218).*q+1.10427;
else;
[kd,m,q,a0]=cvql(fix(kd),fix(m),q,a0);
end;
elseif(m == 2);
if(q <= 1.0&kd == 1);
a0=(((-.0036391.*q2+.0125888).*q2-.0551939).*q2 +.416667).*q2+4.0;
elseif(q <= 1.0&kd == 4);
a0=(.0003617.*q2-.0833333).*q2+4.0;
elseif(q <= 15&kd == 1);
a0=(((3.200972d-4.*q-8.667445d-3).*q -1.829032d-4).*q+.9919999).*q+3.3290504;
elseif(q <= 10.0&kd == 4);
a0=((2.38446d-3.*q-.08725329).*q-4.732542d-3).*q+4.00909;
else;
[kd,m,q,a0]=cvql(fix(kd),fix(m),q,a0);
end;
elseif(m == 3);
if(q <= 1.0&kd == 2);
a0=((6.348e-4.*q+.015625).*q+.0625).*q2+9.0;
elseif(q <= 1.0&kd == 3);
a0=((6.348e-4.*q-.015625).*q+.0625).*q2+9.0;
elseif(q <= 20.0&kd == 2);
a0=(((3.035731d-4.*q-1.453021d-2).*q +.19069602).*q-.1039356).*q+8.9449274;
elseif(q <= 15.0&kd == 3);
a0=((9.369364d-5.*q-.03569325).*q+.2689874).*q +8.771735;
else;
[kd,m,q,a0]=cvql(fix(kd),fix(m),q,a0);
end;
elseif(m == 4);
if(q <= 1.0&kd == 1);
a0=((-2.1e-6.*q2+5.012e-4).*q2+.0333333).*q2+16.0;
elseif(q <= 1.0&kd == 4);
a0=((3.7e-6.*q2-3.669e-4).*q2+.0333333).*q2+16.0;
elseif(q <= 25.0&kd == 1);
a0=(((1.076676d-4.*q-7.9684875d-3).*q +.17344854).*q-.5924058).*q+16.620847;
elseif(q <= 20.0&kd == 4);
a0=((-7.08719d-4.*q+3.8216144d-3).*q +.1907493).*q+15.744;
else;
[kd,m,q,a0]=cvql(fix(kd),fix(m),q,a0);
end;
elseif(m == 5);
if(q <= 1.0&kd == 2);
a0=((6.8e-6.*q+1.42e-5).*q2+.0208333).*q2+25.0;
elseif(q <= 1.0&kd == 3);
a0=((-6.8e-6.*q+1.42e-5).*q2+.0208333).*q2+25.0;
elseif(q <= 35.0&kd == 2);
a0=(((2.238231d-5.*q-2.983416d-3).*q +.10706975).*q-.600205).*q+25.93515;
elseif(q <= 25.0&kd == 3);
a0=((-7.425364d-4.*q+2.18225d-2).*q +4.16399d-2).*q+24.897;
else;
[kd,m,q,a0]=cvql(fix(kd),fix(m),q,a0);
end;
elseif(m == 6);
if(q <= 1.0);
a0=(.4d-6.*q2+.0142857).*q2+36.0;
elseif(q <= 40.0&kd == 1);
a0=(((-1.66846d-5.*q+4.80263d-4).*q +2.53998d-2).*q-.181233).*q+36.423;
elseif(q <= 35.0&kd == 4);
a0=((-4.57146d-4.*q+2.16609d-2).*q-2.349616d-2).*q +35.99251;
else;
[kd,m,q,a0]=cvql(fix(kd),fix(m),q,a0);
end;
elseif(m == 7);
if(q <= 10.0);
[m,q,a0]=cvqm(fix(m),q,a0);
elseif(q <= 50.0&kd == 2);
a0=(((-1.411114d-5.*q+9.730514d-4).*q -3.097887d-3).*q+3.533597d-2).*q+49.0547;
elseif(q <= 40.0&kd == 3);
a0=((-3.043872d-4.*q+2.05511d-2).*q -9.16292d-2).*q+49.19035;
else;
[kd,m,q,a0]=cvql(fix(kd),fix(m),q,a0);
end;
elseif(m >= 8);
if(q <= 3..*m);
[m,q,a0]=cvqm(fix(m),q,a0);
elseif(q > m.*m);
[kd,m,q,a0]=cvql(fix(kd),fix(m),q,a0);
else;
if(m == 8&kd == 1);
a0=(((8.634308d-6.*q-2.100289d-3).*q+.169072).*q -4.64336).*q+109.4211;
elseif(m == 8&kd == 4);
a0=((-6.7842d-5.*q+2.2057d-3).*q+.48296).*q+56.59;
elseif(m == 9&kd == 2);
a0=(((2.906435d-6.*q-1.019893d-3).*q+.1101965).*q -3.821851).*q+127.6098;
elseif(m == 9&kd == 3);
a0=((-9.577289d-5.*q+.01043839).*q+.06588934).*q +78.0198;
elseif(m == 10&kd == 1);
a0=(((5.44927d-7.*q-3.926119d-4).*q+.0612099).*q -2.600805).*q+138.1923;
elseif(m == 10&kd == 4);
a0=((-7.660143d-5.*q+.01132506).*q-.09746023).*q +99.29494;
elseif(m == 11&kd == 2);
a0=(((-5.67615d-7.*q+7.152722d-6).*q+.01920291).*q -1.081583).*q+140.88;
elseif(m == 11&kd == 3);
a0=((-6.310551d-5.*q+.0119247).*q-.2681195).*q +123.667;
elseif(m == 12&kd == 1);
a0=(((-2.38351d-7.*q-2.90139d-5).*q+.02023088).*q -1.289).*q+171.2723;
elseif(m == 12&kd == 4);
a0=(((3.08902d-7.*q-1.577869d-4).*q+.0247911).*q -1.05454).*q+161.471;
end;
end;
end;
return;
end
function [kd,m,q,a0]=cvql(kd,m,q,a0,varargin);
%     ========================================================
%     Purpose: Compute the characteristic value of Mathieu
%     functions  for q ? 3m
%     Input :  m  --- Order of Mathieu functions
%     q  --- Parameter of Mathieu functions
%     Output:  A0 --- Initial characteristic value
%     ========================================================
if(kd == 1|kd == 2)w=2.0d0.*m+1.0d0; end;
if(kd == 3|kd == 4)w=2.0d0.*m-1.0d0; end;
w2=w.*w;
w3=w.*w2;
w4=w2.*w2;
w6=w2.*w4;
d1=5.0+34.0./w2+9.0./w4;
d2=(33.0+410.0./w2+405.0./w4)./w;
d3=(63.0+1260.0./w2+2943.0./w4+486.0./w6)./w2;
d4=(527.0+15617.0./w2+69001.0./w4+41607.0./w6)./w3;
c1=128.0;
p2=q./w4;
p1=sqrt(p2);
cv1=-2.0.*q+2.0.*w.*sqrt(q)-(w2+1.0)./8.0;
cv2=(w+3.0./w)+d1./(32.0.*p1)+d2./(8.0.*c1.*p2);
cv2=cv2+d3./(64.0.*c1.*p1.*p2)+d4./(16.0.*c1.*c1.*p2.*p2);
a0=cv1-cv2./(c1.*p1);
return;
end
function [m,q,a0]=cvqm(m,q,a0,varargin);
%     =====================================================
%     Purpose: Compute the characteristic value of Mathieu
%     functions for q ? m*m
%     Input :  m  --- Order of Mathieu functions
%     q  --- Parameter of Mathieu functions
%     Output:  A0 --- Initial characteristic value
%     =====================================================
hm1=.5.*q./(fix(m).*fix(m)-1.0);
hm3=.25.*hm1.^3./(fix(m).*fix(m)-4.0);
hm5=hm1.*hm3.*q./((fix(m).*fix(m)-1.0).*(fix(m).*fix(m)-9.0));
a0=fix(m).*fix(m)+q.*(hm1+(5.0.*fix(m).*fix(m)+7.0).*hm3 +(9.0.*fix(m).^4+58.0.*fix(m).*fix(m)+29.0).*hm5);
return;
end