function top_partitions = get_top_partitions(consensus,threshold)
top_partitions = zeros(size(consensus));
community = unique(consensus);
count = histc(consensus,community);
j=1;
for i = find(count>threshold)
    top_partitions = top_partitions + j*(consensus == i);
end