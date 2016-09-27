function between_within_similarities_null(similarities, a_indices, b_indices, Nrep)

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
histfit(avg_a_b_sim_n,12,'normal')
disp(avg_a_b_sim)
xh = [avg_a_b_sim avg_a_b_sim]; yh = [0 100];
hold on; plot(xh,yh,'LineWidth',2)

figure;
histfit(avg_a_a_sim_n,12,'normal')
disp(avg_a_a_sim)
xh = [avg_a_a_sim avg_a_a_sim]; yh = [0 100];
hold on; plot(xh,yh,'LineWidth',2)

figure;
histfit(avg_b_b_sim_n,12,'normal')
disp(avg_b_b_sim)
xh = [avg_b_b_sim avg_b_b_sim]; yh = [0 100];
hold on; plot(xh,yh,'LineWidth',2)

figure;
histfit(avg_wtn_sim_n - avg_a_b_sim_n,12,'normal')
disp(avg_wtn_sim - avg_a_b_sim)
xh = [(avg_wtn_sim - avg_a_b_sim) (avg_wtn_sim - avg_a_b_sim)]; yh = [0 100];
hold on; plot(xh,yh,'LineWidth',2)
xlabel('within- and between-group similarity difference')
title('(c) Permutation Test for Fasted and Fed Group Difference Significance')