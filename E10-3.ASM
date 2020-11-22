assume cs:code

data segment
	db 10 dup (0)
data ends

code segment
start:	mov ax,12666
	mov bx,data
	mov ds,bx
	mov si,0
	call dtoc

	mov dh,8
	mov dl,3
	mov cl,2
	call show_str
	
	mov ax,4c00h
	int 21h

; 将10进制转为二进制，并用ASCII编码的方式存储
dtoc:	push bx
	push cx
	push dx
	
	mov si,8 ; 存储到倒数第二位上，最后一位作为字符串结束标记
d:	mov dx,0 ; 用16位被除数无法计算结果，需要用32位被除数
	mov bx,10
	div bx ; ax除以bl，得到余数为dx,商为ax
	add dl,30h ; 余数加上30h得到数字的ASCII码
	mov ds:[si],dl
	mov cx,ax
	jcxz break
	dec si
	jmp d	
	; should use this? jmp short d

break:	pop dx
	pop cx
	pop bx
	ret

show_str: push ax
        push bp

        mov ax,0b800h
        mov es,ax

        ; 计算行号对应的偏移地址
        mov al,160
        mul dh
        mov bp,ax

        ; 计算列号对应的偏移地址, 与上述偏移地址叠加得到真正的偏移地址
        mov al,2
        mul dl
        add bp,ax

        ; 遍历字符串，逐个字节复制到显存中
        mov al,cl
s:      mov cl,ds:[si]
        mov ch,0
        jcxz ok ; 用cx==0判断是否遍历到字符串末尾，是则退出循环
        mov ch,al
        mov es:[bp],cx
        inc si
        add bp,2
        jmp s

ok:     pop bp
        pop ax
        ret	


code ends
end start
