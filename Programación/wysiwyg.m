function wysiwyg()
units=get(gcf,'units');
set(gcf,'units',get(gcf,'PaperUnits'));
set(gcf,'Position',get(gcf,'PaperPosition'));
set(gcf,'Units',units);
