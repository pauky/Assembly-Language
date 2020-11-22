assume cs:codesg

data segment
   db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
   db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
   db '1993','1994','1995'
   ; 以上是表示21年的21个字符串
   dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
   dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
   ; 以上是表示21年公司总收入的21个dword型数据
   dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
   dw 11542,11430,15257,17800
   ; 以上是表示21年公司雇员人数的21个word型数据
data ends

data1 segment
	db 10 dup (0)
data1 ends

codesg segment
start:  mov ax,data1
        mov ds,ax
        mov ax,data
        mov es,ax

        mov cx,21
        mov di,0 ; 年份、收入数据的首地址
        mov bp,168 ; 人数数据的首地址
	mov bh,2 ; 行号
	 

s:      push cx ; cx后面会被用作divdw的余数返回值，所以这里要暂存
	mov bl,2 ; 列号

	; 年份
	mov ax,es:[di]
	mov ds:[5],ax
	mov ax,es:[di+2]
	mov ds:[7],ax
	mov si,5
	mov dl,bl
	mov dh,bh
	mov cl,2 ; 颜色
	call show_str
	add bl,20
        
	; 收入
        mov ax,es:[di+84] ; X86系统的数字在内存中是以小端存储，低位在前
        mov dx,es:[di+86]
	push ax
	push dx
	call dtoc
	mov dl,bl
	mov dh,bh
	mov cl,2 ; 颜色
	call show_str
	add bl,20

        ; 人数
        mov ax,es:[bp]
	mov dx,0
	call dtoc
	mov dl,bl
	mov dh,bh
	mov cl,2 ; 颜色
	call show_str
	add bl,20

	; 人均收入
	pop dx
	pop ax
	mov cx,es:[bp]
	call divdw
	call dtoc
	mov dl,bl
	mov dh,bh
	mov cl,2 ; 颜色
	call show_str 

        add di,4
	add bp,2
	inc bh
	pop cx
        loop s

        mov ax,4c00h
        int 21h


; 名称：dtoc
; 功能：将dword型数转变为表示十进制数的字符串，字符串以0为结尾符
; 参数：(ax)=dword型数据的低16位
; 	(dx)=dword型数据的高16位
;	ds:si指向字符串的首地址
; 返回：ds:si指向转换后字符串的首地址
dtoc:   push bx
        push cx
        push dx
	push ax

        mov si,8
d:      mov cx,10
	call divdw
        add cx,30h ; 余数加上30h得到数字的ASCII码
	mov [si],cl ; 除数是10，所以余数在低8位即可
	mov cx,0
        add cx,ax
	add cx,dx ; divdw的结果存在dx,ax中，将其累加，判断是否为0
        jcxz break0
	dec si
        jmp d
        ; should use this? jmp short d

break0: pop ax
	pop dx
        pop cx
        pop bx
        ret

; 名称：divdw
; 功能：进行不会产生溢出的除法运算，被除数为dword型，除数为word型，结果为dword型
; 参数：(ax)=dword型数据低16位
;	(dx)=dword型数据的高16位
;	(cx)=除数
; 返回：(dx)=结果的高16位，(ax)=结果的低16位
;	(cx)=余数
divdw:  push bp
        push si

        ; 暂存H,L
        mov bp,ax

        ; H/N
        mov ax,dx
        mov dx,0
        div cx ; dx=rem(H/N), ax=int(H/N)

        mov si, ax ; int(H/N)*65536, ax的结果即为最终结果的高位了

        mov ax, bp
        div cx ; 因为rem(H/N) * 65536，所以dx为高16位, ax为L, 结果: 商在ax,余数在dx

        mov cx, dx
        mov dx, si

        pop si
        pop bp
        ret

; 名称：show_str
; 功能：在指定的位置，用指定的颜色，显示一个用0结束的字符串。
; 参数：(dh)=行号（取值范围0~24），(dl)=列号（取值范围0~79），
;	(cl)=颜色，ds:si指向字符串的首地址
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

break1:	pop si 
	pop es
	pop bp
        pop ax
        ret

codesg ends

end start
