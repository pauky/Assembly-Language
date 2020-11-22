assume cs:codesg
datasg segment
	db "Beginner's All-purpose Symbolic Instruction Code.",0
datasg ends

codesg segment
begin:	mov ax,datasg
	mov ds,ax
	mov si,0

	; 打印转换前的结果
	mov dh,1
	mov dl,2
	mov cl,2
	call show_str

	; 执行转换
	call letterc

	; 打印出转换后的结果
	mov dh,2
	mov dl,2
	mov cl,2
	call show_str
	
	mov ax,4c00h
	int 21h

; 名称：letterc
; 功能：将以0结尾的字符串中的小写字母转变成大写字母
; 参数：ds:si指向字符串首地址
letterc:push si
	
s: 	cmp byte ptr [si],0 ; 判断是否到达字符串结尾，因为结尾为0
	je break0
	
	; 判断是否为小写字母a~z，因为其二进制值范围是[61H,7aH]
	cmp byte ptr [si],61H 
	jb next
	cmp byte ptr [si],7aH
	ja next
	
	; 转换为大写
	and byte ptr [si],11011111B

next:	inc si
	loop s

break0:	pop si
	ret

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

codesg ends
end begin
