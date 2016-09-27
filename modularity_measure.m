function Q = modularity_measure(A,gamma,P)
[n,~] = size(A);
wk = sum(A)/n;
w = sum(wk)/n;

Q = 0;

for j=1:n
    for i=1:n
        if (P(i) == P(j))
            Q = Q + A(i,j) - gamma * wk(i)*wk(j) / (2*w);
        end
    end
end