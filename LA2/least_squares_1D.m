function[] = least_squares_1D

%initialize s and t
s = [3;4;3;5;4;3];
t = [6;0;0;0;0;1];

%initialize A and b 
A = zeros(5,4);
b = zeros(5,1);

%fill in A and b
A(1,1) = 1;
A(2,1) = -1;
A(2,2) = 1;
A(3,2) = -1;
A(3,3) = 1;
A(4,3) = -1;
A(4,3) = 1;
A(5,4) = -1;
b(1) = s(2)-s(1)+t(1);
b(2) = s(3)-s(2);
b(3) = s(4)-s(3);
b(4) = s(5)-s(4);
b(5) = s(6)-s(5)-t(6);

%solve for gradient using normal equations
v = inv(A'*A)*A'*b;
t(2) = v(1);
t(3) = v(2);
t(4) = v(3);
t(5) = v(4);

%display solution
bar(t);

end 


