X = load('ex4Data/ex4x.dat');
Y = load('ex4Data/ex4y.dat');

pos = find(Y == 1);
neg = find(Y == 0);
[m, n] = size(X);
X = [ones(m, 1), X];
n = n + 1;

plot(X(pos, 2), X(pos, 3), '+');
hold on;
plot(X(neg, 2), X(neg, 3), 'o');

nIt = 0;
delta = 1;
theta = zeros(n, 1);
while (delta > 1e-6)
    H = X' * diag(sigmond(X * theta) .* sigmond(-X * theta), 0) * X;
    grad = X' * (sigmond(X * theta) - Y);
    theta = theta - H \ grad;
    delta = max(abs(H \ grad));
    nIt = nIt + 1;
end

nIt
xs = 12 : 1 : 63;
ys = (theta(1) + theta(2) * xs) / (-theta(3));
plot(xs, ys, 'b-');
legend('Admitted', 'Not admitted', 'Decision boundary');


xlabel('Exam1 score');
ylabel('Exam2 score');