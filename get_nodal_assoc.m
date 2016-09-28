function [X] = get_nodal_assoc(C)
npart = numel(C(:,1)); % number of partitions
m = numel(C(1,:)); % size of the network

X = zeros(m,m); % Nodal association matrix for C

for i = 1:npart;
    for k = 1:m
        for p = 1:m;
            % element (i,j) indicate the number of times node i and node j
            % have been assigned to the same community
            if isequal(C(i,k),C(i,p))
                X(k,p) = X(k,p) + 1;
            else
                X(k,p) = X(k,p) + 0;
            end
        end
    end
end
