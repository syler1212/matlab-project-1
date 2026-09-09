%Condor model

function [t, juveniles, preAdults, adults, total] = runCondorModel()

% initialization of variables and Rates
clear all;
R = 0.3729 / 2; % The Female birth Rate
PdR = 0.086; % Pre-Adult Death Rate
AdR = 0.086; % Adult Death Rate
PsR = 1 - PdR; % survival Rate for Pre-Adults
AsR = 1 - AdR; % survival Rate for Adults
num_years = 50; % simulation time in years
t = 1: num_years;

% Define arrays and fill with 0's ahead of time to pre-allocate space
%arrays start at 1 in matlab not 0... odd
Y0 = zeros(1, num_years);
Y1 = zeros(1, num_years);
Y2 = zeros(1, num_years);
Y3 = zeros(1, num_years);
Y4 = zeros(1, num_years);
Y5 = zeros(1, num_years);
Y6 = zeros(1, num_years);
A  = zeros(1, num_years);
adultsEligibleToReproduce = A;
% setting initial conditions
Y5(1) = 2;
Y6(1) = 2;





% simulation saved into arrays
% arrayName(index) = value , allows you to write to the array
for yr = 2: num_years
    adultsEligibleToReproduce = A(yr-1) - Y0(yr-1); % only adults without a fledgling < 1 year egg / chick can reproduce
    Y0(yr) = adultsEligibleToReproduce * R;  % just born
    Y1(yr) = Y0(yr-1);         % living our their first year, no PsR needed

    Y2(yr) = Y1(yr-1) * PsR;   % start of pre-adult years
    Y3(yr) = Y2(yr-1) * PsR;
    Y4(yr) = Y3(yr-1) * PsR;
    Y5(yr) = Y4(yr-1) * PsR;
    Y6(yr) = Y5(yr-1) * PsR;   % end of pre-adult years

    A(yr) = A(yr-1) * AsR + Y6(yr-1) * PsR;  % adults
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