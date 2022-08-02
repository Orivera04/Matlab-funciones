function z=plotpoint(point,radius)
syms t
syms s
thesphere=point+radius*[sin(s)*cos(t),sin(s)*sin(t),cos(s)]
plotsurface(thesphere,s,0,pi,t,0,2*pi)