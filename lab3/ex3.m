blue = load("ex3Data/ex3blue.dat");
red = load("ex3Data/ex3red.dat");

plot(blue(:, 1), blue(:, 2), 'b*');
hold on;
plot(red(:, 1), red(:, 2), 'r.');
axis([0, 10, 0, 10]);

mu_blue = mean(blue)';
mu_red = mean(red)';

[m, n] = size(blue);
S_w = zeros(n, n);
for i = 1 : m
    S_w = S_w + (blue(i, :)' - mu_blue) * (blue(i, :)' - mu_blue)';
end
[m, n] = size(red);
for i = 1 : m
    S_w = S_w + (red(i, :)' - mu_red) * (red(i, :)' - mu_red)';
end

theta = S_w \ (mu_blue - mu_red);

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



function pos = projects(line, point)
    t = (point' * line) / (line' * line);
    pos = t * line;
end