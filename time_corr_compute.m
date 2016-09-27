function weighted_graphs_t = time_corr_compute(all_timeseries_filtered)
warning('off','MATLAB:nargchk:deprecated')
[n,m,N] = size(all_timeseries_filtered);

correlations = zeros(m,m,N);
weighted_graphs_t = zeros(m,m,N);
weighted_graph_pos = zeros(m,m,N);
weighted_graph_neg = zeros(m,m,N);
for i=1:N
    correlations(:,:,i) = corrcoef(all_timeseries_filtered(:,:,i));
    weighted_graphs_t(:,:,i) = abs(correlations(:,:,i));
    weighted_graph_pos(:,:,i) = correlations(:,:,i) .* (correlations(:,:,i)>0);
    weighted_graph_neg(:,:,i) = abs(correlations(:,:,i) .* (correlations(:,:,i)<0));
    %weighted_graph(:,:,i) = correlations(:,:,i) .* (correlations(:,:,i)>0);
    for j = 1:length(weighted_graphs_t(:,:,i))
        weighted_graphs_t(j,j,i) = 0;
        weighted_graph_pos(j,j,i) = 0;
        weighted_graph_neg(j,j,i) = 0;
    end
end

%correlations_concat = corrcoef(timeseries_concat_filtered);
%weighted_graph_concat = abs(correlations_concat);
%weighted_graph_concat = correlations_concat .* (correlations_concat>0);
%for i = 1:length(weighted_graph_concat)
%    weighted_graph_concat(i,i) = 0;
%end