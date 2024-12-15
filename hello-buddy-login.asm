; EECS 20 lab Assignment 3: Assembly User Verification
; 
; Program asks user to enter their username, verifies that their +
; username and password are in the system, then greets the user
; > Please enter your name: <user input>
; > Please enter your password: 
; > Hello, <user input>
;
; R0: Holds the input (from TRAP x20) & uses as output (for TRAP x21) and starting addresses for output strings, also result of checking two strings
; R1: initializes to the starting of USERNAME string & points to the end of the string 
; R2: stores a character from the userin username string for database checking
; R3: stores termination comparing value -x0A (NEGENTER)
; R4: stores index checking for username -> pswd map
; R5: stores a character from one of the username in the username database for login checking 
; R6: stores an address in memory pointing to a character of a string from our database 
; R7: the backed up memory pointer for the username that is selected

            .ORIG   x3000
            AND     R4, R4, #0       ; clear R4 for attempts counter
            LEA     R1, USERIN       ; starting address of USERNAME (going to find end of string for appending)
            
; go to memory location of USERIN string to store user entered input
AGAIN       LDR     R2, R1, #0      ; load blank char at USERIN address into R2
            BRz     NEXT            ; if done loading "" (x0000), go to NEXT
            ADD     R1, R1, #1      ; increment hello address
            BR      AGAIN           ; ^^^^ this segment loads the string ""(x0000) into R2
        
; print prompt for user input
TRYAGAIN         
NEXT        LEA     R0, PROMPT      ; get address of prompt for user 
            TRAP    x22             ; PUTS (output prompt message) "Please enter your username: "
        
; fill in user input by appending to where R1 points (after default USERNAME string)
            LD      R3, NEGENTER    ; store (through ld) NEGENTER into R3 for termination comparing later
AGAIN2      TRAP    x20             ; GETC (gather user input one char at a time)
            TRAP    x21             ; OUT (output char for user on console)
            ADD     R2, R0, R3      ; check if user pressed ENTER key: ascii of ENTER=x0A, so x0A+(-x0A)=0 ;if true:R2<-0
            BRz     CONT            ; if they did, we are done, go to CONT
            STR     R0, R1, #0      ; store value in R0 (user input) into memory (wherever end of USERNAME string is pointing)
            ADD     R1, R1, #1      ; increment address of R1 so that we can write to the next available spot
            BR      AGAIN2          ; repreat the process of storing user inputed name
 
; storing values in between code
USER1       .STRINGZ    "panteater"
USER2       .STRINGZ    "qv"
USER3       .STRINGZ    "yomama"
INDEXKEYext2 .FILL      INDEXKEY
; storing values in between code

; check for username in memory
            ; compare userin to username1, if found, go to pswd input, ; compare using ascii representations of each character at each memory location 
            ; if not found, check username2, if not found, check username 3, ; if not found: exit
CONT        LEA     R1, USERIN          ; store address of user inputted string to R1 
            
CHECKuser1  LEA     R6, USER1           ; find first pointer address of username1 string
            LDI     R4, INDEXKEYext2    ; index num = 3,  
            BR      SELECTED
CHECKuser2  LEA     R6, USER2           ; find first pointer address of username2 string
            AND     R0, R0, #0          ; clear R0
            ADD     R0, R0, #2          ; index - 2
            STI     R0, INDEXKEYext2    ; put index 2 back into INDEXKEY  
            AND     R4, R4, #0
            ADD     R4, R4, #2          ; index num = 2 
            LDI     R4, INDEXKEYext2      
            BR      SELECTED
CHECKuser3  LEA     R6, USER3           ; find first pointer address of username3 string
            AND     R0, R0, #0          ; clear R0
            ADD     R0, R0, #1          ; index = 1
            STI     R0, INDEXKEYext2    ; put index 1 back into INDEXKEY 
            AND     R4, R4, #0          ; index num = 1
            ADD     R4, R4, #1      
            LDI     R4, INDEXKEYext2     
            BR      SELECTED
SELECTED    LEA     R1, USERIN      ; store address of user inputted string to R1 
CHECKuser   LDR     R2, R1, #0      ; Load ascii representation value of first character into R2
            LDR     R5, R6, #0      ; load ascii representation value of first character into R5
            AND     R0, R0, #0      ; clear R0 to use for string checking
            NOT     R5, R5          ; negate R5's value
            ADD     R5, R5, #1      ; two complement representation      
            ADD     R0, R2, R5      ;  if its 0, check if the last character was reached
            BRz     checknull       ; one character was found, check if it was the null character   // track memory index mappning to pswd
notnull     ADD     R0, R0, #0      ; clear R0 for ascii checking
            BRnp    userNOTFOUND    ; branch to decrement if the result was not 0
            ADD     R1, R1, #1      ; correct character, increment userin address to check next character
            ADD     R6, R6, #1      ; ^^^ increment database value to check next character
            BR      CHECKuser       ; branch to compare next characters in memory
            ; checking the case where the character of user inputted username is null     
checknull   LDR     R5, R6, #0      ; load ascii representation value of first character into R5
            BRnp    notNULL
checknull2  LDR     R2, R1, #0      ; load ascii representation  
            BRz     FOUNDuser       ; if this is also null, then they match, username found, branch to pswd checking, track index mapping to pswd
            BR      userNOTFOUND    ; if it is not null, they dont match
            
; storing values in between code
TRYAGAINext BR      TRYAGAIN
NOTFOUNDMSG .STRINGZ    "Username does not exist. Please try again. "
USERIN      .STRINGZ    ""
            .BLKW       25     ; 25 characters max username
NEGENTER    .FILL       xFFF6   ; -x0A
PROMPT      .STRINGZ    "Please enter your username: "
INDEXKEY    .FILL       x0003   ; 3 indexes        
USERCOUNTER .FILL       x0003   ; 3 attempts
PSWDCOUNTER .FILL       x0003   ; 3 attempts
; storing values in between code

            ; username was not found so reset the USERIN BLKW back to 0 with a loop, then do other sutff
userNOTFOUND LD     R0, INDEXKEY 
            ADD     R0, R0, #-3     ; 3 -3 = 0, which means you were checking user1, now check user2
            BRz     CHECKuser2
            ; if the above BR line gets skipped, then username = number 2 or 3 
            ADD     R0, R0, #2      ; add 3 back since we just subtracted 3
            ADD     R0, R0, #-1     ; 2-2 = 0;
            BRz     CHECKuser3      ; check third username
            ; if the above BR lines get skipped, then we already checked usermames 1,2 and 3
            ; this means that if the username was still not found for username number 3, username inputted was wrong, decrement counter
            LD      R0, USERCOUNTER ; 3 attempts 
            ADD     R0, R0, #-1     ; decrement the user attempt counter
            ST      R0, USERCOUNTER ; store username attempts counter back into memory if there are still num attempts > 0
            ; reset the index key back to 3 after all 3 usernames have been checked in throuhgh one attempt 
            AND     R0, R0, #0      ; clear R0 temporarily
            ADD     R0, R0, #3      ; R0<-3
            ST      R0, INDEXKEY    ; INDEXKEY<-#3
            ; username was not found so reset the USERIN BLKW back to 0 with a loop, then do take in the next attempt
USERINADD   .BLKW   1
            LEA     R0, USERIN
CONTCLEAR   ST      R0, USERINADD
            AND     R7 , R7, #0     ; put 0 into R7
            STI     R7, USERINADD   ; not done clearing so continue clearing
            ADD     R0, R0, #1      ; increment address counter
            LDR     R7, R0, #0      ; check what value is in R0: if next value in address is 0, we are done clearing, else, clear agian
            BRz     DONECLEAR       ; if you hit a null value you are done clearing the BLKW
            BR      CONTCLEAR
DONECLEAR   LEA     R0, NOTFOUNDMSG ; print message "username does not exist", take in another input to check    
            TRAP    x22             ; PUTS 
            LD      R0, USERCOUNTER 
            BRp     TRYAGAINext     ; loop back to user input again
            LEA     R0, NOATTEMPTS  ; print message "all 3 attempts used", exits
            TRAP    x22             ; PUTS 
            BR     EXIT             ; this hits 0, so all username attempts used. exit


    ; A USERNAME has been validated, take in a password input: store to memory
FOUNDuser   LEA     R7, USERIN
            ST      R7, USERINADDRESS
ENTERPSWD   LEA     R1, PSWDIN      ; load R1 with end of PSWDIN string memory location
            LEA     R0, PSWDPROMPT  ; "User exists. Enter your password: "
            TRAP    x22             ; PUTS display prompt
STAGAIN     TRAP    x20             ; GETC for user entered password
            LD      R3, NEGENTER    ; enter key check
            ADD     R2, R0, R3      ; check if user entered enter key
            BRz     PSWDENTERED     ; if they did, we are done, go to check if password is valid
            STR     R0, R1, #0      ; store PSWD in R0 (user input) into memory (wherever end of PSWDIN string is pointing)
            ADD     R1, R1, #1      ; increment address of R1 so that we can write to the next available spot
            BR      STAGAIN         ; repreat the process of storing user inputed name

            BR  goaround
INDEXKEYext .FILL  INDEXKEY         ; extending accessible range for INDEXKEY
goaround

   ; PSWD checking ; if R4 index = 3 PSWD1 = key, if R4 index  = 2: PSWD2 = key, if R4 index = 1: PSWD3 = key
PSWDENTERED            
            LDI     R4, INDEXKEYext    ; check if R4 index = 3
            ADD     R4, R4, #-3     ; check if R4 index = 3
            BRz     PSWDcheck1  
            LDI     R4, INDEXKEYext
            ADD     R4, R4, #-2     ; check if index = 2
            BRz     PSWDcheck2
            LDI     R4, INDEXKEYext    ; check if index = 1
            ADD     R4, R4, #-1         
            BRz     PSWDcheck3

; storing values in between code
            BR      SKIP
pTRYAGAINext2  BR   ENTERPSWD   ; skip these line
pNOTFOUNDMSG .STRINGZ    "Password invalid. Please try again. "
PSWDIN      .STRINGZ    ""
            .BLKW       25             ; 25 characters max PSWD
USERINADDRESS .BLKW     1
NOATTEMPTS  .STRINGZ    "All 3 attempts used, exiting system."
SKIP
; storing values in between code

; PASSWORD CHECKING : same structure as usename string checking
PSWDcheck1  LEA     R6, PSWD1       ; find first pointer address of pswd1 string
            LDI     R4, INDEXKEYext    ; index num = 3,  
            BR      pSELECTED
PSWDcheck2  LEA     R6, PSWD2       ; find first pointer address of username2 string
            AND     R0, R0, #0      ; clear R0
            ADD     R0, R0, #2      ; index = 2
            STI     R0, INDEXKEYext    ;  put index 2 back into INDEXKEY, and   
            AND     R4, R4, #0
            ADD     R4, R4, #2      ; index num = 2 
            BR      pSELECTED
PSWDcheck3  LEA     R6, PSWD3       ; find first pointer address of username3 string
            AND     R0, R0, #0      ; clear R0
            ADD     R0, R0, #1      ; index = 1
            STI     R0, INDEXKEYext    ;  put index 1 back into INDEXKEY, and 
            AND     R4, R4, #0      ; index num = 1
            ADD     R4, R4, #1      
            BR      pSELECTED
pSELECTED   ADD     R7, R6, #0       ; back up selected user pointer to R7
            LEA     R1, PSWDIN      ; find address of inputted PSWD string 
CHECKpswd   LDR     R2, R1, #0      ; Load ascii representation value of first character into R2 ; user entered password
            LDR     R5, R6, #0      ; load ascii representation value of first character into R5 ; password in database
            BRz     nullfound       ; null found for database password , skip ahead
            LD      R3, ASCII       ; load key for decrypting passwords
            ADD     R5, R5, R3      ; decrypt password based on key 
            AND     R0, R0, #0      ; clear R0 to use for string checking
            NOT     R5, R5          ; negate R5's value
            ADD     R5, R5, #1      ; two complement representation      
            ADD     R0, R2, R5      ;  if its 0, check if the last character was reached
            BRz     pchecknull       ; one character was found, check if it was the null character   // track memory index mappning to pswd
pnotnull    ADD     R0, R0, #0      ; clear R0 for ascii checking
            BRnp    pswdNOTFOUND    ; branch to decrement if the result was not 0
            ADD     R1, R1, #1      ; correct character, increment userin address to check next character
            ADD     R6, R6, #1      ; ^^^ increment database value to check next character
            BR      CHECKpswd       ; branch to compare next characters in memory
nullfound   ; checking the case where the character of user inputted username is null     
pchecknull  LDR     R2, R1, #0      ; load ascii representation value of first character into R5
            BRnp    pnotNULL
            BRz     LOGIN           ; if this is also null, then they match, username found, branch to pswd checking, track index mapping to pswd
            BR      pswdNOTFOUND    ; if it is not null, they dont match

pswdNOTFOUND BR     go; PSWD not found for corresponding username,decrement PSWD counter

PSWDINADD   .BLKW   1

go          LEA     R0, PSWDIN
pCONTCLEAR  ST      R0, PSWDINADD
            AND     R7 , R7, #0 ; put 0 into R7
            STI     R7, PSWDINADD  ; not done clearing so continue clearing
            ADD     R0, R0, #1  ; increment address counter
            LDR     R7, R0, #0  ; check what value is in R0: if next value in address is 0, we are done clearing, else, clear agian
            BRz     pDONECLEAR   ; if you hit a null value you are done clearing the BLKW
            BR      pCONTCLEAR
pDONECLEAR  LEA     R0, pNOTFOUNDMSG     ; print message "pswd invalid", take in another input to check    
            TRAP    x22                 ; PUTS 
            LD      R0, PSWDCOUNTER  ; 3 attempts
            ADD     R0, R0, #-1     ; decrement the pswd attempt counter
            ST      R0, PSWDCOUNTER ; store pwd attempts counter back into memory if there are still num attempts > 0  
            BRp     pTRYAGAINext    ; loop back to user input again
            LEA     R0, NOATTEMPTS ; print message "all 3 attempts used", exits
            TRAP    x22             ; PUTS 
            BR     EXIT            ; this hits 0, so all username attempts used. exit
            
pTRYAGAINext BR      pTRYAGAINext2
; PASSWORD CHECKING : same structure as usename string checking

; print out "You have successfully logged in. Hello, <user name>."
LOGIN       LEA     R0, WELCOME     ; address of logged in WELCOME prompt
            TRAP    x22             ; PUTS (output updated HELLO string)
            LD      R0, USERINADDRESS   ; peter, qv, yomama
            TRAP    x22             ; display username
EXIT        TRAP    x25             ; HALT (stop program)

; storing values in between code
WELCOME     .STRINGZ    "You have successfully logged in. Hello, "
PSWD1       .STRINGZ    "ujyjw"         ;  peter
PSWD2       .STRINGZ    "mjqqtymjwj&"  ; hellothere!  
PSWD3       .STRINGZ    "rfrf"          ;"mama"     
PSWDPROMPT  .STRINGZ    "Enter your password: "
ASCII       .FILL       xFFFB ; -5           ; ascii difference to encrypt passwords ; up shift of 5 ascii

.END