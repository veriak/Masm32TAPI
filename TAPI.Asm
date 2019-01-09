;----------------------------------------------------------------------------------------
; MASM32 TAPI
;  
; MASM32 version of TAPI sample code of
; "Michael C. Amundsen"'s good book - "Mapi, Sapi, and Tapi: Developer's Guide"
;
; Copyright 2007 Veria Kalantari
; veria.kalantary@gmail.com
; https://github.com/veriak
;
;----------------------------------------------------------------------------------------

.386
.model flat, stdcall  
option casemap :none  

include windows.inc
include kernel32.inc
include user32.inc
include Comctl32.inc
include tapi32.inc 

includelib kernel32.lib
includelib user32.lib
includelib Comctl32.lib
includelib tapi32.lib

include TAPI.inc

StrM MACRO data:VARARG                    
    LOCAL Buff
.data
    Buff db data, 0h
.code
    exitm <addr Buff>
ENDM

DlgProc	PROTO :HWND, :UINT, :WPARAM, :LPARAM
PlaceCall PROTO :HWND, :DWORD
memset PROTO :DWORD, :BYTE, :DWORD
ShowProgress PROTO :HWND, :DWORD
SetVarProps PROTO :HWND, :DWORD
LineCallBackProc PROTO :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD

.data
	LineHandle HANDLE 0
	
.data?
	hInstance	DWORD	?
	lines		DWORD	?
	LineParams  LINECALLPARAMS <>
	
.code

start:

	invoke GetModuleHandle, NULL
	mov	hInstance, eax

    invoke InitCommonControls	
    
	invoke DialogBoxParam, hInstance, IDD_MAINDLG, NULL, addr DlgProc, NULL
	invoke ExitProcess, 0
	
DlgProc proc hWin:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM

	LOCAL PhoneNumber [100] : BYTE
	LOCAL hCall : HANDLE
	LOCAL hLine : HANDLE
	LOCAL hComm : HANDLE

	mov	eax, uMsg
	.if eax == WM_INITDIALOG
		invoke SetProp, hWin, StrM("HCALL"), NULL
		invoke SetProp, hWin, StrM("HLINE"), NULL
		invoke SetProp, hWin, StrM("HCOMM"), NULL

	.elseif eax == WM_COMMAND
		mov eax, wParam
		.if	eax == IDC_BTN_CALL
			invoke GetProp, hWin, StrM("HCALL")	
			mov hCall, eax
			.if hCall != NULL
				invoke MessageBox, hWin, StrM("Please Disconnect before making another call"),\
								 StrM("TAPI Error"), MB_OK
				ret
			.endif
			invoke GetDlgItemText, hWin, IDC_EDT_NUMOFDIAL, ADDR PhoneNumber, sizeof PhoneNumber
			invoke PlaceCall, hWin, ADDR PhoneNumber
			.if eax < 0
				invoke ShowProgress, hWin, StrM("Unable to start a TAPI Function") 
			.endif

		.elseif eax == IDC_BTN_HANGOFF
			invoke GetProp, hWin, StrM("HCALL")
			mov hCall, eax
			invoke GetProp, hWin, StrM("HCOMM")
			mov hComm, eax
			.if hComm != NULL
				invoke CloseHandle, hComm
				invoke SetProp, hWin, StrM("HCALL"), NULL
			.endif
			.if hCall != NULL
				invoke lineDrop, hCall, NULL, 0
				invoke ShowProgress, hWin, StrM("Call is Dropped")
				invoke SetProp, hWin, StrM("HCALL"), NULL
			.endif

		.elseif eax == IDC_BTN_EXIT
			invoke GetProp, hWin, StrM("HCALL")
			mov hCall, eax
			invoke GetProp, hWin, StrM("HCOMM")
			mov hComm, eax
			invoke GetProp, hWin, StrM("HLINE")
			mov hLine, eax
			.if hComm != NULL
				invoke CloseHandle, hComm
				invoke SetProp, hWin, StrM("HCOMM"), NULL
			.endif
			.if hCall != NULL
				invoke lineDrop, hCall, NULL, 0
				invoke SetProp, hWin, StrM("HCALL"), NULL
			.endif
			.if hLine != NULL
				invoke lineClose, hLine
				invoke SetProp, hWin, StrM("HLINE"), NULL
			.endif
			.if LineHandle != NULL
				invoke lineShutdown, LineHandle
				mov LineHandle, NULL
			.endif	
			invoke RemoveProp, hWin, StrM("HCALL")
			invoke RemoveProp, hWin, StrM("HCOMM")
			invoke RemoveProp, hWin, StrM("HLINE")
			invoke EndDialog, hWin, 0

		.elseif eax == TAPI_LINE_REPLY 
			invoke ShowProgress, hWin, StrM("Line Reply")
			
		.elseif eax == TAPI_LINECALLSTATE_CONNECTED
			invoke ShowProgress, hWin, StrM("Line Call State is Connected")
		
		.elseif eax == TAPI_LINECALLSTATE_IDLE		
			invoke GetProp, hWin, StrM("HLINE")
			mov hLine, eax
			.if hLine != NULL
				invoke lineClose, hLine
				invoke SetProp, hWin, StrM("HLINE"), NULL
			.endif
			invoke ShowProgress, hWin, StrM("Line Call State is idle")
			
		.elseif eax == TAPI_LINECALLSTATE_DISCONNECTED
			invoke ShowProgress, hWin, StrM("Line Call State is Disconnected")
				
		.elseif eax == TAPI_LINECALLSTATE_BUSY
			invoke ShowProgress, hWin, StrM("Line Call State is Busy")
				
		.elseif eax == TAPI_LINECALLSTATE_AccEPTED
			invoke ShowProgress, hWin, StrM("Line Call State is Accepted")
				
		.elseif eax == TAPI_LINECALLSTATE_PROCEEDING
			invoke ShowProgress, hWin, StrM("Line Call State is Proceeding")
				
		.elseif eax == TAPI_LINECALLSTATE_OFFERING
			invoke ShowProgress, hWin, StrM("Line Call State is Offering")
				
		.elseif eax == TAPI_LINECALLSTATE_DIALTONE
			invoke ShowProgress, hWin, StrM("Line Call State is DialTone")
				
		.elseif eax == TAPI_LINECALLSTATE_DIALING
			invoke ShowProgress, hWin, StrM("Line Call State is Dialing")
						
		.endif
		
	.elseif eax == WM_CLOSE
		invoke EndDialog, hWin, 0
					
	.endif
	
	xor		eax, eax
	ret

DlgProc endp

PlaceCall PROC hWin:HWND, lpPhoneNumber:DWORD
	LOCAL i : DWORD
	LOCAL ApiVersion : DWORD
	LOCAL RetApiVersion : DWORD
	LOCAL ExtensionID : LINEEXTENSIONID
	LOCAL hLine : HANDLE
	LOCAL hCall : HANDLE
	
	invoke lstrlen, lpPhoneNumber
	.if eax < 1
		mov eax, -1
		ret
	.endif
	.if LineHandle == NULL
		invoke lineInitialize, ADDR LineHandle, hInstance, ADDR LineCallBackProc, StrM("TAPI"), ADDR lines  
	.endif
	.if eax < 0
		ret
	.endif
	invoke GetProp, hWin, StrM("HLINE")
	mov hLine, eax
	.if hLine == NULL
		mov i, 0
		mov ebx, lines
		.while i < ebx			
			invoke lineNegotiateAPIVersion, LineHandle, i, tapiLowVersion, tapiHighVersion,\
								 ADDR RetApiVersion, ADDR ExtensionID
			invoke lineOpen, LineHandle, i, ADDR hLine, RetApiVersion, 0, hWin,\
						 LINECALLPRIVILEGE_OWNER or LINECALLPRIVILEGE_MONITOR, LINEMEDIAMODE_DATAMODEM, NULL
			.if eax == 0
				jmp @F
			.endif
			inc i
		.endw
	@@:	
		.if eax != 0
			mov eax, -1
			ret
		.endif
	.endif
	invoke SetProp, hWin, StrM("HLINE"), hLine
	invoke memset, addr	LineParams, 0, sizeof LINECALLPARAMS
	mov eax, sizeof LINECALLPARAMS
	mov LineParams.dwTotalSize, eax
	mov LineParams.dwMinRate, 9600  
	mov LineParams.dwMaxRate, 9600
	push LINEMEDIAMODE_DATAMODEM
	pop LineParams.dwMediaMode
	invoke lineMakeCall, hLine, ADDR hCall, lpPhoneNumber, 0, ADDR LineParams   
	ret 
PlaceCall endp

ShowProgress PROC hWin:HWND, lpOutputString:DWORD
	
	LOCAL dwIndex : DWORD
	
	invoke SendDlgItemMessage, hWin, IDC_LST_CALLPROGRESS, LB_ADDSTRING, 0, lpOutputString
	mov dwIndex, eax
	.if eax == LB_ERR		
		invoke SendDlgItemMessage, hWin, IDC_LST_CALLPROGRESS, LB_DELETESTRING, 0, 0
		invoke SendDlgItemMessage, hWin, IDC_LST_CALLPROGRESS, LB_ADDSTRING, 0, lpOutputString
		mov dwIndex, eax			
	.endif
	invoke SendDlgItemMessage, hWin, IDC_LST_CALLPROGRESS, LB_SETCURSEL, dwIndex, 0
	ret

ShowProgress endp

SetVarProps PROC hWin:HWND, hDevice:DWORD	
	LOCAL LineCallInf:LINECALLINFO
	
	invoke memset, ADDR LineCallInf, 0, sizeof LINECALLINFO
	invoke SetProp, hWin, StrM("HCALL"), hDevice 
	mov eax, sizeof LINECALLINFO
	mov LineCallInf.dwTotalSize, eax
	invoke lineGetCallInfo, hDevice, ADDR LineCallInf
	invoke SetProp, hWin, StrM("HLINE"), LineCallInf.hLine 
	ret

SetVarProps endp

LineCallBackProc PROC hDevice:DWORD, dwMessage:DWORD, dwInstance:DWORD, dwParam1:DWORD,\
					 dwParam2:DWORD, dwParam3:DWORD
	
	LOCAL LineCallInf : LINECALLINFO
	LOCAL lpVarStringStruct : DWORD
	LOCAL sizeofVarStringStruct : DWORD
	LOCAL CommFile : HANDLE
	
	mov eax, dwMessage
	.if eax == LINE_CALLSTATE
		mov eax, dwParam1
		.if eax == LINECALLSTATE_IDLE
			invoke memset, ADDR LineCallInf, 0, sizeof LINECALLINFO
			mov eax, sizeof LINECALLINFO
			mov LineCallInf.dwTotalSize, eax
			invoke lineGetCallInfo, hDevice, ADDR LineCallInf
			invoke lineDeallocateCall, hDevice
			invoke PostMessage, dwInstance, WM_COMMAND, TAPI_LINECALLSTATE_IDLE, LineCallInf.hLine
		
		.elseif eax == LINECALLSTATE_CONNECTED
			mov lpVarStringStruct, NULL
			mov eax, sizeof VARSTRING
			add eax, 1024
			mov sizeofVarStringStruct, eax
			mov CommFile, NULL
			invoke LocalAlloc, 0, sizeofVarStringStruct 
			mov lpVarStringStruct, eax
		@@:
			invoke memset, lpVarStringStruct, 0, sizeofVarStringStruct 
			mov ebx, lpVarStringStruct
			mov eax, sizeofVarStringStruct
			mov (VARSTRING ptr [ebx]).dwTotalSize, eax
			invoke lineGetID, 0, 0, hDevice, LINECALLSELECT_CALL, lpVarStringStruct, StrM("comm/datamodem") 
			cmp eax, 0
			jne @B
			
			mov eax, (VARSTRING ptr [ebx]).dwStringOffset
			add eax, lpVarStringStruct
			mov ebx, DWORD ptr [eax]
			mov CommFile, ebx
			
			invoke SetProp, dwInstance, StrM("HCOMM"), CommFile
			invoke SetVarProps, dwInstance, hDevice
			invoke PostMessage, dwInstance, WM_COMMAND, TAPI_LINECALLSTATE_CONNECTED, CommFile
			invoke LocalFree, lpVarStringStruct
			
		
		.elseif eax == LINECALLSTATE_ACCEPTED
			invoke SetVarProps, dwInstance, hDevice
			invoke PostMessage, dwInstance, WM_COMMAND, TAPI_LINECALLSTATE_AccEPTED, CommFile
			
		.elseif eax == LINECALLSTATE_PROCEEDING
			invoke SetVarProps, dwInstance, hDevice
			invoke PostMessage, dwInstance, WM_COMMAND, TAPI_LINECALLSTATE_PROCEEDING, CommFile
			
		.elseif eax == LINECALLSTATE_OFFERING
			invoke SetVarProps, dwInstance, hDevice
			invoke PostMessage, dwInstance, WM_COMMAND, TAPI_LINECALLSTATE_OFFERING, CommFile
			
		.elseif eax == LINECALLSTATE_DIALTONE
			invoke SetVarProps, dwInstance, hDevice
			invoke PostMessage, dwInstance, WM_COMMAND, TAPI_LINECALLSTATE_DIALTONE, CommFile
			
		.elseif eax == LINECALLSTATE_DIALING
			invoke SetVarProps, dwInstance, hDevice
			invoke PostMessage, dwInstance, WM_COMMAND, TAPI_LINECALLSTATE_DIALING, CommFile
			
		.elseif eax == LINECALLSTATE_BUSY
			invoke SetVarProps, dwInstance, hDevice
			invoke PostMessage, dwInstance, WM_COMMAND, TAPI_LINECALLSTATE_BUSY, CommFile
			
		.elseif eax == LINECALLSTATE_DISCONNECTED
			invoke SetVarProps, dwInstance, hDevice
			invoke PostMessage, dwInstance, WM_COMMAND, TAPI_LINECALLSTATE_DISCONNECTED, CommFile
			
		.endif
	
	.elseif eax == LINE_LINEDEVSTATE
		mov eax, dwParam1
		.if eax == LINEDEVSTATE_REINIT
			
		.elseif eax == LINEDEVSTATE_RINGING
			
		.endif
		
	.elseif eax == LINE_CLOSE
		
	.elseif eax == LINE_REPLY
		invoke PostMessage, dwInstance, WM_COMMAND, TAPI_LINE_REPLY, 0
		
	.elseif eax == LINE_REQUEST
		
	.elseif eax == LINE_ADDRESSSTATE
		
	.elseif eax == LINE_CALLINFO

	.elseif eax == LINE_DEVSPECIFIC

	.elseif eax == LINE_DEVSPECIFICFEATURE

	.elseif eax == LINE_GATHERDIGITS

	.elseif eax == LINE_GENERATE

	.elseif eax == LINE_MONITORDIGITS

	.elseif eax == LINE_MONITORMEDIA

	.elseif eax == LINE_MONITORTONE
					
	.endif
	ret

LineCallBackProc endp

memset PROC pMem:DWORD, dwVal:byte, dwSize:DWORD
    mov edi, pMem
    mov al, dwVal
    mov ecx, dwSize
    cld
    rep stosb 
    ret
memset ENDP

end start	