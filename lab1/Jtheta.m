x = load("ex1Data/ex1x.dat");
y = load("ex1Data/ex1y.dat");

m = length(y);
x = [ones(m, 1), x];

J_vals = zeros(100, 100);
theta0_vals = linspace(-3, 3, 100);
theta1_vals = linspace(-1, 1, 100);
for i = 1 : length(theta0_vals)
    for j = 1 : length(theta1_vals)
        theta = [theta0_vals(i); theta1_vals(j)];
        sum = 0;
        for t = 1 : m
            sum = sum + (x(t, :) * theta - y(t))^2;
        end
        J_vals(i, j) = sum / (2 * m);
    end
end

J_vals = J_vals';
surf(theta0_vals, theta1_vals, J_vals);
hold on;
xlabel("\theta_0");
ylabel("\theta_1");

thetas = load("thetas.txt");
for i = 1 : size(thetas, 1) - 1
    a = [thetas(i, 1), thetas(i, 2)];
    sum = 0;
    for t = 1 : m
        sum = sum + (x(t, :) * a' - y(t))^2;
    end
    a = [a, sum / (2 * m)];

    b = [thetas(i + 1, 1), thetas(i + 1, 2)];
    sum = 0;
    for t = 1 : m
        sum = sum + (x(t, :) * b' - y(t))^2;
    end
    b = [b, sum / (2 * m)];
    quiver3(a(1), a(2), a(3), b(1), b(2), b(3));
end
