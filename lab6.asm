data segment
    string db 6, ?, 6 dup(?)
    out_str db 0dh, 0ah, "string isn't a num", 0dh, 0ah, '$'
data ends

code segment
start:
    assume cs:code, ds:data
    mov ax, data
    mov ds, ax
    
    lea dx, string
    mov ah, 0ah
    int 21h

    mov bx, 1
    mov cl, string + 1
    mov di, cx
    inc di

    call string_to_number_conversion

qt: lea dx, out_str
    mov ah, 9
    int 21h

    mov ah, 4ch
    int 21h

    string_to_number_conversion proc

str_cnvrsn_to_dec: xor ah, ah
        mov al, string + di
        cmp al, 57
        jg qt_due_non_num
        cmp al, 48
        jl qt_due_non_num
        jmp add_dec
qt_due_non_num: jmp qt

add_dec: sub al, 48
        push dx
        mul bx
        pop dx
        add dx, ax

        mov ax, 10d
        push dx
        mul bx
        pop dx
        mov bx, ax

        dec di
        loop str_cnvrsn_to_dec
        inc di

        xor ah, ah
tenth_notation_to_2nd_cnvrsn: xor al, al
        shr dx, 1
        adc al, 48
        mov out_str + di, al
        inc di
        cmp dx, 1
        jge tenth_notation_to_2nd_cnvrsn
        
        mov out_str + di, '$'
        dec di

        inc si
        inc si
        mov cx, di
        dec cx
        shr cx, 1

revert_str: mov al, out_str + si
        mov bl, out_str + di
        mov out_str + si, bl
        mov out_str + di, al
        inc si
        dec di
        loop revert_str
        ret
    
    string_to_number_conversion endp

code ends
end start
