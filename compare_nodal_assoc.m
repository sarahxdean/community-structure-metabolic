function compare_nodal_assoc(a_all_part, b_all_part, a_top_part, b_top_part)
X = get_nodal_assoc(vertcat(a_all_part, b_all_part));
X_tues = get_nodal_assoc(a_all_part);
X_thurs = get_nodal_assoc(b_all_part);
X_diff = X_tues-X_thurs;


[~, order] = sort(a_top_part);
plot_colored_matrix(X_tues(order,order,1),180)
plot_colored_matrix(abs(X_diff(order,order,1)),180)

[~, order] = sort(b_top_part);
plot_colored_matrix(X_thurs(order,order,1),180)
plot_colored_matrix(abs(X_diff(order,order,1)),180)

%[assoc_partition_assignment, Qc, qc] = get_consensus_partitions(get_multiple_partitions(abs(X_tues-X_thurs), 100, 1));
%fcn_myconnectome_surface2(assoc_partition_assignment.') % nodes are in the same module if they differ strongly with other nodes in that module?