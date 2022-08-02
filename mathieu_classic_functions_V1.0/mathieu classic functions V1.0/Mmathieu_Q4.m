function f4r=Mmathieu_Q4(kf,m,Q,x,varargin)
f1r=Mmathieu_Q1(kf,m,Q,x,varargin);
f2r=Mmathieu_Q3(kf,m,Q,x,varargin);
f4r=2.*f1r-f2r;
end