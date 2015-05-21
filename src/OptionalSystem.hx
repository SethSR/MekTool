enum OptionalSystem {
	Stereo              (properties: Array<Property>); // extends OptType { override val toString = "Stereo" }
	Liftwire            (properties: Array<Property>); // extends OptType { override val toString = "Liftwire" }
	AntiTheftCodeLock   (properties: Array<Property>); // extends OptType { override val toString = "Anti-Theft Code Lock" }
	Spotlights          (properties: Array<Property>); // extends OptType { override val toString = "Spotlights" }
	Nightlights         (properties: Array<Property>); // extends OptType { override val toString = "Nightlights" }
	StorageModule       (properties: Array<Property>); // extends OptType { override val toString = "Storage Module" }
	Micromanipulators   (properties: Array<Property>); // extends OptType { override val toString = "Micromanipulators" }
	SlickSpray          (properties: Array<Property>); // extends OptType { override val toString = "Slick-Spray" }
	BoggSpray           (properties: Array<Property>); // extends OptType { override val toString = "Bogg-Spray" }
	DamageControlPackage(properties: Array<Property>); // extends OptType { override val toString = "Damage Control Package" }
	QuickChangeMount    (properties: Array<Property>); // extends OptType { override val toString = "Quick Change Mount" }
	SilentRunning       (properties: Array<Property>); // extends OptType { override val toString = "Silent Running" }
	Parachute           (properties: Array<Property>); // extends OptType { override val toString = "Parachute" }
	ReEntryPackage      (properties: Array<Property>); // extends OptType { override val toString = "Re-Entry Package" }
	EjectionSeat        (properties: Array<Property>); // extends OptType { override val toString = "Ejection Seat" }
	EscapePod           (properties: Array<Property>); // extends OptType { override val toString = "Escape Pod" }
	ManeuverPod         (properties: Array<Property>); // extends OptType { override val toString = "Maneuver Pod" }
	VehiclePod          (properties: Array<Property>); // extends OptType { override val toString = "Vehicle Pod" }
}