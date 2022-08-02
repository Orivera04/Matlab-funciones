function [val,bp,wf]=gcquad(func,xlow,...
                     xhigh,nquad,mparts,varargin)
%
% [val,bp,wf]=gcquad(func,xlow,...
%     xhigh,nquad,mparts,varargin)

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function integrates a general function using 
% a composite Gauss formula of arbitrary order. The 
% integral value is returned along with base point and
% weight factor vectors computed by a formulation using 
% eigenvalue calculation. The integration interval is
% divided into mparts sections of equal length and 
% integration over each part is performed with a Gauss
% formula making nquad function evaluations. Results 
% are exact for polynomials of degree up to 2*nquad-1.   
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% func         - name of a function to be integrated
%                having an argument list of the form
%                func(x,p1,p2,...) where any auxiliary
%                parameters p1,p2,.. are passed through
%                variable varargin. Use [ ] for the
%                function name if only the base points
%                and weight factors are needed.
% xlow,xhigh   - integration limits
% nquad        - order of Gauss formula chosen
% mparts       - number of subintervals selected in 
%                the composite integration
% varargin     - variable length parameter used to
%                pass additional arguments needed in
%                the integrand func
% val          - numerical value of the integral
% bp,wf        - vectors containing base points and 
%                weight factors in the composite
%                integral formula
%
% A typical calculation such as:
% Fun=inline('(sin(w*t).^2).*exp(c*t)','t','w','c');
% A=0; B=12; nquad=21; mparts=10; w=10; c=8;  
% [value,pcterr]=integrate(Fun,A,B,nquad,mparts,w,c);
% gives value = 1.935685556078172e+040 which is 
% accurate within an error of 1.9e-13 percent.
%
% User m functions called:  the function name passed 
%                           in the argument list

%----------------------------------------------

 if isempty(nquad),  nquad=10; end
 if isempty(mparts), mparts=1; end

% Compute base points and weight factors 
% for the single interval [-1,1]. (Ref:
% 'Methods of Numerical Integration' by
% P. Davis and P. Rabinowitz, page 93)

u=(1:nquad-1)./sqrt((2*(1:nquad-1)).^2-1);
[vc,bp]=eig(diag(u,-1)+diag(u,1));
[bp,k]=sort(diag(bp)); wf=2*vc(1,k)'.^2;

% Modify the base points and weight factors
% to apply for a  composite interval
d=(xhigh-xlow)/mparts;  d1=d/2;
dbp=d1*bp(:); dwf=d1*wf(:);  dr=d*(1:mparts);
cbp=dbp(:,ones(1,mparts))+ ...
dr(ones(nquad,1),:)+(xlow-d1);
cwf=dwf(:,ones(1,mparts)); wf=cwf(:); bp=cbp(:);

% Compute the integral
if isempty(func)
  val=[];
else
  f=feval(func,bp,varargin{:}); val=wf'*f(:);
end