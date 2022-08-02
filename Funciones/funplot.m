function funplot(f,lims)

% Simple function plotter.

% Test for characters that f is a function rather than a function name:
if any(f<48)
  f = inline(f);
end


x = linspace(lims(1),lims(2));
y = feval(f,x);
clf
plot(x,y)
