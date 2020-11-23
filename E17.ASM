; 安装int 7ch中断例程到0:200h处
; 参数说明：
; 1. 用ah传递功能号，0是读，1是写；
; 2. 用dx传递要读写的扇区的逻辑扇区号；
; 3. 用es:dx指向存储读出数或写入数据的内存区；
assume cs:code
code segment
start:	mov ax,0
	mov es,ax
	mov ax,cs
	mov ds,ax
	mov si,offset int7c
	mov di,200h
	mov cx,offset int7cend-offset int7c
	cld
	rep movsb

	; 设置中断表，注意先不响应可屏蔽中断，设置完中断表再恢复，防止设置一半突然产生中断，导致中断地址异常
	mov ax,0
	mov es,ax
        cli
        mov word ptr es:[7ch*4],200h
        mov word ptr es:[7ch*4+2],0
        sti
	
	mov ax,4c00h
	int 21h


int7c:	push ax ; 暂存ah的值	
	push bx ; 暂存bx的值，其为磁盘读写的内存区开始偏移地址
	; 计算面号
	mov ax,dx
	mov dx,0
	mov bx,1440
	div bx
	mov dh,al ; ax为商，dx为余数，因余数不会大于8位，所以用al

	; 计算磁道号
	mov ax,dx ; 计算面号时，dx为div运算后的余数
	mov bl,18
	mov ch,al ; al为商，ah为余数

	; 计算扇区号
	mov cl,ah
	inc cl

	pop bx ; 取出bx的值
	pop ax ; 取出ah的值
	add ah, 2 ; 转换成13h中断例程的功能号
	mov al,1 ; 读写的扇区数
	mov dl,81h ; 从D盘读数据
	int 13h
	
	iret
	
int7cend: nop	

code ends
end start
