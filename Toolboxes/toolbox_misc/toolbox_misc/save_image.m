function save_image(name)

% save_image - save current graphic with given base name
%
%   save_image(name);
%   
%   If you want to save for english version, then you
%   should define a global variable lang with value 'en'.
%
%   Copyright (c) 2004 Gabriel Peyré

global lang;
global base_path;
if ~strcmp(lang,'en')
    lang = 'fr';
end
if isempty(base_path);
    base_path = '/images/';
end

str = [base_path,name];
if strcmp(lang,'fr')==0
    str = [str, '-', lang];    
end
disp(['--> Saving file ', str, '.']);

saveas(gcf, str, 'eps');
saveas(gcf, str, 'png');