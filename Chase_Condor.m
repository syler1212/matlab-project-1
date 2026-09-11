
clear all

%We want to plot over 50 years
%initial conditions, both have 1? breeding pair?
r_c_double = 1.8;
r_c = 0.9;
r_w = 0.3729;
wild_capacity = 400;
captive_capacity = 150;

deltaX = 1;    % time step (months)
tf = 100;         % final time (months)
x = 0:deltaX:tf;    % time vector (months)

C_0(1) = 20;  % W pop. vector with initial value (sharks)
C_1(1) = 0;
C_2(1) = 0;
C_3(1) = 0;
C_4(1) = 0;
C_5(1) = 0;
C_6(1) = 0;
C_a(1) = 0;
C_j(1) = 0;
C_t(1) = 0;

W_0(1) = 20;
W_1(1) = 0;
W_2(1) = 0;
W_3(1) = 0;
W_4(1) = 0;
W_5(1) = 0;
W_6(1) = 0;
W_7(1) = 0;
W_j(1) = 0;
W_a(1) = 0;
W_t(1) = 0;

%% Main loop
% begin loop at i=2 because t(1) and P(1) hold initial cond.
% loop runs until numIter+1 because if t(1) = 0, then t(numIter+1) = tf
for i = 2:length(x)
    %Compute captive population
    C_t(i) = (C_0(i-1) + C_1(i-1) + C_j(i-1) + C_a(i-1)) - (C_t(i-1) * 0.086);
    C_0(i) = C_a(i-1) * 0.5 * r_c;
    overpop = false;
    if C_t(i) > 150
        overpop = true;
        C_1(i) = 0;
        C_2(i) = 0;
        C_3(i) = 0;
        C_4(i) = 0;
        C_5(i) = 0;
        C_6(i) = 0;
    else
        C_1(i) = C_0(i-1);
        C_2(i) = 0.2 * C_1(i-1);
        C_3(i) = C_2(i-1);
        C_4(i) = C_3(i-1);
        C_5(i) = C_4(i-1);
        C_6(i) = C_5(i-1);
    end
    C_j(i) = C_2(i) + C_3(i) + C_4(i) + C_5(i) + C_6(i);
    C_a(i) = C_a(i-1) + C_6(i-1);
    

    %Compute wild population
    W_t(i) = (W_0(i-1) + W_1(i-1) + W_j(i-1) + W_a(i-1)) - (W_t(i-1) * 0.086);
    W_0(i) = (W_a(i-1) * 0.5 * r_w) - ((W_t(i-1) / wild_capacity) * W_a(i-1)* 0.5 * r_w);
    W_1(i) = W_0(i-1) + 0.8 * C_1(i);
    W_2(i) = W_1(i-1);
    W_3(i) = W_2(i-1);
    W_4(i) = W_3(i-1);
    W_5(i) = W_4(i-1);
    W_6(i) = W_5(i-1);
    W_7(i) = W_6(i-1);
    W_j(i) = W_2(i) + W_3(i) + W_4(i) + W_5(i) + W_6(i) + W_7(i);
    if overpop == true
        W_1(i) = W_0(i-1) + C_1(i);
        W_3(i) = W_2(i-1) + C_2(i);
        W_4(i) = W_3(i-1) + C_3(i);
        W_5(i) = W_4(i-1) + C_4(i);
        W_6(i) = W_5(i-1) + C_5(i);
        W_7(i) = W_6(i-1) + C_6(i);
    end   
    W_a(i) = W_a(i-1) + W_6(i-1);
    
    
    
end

%% Plot Solutions
% plot unconstrained and constrained
plot(x, C_t, x, W_t, 'LineWidth', 2.5);


% add carrying capacity
yline(captive_capacity,'--', 'LineWidth', 2.5);

% add carrying capacity
yline(wild_capacity,'--', 'LineWidth', 2.5);

xlim([0 100])
% restrict y-axis to better see logistic curve
ylim([0 600]);

% label both axes
xlabel('Time (years)');
ylabel('Condor Populations');


% add legend
legend({' Captive', ' Wild', ' Wild Carrying Capacity', ...
    ' Captive Carrying Capacity'}, 'location', 'northeast');

