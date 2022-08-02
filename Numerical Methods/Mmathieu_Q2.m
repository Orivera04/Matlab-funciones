function f3r=Mmathieu_Q2(kf,m,Q,x,varargin);
f1r=Mmathieu_Q3(kf,m,Q,x,varargin);
f2r=Mmathieu_Q1(kf,m,Q,x,varargin);
f3r=-i.*(f1r-f2r);
end