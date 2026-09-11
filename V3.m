clear all;
%%
%Condor model
function [t, Wjuveniles, Wadults, Wtotal, Cjuveniles, Cadults, Ctotal, TotalBirds] = runCondorModel()
% initialization of variables and Rates

CR =  1.8 / 2; % The Female birth Rate assuming double clutching
WR = 0.3729/2; % wild female birth rate
num_years = 500; % simulation time in years
t = 1: num_years;
Kr = 1 - 0.8; % the keep rate of juvy condors
Rr = 0.8; % the release rate
MR = 0.086; % mortality rate for all birds
AMR = 0.086; % adult mortality rate
JMR = 0.086; % juv mortality rate
SR = 1 - MR; %survival rate for all birds
JSR = 1 - JMR; % juv survival rate
ASR = 1 - AMR; % adult survival rate
Captivecap = 150;
Wildcap = 400;



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

Y5(1) = 2;
Y6(1) = 2;
WY5(1) = 2;
WY6(1) = 2;


for yr = 2: num_years
    
    Ctotal_prev = Y0(yr-1) + Y1(yr-1) + Y2(yr-1) + Y3(yr-1) + Y4(yr-1) + Y5(yr-1) + Y6(yr-1) + A(yr-1);

    Wtotal_prev = WY0(yr-1) + WY1(yr-1) + WY2(yr-1) + WY3(yr-1) + WY4(yr-1) + WY5(yr-1) + WY6(yr-1) + WY7(yr-1) + WA(yr-1);
    
    WCC = 1 - (Wtotal_prev / Wildcap); % we might have to add a clamp here to prevent a negative value subtracting born chicks

    


    if Ctotal_prev <= Captivecap 
        
        %captive condor section
        
        adultsEligibleToReproduce = A(yr-1);
        
        Y0(yr) = (adultsEligibleToReproduce * CR);  % just born
        
        Y1(yr) = Y0(yr-1);         % living out their first year, no release
    
        Y2(yr) = Y1(yr-1) *  Kr * JSR;   % start of pre-adult years
        Y3(yr) = Y2(yr-1) *  JSR;
        Y4(yr) = Y3(yr-1) *  JSR;
        Y5(yr) = Y4(yr-1) *  JSR;
        Y6(yr) = Y5(yr-1) *  JSR;   
        Y7(yr) = 0;   % end of pre-adult years
        A(yr) = A(yr-1) * ASR + Y6(yr-1) * JSR;  % adults
    
    
    
    
        %wild condors
    
        WildadultsEligibleToReproduce = WA(yr-1);
    
        WY0(yr) = (WildadultsEligibleToReproduce * WR * WCC);  % just born
    
        WY1(yr) = WY0(yr-1);         
    
        WY2(yr) = (WY1(yr-1) * JSR + Y1(yr-1) * Rr * JSR);   % start of juv years
        WY3(yr) = WY2(yr-1) * JSR;
        WY4(yr) = WY3(yr-1) * JSR;
        WY5(yr) = WY4(yr-1) * JSR;
        WY6(yr) = WY5(yr-1) * JSR;   
        WY7(yr) = WY6(yr-1) * JSR; 
        WY8(yr) = 0;        % end of juv years
        WA(yr) = WA(yr-1) * ASR + WY7(yr-1) * JSR;  % adults
    else 
   
        %captive all juvys are released
        adultsEligibleToReproduce = A(yr-1);
        Y0(yr) = (adultsEligibleToReproduce * CR);  % just born
        Y1(yr) = Y0(yr-1);         % living out their first year, no release
        Y2(yr) = 0;   % start of pre-adult years
        Y3(yr) = 0;
        Y4(yr) = 0;
        Y5(yr) = 0;
        Y6(yr) = 0;   
        Y7(yr) = 0;   % end of pre-adult years
        A(yr) = A(yr-1) * ASR + Y6(yr-1) * SR;  % adults
        %wild condors
        WildadultsEligibleToReproduce = WA(yr-1);
        WY0(yr) = (WildadultsEligibleToReproduce * WR * WCC);  % just born
        WY1(yr) = WY0(yr-1);         % living out their first year, no release
        WY2(yr) = (WY1(yr-1) * JSR + Y1(yr-1) * 1.0 * SR);   % start of juv years
        WY3(yr) = WY2(yr-1) * JSR + Y2(yr-1) ;
        WY4(yr) = WY3(yr-1) * JSR + Y3(yr-1) ;
        WY5(yr) = WY4(yr-1) * JSR + Y4(yr-1) ;
        WY6(yr) = WY5(yr-1) * JSR + Y5(yr-1) ;   
        WY7(yr) = WY6(yr-1) * JSR + Y6(yr-1) ; 
        WY8(yr) = 0;        % end of juv years
        WA(yr) = WA(yr-1) * ASR + WY7(yr-1) * ASR;  % adults
    
    
    end
    
end
% Group totals for plotting
% combining arrays to account for the correct groups for captive 
Cjuveniles = Y1 + Y2 + Y3 + Y4 + Y5 + Y6;
Cadults    = A;
Ctotal     = Y0 + Cjuveniles + Cadults;
Wjuveniles = WY1 + WY2 + WY3 + WY4 + WY5 + WY6 + WY7;
Wadults    = WA;
Wtotal     = WY0 + Wjuveniles + Wadults;
TotalBirds = Wtotal + Ctotal;
end
%%

Captivecap = 150;
Wildcap = 400;

[t, Wjuveniles, Wadults, Wtotal, Cjuveniles, Cadults, Ctotal, TotalBirds] = runCondorModel();
figure;
plot(t, Ctotal, 'b-', 'LineWidth', 1.5); hold on;
plot(t, Wtotal, 'g-', 'LineWidth', 1.5);
plot(t, Cadults, 'b', 'LineWidth', 1.2);
plot(t, Wadults, 'g', 'LineWidth', 1.2);
plot(t, TotalBirds, 'r', 'LineWidth', 1.8);
yline(Captivecap,'--c', 'LineWidth', 2.5);
yline(Wildcap,'--y', 'LineWidth', 2.5);
grid on;

legend('Captive Total', 'Wild Total', 'Captive Adults', 'Wild Adults','TotalBirds','Captivecap', 'Wildcap', 'Location', 'northwest');
xlabel('Years');
ylabel('Number of Female Condors');
title('Captive and Wild Condor Populations (Project 3)');

