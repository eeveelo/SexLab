scriptname ActorUtil Hidden

;/
	Override packages of actors.

	These overrides persist through save games. If you override package on same actor
	more than once then the package with highest priority will run, if multiple
	overrides have same priority then last added package will run. Priority ranges
	from 0 to 100 with 100 being highest priority.
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
	