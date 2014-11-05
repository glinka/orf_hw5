%super imposing a grid on the bird's eye view of campus

M = size(colleges,1);
N = size(colleges,2);

for k = 11:22:M
    x = [1 N];
    y = [k k];
    plot(x,y,'Color','w');
    plot(x,y,'Color','k');
end

for k = 1:22:N
    x = [k k];
    y = [1 M];
    plot(x,y,'Color','w');
    plot(x,y,'Color','k');
end
