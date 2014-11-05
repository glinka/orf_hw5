function [] = dillon_gym_loc()
dg = [18.5, 21.5];
Z = zeros(4,2);
Z(1,:) = [11,10];
Z(2,:) = [22,15];
Z(3,:) = [30,20];
Z(4,:) = [10,34];
% % 1.1
cvx_begin
    variable x(2)   
    minimize(sum((Z(:,1) - x(1)).^2 + (Z(:,2) - x(2)).^2))
cvx_end
x1 = x;
o1 = cvx_optval;

colleges = imread('princetoncampus.png');
imshow(colleges, 'InitialMagnification', 50);
hold on;
Circledraw(x(1), x(2), 0.5, 'r')




% % 1.3
cvx_begin
    variables x(2) e
    minimize(e)
    subject to
        for i = 1:4
            e >= norm(Z(i,:) - transpose(x))
        end
cvx_end
x3 = x;
o3 = cvx_optval;
Circledraw(x(1), x(2), 0.5, 'b')

% 2.2
fh = [30,30];
cvx_begin
    variable x(2)
    minimize(sum((Z(:,1) - x(1)).^2 + (Z(:,2) - x(2)).^2))
    subject to
        norm(fh - transpose(x)) <= 8
cvx_end
x4 = x;
Circledraw(x(1), x(2), 0.5, 'g')

% draw feasible boundary
Circledraw(30, 30, 8, 'c')
for i = 1:3
    plot(Z(i:i+1,1), Z(i:i+1,2), 'c')
end
plot(Z(1,1), Z(1,2), Z(4,1), Z(4,2), 'c')


% figure out whether or not to relocate
dg1 = sum((Z(:,1) - dg(1)).^2 + (Z(:,2) - dg(2)).^2);
r1 = 'false';
if abs(o1 - dg1)/dg1 > 0.15
    r1 = 'true';
end
dg2 = 0;
for i = 1:4
    if norm(Z(i,:) - dg) > dg2
        dg2 = norm(Z(i,:) - dg);
    end
end
r2 = 'false';
if abs(o3- dg2)/dg2 > 0.15
    r2 = 'true';
end

fh = [20,20];
fhd = norm(transpose(x1) - fh)^2;

% for part 1.2
gradF = @(x) 2*[sum(x(1) - Z(:,1)), sum(x(2) - Z(:,2))];
dfda = @(x,a,d) sum(2*d(1)*(x(1) + a*d(1) - Z(:,1)) + 2*d(2)*(x(2) + a*d(2) - Z(:,2)));
ddfdaa = @(x,a,d) 8*(d(1)^2 + d(2)^2);


% 1.2a
iter = 0;
maxiter = 100;
err = 1;
tol = 1e-5;
ntol = 1e-8;
x = rand(1,2);
while err > tol && iter < maxiter
    df = -gradF(x);
    nerr = 1;
    maxniter = 100;
    niter = 0;
    a = 0.5;
    while nerr > ntol && niter < maxniter
        a = a - dfda(x,a,df)/ddfdaa(x,a,df);
        nerr = abs(dfda(x,a,df)/ddfdaa(x,a,df));
        niter = niter + 1;
    end
    x = x + a*df;
    err = norm(df);
    iter = iter + 1;
end
elsiters = iter;
x2 = x;

% 1.2b
for a = [.5, 0.25, 2.0/9]
    iter = int32(0);
    maxiter = 100;
    X = zeros(maxiter,2);
    err = 1;
    tol = 1e-5;
    x = rand(1,2);
    while err > tol && iter < maxiter
        df = -gradF(x);
        x = x + a*df;
        err = norm(df);
        iter = iter + 1;
        X(iter,:) = x;
    end
    figure()
    scatter(X(1:iter,1),X(1:iter,2),50,linspace(0,1,iter))
    x
end

abs(o1 - dg1)/dg1
abs(o3- dg2)/dg2

display(sprintf('\nLocation based on (1):\n\txOPT = %3.2f, %3.2f \n\treolcate: %s', x1(1), x2(2), r1))
display(sprintf('\nLocation based on (2):\n\txOPT = %3.2f, %3.2f \n\treolcate: %s', x3(1), x3(2), r2))
display(sprintf('\nAs the fire hydrant is at distance %3.2f (< 8) from the optimal value of (1), the same optimal value will satisfy the addtional fire hydrant constraint and thus the location will not change', fhd))
display(sprintf('\nLocation of movie theater:\n\txOPT = %3.2f, %3.2f', x4(1), x4(2)))
display(sprintf('\nExact line search took %i iterations to converge.', elsiters))
end
