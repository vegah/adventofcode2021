; Not optimized, the code is meant to return the solution - not being the most cost effective solution :)
; Will run on nasm with SASM, remember to set x64 in settings if you have x64 nasm installed
; Just test data included, but tested and passed with real puzzle data aswell

%include "io64.inc"

section .text
global CMAIN
CMAIN:
    mov rbp, rsp; for correct debugging
    mov eax, instructions
.loop    call getnextinstruction
    call getnextnumber
    call movesubmarine
    mov bl,[eax]
    inc eax
    sub bl,0    ; No movs on intel architecture, but sub triggers flags.  In effect this is cmp bl,0
    jnz .loop
    
    mov eax, [depth]
    mov ebx, [horpos]
    mul ebx ; The result is in eax now.
    PRINT_DEC 4,eax ; if you are using SASM macros
    
    
    
    ret

movesubmarine:
.for    push rax
        mov esi,currentinstruction
        mov edi,forwarddef
        mov ecx,forwardlen        
        cld
        repe cmpsb
        jne .up
        mov ecx,DWORD[horpos]
        mov ebx,0
        mov bl, [currentnumber]
        mov eax,ebx
        add ecx,ebx
        mov [horpos],ecx
        mov edx,[aim]
        mul edx
        add [depth],eax
        jmp .end
        
.up     mov esi,currentinstruction
        mov edi,updef
        mov ecx,uplen        
        repe cmpsb
        jne .down
        mov ecx,DWORD[aim]
        mov ebx,0
        mov bl, [currentnumber]
        sub ecx,ebx
        mov [aim],ecx
        jmp .end

.down   mov esi,currentinstruction
        mov edi,downdef
        mov ecx,downlen        
        repe cmpsb
        jne .end
        mov ecx,DWORD[aim]
        mov ebx,0
        mov bl, [currentnumber]
        add ecx,ebx
        mov [aim],ecx
.end    pop  rax
        ret
        
        
getnextnumber:
        mov ecx,currentnumber
        mov bl,[eax]
        sub bl,0x30
        mov [ecx],bl
        inc eax
        ret
        
getnextinstruction:
        mov ecx,currentinstruction
.loop   mov bl,[eax]
        inc eax
        cmp bl,0x20 ; space?
        je  .done
        mov [ecx],bl
        inc ecx
        jmp .loop
        
.done   mov [ecx],BYTE 0
        ret


section .data
            
forwarddef db 'forward'
forwardlen equ $-forwarddef
updef db 'up'
uplen equ $-updef
downdef db'down'
downlen equ $-downdef


depth dd 0x00
horpos dd 0x00
aim dd 0x00

currentinstruction: db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00    
currentnumber: db 0x00

        
instructions:
    db 'forward 5',0x0a
    db 'down 5',0x0a
    db 'forward 8',0x0a
    db 'up 3',0x0a
    db 'down 8',0x0a
    db 'forward 2',0x00
    