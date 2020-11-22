assume cs:code
code segment

        mov ax,0
        mov ds,ax
        mov bx,0200h
        mov cx,63
s:      mov ds:[bx],bl
        inc bx
        loop s

        mov ax,4c00h
        int 21h

code ends
end
