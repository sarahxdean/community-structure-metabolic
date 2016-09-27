function distances = calc_dists(weighted_graphs)
disp('computing network distances')
[n,m,N] = size(weighted_graphs);
distances = zeros(n,n,N);
for i=1:N
   distances(:,:,i) = distance_wei(1./weighted_graphs(:,:,i));
   disp(i)
end
