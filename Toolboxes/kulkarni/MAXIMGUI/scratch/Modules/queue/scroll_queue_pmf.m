function scroll_queue_pmf(vdim)

global num_qpmf num_qpmfa QPmf_handles

% Scrolls through values of a matrix using the value of the slider bar

col_dim = size(QPmf_handles, 2) ; 
row_dim = size(num_qpmf, 1) ;
offset = floor((row_dim-vdim)*(1 - get(gcbo, 'Value'))) ;

maxdim = min(vdim, size(QPmf_handles, 1)) ;

for j = 1:maxdim
     set(QPmf_handles(j, 1), 'String', sprintf('%i', num_qpmf(j+offset, 1)))
     set(QPmf_handles(j, 2), 'String', sprintf('%6.5f', sum(num_qpmf(1:j+offset, 2))))
     set(QPmf_handles(j, 3), 'String', sprintf('%i', num_qpmfa(j+offset, 1)))
     set(QPmf_handles(j, 4), 'String', sprintf('%6.5f', sum(num_qpmfa(1:j+offset, 2))))
 end