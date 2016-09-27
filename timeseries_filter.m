function all_timeseries_filtered = timeseries_filter(all_timeseries,sample_times, filter_band)
[n,m,N] = size(all_timeseries);
all_timeseries_filtered = zeros(n,m,N);
for i=1:N
    ts = timeseries(all_timeseries(:,:,i), sample_times);
    ts_f = idealfilter(ts, filter_band, 'band');
    all_timeseries_filtered(:,:,i) = ts_f.Data;
end

%ts = timeseries(timeseries_concat, (1:43512)/600);
%ts_f = idealfilter(ts, [0.06 0.12], 'band');
%timeseries_concat_filtered = ts_f.Data;