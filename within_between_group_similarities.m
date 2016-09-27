function [a_a_sim, b_b_sim, a_b_sim] = within_between_group_similarities(similarities, a_indices, b_indices)
a_a_sim = nonzeros(triu(similarities(a_indices,a_indices),1)); % non-independent. t-test?
b_b_sim = nonzeros(triu(similarities(b_indices,b_indices),1));
a_b_sim =nonzeros(triu(similarities(a_indices,b_indices),1));