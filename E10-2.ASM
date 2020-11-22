assume cs:code
code segment
start:	mov ax,4240h ; 被除数的L
	mov dx,000fh ; 被除数的H
	mov cx,0ah ; 除数
	call divdw
	
	mov ax,4c00h
	int 21h

divdw:	push bp
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
	
	
	
code ends
end start
