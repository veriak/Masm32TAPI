;----------------------------------------------------------------------------------------
; TAPI.inc  
;
; Copyright 2007 Veria Kalantary - Ideas of East Company
; http://www.IdeasofEast.com; http://www.ioe.co.ir
;----------------------------------------------------------------------------------------

LINEEXTENSIONID struct
	dwExtensionID0 DWORD ?
	dwExtensionID1 DWORD ?
	dwExtensionID2 DWORD ?
	dwExtensionID3 DWORD ?
LINEEXTENSIONID ends

LINEDIALPARAMS struct
    dwDialPause 		DWORD ?
    dwDialSpeed 		DWORD ?
    dwDigitDuration		DWORD ?
    dwWaitForDialtone	DWORD ?
LINEDIALPARAMS ends

LINECALLPARAMS struct
    dwTotalSize						DWORD ?
    dwBearerMode					DWORD ?
    dwMinRate						DWORD ?
    dwMaxRate						DWORD ?
    dwMediaMode						DWORD ?
  	dwCallParamFlags				DWORD ?
    dwAddressMode					DWORD ?
    dwAddressID						DWORD ?
    DialParams 						LINEDIALPARAMS <> 
	dwOrigAddressSize				DWORD ?
    dwOrigAddressOffset				DWORD ?
    dwDisplayableAddressSize		DWORD ?
    dwDisplayableAddressOffset		DWORD ?
    dwCalledPartySize				DWORD ?
    dwCalledPartyOffset				DWORD ?
    dwCommentSize					DWORD ?
    dwCommentOffset					DWORD ?
    dwUserUserInfoSize				DWORD ?
    dwUserUserInfoOffset			DWORD ?
    dwHighLevelCompSize				DWORD ?
    dwHighLevelCompOffset			DWORD ?
    dwLowLevelCompSize				DWORD ?
    dwLowLevelCompOffset			DWORD ?
    dwDevSpecificSize				DWORD ?
    dwDevSpecificOffset				DWORD ?
    dwPredictiveAutoTransferStates	DWORD ?
    dwTargetAddressSize				DWORD ?
    dwTargetAddressOffset			DWORD ?
    dwSendingFlowspecSize			DWORD ?
    dwSendingFlowspecOffset			DWORD ?
    dwReceivingFlowspecSize			DWORD ?
    dwReceivingFlowspecOffset		DWORD ?
    dwDeviceClassSize				DWORD ?
    dwDeviceClassOffset				DWORD ?
    dwDeviceConfigSize				DWORD ?
    dwDeviceConfigOffset			DWORD ?
    dwCallDataSize					DWORD ?
    dwCallDataOffset				DWORD ?
    dwNoAnswerTimeout				DWORD ?
    dwCallingPartyIDSize			DWORD ?
    dwCallingPartyIDOffset			DWORD ?
LINECALLPARAMS ends

LINECALLINFO struct
    dwTotalSize						DWORD ?
    dwNeededSize					DWORD ?
    dwUsedSize						DWORD ?
    hLine 							HANDLE ?
    dwLineDeviceID					DWORD ?
    dwAddressID						DWORD ?
    dwBearerMode					DWORD ?
    dwRate							DWORD ?
    dwMediaMode						DWORD ?
    dwAppSpecific					DWORD ?
    dwCallID						DWORD ?
    dwRelatedCallID					DWORD ?
    dwCallParamFlags				DWORD ?
    dwCallStates					DWORD ?
    dwMonitorDigitModes				DWORD ?
    dwMonitorMediaModes				DWORD ?
    DialParams						LINEDIALPARAMS <>
    dwOrigin						DWORD ?
    dwReason						DWORD ?
    dwCompletionID					DWORD ?
    dwNumOwners						DWORD ?
    dwNumMonitors					DWORD ?
    dwCountryCode					DWORD ?
    dwTrunk							DWORD ?
    dwCallerIDFlags					DWORD ?
    dwCallerIDSize					DWORD ?
    dwCallerIDOffset				DWORD ?
    dwCallerIDNameSize				DWORD ?
    dwCallerIDNameOffset			DWORD ?
    dwCalledIDFlags					DWORD ?
    dwCalledIDSize					DWORD ?
    dwCalledIDOffset				DWORD ?
    dwCalledIDNameSize				DWORD ?
    dwCalledIDNameOffset			DWORD ?
    dwConnectedIDFlags				DWORD ?
    dwConnectedIDSize				DWORD ?
    dwConnectedIDOffset				DWORD ?
    dwConnectedIDNameSize			DWORD ?
    dwConnectedIDNameOffset			DWORD ?
    dwRedirectionIDFlags			DWORD ?
    dwRedirectionIDSize				DWORD ?
    dwRedirectionIDOffset			DWORD ?
    dwRedirectionIDNameSize			DWORD ?
    dwRedirectionIDNameOffset		DWORD ?
    dwRedirectingIDFlags			DWORD ?
    dwRedirectingIDSize				DWORD ?
    dwRedirectingIDOffset			DWORD ?
    dwRedirectingIDNameSize			DWORD ?
    dwRedirectingIDNameOffset		DWORD ?
    dwAppNameSize					DWORD ?
    dwAppNameOffset					DWORD ?
    dwDisplayableAddressSize		DWORD ? 
    dwDisplayableAddressOffset		DWORD ?
    dwCalledPartySize				DWORD ?
    dwCalledPartyOffset				DWORD ?
    dwCommentSize					DWORD ?
    dwCommentOffset					DWORD ?
    dwDisplaySize					DWORD ?
    dwDisplayOffset					DWORD ?
    dwUserUserInfoSize				DWORD ?
    dwUserUserInfoOffset			DWORD ?
    dwHighLevelCompSize				DWORD ?
    dwHighLevelCompOffset			DWORD ?
    dwLowLevelCompSize				DWORD ?
    dwLowLevelCompOffset			DWORD ?
    dwChargingInfoSize				DWORD ?
    dwChargingInfoOffset			DWORD ?
    dwTerminalModesSize				DWORD ?
    dwTerminalModesOffset			DWORD ?
    dwDevSpecificSize				DWORD ?
    dwDevSpecificOffset				DWORD ?
    dwCallTreatment					DWORD ?
    dwCallDataSize					DWORD ?
    dwCallDataOffset				DWORD ?
    dwSendingFlowspecSize			DWORD ?
    dwSendingFlowspecOffset			DWORD ?
    dwReceivingFlowspecSize			DWORD ?
    dwReceivingFlowspecOffset		DWORD ?
LINECALLINFO ends

VARSTRING struct
    dwTotalSize						DWORD ?
    dwNeededSize					DWORD ?
    dwUsedSize						DWORD ?
    dwStringFormat					DWORD ?
    dwStringSize					DWORD ?
    dwStringOffset					DWORD ?
VARSTRING ends    

.const
	IDD_MAINDLG 					EQU		1000
	IDC_EDT_NUMOFDIAL 				EQU		1001
	IDC_BTN_CALL 					EQU		1003
	IDC_BTN_HANGOFF 				EQU		1004
	IDC_BTN_EXIT 					EQU		1005
	IDC_LST_CALLPROGRESS			EQU		1007
	tapiLowVersion					EQU		10004H
	tapiHighVersion  				EQU		20002H
    TAPI_LINE_REPLY         		EQU		5000 
	TAPI_LINECALLSTATE_CONNECTED	EQU		5001 
	TAPI_LINECALLSTATE_IDLE 		EQU     5002 
	TAPI_LINECALLSTATE_DISCONNECTED EQU		5003 
	TAPI_LINECALLSTATE_BUSY 		EQU     5004 
	TAPI_LINECALLSTATE_AccEPTED  	EQU     5005 
	TAPI_LINECALLSTATE_PROCEEDING   EQU     5006 
	TAPI_LINECALLSTATE_OFFERING     EQU   	5007 
	TAPI_LINECALLSTATE_DIALTONE     EQU   	5008 
	TAPI_LINECALLSTATE_DIALING      EQU  	5009 
	
	LINECALLPRIVILEGE_NONE          EQU     00000001h
 	LINECALLPRIVILEGE_MONITOR    	EQU     00000002h
	LINECALLPRIVILEGE_OWNER			EQU	    00000004h
	
	LINEMEDIAMODE_UNKNOWN 			EQU     00000002h
	LINEMEDIAMODE_INTERACTIVEVOICE  EQU     00000004h
	LINEMEDIAMODE_AUTOMATEDVOICE    EQU     00000008h
	LINEMEDIAMODE_DATAMODEM         EQU     00000010h
	LINEMEDIAMODE_G3FAX             EQU     00000020h
	LINEMEDIAMODE_TDD               EQU     00000040h
	LINEMEDIAMODE_G4FAX             EQU     00000080h
	LINEMEDIAMODE_DIGITALDATA       EQU     00000100h
	LINEMEDIAMODE_TELETEX           EQU     00000200h
	LINEMEDIAMODE_VIDEOTEX          EQU     00000400h
	LINEMEDIAMODE_TELEX             EQU     00000800h
	LINEMEDIAMODE_MIXED             EQU     00001000h
	LINEMEDIAMODE_ADSI              EQU     00002000h
	LINEMEDIAMODE_VOICEVIEW         EQU     00004000h
	LINEMEDIAMODE_VIDEO             EQU     00008000h
	LAST_LINEMEDIAMODE              EQU     00008000h

	LINE_ADDRESSSTATE               EQU        0
	LINE_CALLINFO                   EQU        1
    LINE_CALLSTATE                  EQU		   2     
    LINE_CLOSE                      EQU        3
    LINE_DEVSPECIFIC                EQU        4
    LINE_DEVSPECIFICFEATURE         EQU        5
    LINE_GATHERDIGITS               EQU        6
    LINE_GENERATE                   EQU        7
    LINE_LINEDEVSTATE               EQU        8
    LINE_MONITORDIGITS              EQU        9
    LINE_MONITORMEDIA               EQU        10
    LINE_MONITORTONE                EQU        11
    LINE_REPLY                      EQU        12
    LINE_REQUEST                    EQU        13
    PHONE_BUTTON                    EQU        14
    PHONE_CLOSE                     EQU        15
    PHONE_DEVSPECIFIC               EQU        16
    PHONE_REPLY                     EQU        19            
    PHONE_CREATE                    EQU        20            
    LINE_AGENTSPECIFIC              EQU        21            
    LINE_AGENTSTATUS                EQU        22            
    LINE_APPNEWCALL                 EQU        23            
    LINE_PROXYREQUEST               EQU        24            
    LINE_REMOVE                     EQU        25            
    PHONE_REMOVE                    EQU        26           
	LINE_AGENTSESSIONSTATUS         EQU        27           
    LINE_QUEUESTATUS                EQU        28           
    LINE_AGENTSTATUSEX              EQU        29          
    LINE_GROUPSTATUS                EQU        30          
    LINE_PROXYSTATUS                EQU        31          
    LINE_APPNEWCALLHUB              EQU        32          
    LINE_CALLHUBCLOSE               EQU        33          
    LINE_DEVSPECIFICEX              EQU        34          

    LINECALLSTATE_IDLE               EQU        00000001h
    LINECALLSTATE_OFFERING           EQU        00000002h
    LINECALLSTATE_ACCEPTED           EQU        00000004h
    LINECALLSTATE_DIALTONE           EQU        00000008h
    LINECALLSTATE_DIALING            EQU        00000010h
    LINECALLSTATE_RINGBACK           EQU        00000020h
    LINECALLSTATE_BUSY               EQU        00000040h
    LINECALLSTATE_SPECIALINFO        EQU        00000080h
    LINECALLSTATE_CONNECTED          EQU        00000100h
    LINECALLSTATE_PROCEEDING         EQU        00000200h
    LINECALLSTATE_ONHOLD             EQU        00000400h
    LINECALLSTATE_CONFERENCED        EQU        00000800h
    LINECALLSTATE_ONHOLDPENDCONF     EQU        00001000h
    LINECALLSTATE_ONHOLDPENDTRANSFER EQU        00002000h
    LINECALLSTATE_DISCONNECTED       EQU        00004000h
    LINECALLSTATE_UNKNOWN            EQU        00008000h

	LINECALLSELECT_LINE              EQU    	00000001h
	LINECALLSELECT_ADDRESS           EQU    	00000002h
	LINECALLSELECT_CALL              EQU    	00000004h
	INECALLSELECT_DEVICEID           EQU   		00000008h
	INECALLSELECT_CALLID             EQU   		00000010h

    LINEDEVSTATE_OTHER               EQU        00000001h
    LINEDEVSTATE_RINGING             EQU        00000002h
    LINEDEVSTATE_CONNECTED           EQU        00000004h
    LINEDEVSTATE_DISCONNECTED        EQU        00000008h
    LINEDEVSTATE_MSGWAITON           EQU        00000010h
    LINEDEVSTATE_MSGWAITOFF          EQU        00000020h
    LINEDEVSTATE_INSERVICE           EQU        00000040h
    LINEDEVSTATE_OUTOFSERVICE        EQU        00000080h
    LINEDEVSTATE_MAINTENANCE         EQU        00000100h
    LINEDEVSTATE_OPEN                EQU        00000200h
    LINEDEVSTATE_CLOSE               EQU        00000400h
    LINEDEVSTATE_NUMCALLS            EQU        00000800h
    LINEDEVSTATE_NUMCOMPLETIONS      EQU        00001000h
    LINEDEVSTATE_TERMINALS           EQU        00002000h
    LINEDEVSTATE_ROAMMODE            EQU        00004000h
    LINEDEVSTATE_BATTERY             EQU        00008000h
    LINEDEVSTATE_SIGNAL              EQU        00010000h
    LINEDEVSTATE_DEVSPECIFIC         EQU        00020000h
    LINEDEVSTATE_REINIT              EQU        00040000h
    LINEDEVSTATE_LOCK                EQU        00080000h
    LINEDEVSTATE_CAPSCHANGE          EQU        00100000h
    LINEDEVSTATE_CONFIGCHANGE        EQU        00200000h
    LINEDEVSTATE_TRANSLATECHANGE     EQU        00400000h
    LINEDEVSTATE_COMPLCANCEL         EQU        00800000h
    LINEDEVSTATE_REMOVED             EQU        01000000h    