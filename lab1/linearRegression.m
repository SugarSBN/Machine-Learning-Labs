x = load("ex1Data/ex1x.dat");
y = load("ex1Data/ex1y.dat");

plot(x, y, 'o');
ylabel("Height in meters");
xlabel("Age in years");

m = length(y);
x = [ones(m, 1), x];

alpha = 0.07;
theta = [0; 0];
numIt = 0;
while 1 > 0
    newTheta = zeros(2, 1);
    h = x * theta;
    for j = 1 : 2
        sum = 0;
        for i = 1 : m
            sum = sum + (h(i) - y(i)) * x(i, j);
        end
        newTheta(j) = theta(j) - alpha / m * sum;
    end
    if max(abs(newTheta - theta)) < 0.00001
        break;
    end
    theta = newTheta;
    numIt = numIt + 1;
    if mod(numIt, 100) == 0
        numIt
    end
end

hold on;
plot(x(:, 2), x * theta, '-');

legend( 'Training data' , 'Linear regression');