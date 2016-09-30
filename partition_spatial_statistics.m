function partition_significance = partition_spatial_statistics(weighted_graphs, Nreps, partition_assignment, a_indices, b_indices, coor) %coor in node_assign.mat

% need to get number of nodes in each partition
partition_hist = histc(partition_assignment.',unique(partition_assignment.'));
bar3(partition_hist)
[m,~] = size(partition_hist);

partition_significance = ones(84,m);
for i=1:84
    [sigMatrix, ~, ~] = sig_permtest(partition_assignment(i,:),weighted_graphs(:,:,i),Nreps);
    signif_diag = sigMatrix(1:size(sigMatrix,1)+1:end);
    partition_significance(i,1:length(signif_diag)) = signif_diag;
end
sig_10 = partition_significance<0.1;
sig_05 = partition_significance<0.05;

%% pairwise %%
pairwise_dists = zeros(7,84); % todo more than just average?
for i=1:84
    dists = comm_ave_pairwise_spatial_dist(partition_assignment(i,:),coor); 
    pairwise_dists(1:6,i) = [dists(1:end-1,2);zeros(6-length(dists(1:end-1,2)),1)];
    pairwise_dists(7,i) = dists(end,2);
end

average_pairwise_dists = sum(pairwise_dists(1:m,:).*(partition_hist),1)/630;
average_pairwise_dists_10 = sum(pairwise_dists(1:m,:).*(partition_hist.*sig_10.'),1)./(sum(partition_hist.*sig_10.'));
average_pairwise_dists_05 = sum(pairwise_dists(1:m,:).*(partition_hist.*sig_05.'),1)./(sum(partition_hist.*sig_05.'));

[h,p] = ttest2(average_pairwise_dists(a_indices),average_pairwise_dists(b_indices))
[h,p] = ttest2(average_pairwise_dists_05(a_indices),average_pairwise_dists_05(b_indices))
[h,p] = ttest2(average_pairwise_dists_10(a_indices),average_pairwise_dists_10(b_indices))

%% laterality
laterality = zeros(1,630);
laterality(1:309) = 1; % LEFT
laterality(617:623) = 1;
partition_laterality = zeros(7,84);

for i=1:84
    c = comm_laterality(partition_assignment(i,:),laterality); 
    partition_laterality(1:6,i) = [c(1:end-1,2);zeros(6-length(c(1:end-1,2)),1)];
    partition_laterality(7,i) = c(end,2);
end

average_partition_laterality = sum(partition_laterality(1:m,:).*(partition_hist),1)/630;
average_partition_laterality_10 = sum(partition_laterality(1:m,:).*(partition_hist.*sig_10.'),1)./(sum(partition_hist.*sig_10.'));
average_partition_laterality_05 = sum(partition_laterality(1:m,:).*(partition_hist.*sig_05.'),1)./(sum(partition_hist.*sig_05.'));

[h,p] = ttest2(average_partition_laterality(a_indices),average_partition_laterality(b_indices))
[h,p] = ttest2(average_partition_laterality_05(a_indices),average_partition_laterality_05(b_indices))
[h,p] = ttest2(average_partition_laterality_10(a_indices),average_partition_laterality_10(b_indices))

%% radius
community_raduis = zeros(7,84); % todo more than just average
for i=1:84
    dists = comm_radius(partition_assignment(i,:),coor);
    community_raduis(1:6,i) = [dists(1:end-1,2);zeros(6-length(dists(1:end-1,2)),1)];
    community_raduis(7,i) = dists(end,2);
end

average_community_raduis = sum(community_raduis(1:m,:).*(partition_hist),1)/630;
average_community_raduis_10 = sum(community_raduis(1:m,:).*(partition_hist.*sig_10.'),1)./(sum(partition_hist.*sig_10.'));
average_community_raduis_05 = sum(community_raduis(1:m,:).*(partition_hist.*sig_05.'),1)./(sum(partition_hist.*sig_05.'));

[h,p] = ttest2(average_community_raduis(a_indices),average_community_raduis(b_indices))
[h,p] = ttest2(average_community_raduis_05(a_indices),average_community_raduis_05(b_indices))
[h,p] = ttest2(average_community_raduis_10(a_indices),average_community_raduis_10(b_indices))
%% spatial extent
% community_spatial = zeros(7,84); % todo more than just average
% for i=1:84
%     % gives an error having to do with convex hull
%     spat = comm_spatial_extent(relabled_partition_assignment(i,:),coor);
%     community_spatial(:,i) = spat(:,2);
% end
% 
% figure;
% colors = [ 0    0.4470    0.7410;
%     0.8500    0.3250    0.0980;
%     0.9290    0.6940    0.1250;
%     0.4940    0.1840    0.5560;
%     0.4660    0.6740    0.1880;
%     0.3010    0.7450    0.9330;
%     0.6350    0.0780    0.1840];
% for j=1:6
%     hold on
%     plot(sessions_days_key(tuesday_indices,3), community_spatial(j,tuesday_indices),'*','Color',colors(j,:))
%     plot(sessions_days_key(tuesday_indices,3), community_spatial(j,tuesday_indices),'Color',colors(j,:))
%     plot(sessions_days_key(thursday_indices,3), community_spatial(j,thursday_indices),'.','Color',colors(j,:))
%     plot(sessions_days_key(thursday_indices,3), community_spatial(j,thursday_indices),'Color',colors(j,:))
%     [h,p] = ttest2(community_spatial(j,tuesday_indices),community_spatial(j,thursday_indices))
% end
% % weighted average and ttest
% figure;
% plot(sessions_days_key(tuesday_indices,3), community_spatial(7,tuesday_indices),'*')
% hold on
% plot(sessions_days_key(thursday_indices,3), community_spatial(7,thursday_indices),'.')
% legend('fasted','fed')
% title('average community spatial extent')
% xlabel('days since 10/25/2013')
% ylabel('distance (mm)')
% [h,p] = ttest2(community_spatial(7,tuesday_indices),community_spatial(7,thursday_indices))
% [R,P] = corrcoef(sessions_days_key(tuesday_indices,3),community_spatial(7,tuesday_indices))
% [R,P] = corrcoef(sessions_days_key(thursday_indices,3),community_spatial(7,thursday_indices))
% [R,P] = corrcoef(vertcat(sessions_days_key(tuesday_indices,3),sessions_days_key(thursday_indices,3)),horzcat(community_spatial(7,tuesday_indices),community_spatial(7,thursday_indices)))
% 
% %% 