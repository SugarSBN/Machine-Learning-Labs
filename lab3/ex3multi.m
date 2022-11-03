blue = load("ex3Data/ex3blue.dat");
red = load("ex3Data/ex3red.dat");
green = load("ex3Data/ex3green.dat");

plot(blue(:, 1), blue(:, 2), 'b.');
hold on;
plot(red(:, 1), red(:, 2), 'r.');
plot(green(:, 1), green(:, 2), 'g.');

axis([0, 10, 0, 10]);

mu_blue = mean(blue)';
mu_red = mean(red)';
mu_green = mean(green)';

mu = (sum(blue) + sum(red) + sum(green)) / (size(blue, 1) + size(red, 1) + size(green, 1));
mu = mu';

S_b = size(blue, 1) * (mu_blue - mu) * (mu_blue - mu)' + size(red, 1) * (mu_red - mu) * (mu_red - mu)' + size(green, 1) * (mu_green - mu) * (mu_green - mu)';

S_w = zeros(2, 2);
for i = 1 : size(blue, 1)
    S_w = S_w + (blue(i, :) - mu_blue) * (blue(i, :) - mu_blue)';
end
for i = 1 : size(red, 1)
    S_w = S_w + (red(i, :) - mu_red) * (red(i, :) - mu_red)';
end
for i = 1 : size(green, 1)
    S_w = S_w + (green(i, :) - mu_green) * (green(i, :) - mu_green)';
end

S = S_w \ S_b;
[V, D] = eig(S);
[mx, i] = max(diag(D));
theta = V(:, i);

xs = 0 : 0.1 : 10;
ys = theta(2) / theta(1) * xs;
plot(xs, ys, 'k-');

for i = 1 : size(blue, 1)
    p = projects(theta, blue(i, :)');
    line([blue(i, 1), p(1)], [blue(i, 2), p(2)], 'LineStyle', '--', 'Color', 'k', 'LineWidth', 0.5);
    plot(p(1), p(2), 'b*');
end

for i = 1 : size(red, 1)
    p = projects(theta, red(i, :)');
    line([red(i, 1), p(1)], [red(i, 2), p(2)], 'LineStyle', '--', 'Color', 'k', 'LineWidth', 0.5);
    plot(p(1), p(2), 'r.');
end

for i = 1 : size(green, 1)
    p = projects(theta, green(i, :)');
    line([green(i, 1), p(1)], [green(i, 2), p(2)], 'LineStyle', '--', 'Color', 'k', 'LineWidth', 0.5);
    plot(p(1), p(2), 'g.');
end

function pos = projects(line, point)
    t = (point' * line) / (line' * line);
    pos = t * line;
end