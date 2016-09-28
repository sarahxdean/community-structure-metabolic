function plot_colored_matrix(A, n)
figure;
imagesc(A)
colormap(pmkmp(n))
set(gca, 'CLim', [0, max(max(A))]);
colorbar
axis square
set(gca, 'XTick', [], 'XTickLabel', [])
set(gca, 'YTick', [], 'YTickLabel', [])