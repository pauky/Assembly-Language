assume cs:codesg,ds:data
data segment
	db 'welcome to masm!'
data ends

codesg segment
start:	mov ax,data
	mov ds,ax
	mov ax,0b872h
	mov es,ax
	mov bx,0
	mov si,0

	mov cx,16
s:	mov al,[bx]
	;mov ah,72h ;绿色
	;mov ah,24h ;绿底红色
	;mov ah,71h ;白底蓝色
	mov ah,f1h ;白底蓝色 + 闪烁
	mov es:[si],ax
	add bx,1
	add si,2
	loop s
	
	mov ax,4c00h
	int 21h
codesg ends
end start
