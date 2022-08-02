function d2r=DMmathieu_Q2(kf,m,Q,x,varargin)
d3r=DMmathieu_Q3(kf,m,Q,x,varargin);
d1r=DMmathieu_Q1(kf,m,Q,x,varargin);
d2r=-i.*(d3r-d1r);
end