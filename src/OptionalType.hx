enum OptionalSystem {
	Stereo              (properties: List<Property>); // extends OptType { override val toString = "Stereo" }
	Liftwire            (properties: List<Property>); // extends OptType { override val toString = "Liftwire" }
	AntiTheftCodeLock   (properties: List<Property>); // extends OptType { override val toString = "Anti-Theft Code Lock" }
	Spotlights          (properties: List<Property>); // extends OptType { override val toString = "Spotlights" }
	Nightlights         (properties: List<Property>); // extends OptType { override val toString = "Nightlights" }
	StorageModule       (properties: List<Property>); // extends OptType { override val toString = "Storage Module" }
	Micromanipulators   (properties: List<Property>); // extends OptType { override val toString = "Micromanipulators" }
	SlickSpray          (properties: List<Property>); // extends OptType { override val toString = "Slick-Spray" }
	BoggSpray           (properties: List<Property>); // extends OptType { override val toString = "Bogg-Spray" }
	DamageControlPackage(properties: List<Property>); // extends OptType { override val toString = "Damage Control Package" }
	QuickChangeMount    (properties: List<Property>); // extends OptType { override val toString = "Quick Change Mount" }
	SilentRunning       (properties: List<Property>); // extends OptType { override val toString = "Silent Running" }
	Parachute           (properties: List<Property>); // extends OptType { override val toString = "Parachute" }
	ReEntryPackage      (properties: List<Property>); // extends OptType { override val toString = "Re-Entry Package" }
	EjectionSeat        (properties: List<Property>); // extends OptType { override val toString = "Ejection Seat" }
	EscapePod           (properties: List<Property>); // extends OptType { override val toString = "Escape Pod" }
	ManeuverPod         (properties: List<Property>); // extends OptType { override val toString = "Maneuver Pod" }
	VehiclePod          (properties: List<Property>); // extends OptType { override val toString = "Vehicle Pod" }
}