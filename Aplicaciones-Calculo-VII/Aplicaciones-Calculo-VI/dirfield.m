function dirfield(f,tval,yval)
% dirfield(f, t1:dt:t2, y1:dy:y2)
%   
%   plot direction field for first order ODE y' = f(t,y)
%   using t-values from t1 to t2 with spacing of dt
%   using y-values from y1 to t2 with spacing of dy
%
%   f is the name of an inline function (without quotes),
%     or the name of an m-file (with quotes).
%
% Example: y' = -y^2 + t
%   Show direction field for t in [-1,3], y in [-2,2], use
%   spacing of .2 for both t and y:
%
%   f = inline('-y^2 + t','t','y')
%   dirfield(f, -1:.2:3, -2:.2:2)

[tm,ym]=meshgrid(tval,yval);
dt = tval(2) - tval(1); 
dy = yval(2) - yval(1);
yp=feval(vectorize(f),tm,ym); 
s = 1./max(1/dt,abs(yp)./dy)*0.35;
h = ishold;
quiver(tval,yval,s,s.*yp,0,'.r'); hold on;
quiver(tval,yval,-s,-s.*yp,0,'.r');
if h
  hold on
else
  hold off
end

axis tight;
