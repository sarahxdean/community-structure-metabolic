function all_timeseries = timeseries_import(filename, n, m)

all_filenames = fileread(filename);
filenames_cell = textscan(all_filenames, '%s', 'delimiter', sprintf('\n'));
filenames = filenames_cell{1,1};

N = max(size(filenames));
all_timeseries = zeros(n,m,N);
for i=1:N
    all_timeseries(:,:,i) = dlmread(filenames{i},' ');
end

%timeseries_concat = reshape(permute(all_timeseries, [1 3 2]), [518*N,630]);