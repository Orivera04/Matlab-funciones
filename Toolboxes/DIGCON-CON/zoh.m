function [tt,yy]=zoh(t,y)
%ZOH	Zero-order-hold digital-to-analog (D/A) reconstruction.
%	[tt,yy]=zoh(t,y) performs a zero-order-hold reconstruction of the 
%	sampled-data (vector) signal y.  The samples in y correspond to
%	sampling times in the  vector t.  The function returns a new time
%	axis and new samples, tt and yy, that are used to obtain a
%	piecewise constant plot of the signal(s) in y.

%  R.J. Vaccaro 3/00

p=length(y);
if p==length(t)
  tt(1:2:2*p-1)=t;
  tt(2:2:2*p-2)= t(2:p);
  tt(2*p)=t(p)+t(2)-t(1);
  yy(:,1:2:2*p-1)=y;
  yy(:,2:2:2*p)=y;
else
 fprintf('\nError in ZOH: Time axis must have the same number of elements')
 fprintf('\nas the signal.\n\n')
end
return
