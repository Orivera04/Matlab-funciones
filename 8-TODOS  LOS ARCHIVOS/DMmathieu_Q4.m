function d4r=DMmathieu_Q4(kf,m,Q,x,varargin)
d3r=DMmathieu_Q3(kf,m,Q,x,varargin);
d1r=DMmathieu_Q1(kf,m,Q,x,varargin);
d4r=2.*d1r-d3r;
end