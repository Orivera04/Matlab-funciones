function v=mmppval(pp,xx)
%MMPPVAL Evaluate 1-D Piecewise Polynomial. (MM)
% MMPPVAL(PP,XI) evaluates the piecewise polynomial PP
% at the points specified in XI.
%
% This function is equivalent to PPVAL, but faster since
% it is restricted to 1-D polynomials and it uses HISTC to
% find the local coordinates of each point in XI.
%
% For scalar XI, it is even faster.

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 02/20/01
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if ~isa(pp,'struct')| ~strcmp(pp.form,'pp') | pp.dim>1
   error('1-D piecewise polynomial required.')
end
if numel(xx)==1   % scalar input
   idx=find(xx>=pp.breaks);
   if isempty(idx)               % extrapolate if necessary
      idx=1;
   elseif idx(end)>pp.pieces
      idx=pp.pieces;
   end
   xs=xx-pp.breaks(idx(end));    % local coordinates
   c=pp.coefs(idx(end),:);       % local polynomial
   if pp.order==4                % quick eval for cubic spline
      v=((c(1)*xs + c(2))*xs + c(3))*xs +c(4);
   else
      v=c(1);
      for i=2:pp.order           % apply Horner's method
         v=xs.*v+c(i);
      end
   end
   
else              % array input
   
   x=pp.breaks;
   c=pp.coefs.';
   [rx,cx] = size(xx);
	xs=xx(:).';
	lx=length(xs); 
	tosort=0;
	if any(diff(xs)<0)
      tosort=1;[xs,ix]=sort(xs);
	end
	% for each data point, compute its breakpoint interval
	[ignore,idx]=histc(xs,x);
	idx(xs<x(1)|~isfinite(xs))=1; % extrapolate using first
	idx(xs>=x(end))=pp.pieces;    % and last polynomial
	
	xs=xs-x(idx);                 % local coordinates
   if pp.order==4                % quick eval for cubic spline
      v=((c(1,idx).*xs + c(2,idx)).*xs + c(3,idx)).*xs +c(4,idx);
   else
		v=c(1,idx);
		for i=2:pp.order           % apply Horner's method
         v=xs.*v+c(i,idx);
		end
   end
	
	if tosort
      v(ix)=v;
	end
	v=reshape(v,rx,cx);
end