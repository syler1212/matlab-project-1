%Condor model

function [t, juveniles, preAdults, adults, total] = runCondorModel()

% initialization of variables and Rates

R = 0.3729; % The Female birth Rate
dR = 0.086; % Pre-Adult and Adult Death Rate
PsR = 1 - dR; % survival Rate for Pre-Adults
AsR = 1 - dR; % survival Rate for Adults
num_years = 50; % simulation time in years
t = 0: num_years;

% Define arrays and fill with 0's ahead of time to pre-allocate space
%arrays start at 1 in matlab not 0... odd
Y0 = zeros(1, num_years + 1);
Y1 = zeros(1, num_years + 1);
Y2 = zeros(1, num_years + 1);
Y3 = zeros(1, num_years + 1);
Y4 = zeros(1, num_years + 1);
Y5 = zeros(1, num_years + 1);
Y6 = zeros(1, num_years + 1);
A  = zeros(1, num_years + 1);

% setting initial conditions
Y5(1) = 2;
Y6(1) = 2;








% simulation saved into arrays
% arrayName(index) = value , allows you to write to the array
for yr = 1: num_years

    Y0(yr+1) = (A(yr) * R);  % just born
    Y1(yr+1) = Y0(yr);         % living our their first year, no PsR needed

    Y2(yr+1) = Y1(yr) * PsR;   % start of pre-adult years
    Y3(yr+1) = Y2(yr) * PsR;
    Y4(yr+1) = Y3(yr) * PsR;
    Y5(yr+1) = Y4(yr) * PsR;
    Y6(yr+1) = Y5(yr) * PsR;   % end of pre-adult years

    A(yr+1) = A(yr) * AsR + Y6(yr) * PsR;  % adults
end


    

    % Group totals for plotting
    % combining arrays to account for the correct groups
    juveniles = Y0 + Y1;
    preAdults = Y2 + Y3 + Y4 + Y5 + Y6;
    adults    = A;
    total     = juveniles + preAdults + adults;



end
%%
[t, juveniles, subadults, adults, total] = runCondorModel();


% Plot
plot(t, juveniles, t, subadults, t, adults, t, total);
legend('Juveniles', 'PreAdults', 'Adults', 'Total');
xlabel('Years');
ylabel('Number of Female Condors');