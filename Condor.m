%Condor model

function [t,wildY0,wildY1,wildImmature,wildAdults,captiveY0,captiveY1,captiveImmature,captiveAdults] = runCondorModel()

% initialization of variables and Rates
clear all;
num_years = 50;
t = 1: num_years;

year1DeathRate = 0.086;
preAdultDeathRate = 0.086;
adultDeathRate = 0.086;
year1SurvivalRate = 1 - year1DeathRate;
preAdultSurvivalRate = 1 - preAdultDeathRate;
adultSurvivalRate = 1 - adultDeathRate;


captiveBreedingAge = 7;
wildBreedingAge = 8;
captiveCapacityCap = 150;
wildCarryingCapacity = 400;

captivedoubleClutchFecundity = 1.8 / 2;
captiveFecundity = 0.9 / 2;
wildFecundity = 0.3729 / 2;


percentToReleaseYearly = 0.8;

captiveY0 = zeros(1, num_years);
captiveY1 = zeros(1, num_years);
captiveY2 = zeros(1, num_years);
captiveY3 = zeros(1, num_years);
captiveY4 = zeros(1, num_years);
captiveY5 = zeros(1, num_years);
captiveY6 = zeros(1, num_years);
captiveAdults = zeros(1, num_years);

wildY0 = zeros(1, num_years);
wildY1 = zeros(1, num_years);
wildY2 = zeros(1, num_years);
wildY3 = zeros(1, num_years);
wildY4 = zeros(1, num_years);
wildY5 = zeros(1, num_years);
wildY6 = zeros(1, num_years);
wildY7 = zeros(1, num_years);
wildAdults = zeros(1, num_years);

captiveY2(1) = 10;
captiveY3(1) = 10;
captiveY4(1) = 10;
captiveY5(1) = 10;
captiveY6(1) = 10;
captiveAdults(1) = 10;
wildY5(1) = 2;

% simulation saved into arrays
% arrayName(index) = value , allows you to write to the array
for yr = 2: num_years
    
    captiveAdultsEligibleToReproduce = captiveAdults(yr-1); %captiveAdults(yr-1) - captiveY0; % double-clutching?
    captiveY0(yr) = captiveAdultsEligibleToReproduce * captiveFecundity;
    captiveY1(yr) = captiveY0(yr-1) * year1SurvivalRate;
    captiveY2(yr) = captiveY1(yr-1) * preAdultSurvivalRate;
    captiveY3(yr) = captiveY2(yr-1) * preAdultSurvivalRate;
    captiveY4(yr) = captiveY3(yr-1) * preAdultSurvivalRate;
    captiveY5(yr) = captiveY4(yr-1) * preAdultSurvivalRate;
    captiveY6(yr) = captiveY5(yr-1) * preAdultSurvivalRate;
    captiveAdults(yr) = captiveAdults(yr-1) * adultSurvivalRate;
    captiveAdults(yr) = captiveAdults(yr) + (captiveY6(yr-1) * preAdultSurvivalRate);

    lastTotalWild = wildY0(yr-1) + wildY1(yr-1) + wildY2(yr-1)+ wildY3(yr-1) + wildY4(yr-1) + wildY5(yr-1) + wildY6(yr-1) + wildY7(yr-1) + wildAdults(yr-1);
    wildAdultsEligibleToReproduce = wildAdults(yr-1); %captiveAdults(yr-1) - captiveY0; % double-clutching?
    wildY0(yr) = wildAdultsEligibleToReproduce * wildFecundity;
    wildY1(yr) = wildY0(yr-1) * year1SurvivalRate * (1-(lastTotalWild/wildCarryingCapacity));
    wildY2(yr) = wildY1(yr-1) * preAdultSurvivalRate * (1-(lastTotalWild/wildCarryingCapacity));
    wildY3(yr) = wildY2(yr-1) * preAdultSurvivalRate * (1-(lastTotalWild/wildCarryingCapacity));
    wildY4(yr) = wildY3(yr-1) * preAdultSurvivalRate * (1-(lastTotalWild/wildCarryingCapacity));
    wildY5(yr) = wildY4(yr-1) * preAdultSurvivalRate * (1-(lastTotalWild/wildCarryingCapacity));
    wildY6(yr) = wildY5(yr-1) * preAdultSurvivalRate * (1-(lastTotalWild/wildCarryingCapacity));
    wildY7(yr) = wildY6(yr-1) * preAdultSurvivalRate * (1-(lastTotalWild/wildCarryingCapacity));
    wildAdults(yr) = wildAdults(yr-1) * adultSurvivalRate * (1-(lastTotalWild/wildCarryingCapacity));
    wildAdults(yr) = wildAdults(yr-1) + (wildY6(yr-1) * (1-(lastTotalWild/wildCarryingCapacity)));
    
    totalWild = wildY0(yr) + wildY1(yr) + wildY2(yr)+ wildY3(yr) + wildY4(yr) + wildY5(yr) + wildY6(yr) + wildY7(yr) + wildAdults(yr);
    %release 80% of captive juveniles
    totalCaptive = captiveY0(yr) + captiveY1(yr) + captiveY2(yr) + captiveY3(yr) + captiveY4(yr) + captiveY5(yr) + captiveY6(yr) + captiveAdults(yr);
    if totalCaptive < captiveCapacityCap
        year1ToRelease = captiveY1(yr) * percentToReleaseYearly;
        year2ToRelease = captiveY2(yr) * percentToReleaseYearly;
        year3ToRelease = captiveY3(yr) * percentToReleaseYearly;
        year4ToRelease = captiveY4(yr) * percentToReleaseYearly;
        year5ToRelease = captiveY5(yr) * percentToReleaseYearly;
        year6ToRelease = captiveY6(yr) * percentToReleaseYearly;
    else
        year1ToRelease = captiveY1(yr);
        year2ToRelease = captiveY2(yr);
        year3ToRelease = captiveY3(yr);
        year4ToRelease = captiveY4(yr);
        year5ToRelease = captiveY5(yr);
        year6ToRelease = captiveY6(yr);
    end
    captiveY1(yr) = captiveY1(yr) - year1ToRelease;
    wildY1(yr) = wildY1(yr) + year1ToRelease;

    captiveY2(yr) = captiveY2(yr) - year2ToRelease;
    wildY2(yr) = wildY2(yr) + year2ToRelease;

    captiveY3(yr) = captiveY3(yr) - year3ToRelease;
    wildY3(yr) = wildY3(yr) + year3ToRelease;

    captiveY4(yr) = captiveY4(yr) - year4ToRelease;
    wildY4(yr) = wildY4(yr) + year4ToRelease;

    captiveY5(yr) = captiveY5(yr) - year5ToRelease;
    wildY5(yr) = wildY5(yr) + year5ToRelease;

    captiveY6(yr) = captiveY6(yr) - year6ToRelease;
    wildY6(yr) = wildY6(yr) + year6ToRelease;
    
    disp(wildAdults(yr));
  
end


    

    % Group totals for plotting
    % combining arrays to account for the correct groups
    wildImmature = wildY2 + wildY3 + wildY4 + wildY5 + wildY6 + wildY7;
    captiveImmature = captiveY2 + captiveY3 + captiveY4 + captiveY5 + captiveY6;



end
%%
[t, wildY0,wildY1,wildImmature,wildAdults,captiveY0,captiveY1,captiveImmature,captiveAdults] = runCondorModel();


% Plot
%plot(t, wildY0,t,wildY1,t,wildImmature,t,wildAdults,t,captiveY0,t,captiveY1,t,captiveImmature,t,captiveAdults);

plot(t, wildY0, t, wildY1, t, wildImmature, t, wildAdults);
legend('Wild Hatchlings', 'Wild Year 1s', 'Wild Immature', 'Wild Adults');
xlabel('Years');
ylabel('Number of Female Condors');

plot(t, captiveY0, t, captiveY1, t, captiveImmature, t, captiveAdults);
legend('Captive Hatchlings', 'Captive Year 1s', 'Captive Immature', 'Captive Adults');
xlabel('Years');
ylabel('Number of Female Condors');