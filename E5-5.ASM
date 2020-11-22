assume cs:code
a segment
        db 1,2,3,4,5,6,7,8
a ends

b segment
        db 1,2,3,4,5,6,7,8
b ends

c segment
        db 0,0,0,0,0,0,0,0
c ends

code segment
start:  mov ax,a
        mov ds,ax
        mov ax,b
        mov ss,ax
        mov ax,c
        mov es,ax

        mov cx,8
        mov bx,0
        mov ax,0
s:      add al,ds:[bx]
        add al,ss:[bx]
        mov es:[bx], al
        mov al, 0
        add bx,1
        loop s

        mov ax,4c00h
        int 21h

code ends

end start
