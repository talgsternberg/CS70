figure(1);
get_coords('ball.mp4', 'ball_coords.mat', 4);

load('ball_coords.mat');

%least squares for y = ax+b
X_ab = [coords(:,1),ones(25,1)]; 
Y_ab = coords(:,2);
b_ab = inv(X_ab'*X_ab) * X_ab' * Y_ab;


%least squares for y = ax^2+bx+c
X_ab2c = [(coords(:,1).^2), coords(:,1), ones(25,1)];
Y_ab2c = coords(:,2);
b_ab2c = inv(X_ab2c'*X_ab2c) * X_ab2c' * Y_ab2c;


%least squares for y = ax^2+bx
X_ab2 = [(coords(:,1).^2), coords(:,1)];
Y_ab2 = coords(:,2);
b_ab2 = inv(X_ab2' * X_ab2) * X_ab2' * Y_ab2;


%least squares for y = asin((1/335.5)x-9.9)+b
X_sin = [sin((1/335.5)*coords(:,1)-9.9), ones(25,1)];
Y_sin = coords(:,2);
b_sin = inv(X_sin' * X_sin) * X_sin' * Y_sin;


%plotting
figure(1);
hold on;
set(gca, 'YDir', 'reverse');
x_axis_points = coords(:,1);
plot(coords(:,1), coords(:,2)); %my coordinates


%linear model
y_points_linear = (b_ab(1,1)* x_axis_points) + b_ab(2,1);
plot(x_axis_points, y_points_linear);

%parabolic model with c
y_points_quadratic_c = (b_ab2c(1,1) * x_axis_points.^2) + (b_ab2c(2,1) * x_axis_points) +  b_ab2c(3,1);
plot(x_axis_points, y_points_quadratic_c, '-o');

%parabolic model without c
y_points_quadratic = (b_ab2(1,1) * x_axis_points.^2) + (b_ab2(2,1) * x_axis_points);
plot(x_axis_points, y_points_quadratic, '--');

%sin model
y_sin = b_sin(1,1)*sin((1/335.5)*x_axis_points -9.9) + b_sin(2,1);
plot(x_axis_points, y_sin, ':');

hold off;


%mean squared error calculator
y_observed = coords(:,2);

%linear (expected is y_points_linear from above)
lin_err = immse(y_observed,y_points_linear);
disp('Linear Error');
disp(lin_err);

%quadratic (expected is y_points_quadratic_c from above)
quadc_err = immse(y_observed, y_points_quadratic_c);
disp('Quadratic Error');
disp(quadc_err);

%quadratic with no shift (expected is y_points_quadratic from above)
quad_err = immse(y_observed, y_points_quadratic);
disp('Quadratic Error W/O C');
disp(quad_err);

%sin (expected is y_sin from above)
sin_err = immse(y_observed, y_sin);
disp('Sin Error');
disp(sin_err);





    
%coords/frames check
%genuinly cant figure out why this wont work: is frames matrix wrong
figure(2);
set(gcf);
set(gca, 'YDir', 'reverse');
for c = 1:25    
    
    %load the frame
    frame = frames(:,:,:,c);
    
    %draw the frame
    imshow(uint8(frame));
    drawnow;
    
    %hold, plot the coord, pause, and take off hold
    hold on;
    
    %user clicked point
    plot(coords(c,1), coords(c,2), '.r');
    
    %the predicted quadratic model
    plot(x_axis_points(c),y_points_quadratic_c(c), '.g'); 
    
    pause(0.5);
    hold off;    
end   







