function bigscreen(arg)
%BIGSCREEN  Set graphics properties for large audiences.
%   BIGSCREEN with no arguments sets several Handle Graphics font
%   and line sizes to values appropriate for big screen projectors.
%   BIGSCREEN('off') sets them back to their "factory" defaults.

if nargin == 0 | isequal(arg,'on')
   switch get(0,'screensize')*[0 0 1 0]'
      case 1920
         set(0,'defaultfigureposition',[128 256 1024 768])
         fs = 14;
         lw = 2;
      case 1600
         set(0,'defaultfigureposition',[256 128 1024 896])
         fs = 14;
         lw = 2;
      case 1280
         set(0,'defaultfigureposition',[128 16 1024 768])
         fs = 14;
         lw = 2;
      case 1024
         set(0,'defaultfigureposition',[128 16 768 672]);
         fs = 12;
         lw = 2;
      case 800
         set(0,'defaultfigureposition',[64 32 680 510])
         fs = 12;
         lw = 2;
      otherwise
         warning('Unfamiliar screensize')
         return
   end
   set(0,'defaultuicontrolfontsize',fs)
   set(0,'defaulttextfontsize',fs)
   set(0,'defaultaxesfontsize',fs)
   set(0,'defaultlinemarkersize',fs)
   set(0,'defaultlinelinewidth',lw)
   set(0,'defaultuicontrolfontweight','bold')
   set(0,'defaulttextfontweight','bold')
   set(0,'defaultaxesfontweight','bold')
elseif isequal(arg,'off')
   set(0,'defaultfigureposition','factory');
   set(0,'defaultuicontrolfontsize','factory');
   set(0,'defaulttextfontsize','factory');
   set(0,'defaultaxesfontsize','factory');
   set(0,'defaultlinemarkersize','factory');
   set(0,'defaultlinelinewidth','factory');
   set(0,'defaultuicontrolfontweight','factory');
   set(0,'defaulttextfontweight','factory');
   set(0,'defaultaxesfontweight','factory');
else
   error('Unfamiliar argument')
end
