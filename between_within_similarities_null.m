function between_within_similarities_null(similarities, a_indices, b_indices, Nrep, aname, bname, measurename)

[a_a_sim, b_b_sim, a_b_sim] = within_between_group_similarities(similarities, a_indices, b_indices);
avg_a_a_sim = mean(a_a_sim);
avg_b_b_sim = mean(b_b_sim);
avg_a_b_sim = mean(a_b_sim);
avg_wtn_sim = mean(vertcat(a_a_sim,b_b_sim));

a = length(a_indices);
b = length(b_indices);

all_indices = vertcat(a_indices, b_indices);
avg_a_a_sim_n = zeros(1,Nrep);
avg_b_b_sim_n = zeros(1,Nrep);
avg_a_b_sim_n = zeros(1,Nrep);
avg_wtn_sim_n = zeros(1,Nrep);

for i = 1:Nrep
    disp(i)
    scrambled = all_indices(randperm(a+b),:);
    null_a = scrambled(1:a,:);
    null_b = scrambled((a+1):end,:);
    [aa, bb, ab] = within_between_group_similarities(similarities,null_a,null_b);
    avg_a_a_sim_n(i) = mean(aa);
    avg_b_b_sim_n(i) = mean(bb);
    avg_wtn_sim_n(i) = mean(vertcat(aa,bb));
    avg_a_b_sim_n(i) = mean(ab);
end

figure;
subplot(1,3,1)
null_histogram_figure(avg_a_b_sim_n, avg_a_b_sim, ...
    ['between group ' measurename], ['Permutation Test for Between Group ' measurename ' Significance'])
subplot(1,3,2)
null_histogram_figure(avg_a_a_sim_n, avg_a_a_sim, ...
    ['within ' aname ' group ' measurename], ['Permutation Test for ' aname ' ' measurename ' Significance'])
subplot(1,3,3)
null_histogram_figure(avg_b_b_sim_n, avg_b_b_sim, ...
    ['within ' aname ' group' measurename], ['Permutation Test for ' bname ' ' measurename ' Similarity Significance'])

figure;
null_histogram_figure(avg_wtn_sim_n - avg_a_b_sim_n, avg_wtn_sim - avg_a_b_sim, ...
    ['within- and between-group ' measurename ' difference'], ['Permutation Test for ' aname ' and ' bname ' Group Difference Significance'])