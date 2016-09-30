function write_partition_to_pajek(partition, path)

[fid, ~] = fopen(path, 'w');
fprintf(fid,'%s\n', '*Vertices: 630');
fprintf(fid,'%i\n', partition);
fclose(fid);
