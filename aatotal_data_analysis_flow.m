% add all libraries to the path
addpath(genpath('../wmtsa-matlab-0.2.6'))
addpath(genpath('../BCT'))
addpath(genpath('../GenLouvain2.0'))
addpath(genpath('../commdetect'))
addpath(genpath('../robust_stat'))

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

weighted_graphs = abs(weighted_graphs_w); %consider looking at not just absolute value?

% SECTION 2: computing basic network measures
% load('weighted_graphs_t.mat')
% load('weighted_graphs_w)
distances = calc_dists(weighted_graphs);
save('distances_w','distances')
[strength_average, clust_coeff_mean, characteristic_pathlength, global_efficiency] = calc_network_measure_logitudinal(weighted_graphs, distances);

% SECTION 3: finding partitions, modularity
for gamma = [0.9 1 1.1 1.2]
    [partition_assignment,Q,Qc,qc] = compute_all_partitions(weighted_graphs, gamma, 100); %can up Nreps
    save(['partition_assignment' num2str(gamma)],'partition_assignment')
    save(['Q' num2str(gamma)],'Q')
    save(['Qc' num2str(gamma)],'Qc')
    save(['qc' num2str(gamma)],'qc')
end
load('partition_assignment1')
load('Q1')
load('Qc1')
load('qc1')

% SECTION 4: partition measures *hungarian algorithm
similarities = all_partition_similarities(partition_assignment);
[tuesday_indices, thursday_indices] = tues_thurs_session_keys();

tues_tues_sim = nonzeros(triu(similarities(tuesday_indices,tuesday_indices),1));
thurs_thurs_sim = nonzeros(triu(similarities(thursday_indices,thursday_indices),1));
tues_thurs_sim =nonzeros(triu(similarities(tuesday_indices,thursday_indices),1));

% SECTION 5: main figures

% boxplot: similarities, community size, ~*~hungarian alg and over time~*~

% SECTION 6: supplementary figures

% boxplot: other graph statistics, Q/Qc 
% something about significant modules

% all: other values of gamma