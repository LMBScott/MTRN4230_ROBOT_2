function z5207471_ROBOT_2()
    transl(1,2); % Pure translation homogeneous transform
    trot2(30, 'deg'); % Pure rotation homogeneous transform
    T1 = se2(1, 2, 30, 'deg'); % Homogeneous transform
    trplot2(T1, 'frame', '1', 'color', 'b'); % Plot homogeneous transform
    
end