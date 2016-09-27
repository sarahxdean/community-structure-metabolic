function similarities = all_partition_similarities(partition_assignment)
[N,m] = size(partition_assignment);
similarities = zeros(N,N);
for i = 1:N
    for j = 1:N
        z = zrand(partition_assignment(i,:),partition_assignment(j,:));
        similarities(i,j) = z;
    end
end