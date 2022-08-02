function h=figurem(varargin)
% function h=figurem(varargin) Silly convience function that replaces figure.
% It installs magnifyrecttofig handlers on figure after calling figure with
% input args. e.g. figurem; plot(.....); 
% Andrew Diamond, EnVision Systems LLC, 3/28/05
if(isempty(varargin))
    if(nargout==0)
        figure;
    else
        h=figure;
    end
else
    if(nargout==0)
        figure(varargin);
    else
        h=figure(varargin);
    end
end
magnifyrecttofig;
