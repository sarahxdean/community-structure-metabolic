function [partition_assignment, Q, qc] = get_consensus_partitions(A, N, gamma)
S = get_multiple_partitions(A, N, gamma);
[S2, Q2, ~, qc] = consensus_iterative(S);
while qc > 0 %all consensus partitions must agree (max(size(A))*N/100)
    disp('repeating to find agreeing consensus')
    [S2, Q2, ~, qc] = consensus_iterative(S2);
end
partition_assignment = S2(1,:);
Q = nonzeros(Q2(1)); %this Q is the modularity of network weighted by association matrix over partitions 
end
