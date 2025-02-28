Scriptname TestSelectiveLoading extends TestSelectiveLoadingParent

import Utility

Float Function main(Float value, ObjectReference ref, TestSelectiveLoadingOtherParent other)
	; ObjectReference
	ref.GetDisplayName()
	; Form
	ref.GetFormID()
	; Game
	Game.GetPlayer()
	; Utility
	RandomInt(0, 100)
	; TestSelectiveLoadingParent
	ParentMethod()

	(other as TestSelectiveLoadingOther).OtherObjVar
	; TODO add error msg
	; ParentGlobalFunc() ; original compiler error: TestSelectiveLoading.psc(17,1): global function ParentGlobalFunc cannot be called on an object
	Return value
EndFunction