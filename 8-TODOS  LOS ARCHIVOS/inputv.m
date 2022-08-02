function varargout=inputv(prompt)
%
% [a1,a2,...,a_nargout]=inputv(prompt)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function reads several values on one
% line. The items should be separated by 
% commas or blanks. 
%
% prompt              - A string preceding the 
%                       data entry.  It is set
%                       to ' ? ' if no value of
%                       prompt is given.
% a1,a2,...,a_nargout - The output variables 
%                       that are created. If 
%                       not enough data values
%                       are given following the
%                       prompt, the remaining
%                       undefined values are 
%                       set equal to NaN
%
% A typical function call is:
% [A,B,C,D]=inputv('Enter values of A,B,C,D: ')
%
%----------------------------------------------

if nargin==0, prompt=' ? '; end
u=input(prompt,'s'); v=eval(['[',u,']']);
ni=length(v); no=nargout; 
varargout=cell(1,no); k=min(ni,no);
for j=1:k, varargout{j}=v(j); end
if no>ni
	for j=ni+1:no, varargout{j}=nan; end
end
