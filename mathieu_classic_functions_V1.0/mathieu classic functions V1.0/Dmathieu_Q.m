function csd=Dmathieu_Q(kf,m,Q,xr,csd,varargin);
%     ===============================================================
%     Purpose: Compute Mathieu functions cem'(x,q)and sem'(x,q)
%  
%     Input :  KF  --- Function code
%     KF=1 for computing cem'(x,q)
%     KF=2 for computing sem'(x,q)
%     m   --- Order of Mathieu functions
%     Q   --- Parameter of Mathieu functions(Q<0)
%     x   --- Argument of Mathieu functions(»¡¶È)
%     Output:  CSD --- cem'x,q)or sem'x,q)
%     Routines called:
%(1)CVA2 for computing the characteristic values
%(2)FCOEF for computing the expansion coefficients
%     ===============================================================
q=abs(Q);
ic=fix(fix(m)./2);
eps=1.0d-14;
if(kf == 1&m == 2.*fix(m./2))
   csd=(-1)^(ic+1).*dmathieuq(1,m,q,pi/2-xr);
end;
if(kf == 1&m ~= 2.*fix(m./2))
    csd=(-1)^(ic+1).*dmathieuq(2,m,q,pi/2-xr);
end;
if(kf == 2&m ~= 2.*fix(m./2))
    csd=(-1)^(ic+1).*dmathieuq(1,m,q,pi/2-xr);
end;
if(kf == 2&m == 2.*fix(m./2))
    csd=(-1)^(ic).*dmathieuq(2,m,q,pi/2-xr);
end;