function S = get_multiple_partitions(A, N, gamma)
[num_nodes, ~] = size(A);
S = zeros(N,num_nodes);
for j=1:N
    S(j,:) = multislice_static_unsigned(A,gamma); 
end
end