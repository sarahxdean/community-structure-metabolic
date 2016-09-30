% add all libraries to the path
addpath(genpath('../wmtsa-matlab-0.2.6'))
addpath(genpath('../BCT'))
addpath(genpath('../GenLouvain2.0'))
addpath(genpath('../commdetect'))
addpath(genpath('../robust_stat'))
addpath(genpath('../pmkmp'))
addpath(genpath('../surfaceViewer'))

% SECTION 1: CREATING THE WEIGHTED GRAPHS FROM RAW DATA. Question: what is
% the sampling period?
all_timeseries = timeseries_import('timeseries_filenames.txt', 518, 630); %file includes relative pathnames

% Option 1: timeseries correlations with a low pass filter
all_timeseries_filtered = timeseries_filter(all_timeseries, (1:518)/600, [0.06 0.12]);
%timeseries_plot
weighted_graphs_t = time_corr_compute(all_timeseries_filtered);

% Option 2: wavelet transform and correlations
[wavelet_correlations, weighted_graphs_w] = wavelet_corr_calc(all_timeseries);
save('weighted_graphs_t', 'weighted_graphs_t')
save('weighted_graphs_w', 'weighted_graphs_w')

% load('weighted_graphs_w.mat')
weighted_graphs = abs(weighted_graphs_w); %consider looking at not just absolute value?

% SECTION 2: comparing raw networks
similarities_raw = all_matrix_similarities(weighted_graphs);
[tuesday_indices, thursday_indices] = tues_thurs_session_keys();
% null test for significance
between_within_similarities_null(similarities_raw, tuesday_indices, thursday_indices, 500, 'Fasted', 'Fed', 'Correlation')
%boxplots and t-test
[tues_tues_sim, thurs_thurs_sim, tues_thurs_sim] = within_between_group_similarities(similarities_raw, tuesday_indices, thursday_indices);
miny = min(vertcat(tues_tues_sim,thurs_thurs_sim,tues_thurs_sim));
maxy = max(vertcat(tues_tues_sim,thurs_thurs_sim,tues_thurs_sim));
boxplot(vertcat(tues_tues_sim,thurs_thurs_sim)); axis([0.7,1.3,miny,maxy])
figure; boxplot(tues_thurs_sim);  axis([0.7,1.3,miny,maxy])
figure; cdfplot(vertcat(tues_tues_sim,thurs_thurs_sim))
hold on; cdfplot(tues_thurs_sim); legend('Within', 'Between')
[h,p ]=ttest2(vertcat(tues_tues_sim,thurs_thurs_sim), tues_thurs_sim);
disp(['Correlation group ttest2 p-value: ' num2str(p)]) % not sure ttest is applicable


% add more analysis at this point? but how -- averaging together the graphs
% for fasted/fed seems bad

% SECTION 3: looking at basic network measures
distances = calc_dists(weighted_graphs);
save('distances_w','distances')
[strengths, clust_coeff, characteristic_pathlength, global_efficiency] = calc_network_measure_logitudinal(weighted_graphs, dist);
strength_average = mean(strengths,1).';
clust_coeff_mean = mean(clust_coeff,1).';

[~,p]=ttest2(strength_average(tuesday_indices),strength_average(thursday_indices));
disp(['Average Strength ttest2 p-value: ' num2str(p)])
[~,p]=ttest2(clust_coeff_mean(tuesday_indices),clust_coeff_mean(thursday_indices));
disp(['Average Clustering ttest2 p-value: ' num2str(p)])
[~,p]=ttest2(characteristic_pathlength(tuesday_indices),characteristic_pathlength(thursday_indices));
disp(['Average Pathlength ttest2 p-value: ' num2str(p)])
[~,p]=ttest2(global_efficiency(tuesday_indices),global_efficiency(thursday_indices));
disp(['Average Efficiency ttest2 p-value: ' num2str(p)])

% SECTION 4: finding partitions, modularity (check for differences)
for gamma = [0.9 1 1.1 1.2]
    disp(gamma)
    [partition_assignment,Q,Qc,qc] = compute_all_partitions(weighted_graphs, gamma, 500, 'Fasted', 'Fed', 'Similarity'); %can up Nreps
    save(['partition_assignment' num2str(gamma)],'partition_assignment')
    save(['Q' num2str(gamma)],'Q')
    save(['Qc' num2str(gamma)],'Qc')
    save(['qc' num2str(gamma)],'qc')
end
% load('partition_assignment1')
% load('Q1')
% load('Qc1')
% load('qc1')

[~,p]=ttest2(Q(tuesday_indices),Q(thursday_indices));
disp(['Average Modularity ttest2 p-value: ' num2str(p)])
[~,p]=ttest2(Qc(tuesday_indices),Qc(thursday_indices));
disp(['Average Modularity of consensus ttest2 p-value: ' num2str(p)])

miny = min(vertcat(Q(tuesday_indices),Q(thursday_indices)));
maxy = max(vertcat(Q(tuesday_indices),Q(thursday_indices)));
figure; boxplot(Q(tuesday_indices)); axis([0.7,1.3,miny,maxy])
figure; boxplot(Q(thursday_indices));  axis([0.7,1.3,miny,maxy])
figure; cdfplot(Q(tuesday_indices))
hold on; cdfplot(Q(thursday_indices)); legend('Fasted', 'Fed')

% SECTION 5: partition similarity, nodal association*, area of brain* (spatial measures *hungarian algorithm)
similarities = all_partition_similarities(partition_assignment);
[tues_tues_sim, thurs_thurs_sim, tues_thurs_sim] = within_between_group_similarities(similarities, tuesday_indices, thursday_indices);
% permutation test
between_within_similarities_null(similarities, tuesday_indices, thursday_indices, 500, 'Fasted', 'Fed', 'Similarity')
% boxlpots 
miny = min(vertcat(tues_tues_sim,thurs_thurs_sim,tues_thurs_sim));
maxy = max(vertcat(tues_tues_sim,thurs_thurs_sim,tues_thurs_sim));
figure; boxplot(vertcat(tues_tues_sim,thurs_thurs_sim)); axis([0.7,1.3,miny,maxy])
figure; boxplot(tues_thurs_sim);  axis([0.7,1.3,miny,maxy])
figure; cdfplot(vertcat(tues_tues_sim,thurs_thurs_sim))
hold on; cdfplot(tues_thurs_sim); legend('Within', 'Between')
[h,p ]=ttest2(vertcat(tues_tues_sim,thurs_thurs_sim), tues_thurs_sim);
disp(['Similarity group ttest2 p-value: ' num2str(p)]) % not sure ttest is applicable
 % more: community size, ~*~hungarian alg and over time~*~

% SECTION 6: consensus partition, nodal association comparison, on-brain
% comparison (alluvial)
tues_consensus = get_consensus_partitions(partition_assignment(tuesday_indices,:));
thurs_consensus = get_consensus_partitions(partition_assignment(thursday_indices,:));

tues_top_partitions = get_top_partitions(tues_consensus, 15);
thurs_top_partitions = get_top_partitions(thurs_consensus, 15);

% node modular allegiance/tues-thurs DIFFERENCES. highlight.. on brain?
compare_nodal_assoc(partition_assignment(tuesday_indices,:), partition_assignment(thursday_indices,:), tues_top_partitions, thurs_top_partitions)

% brain plot of consensus partitions
fcn_myconnectome_surface2(tues_top_partitions.')
fcn_myconnectome_surface2(thurs_top_partitions.')

% Get the alluvial flow daigram:
write_matrix_to_pajek(weighted_graphs(:,:,1), '../final-figures/pajek.net') %need baseline connectivity matrix even though this won't be used
write_partition_to_pajek(tues_top_partitions.', '../final-figures/pajek_tues.clu')
write_partition_to_pajek(thurs_top_partitions.', '../final-figures/pajek_thurs.clu')
%upload files here:
%http://www.mapequation.org/apps/AlluvialGenerator.html#alluvialinstructions
%"Add Network"


% day-by-day: spatial statistics (partition_statistics.m). Inter/intra? 
partition_significance = partition_spatial_statistics(weighted_graphs, 500, partition_assignment, tuesday_indices, thursday_indices, coor);

% Classification algorithm?
partition_sim_as_graph(tuesday_indices, thursday_indices, similarities, 1, 500)

% interesting to look through ALL available data (anxiety, etc) and see if
% tuesday/thursday difference is detected anywhere else

% SECTION 7: supplementary figures
boxplot(strengths,'PlotStyle','compact')
boxplot(clust_coeff,'PlotStyle','compact')
% other metrics

% something about significant modules?

% all: other values of gamma