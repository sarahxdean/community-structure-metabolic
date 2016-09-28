function [strengths, clust_coeff, characteristic_pathlength, global_efficiency] = calc_network_measure_logitudinal(weighted_graphs, dist)
%normalize?

[n,m,N] = size(weighted_graphs);

%calc all average strengths
strengths = zeros(n,N);
for i=1:N
    strengths(:,i) = strengths_und(weighted_graphs(:,:,i));
end

%calc all clusting coeffs
clust_coeff = zeros(n,N);
for i=1:N
    clust_coeff(:,i) = clustering_coef_wu(weighted_graphs(:,:,i));
end

characteristic_pathlength = zeros(N,1);
global_efficiency = zeros(N,1);
for i=1:N
    [characteristic_pathlength(i),global_efficiency(i)] = charpath(dist(:,:,i));
end