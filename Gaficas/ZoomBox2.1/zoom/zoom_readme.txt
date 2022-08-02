This zoom-macro zooms on all x-axes of a figure.

This m-file is the matlab zoom.m, slightly adapted.

This macro is called "zoom.m", like the matlab m-file. This is done on purpose.
The best is, that you overwrite the matlab m-file (take a copy if you are not sure).
If you do that, you can use the zoom buttons on the figure and zooming occurs just
the way you are used to, exept you zoom on all x-axes.

So, drag the mouse and zoom...
So, no use of zoom(h,...) and so on necessary.

This m-file has a default behaviour of zooming on all x-axes.
If you want to zoom on just one axis
--> type "zoom one" (NOT "zoom ON", that's different)
The m-file uses a memory persistant variable, the rest of your matlab session, you will zoom
on just one axis.

If you want to zoom again on all the axes
--> type "zoom all"
Because of the memory persistant variable, the rest of the session will be zooming
on all the axes.

All other zooming-commands, like "zoom on", "zoom off", "zoom XON" and so on, still exist.


The macro is developed under matlab 5.3 but also works with matlab 6.1.