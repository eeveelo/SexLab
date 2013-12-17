scriptname ActorUtil Hidden

;/
	Packages.
/;

; This will add a package to actor that will override its normal behavior. Using this function overrides all packages added from any other location.
function AddPackageOverride(Actor targetActor, Package targetPackage, int priority = 30, int flags = 0) global native

; Remove a previously added package override.
bool function RemovePackageOverride(Actor targetActor, Package targetPackage) global native

; Count how many package overrides are currently on this actor. It will also count ones that's condition isn't met.
int function CountPackageOverride(Actor targetActor) global native

; Remove all package overrides on this actor, including ones that were added by other mods.
int function ClearPackageOverride(Actor targetActor) global native

; Remove this package from all actor overrides.
int function RemoveAllPackageOverride(Package targetPackage) global native
