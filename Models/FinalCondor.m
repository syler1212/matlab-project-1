clear all;
%%
%Condor model
function [t, wildJuveniles, wildImmatures, wildAdults, wildTotal, captiveJuveniles, captiveImmatures, captiveAdults, captiveTotal, totalBirds, Y1, WY1] = runCondorModel()
% initialization of variables and Rates
doubleClutching = true;
captiveBirthRate = 0.9; % The Female birth Rate assuming double clutching
if doubleClutching == true
    captiveBirthRate = captiveBirthRate * 2;
end
wildBirthRate = 0.3729; % wild female birth rate
num_years = 50; % simulation time in years
t = 0: num_years;
releaseRate = 0.8; % the release rate
keepRate = 1 - releaseRate; % the keep rate of juvenile condors
% Part A
captiveAdultMortalityRate = 0.086;
wildAdultMortalityRate = 0.086;
captiveImmatureMortalityRate = 0.086;
wildImmatureMortalityRate = 0.086;
captiveYear1MortalityRate = 0.086;
wildYear1MortalityRate = 0.086;

% Part B
% captiveAdultMortalityRate = 0.069;
% wildAdultMortalityRate = 0.069;
% captiveImmatureMortalityRate = 0.138;
% wildImmatureMortalityRate = 0.138;
% captiveYear1MortalityRate = 0.138;
% wildYear1MortalityRate = 0.138;

% Part C
% captiveAdultMortalityRate = 0.086;
% wildAdultMortalityRate = 0.086;
% captiveImmatureMortalityRate = 0.086;
% wildImmatureMortalityRate = 0.086;
% captiveYear1MortalityRate = 0.659;
% wildYear1MortalityRate = 0.659;

% Part D
% captiveAdultMortalityRate = 0.069;
% wildAdultMortalityRate = 0.069;
% captiveImmatureMortalityRate = 0.138;
% wildImmatureMortalityRate = 0.138;
% captiveYear1MortalityRate = 0.659;
% wildYear1MortalityRate = 0.659;

% Part E
% captiveAdultMortalityRate = 0.099;
% wildAdultMortalityRate = 0.099;
% captiveImmatureMortalityRate = 0.099;
% wildImmatureMortalityRate = 0.099;
% captiveYear1MortalityRate = 0.659;
% wildYear1MortalityRate = 0.659;

% Part F
% Same mortality rates as Part D (0.069, 0.138, 0.659)
% captiveAdultMortalityRate = 0.069;
% wildAdultMortalityRate = 0.069;
% captiveImmatureMortalityRate = 0.138;
% wildImmatureMortalityRate = 0.138;
% captiveYear1MortalityRate = 0.659;
% wildYear1MortalityRate = 0.659;

captiveAdultSurvivalRate = 1 - captiveAdultMortalityRate;
wildAdultSurvivalRate = 1 - wildAdultMortalityRate;
captiveImmatureSurvivalRate = 1 - captiveImmatureMortalityRate;
wildImmatureSurvivalRate = 1 - wildImmatureMortalityRate;
captiveYear1SurvivalRate = 1 - captiveYear1MortalityRate;
wildYear1SurvivalRate = 1 - wildYear1MortalityRate;
captiveCapacity = 150;
wildCapacity = 400;

% Define arrays and fill with 0's ahead of time to pre-allocate space
% arrays start at 1 in matlab not 0... odd 
% captive and wild groups, vectors 

Y0 = zeros(1, num_years + 1);
Y1 = zeros(1, num_years + 1);
Y2 = zeros(1, num_years + 1);
Y3 = zeros(1, num_years + 1);
Y4 = zeros(1, num_years + 1);
Y5 = zeros(1, num_years + 1);
Y6 = zeros(1, num_years + 1);
Y7 = zeros(1, num_years + 1);
A  = zeros(1, num_years + 1);

WY0 = zeros(1, num_years + 1);
WY1 = zeros(1, num_years + 1);
WY2 = zeros(1, num_years + 1);
WY3 = zeros(1, num_years + 1);
WY4 = zeros(1, num_years + 1);
WY5 = zeros(1, num_years + 1);
WY6 = zeros(1, num_years + 1);
WY7 = zeros(1, num_years + 1);
WY8 = zeros(1, num_years + 1);
WA  = zeros(1, num_years + 1);

% setting initial conditions
% initial conditions derived from 2022 population data
% https://www.nps.gov/articles/000/caco-world-2022.htm
% initial conditions assume all wild condors can breed together,
% which is not necessarily the case.

Y0(1) = 44;
Y1(1) = 39;
Y2(1) = 45/6;
Y3(1) = 45/6;
Y4(1) = 45/6;
Y5(1) = 45/6;
Y6(1) = 45/6;
Y7(1) = 45/6;
A(1) = 86;

% initial conditions derived from 1987 population data
% nps.gov/pinn/learn/nature/condor-history.htm

%A(1) = 22;

% Actual wild population is over our assumed carrying capacity, so start
% our simulation assuming no wild Condors.
for yr = 2: num_years + 1
    
    captiveTotalPrev = Y0(yr-1) + Y1(yr-1) + Y2(yr-1) + Y3(yr-1) + Y4(yr-1) + Y5(yr-1) + Y6(yr-1) + A(yr-1);
    wildTotalPrev = WY0(yr-1) + WY1(yr-1) + WY2(yr-1) + WY3(yr-1) + WY4(yr-1) + WY5(yr-1) + WY6(yr-1) + WY7(yr-1) + WA(yr-1);
    
    wildCarryingCapacity = 1 - (wildTotalPrev / wildCapacity);

    % Part F loop override: uncomment when running Part F
    % if yr == 7 % year 5 transition (at yr index 7, 5 elapsed years have finished)
    %     % release all remaining captive cohorts into the wild
    %     WY0(yr) = WY0(yr-1) + Y0(yr-1);
    %     WY1(yr) = WY0(yr-1);
    %     WY2(yr) = (WY1(yr-1) * wildYear1SurvivalRate + (Y1(yr-1) * wildYear1SurvivalRate));
    %     WY3(yr) = (WY2(yr-1) * wildImmatureSurvivalRate + (Y2(yr-1) * wildImmatureSurvivalRate));
    %     WY4(yr) = (WY3(yr-1) * wildImmatureSurvivalRate + (Y3(yr-1) * wildImmatureSurvivalRate));
    %     WY5(yr) = (WY4(yr-1) * wildImmatureSurvivalRate + (Y4(yr-1) * wildImmatureSurvivalRate));
    %     WY6(yr) = (WY5(yr-1) * wildImmatureSurvivalRate + (Y5(yr-1) * wildImmatureSurvivalRate));
    %     WY7(yr) = (WY6(yr-1) * wildImmatureSurvivalRate + (Y6(yr-1) * wildImmatureSurvivalRate));
    %     WY8(yr) = 0;
    %     WA(yr)  = (WA(yr-1) * wildAdultSurvivalRate + (A(yr-1) * wildAdultSurvivalRate) + (WY7(yr-1) * wildImmatureSurvivalRate));
    %     % captive facility is now zeroed out
    %     continue;
    % elseif yr > 7
    %     % captive facility remains empty for the rest of time
    %     wildadultsEligibleToReproduce = WA(yr-1) / 2;
    %     WY0(yr) = (wildadultsEligibleToReproduce * wildBirthRate * wildCarryingCapacity);
    %     WY1(yr) = WY0(yr-1);
    %     WY2(yr) = WY1(yr-1) * wildYear1SurvivalRate;
    %     WY3(yr) = WY2(yr-1) * wildImmatureSurvivalRate;
    %     WY4(yr) = WY3(yr-1) * wildImmatureSurvivalRate;
    %     WY5(yr) = WY4(yr-1) * wildImmatureSurvivalRate;
    %     WY6(yr) = WY5(yr-1) * wildImmatureSurvivalRate;
    %     WY7(yr) = WY6(yr-1) * wildImmatureSurvivalRate;
    %     WY8(yr) = 0;
    %     WA(yr)  = WA(yr-1) * wildAdultSurvivalRate + (WY7(yr-1) * wildImmatureSurvivalRate);
    %     continue;
    % end

    % If total captive population is less than our capacity, release 80% of
    % year-1 juveniles each year
    if captiveTotalPrev <= captiveCapacity 
        releaseRate = 0.8;
        keepRate = 1 - releaseRate;
    else 
        releaseRate = 1.0;
        keepRate = 1 - releaseRate;
    end
        
    % captive condor section
    adultsEligibleToReproduce = A(yr-1) / 2; % assume 50% of adults are female
    Y0(yr) = (adultsEligibleToReproduce * captiveBirthRate); % just born
    
    Y1(yr) = Y0(yr-1); % living out their first year (juveniles), no release, birth rate accounts for first-year mortality
    Y2(yr) = Y1(yr-1) * keepRate * captiveYear1SurvivalRate; % start of immature years
    Y3(yr) = Y2(yr-1) * captiveImmatureSurvivalRate;
    Y4(yr) = Y3(yr-1) * captiveImmatureSurvivalRate;
    Y5(yr) = Y4(yr-1) * captiveImmatureSurvivalRate;
    Y6(yr) = Y5(yr-1) * captiveImmatureSurvivalRate;   
    Y7(yr) = 0; % end of immature years
    A(yr) = A(yr-1) * captiveAdultSurvivalRate + (Y6(yr-1) * captiveImmatureSurvivalRate); % adults
  
    % wild condors
    wildadultsEligibleToReproduce = WA(yr-1) / 2; % assume 50% of adults are female
    WY0(yr) = (wildadultsEligibleToReproduce * wildBirthRate * wildCarryingCapacity); % just born
    WY1(yr) = WY0(yr-1); % living out their first year (juveniles)        
    WY2(yr) = (WY1(yr-1) * wildYear1SurvivalRate + (Y1(yr-1) * releaseRate * wildYear1SurvivalRate)); % start of immature years
    WY3(yr) = WY2(yr-1) * wildImmatureSurvivalRate;
    WY4(yr) = WY3(yr-1) * wildImmatureSurvivalRate;
    WY5(yr) = WY4(yr-1) * wildImmatureSurvivalRate;
    WY6(yr) = WY5(yr-1) * wildImmatureSurvivalRate;   
    WY7(yr) = WY6(yr-1) * wildImmatureSurvivalRate; 
    WY8(yr) = 0; % end of immature years
    WA(yr) = WA(yr-1) * wildAdultSurvivalRate + (WY7(yr-1) * wildImmatureSurvivalRate); % adults
    
end
% Group totals for plotting
% combining arrays to account for the correct groups for captive 
captiveJuveniles = Y1;
captiveImmatures = Y2 + Y3 + Y4 + Y5 + Y6;
captiveAdults    = A;
captiveTotal     = Y0 + captiveJuveniles + captiveImmatures + captiveAdults;

wildJuveniles = WY1;
wildImmatures = WY2 + WY3 + WY4 + WY5 + WY6 + WY7;
wildAdults    = WA;
wildTotal     = WY0 + wildJuveniles + wildImmatures + wildAdults;
totalBirds    = wildTotal + captiveTotal;
end
%%
Captivecap = 150;
Wildcap = 400;
[t, Wjuveniles, Wimmatures, Wadults, Wtotal, Cjuveniles, Cimmatures, Cadults, Ctotal, TotalBirds, Y1, WY1] = runCondorModel();
figure;
plot(t, Ctotal, 'Color', '#052F73', 'LineWidth', 1.5); hold on;
plot(t, Wtotal,'Color',  '#052f73', 'LineWidth', 1.5, 'LineStyle', '--');
plot(t, Cadults, 'b', 'LineWidth', 1.2);
plot(t, Wadults, '--b', 'LineWidth', 1.2);
plot(t, TotalBirds, 'g', 'LineWidth', 1.8);
yline(Captivecap,'--c', 'LineWidth', 2.5);
yline(Wildcap,'--k', 'LineWidth', 2.5);
grid on;
legend('Captive Total', 'Wild Total', 'Captive Adults', 'Wild Adults','TotalBirds','Captivecap', 'Wildcap','Location', 'northwest');
xlabel('Years');
ylabel('Number of Condors');
title('Captive and Wild Condor Populations (Project 3)');
