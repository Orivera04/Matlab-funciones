function varargout=getn(H,varargin)
%GETN Get Multiple Object Properties.
% [Prop1,Prop2,...] = GETN(H,PName1,PName2,...) returns the requested
% properties of the scalar handle H in the corresponding output arguments.
%
% For example, [Xlim,Ylim,Xlabel] = GETN(gca,'Xlim','Ylim','Xlabel')
% returns the requested axes properties in like-named output variables.
%
% This simplifies the construct
% [Xlim,Ylim,Xlabel] = deal(get(gca,{'Xlim','Ylim','Xlabel'}))

if max(size(H))~=1 || ~ishandle(H)
   error('Scalar Object Handle Required.')
end
varargout=get(H,varargin);