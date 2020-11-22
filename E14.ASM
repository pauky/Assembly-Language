assume cs:code
code segment
d1: db '00/00/00 00:00:00', 0 ; 时间信息暂存区
d2: db 9,8,7,4,2,0 ; CMOS RAM单元的地址，分别代表年、月、日、时、分、秒

start:	mov ax,cs
	mov ds,ax
	mov bx,offset d1
	mov di,offset d2

	mov cx,6
s:	push cx
	
	; 获取时间信息
	mov  al,[di]
	out 70h,al
	in al,71h
	
	; 转换时间信息，BCD转ACSII
	mov ah,al
	mov cl,4
	shr ah,cl
	and al,00001111b
	add ah,30h
	add al,30h
	
	; 时间信息转入数据区
	mov [bx],ah
	mov [bx+1],al
	
	add bx,3
	inc di
	pop cx
	loop s

	; 屏幕展示时间
	mov si,0
	mov dh,12
	mov dl,2
	mov cl,2
	call show_str

	mov ax,4c00h
	int 21h

; 名称：show_str
; 功能：在指定的位置，用指定的颜色，显示一个用0结束的字符串。
; 参数：(dh)=行号（取值范围0~24），(dl)=列号（取值范围0~79），
;       (cl)=颜色，ds:si指向字符串的首地址
; 返回：无
show_str: push ax
        push bp
        push es
        push si

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
s2:     mov cl,ds:[si]
        mov ch,0
        jcxz break1 ; 用cx==0判断是否遍历到字符串末尾，是则退出循环
        mov ch,al
        mov es:[bp],cx
        inc si
        add bp,2
        jmp s2

break1: pop si
        pop es
        pop bp
        pop ax
        ret
	
code ends
end start
