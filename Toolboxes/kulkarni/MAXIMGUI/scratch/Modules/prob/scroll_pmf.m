function scroll_pmf(vdim)

global Num_pmf Pmf_handles

% Scrolls through values of a matrix using the value of the slider bar

col_dim = size(Pmf_handles, 2) ; 
row_dim = size(Num_pmf, 1) ;
offset = floor((row_dim-vdim)*(1 - get(gcbo, 'Value'))) ;

maxdim = min(vdim, size(Pmf_handles, 1)) ;

for j = 1:maxdim
   set(Pmf_handles(j, 1), 'String', sprintf('%i', Num_pmf(j+offset, 1)))
   set(Pmf_handles(j, 2), 'String', sprintf('%7.5f', Num_pmf(j+offset, 2)))
end
