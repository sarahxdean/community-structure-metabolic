function partition_sim_as_graph(a_indices, b_indices, similarities, gamma, Nreps)
[~, ordered] = sort( [a_indices; b_indices]);

figure;
imagesc(similarities([a_indices; b_indices],[a_indices; b_indices]))
colormap(pmkmp(180))
colorbar
axis square

S = compute_all_partitions(similarities([a_indices; b_indices],[a_indices; b_indices]), gamma, Nreps);
figure; imagesc(S(ordered));
figure; imagesc(S(1:length(a_indices)));
figure; imagesc(S(length(a_indices)+1:end));
