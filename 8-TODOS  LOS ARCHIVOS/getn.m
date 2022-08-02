function varargout=getn(H,varargin)
%GETN Get Multiple Object Properties.
% [Prop1,Prop2,...]=GETN(H,PName1,PName2,...)
% returns the requested properties of the scalar handle H in
% the corresponding output arguments.
%
% For example, [Xlim,Ylim,Xlabel]=get(gca,'Xlim','Ylim','Xlabel')
% returns the requested axes properties in like-named output variables.
%
% This simplifies the construct
% [Xlim,Ylim,Xlabel]=deal(get(gca,{'Xlim','Ylim','Xlabel'}))

% This function mimics one of the features of MMGET in the
% Mastering MATLAB Toolbox. www.eece.maine.edu/mm
% This function demonstrates the power of varargin and varargout.
% D.C. Hanselman, University of Maine, Orono, ME  04469-5708

if max(size(H))~=1|~ishandle(H)
   error('Scalar Object Handle Required.')
end
varargout=get(H,varargin);