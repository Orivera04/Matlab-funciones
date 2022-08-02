function scroll_cdf(vdim)

global Num_cdf Cdf_handles

% Scrolls through values of a matrix using the value of the slider bar

col_dim = size(Cdf_handles, 2) ; 
row_dim = size(Num_cdf, 1) ;
offset = floor((row_dim-vdim)*(1 - get(gcbo, 'Value'))) ;

maxdim = min(vdim, size(Cdf_handles, 1)) ;

for j = 1:maxdim
  set(Cdf_handles(j, 1), 'String', sprintf('%i', Num_cdf(j+offset, 1)))
  set(Cdf_handles(j, 2), 'String', sprintf('%7.5f', Num_cdf(j+offset, 2)))
end