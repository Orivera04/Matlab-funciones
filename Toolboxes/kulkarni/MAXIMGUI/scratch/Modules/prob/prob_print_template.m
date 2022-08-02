function prob_print_template(fid)

% Outputs data from Probability Models to a printable format
% Usage:  fid: file identifier (created as: fid = fopen(filename, option))

global Primary_state mean_var num_cdf num_pmf

dim = max(size(num_cdf)) ;

% Max number of rows to print on a page 
max_dim = 45 ;    
num_panels = ceil(dim/max_dim) ;

% Titles
model = get_primary_model; 
standard_model=get_std_model_state(model);

title = [Primary_state(model).model ' - ' Primary_state(model).std_model_array{get_std_model_state(model)}] ;
fprintf(fid, '%s \n\n\r', title) ;

% Mean & Variance
fprintf(fid, 'Mean:   ') ;
fprintf(fid, '%12.5f', mean_var(1)) ;
fprintf(fid, '           Variance:    ') ;
fprintf(fid, '%12.5f', mean_var(2)) ;
fprintf(fid, '\n\n\r') ;

% CDF and PDF/PMF (side-by-side)
for panel_i = 1:num_panels
  fprintf(fid, 'CDF:                           PDF/PMF: \n\n\r') ;
  for i = (panel_i-1)*max_dim+1:min(panel_i*max_dim, dim)
    fprintf(fid, '%i %s %7.5f', num_cdf(i, 1), '         ', num_cdf(i, 2)) ;
    fprintf(fid, '%s', '           ') ;
    fprintf(fid, '%i %s %7.5f', num_pmf(i, 1), '         ', num_pmf(i, 2)) ;
    fprintf(fid, '\n\r') ;
  end
  fprintf(fid, '\n\n\r\f') ;
end

