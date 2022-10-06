x = load('ex5Data/ex5Logx.dat');
y = load('ex5Data/ex5Logy.dat');

pos = find(y); 
neg = find(y == 0);


X = map_feature(x(:, 1), x(:, 2));
[m, n] = size(X);
plot(x(pos, 1), x(pos, 2), '+');
hold on;
plot(x(neg, 1), x(neg, 2), 'o');
% lambda = 1;
% lambda = 0;
lambda = 1;
theta = zeros(n, 1);
for it = 1 : 10
    grad = X' * (sigmond(X * theta) - y) / m;
    reg = lambda / m .* theta;
    reg(1) = 0;
    grad = grad + reg;
    H = X' * diag(sigmond(X * theta) .* sigmond(-X * theta), 0) * X / m + lambda / m .* diag([0, ones(1, n - 1)]);
    theta = theta - H \ grad;
end

u = linspace(-1, 1.5, 200);
v = linspace(-1, 1.5, 200);
z = zeros(length(u), length(v));

for i = 1 : length(u)
    for j = 1 : length(v)
        z(j, i) = map_feature(u(i), v(j)) * theta;
    end
end
contour(u, v, z, [0, 0], 'LineWidth', 2);
legend('y=1', 'y=0', 'decision bound');