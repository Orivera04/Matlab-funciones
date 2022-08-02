Force=[0 100 100]*1e3;%Newtons
Length=[0.09 0.07 0.05];%meters
Radii=[0.01 0.02 0.01];%meters
Youngs=[200 220 215]*1e9;%Pascals
Gap=0.001;%meters
AppliedLoads=[-100]*1e3;%Newtons
%%%Begin Common Code%%%%%
Area=(Radii.^2)*pi;%meters^2
Deflection=(Force.*Length)./(Area.*Youngs);
TotalDeflection=sum(Deflection);
ForcedDeflection=TotalDeflection-Gap;
Stiffness=Length./(Area.*Youngs);
Percentage=Stiffness./sum(Stiffness);
RegionalDeflection=ForcedDeflection.*Percentage;
ReactionRightVector=-RegionalDeflection.*Youngs.*Area./Length;
RightReaction=ReactionRightVector(1)
LeftReaction=-sum(AppliedLoads)-RightReaction
