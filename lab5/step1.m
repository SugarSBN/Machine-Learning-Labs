x = load('ex5Data/ex5Linx.dat');
y = load('ex5Data/ex5Liny.dat');


[m, n] = size(x);
X = [ones(m, 1), x, x.^2, x.^3, x.^4, x.^5];
[m, n] = size(X);
reg = diag([0, ones(1, n - 1)]);
xs = [-1 : 0.1 : 1]';

subplot(1, 3, 1);
plot(x, y, 'rO');
hold on;
lambda = 0;
theta = inv(X' * X + lambda * reg) * X' * y;
ys = [ones(21, 1), xs, xs.^2, xs.^3, xs.^4, xs.^5] * theta;
plot(xs, ys, 'b--');
legend('Samples', '\lambda=0');

subplot(1, 3, 2);
plot(x, y, 'rO');
hold on;
lambda = 1;
theta = inv(X' * X + lambda * reg) * X' * y;
ys = [ones(21, 1), xs, xs.^2, xs.^3, xs.^4, xs.^5] * theta;
plot(xs, ys, 'b--');
legend('Samples', '\lambda=1');

subplot(1, 3, 3);
plot(x, y, 'rO');
hold on;
lambda = 10;
theta = inv(X' * X + lambda * reg) * X' * y;
ys = [ones(21, 1), xs, xs.^2, xs.^3, xs.^4, xs.^5] * theta;
plot(xs, ys, 'b--');
legend('Samples', '\lambda=10');
