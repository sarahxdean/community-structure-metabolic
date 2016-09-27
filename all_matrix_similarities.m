function similarities = all_matrix_similarities(weighted_graphs)
[n,m,N] = size(weighted_graphs);
similarities = zeros(N,N);
disp('computing raw correlations between networks')
for i = 1:N
    disp(i)
    for j = 1:N
        c = corrcoef(weighted_graphs(:,:,i),weighted_graphs(:,:,j));
        similarities(i,j) = c(1,2);
    end
end