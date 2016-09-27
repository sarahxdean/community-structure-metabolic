function [avg_bt_sim, avg_wtn_sim, avg_wtn_a_sim, avg_wtn_b_sim] = group_partition_similarities(A,B)
[a,~] = size(A);
[b,~] = size(B);

bt_sim = 0;
for i = 1:a
    for j = 1:b
        z = zrand(A(i,:),B(j,:));
        bt_sim = bt_sim + z;
    end
end
avg_bt_sim = bt_sim / (a*b);

wtn_a = 0;
for i = 1:a
    for j = 1:a
        z = zrand(A(i,:),A(j,:));
        wtn_a = wtn_a + z;
    end
end
avg_wtn_a_sim = (wtn_a) / (a*a);

wtn_b = 0;
for i = 1:b
    for j = 1:b
        z = zrand(B(i,:),B(j,:));
        wtn_b = wtn_b + z;
    end
end
avg_wtn_b_sim = (wtn_b) / (b*b);

avg_wtn_sim = (wtn_a + wtn_b) / (a*a + b*b);

end