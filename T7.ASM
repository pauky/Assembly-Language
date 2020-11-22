assume cs:codesg,ds:data,ss:table

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

table segment
   db 21 dup ('year summ ne ?? ')
table ends

codesg segment
start: mov ax,data
       mov ds,ax
       mov bx,0              ; 设置date段的地址
       mov dx, table
       mov ss,dx
       mov bp,0              ; 设置table段的地址

       mov di,54h            ; 公司总收入的起始偏移地址
       mov si,0A8h           ; 公司雇员的起始偏移地址

       mov cx,21
    s: mov ax,[bx]
       mov dx,[bx+2]
       mov [bp],ax
       mov [bp+2],dx         ; 将date段中的年份数据存放到table段的前四个字节单元处

       mov ax,[bx+di]
       mov dx,[bx+di+2]
       mov [bp+5], ax
       mov [bp+7], dx        ; 将date段中的总收入存放到table段的第6个位置的双字单元处

       div word ptr [si]     ; 得到除数：公司雇员数
       mov [bp+13], ax       ; 将得到的取整后的结果存放到table段的第13个位置的字单元处

       mov ax,[si]
       mov [bp+10], ax       ; 将date段中的公司雇员人数存放到table段的第10个位置的字单元处

       add bx,4
       add si,2
       add bp,10H
       loop s

       mov ax,4c00h 
       int 21h

codesg ends

end start
