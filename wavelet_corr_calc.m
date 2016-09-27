function [wavelet_correlations, weighted_graphs_w] = wavelet_corr_calc(all_timeseries)
[n,m,N] = size(all_timeseries);

coeff1 = modwt(all_timeseries(:,1,1),'la8',4); %day 1 region 1
coeff2 = modwt(all_timeseries(:,2,1),'la8',4); %day 1 region 2
calc = modwt_wcor(coeff1, coeff2);
corr = calc(2); %scale 2 is most common

%maybe eventually replace this part with a wavelet computation

wavelet_correlations = zeros(m,m,N);
weighted_graphs_w = zeros(m,m,N);
disp('Computing wavelet correlations for each recording session')
for i=1:N %days 1 to N
    disp(i)
    coeffs = modwt(all_timeseries(:,:,i),'la8',4);
    for j=1:630
        for k = 1:j
            calc_corr = modwt_wcor(coeffs(:,:,j), coeffs(:,:,k));
            wavelet_correlations(j,k,i) = calc_corr(2);
            wavelet_correlations(k,j,i) = calc_corr(2); %symmetric
        end
    end
    weighted_graphs_w(:,:,i) = wavelet_correlations(:,:,i);
    for j = 1:length(weighted_graphs_w(:,:,i))
        weighted_graphs_w(j,j,i) = 0;
    end
end