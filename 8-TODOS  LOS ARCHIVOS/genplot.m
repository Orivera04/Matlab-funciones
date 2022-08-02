function out=genplot(varargin)
%GENPLOT "general plotter"
% Depending on the arguments with which it is called, genplot 
% plots the graph of a function of one or two variables, a contour plot of a
% function of two variables, a parametrized curve in two 
% or three dimensions, or a parametrized surface in three dimensions as a
% surface plot, a mesh plot, or an ensemble of curve plots. The first
% argument is a symbolic function or  parametrization of a curve or surface.
% The next one or two arguments determine the range and number of plotting
% values for each parameter in the form min:step:max. The next argument, if
% present, is one of the MATLAB plotting commands enclosed in quotes. This can 
% be 'plot', 'plot3', 'surf', 'mesh', 'contour', or 'contour3'. There are 
% defaults if no command is specified. The remaining argument, if present, 
% is an additional specification to the plotting command such
% as color, choice of contour(s), etc.
%
% Examples:
% syms x y z
% genplot(sin(x), -2*pi:0.1*pi:2*pi, 'plot', 'b')
% %%  This plots a sine curve in blue.
% genplot(x^2-y^2, -2:0.1:2, -2:0.1:2, 'mesh')
% %%  This plots a saddle surface in 'mesh' style.
% genplot(x^2-y^2, -2:0.1:2, -2:0.1:2) 
% %% or 
% genplot(x^2-y^2, -2:0.1:2, -2:0.1:2, 'surf')
% %%  This plots a saddle surface in 'surf' (solid surface) style.
% genplot(x^2-y^2, -2:0.1:2, -2:0.1:2, 'plot3')
% %%  This plots a saddle surface in 'plot3' (colored line) style.
% genplot(x^2+y^2-z^2, -2:0.1:2, -2:0.1:2, -2:0.1:2, 1)
% %%  This plots the one-sheeted hyperboloid x^2+y^2-z^2=1.
% lemn = (x^2+y^2)^2-x^2+y^2
% genplot(lemn, -2:0.05:2, -2:0.05:2, 'contour', [-.2, -.1, 0, .1, 1, 2, 3])
% %%  This plots the contours lemn = -.2, -.1, 0, .1, 1, 2, 3.
% %%  The contour lemn = 0 is a lemniscate.
%
floc=varargin{1};
locvars=argnames(inline(vectorize(floc)));
%this returns a list of variables occuring in f.
vars=length(locvars);

if length(floc)==1
%%floc is now assumed to be a function.
         gloc=inline(vectorize(floc));
      
      if vars==1
%%This case is equivalent to ezplot.
         xloc=varargin{2};
         yloc=gloc(xloc);
         if nargin==2
            plot(xloc,yloc)
         else
            command=varargin{3};
            if nargin==3
               eval([command,'(xloc,yloc)'])
            else
               spec=varargin{4};
               eval([command,'(xloc,yloc,spec)'])
            end
         end
         
      end
      if vars==2
%%This plots the graph of a function of two variables.
         [xloc, yloc]=meshgrid(varargin{2},varargin{3});
         zloc=gloc(xloc,yloc);
         
         
            if nargin==3 
               surf(xloc,yloc,zloc)
               
            else command=varargin{4};
               if nargin==4
                  eval([command,'(xloc,yloc,zloc)'])
               else spec=varargin{5};
                  if nargin==5
                     eval([command,'(xloc,yloc,zloc,spec)'])
                  else spec2=varargin{6};
                     eval([command,'(xloc,yloc,zloc,spec,spec2)'])
                  end
                  

                     
               end   
            end
         end
         
         if vars==3
            figure;
            [xloc, yloc]=meshgrid(varargin{2},varargin{3});
            gloc=inline(vectorize(floc));
            val=varargin{5};
            for zloc=varargin{4}
            lims = [min(xloc(:)),max(xloc(:)), min(yloc(:)),max(yloc(:))];
    c = contours(xloc,yloc,gloc(xloc,yloc,zloc), [val val]);
    limit = size(c,2);
    i = 1;
    h = [];
	while(i < limit)
	  npoints = c(2,i);
	  nexti = i+npoints+1;
	  xdata = c(1,i+1:i+npoints);
	  ydata = c(2,i+1:i+npoints);
	  zdata = zloc + 0*xdata;  % Make zdata the same size as xdata
	  line('XData',xdata,'YData',ydata,'ZData',zdata); hold on;
	  i = nexti;
	end
end
view(3)
xlabel(char(locvars(1)))
ylabel(char(locvars(2)))
zlabel(char(locvars(3)))
hold off

      end
      end
 if length(floc)==2
    %%The first argument is a two component vector
    if vars==1
       %%f is a parametrized plane curve. The explicit variable in the
       %%next two lines avoids an error if both components do not
       %%depend explicitly on the parameter. char(locvars(1)) returns
       %the symbolic parameter. This will become even
       %%more important in the case of three-component curves
       %%and parametrized surfaces.

      g1loc=inline(vectorize(floc(1)),char(locvars(1)));
      g2loc=inline(vectorize(floc(2)),char(locvars(1)));
      
         tloc=varargin{2};
         xloc=g1loc(tloc);         
         yloc=g2loc(tloc);
         if nargin==2
            plot(xloc,yloc)
         else
            command=varargin{3};
            if nargin==3
               eval([command,'(xloc,yloc)'])
            else
               spec=varargin{4};
               eval([command,'(xloc,yloc,spec)'])
            end
         end
         
               
      end
      if vars==2
         g1loc=inline(vectorize(floc(1)),char(locvars(1)),char(locvars(2)));
         g2loc=inline(vectorize(floc(2)),char(locvars(1)),char(locvars(2)));
         [xloc,yloc]=meshgrid(varargin{2},varargin{3});
         uloc=g1loc(xloc,yloc);
         vloc=g2loc(xloc,yloc);
         quiver(xloc,yloc,uloc,vloc);
      end
      

   end
   if length(floc)==3
      %%The first argument has three components.
      if vars==1

      g1loc=inline(vectorize(floc(1)),char(locvars(1)));      
      g2loc=inline(vectorize(floc(2)),char(locvars(1)));
      g3loc=inline(vectorize(floc(3)),char(locvars(1)));
      %%a parametrized space curve.
         tloc=varargin{2};
         xloc=g1loc(tloc);
         yloc=g2loc(tloc);
         zloc=g3loc(tloc);
         if nargin==2
            if zloc==0
               plot(xloc,yloc)
            else
               plot3(xloc,yloc,zloc)
            end
         else 
            command=varargin{3};
            if nargin==3
               eval([command,'(xloc,yloc,zloc)'])
            else
               spec=varargin{4};
               eval([command,'(xloc,yloc,zloc,spec)'])
            end
         end
                
      
      end
      if vars==2
      %%The case of a parametrized surface.
         g1loc=inline(vectorize(floc(1)),char(locvars(1)),char(locvars(2)));      
         g2loc=inline(vectorize(floc(2)),char(locvars(1)),char(locvars(2)));
         g3loc=inline(vectorize(floc(3)),char(locvars(1)),char(locvars(2)));

         [sloc,tloc]=meshgrid(varargin{2},varargin{3});         
         xloc=g1loc(sloc,tloc);
         yloc=g2loc(sloc,tloc);
         zloc=g3loc(sloc,tloc);
          if nargin==3            
            surf(xloc,yloc,zloc)
         else 
            command=varargin{4};
            if nargin==4
               eval([command,'(xloc,yloc,zloc)'])
            else
               spec=varargin{5};
               eval([command,'(xloc,yloc,zloc,spec)'])
            end
         end
      end
      if vars==3
         g1loc=inline(vectorize(floc(1)),char(locvars(1)),char(locvars(2)),char(locvars(3)));      
         g2loc=inline(vectorize(floc(2)),char(locvars(1)),char(locvars(2)),char(locvars(3)));
         g3loc=inline(vectorize(floc(3)),char(locvars(1)),char(locvars(2)),char(locvars(3)));
         [xloc,yloc,zloc]=meshgrid(varargin{2},varargin{3},varargin{4});
         uloc=g1loc(xloc,yloc,zloc);
         vloc=g2loc(xloc,yloc,zloc);
         wloc=g3loc(xloc,yloc,zloc);
         quiver3(xloc,yloc,zloc,uloc,vloc,wloc);
      end
      
         
   end
   
