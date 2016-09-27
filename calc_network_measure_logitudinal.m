function [strength_average, clust_coeff_mean, characteristic_pathlength, global_efficiency] = calc_network_measure_logitudinal(weighted_graphs, dist)
%normalize?

[n,m,N] = size(weighted_graphs);

%calc all average strengths
strengths = zeros(n,N);
for i=1:N
    strengths(:,i) = strengths_und(weighted_graphs(:,:,i));
end
strength_average = mean(strengths,1).';

%calc all clusting coeffs
clust_coeff_mean = zeros(N,1);
for i=1:N
    clust_coeff_mean(i) = mean(mean(clustering_coef_wu(weighted_graphs(:,:,i))));
end

characteristic_pathlength = zeros(N,1);
global_efficiency = zeros(N,1);
for i=1:N
    [characteristic_pathlength(i),global_efficiency(i)] = charpath(dist(:,:,i));
end