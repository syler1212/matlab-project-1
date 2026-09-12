clear all;
%%
%Condor model
function [t, wildJuveniles, wildAdults, wildTotal, captiveJjuveniles, captiveadults, captivetotal, totalBirds] = runCondorModel()
% initialization of variables and Rates

doubleClutching = true;

captiveBirthRate =  0.9; % The Female birth Rate assuming double clutching
if doubleClutching == true
    captiveBirthRate = captiveBirthRate * 2;
end
wildBirthRate = 0.3729; % wild female birth rate

num_years = 50; % simulation time in years
t = 1: num_years;

releaseRate = 0.8; % the release rate
keepRate = 1 - releaseRate; % the keep rate of juvy condors

adultMortalityRate = 0.086; % adult mortality rate
juvenileMortalityRate = 0.086; % juv mortality rate
year1MortalityRate = 0.138;
juvenileSurvivalRate = 1 - juvenileMortalityRate; % juv survival rate
adultSurvivalRate = 1 - adultMortalityRate; % adult survival rate
year1SurvivalRate = 1 - year1MortalityRate;

captiveCapacity = 150;
wildCapacity = 400;



% Define arrays and fill with 0's ahead of time to pre-allocate space
%arrays start at 1 in matlab not 0... odd 
%captive and wild groups, vectors 



Y0 = zeros(1, num_years);
Y1 = zeros(1, num_years);
Y2 = zeros(1, num_years);
Y3 = zeros(1, num_years);
Y4 = zeros(1, num_years);
Y5 = zeros(1, num_years);
Y6 = zeros(1, num_years);
Y7 = zeros(1, num_years);
A  = zeros(1, num_years);




WY0 = zeros(1, num_years);
WY1 = zeros(1, num_years);
WY2 = zeros(1, num_years);
WY3 = zeros(1, num_years);
WY4 = zeros(1, num_years);
WY5 = zeros(1, num_years);
WY6 = zeros(1, num_years);
WY7 = zeros(1, num_years);
WY8 = zeros(1, num_years);
WA  = zeros(1, num_years);

% setting initial conditions

Y5(1) = 20;
Y6(1) = 20;
WY5(1) = 2;
WY6(1) = 2;


for yr = 2: num_years
    
    captiveTotalPrev = Y0(yr-1) + Y1(yr-1) + Y2(yr-1) + Y3(yr-1) + Y4(yr-1) + Y5(yr-1) + Y6(yr-1) + A(yr-1);

    wildTotalPrev = WY0(yr-1) + WY1(yr-1) + WY2(yr-1) + WY3(yr-1) + WY4(yr-1) + WY5(yr-1) + WY6(yr-1) + WY7(yr-1) + WA(yr-1);
    
    wildCarryingCapacity = 1 - (wildTotalPrev / wildCapacity); % we might have to add a clamp here to prevent a negative value subtracting born chicks

    

    %If total captive population is less than our capacity, release 80% of
    %year-1 juveniles each year
    if captiveTotalPrev <= captiveCapacity 
        
        %captive condor section
        
        adultsEligibleToReproduce = A(yr-1) / 2; %assume 50% of adults are female

        %If we're not double clutching, we have to subtract the adults
        %eligible to reproduce by the number of year 0 chicks, to account
        %for adults that are busy raising chicks and won't reproduce that
        %year. If we are double-clutching, then this number is
        %approximately halved since human handlers are manually raising half of the
        %chicks on any given year
        if doubleClutching == true
            adultsEligibleToReproduce = adultsEligibleToReproduce - (Y0(yr-1)/2);
        else
            adultsEligibleToReproduce = adultsEligibleToReproduce - Y0(yr-1);
        end
        Y0(yr) = (adultsEligibleToReproduce * captiveBirthRate);  % just born
        
        Y1(yr) = Y0(yr-1);         % living out their first year, no release, birth rate accounts for first-year mortality
    
        Y2(yr) = Y1(yr-1) *  keepRate * year1SurvivalRate;   % start of pre-adult years
        Y3(yr) = Y2(yr-1) *  juvenileSurvivalRate;
        Y4(yr) = Y3(yr-1) *  juvenileSurvivalRate;
        Y5(yr) = Y4(yr-1) *  juvenileSurvivalRate;
        Y6(yr) = Y5(yr-1) *  juvenileSurvivalRate;   
        Y7(yr) = 0;   % end of pre-adult years
        A(yr) = A(yr-1) * adultSurvivalRate + (Y6(yr-1) * juvenileSurvivalRate);  % adults
      
        %wild condors
    
        wildadultsEligibleToReproduce = WA(yr-1) / 2;  %assume 50% of adults are female
        %see note on line 89. No double-clutching in the wild.
        wildadultsEligibleToReproduce = wildadultsEligibleToReproduce - WY0(yr-1);
        WY0(yr) = (wildadultsEligibleToReproduce * wildBirthRate * wildCarryingCapacity);  % just born
    
        WY1(yr) = WY0(yr-1);         
    
        WY2(yr) = (WY1(yr-1) * year1SurvivalRate + (Y1(yr-1) * releaseRate * juvenileSurvivalRate));   % start of juv years
        WY3(yr) = WY2(yr-1) * juvenileSurvivalRate;
        WY4(yr) = WY3(yr-1) * juvenileSurvivalRate;
        WY5(yr) = WY4(yr-1) * juvenileSurvivalRate;
        WY6(yr) = WY5(yr-1) * juvenileSurvivalRate;   
        WY7(yr) = WY6(yr-1) * juvenileSurvivalRate; 
        WY8(yr) = 0;        % end of juv years
        WA(yr) = WA(yr-1) * adultSurvivalRate + (WY7(yr-1) * juvenileSurvivalRate);  % adults
    else 
        
        %otherwise, captive population has reached capacity - release all
        %juveniles to the wild
        adultsEligibleToReproduce = A(yr-1) / 2;  % assume 50% of adults are female
        %see note above on line 89
        if doubleClutching == true
            adultsEligibleToReproduce = adultsEligibleToReproduce - (Y0(yr-1)/2);
        else
            adultsEligibleToReproduce = adultsEligibleToReproduce - Y0(yr-1);
        end
        Y0(yr) = (adultsEligibleToReproduce * captiveBirthRate);  % just born
        Y1(yr) = Y0(yr-1);         % living out their first year, no release
        Y2(yr) = 0;   % start of pre-adult years
        Y3(yr) = 0;
        Y4(yr) = 0;
        Y5(yr) = 0;
        Y6(yr) = 0;   
        Y7(yr) = 0;   % end of pre-adult years
        A(yr) = A(yr-1) * adultSurvivalRate + Y6(yr-1) * juvenileSurvivalRate;  % adults
        %wild condors
        wildadultsEligibleToReproduce = WA(yr-1) / 2;  % assume 50% of adults are female
        %see note on line 89. No double-clutching in the wild.
        wildadultsEligibleToReproduce = wildadultsEligibleToReproduce - WY0(yr-1);
        WY0(yr) = (wildadultsEligibleToReproduce * wildBirthRate * wildCarryingCapacity);  % just born
        WY1(yr) = WY0(yr-1);         % living out their first year, no release
        WY2(yr) = WY1(yr-1) * year1SurvivalRate + (Y1(yr-1) * year1SurvivalRate);   % start of juv years
        WY3(yr) = WY2(yr-1) * juvenileSurvivalRate + Y2(yr-1);
        WY4(yr) = WY3(yr-1) * juvenileSurvivalRate + Y3(yr-1);
        WY5(yr) = WY4(yr-1) * juvenileSurvivalRate + Y4(yr-1);
        WY6(yr) = WY5(yr-1) * juvenileSurvivalRate + Y5(yr-1);   
        WY7(yr) = WY6(yr-1) * juvenileSurvivalRate + Y6(yr-1); 
        WY8(yr) = 0;        % end of juv years
        WA(yr) = (WA(yr-1) * adultSurvivalRate) + (WY7(yr-1) * juvenileSurvivalRate);  % adults
    
    
    end
    
end
% Group totals for plotting
% combining arrays to account for the correct groups for captive 
captiveJjuveniles = Y1 + Y2 + Y3 + Y4 + Y5 + Y6;
captiveadults    = A;
captivetotal     = Y0 + captiveJjuveniles + captiveadults;
wildJuveniles = WY1 + WY2 + WY3 + WY4 + WY5 + WY6 + WY7;
wildAdults    = WA;
wildTotal     = WY0 + wildJuveniles + wildAdults;
totalBirds = wildTotal + captivetotal;
end
%%

Captivecap = 150;
Wildcap = 400;

[t, Wjuveniles, Wadults, Wtotal, Cjuveniles, Cadults, Ctotal, TotalBirds] = runCondorModel();
figure;
plot(t, Ctotal, 'Color', '#034473', 'LineWidth', 1.5); hold on;
plot(t, Wtotal,'Color',  '#a32900', 'LineWidth', 1.5);
plot(t, Cadults, 'b', 'LineWidth', 1.2);
plot(t, Wadults, 'r', 'LineWidth', 1.2);
plot(t,Cjuveniles, 'c', 'LineWidth',1.2);
plot(t,Wjuveniles, 'm', 'LineWidth',1.2);
plot(t, TotalBirds, 'g', 'LineWidth', 1.8);
yline(Captivecap,'--c', 'LineWidth', 2.5);
yline(Wildcap,'--r', 'LineWidth', 2.5);
grid on;

legend('Captive Total', 'Wild Total', 'Captive Adults', 'Wild Adults', 'Captive Juveniles', 'Wild Juveniles','TotalBirds','Captivecap', 'Wildcap', 'Location', 'northwest');
xlabel('Years');
ylabel('Number of Female Condors');
title('Captive and Wild Condor Populations (Project 3)');

