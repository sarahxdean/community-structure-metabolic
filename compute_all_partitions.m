function [partition_assignment,Q,Qc,qc] = compute_all_partitions(weighted_graphs, gamma, Nreps)
n,m,N = size(weighted_graphs);

partition_assignment = zeros(N,n);
Q = zeros(N,1);
Qc = zeros(N,1);
qc = zeros(N,1); % qc: fraction of nodes that are repelling (wrt null model)
for i=1:N
    disp('-------------------------------------------------------------------------------------')
    disp(i)
    [partition_assignment(i,:), Qc(i), qc(i)] = get_consensus_partitions(get_multiple_partitions(A, Nreps, gamma));
    Q(i) = modularity_measure(weighted_graphs(:,:,i),gamma, partition_assignment(i,:)); 
end
% 
% [Y I] = sort(partition_assignment(1,:));
% rearranged = weighted_graphs(I,I,1);
% figure;
% imagesc(abs(rearranged))
% 
% [Y I] = sort(partition_assignment(5,:));
% rearranged = weighted_graphs(I,I,5);
% figure;
% imagesc(abs(rearranged))