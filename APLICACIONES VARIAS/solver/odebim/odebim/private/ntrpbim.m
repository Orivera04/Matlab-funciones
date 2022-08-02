function [yinterp,ypinterp] = ntrpbim(tinterp,t,y,tnew,ynew,h,dd,k,idxNonNegative)

   


yinterp = y(:,ones(size(tinterp)));
ypinterp = [];
% for i = 1:length(y)
%   yinterp(i,:) =  interp1([t;tnew(1:k)],[y(i),ynew(i,1:k)],tinterp);
% end


for ti = 1:length(tinterp)
    dt = (tinterp(ti)-tnew)/h;
    yinterp(:,ti) = dd(k+1,:)';
    for ki = k:-1:1
        dt = dt+1.0;
        yinterp(:,ti) = yinterp(:,ti)*dt+dd(ki,:)';
    end
end
  if nargout > 1
    ypinterp = [];
  end  

% Non-negative solution
if ~isempty(idxNonNegative)
  idx = find(yinterp(idxNonNegative,:)<0); % vectorized
  if ~isempty(idx)
    w = yinterp(idxNonNegative,:);
    w(idx) = 0;
    yinterp(idxNonNegative,:) = w;
    if nargout > 1   % the derivative
      w = ypinterp(idxNonNegative,:);
      w(idx) = 0;
      ypinterp(idxNonNegative,:) = w;
    end      
  end
end  