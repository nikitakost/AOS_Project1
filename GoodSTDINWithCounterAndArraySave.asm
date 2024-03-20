.model small
.stack 100h

.data
    MAX_ROWS equ 100
    MAX_LENGTH equ 255
    buffer db MAX_ROWS * (MAX_LENGTH + 2) dup (?) ; 2 байти для CR LF

.code
start:
    mov ax, @data
    mov ds, ax

    mov si, offset buffer ; початок буфера
    mov cx, MAX_ROWS ; кількість рядків, які треба зчитати

read_lines:
    call read_line ; читання рядка
    test ax, ax
    jz end_program ; якщо ax = 0, то EOF
    ; Якщо рядок не пустий, зберігаємо його
    mov di, si
    add di, ax ; di = si + довжина рядка
    mov byte ptr [di], 0 ; додаємо нуль "Термінатор" (ідентифікатор закінчення рядка)

    add si, ax ; si = si + довжина рядка
    inc si ; переходимо на наступний байт (0x0D або 0x0A)
    loop read_lines 

end_program:
    mov ax, 4C00h
    int 21h

read_line PROC
    mov cx, MAX_LENGTH 
    mov di, si  
read_char:
    mov ah, 01h ; чекаємо введення символу
    int 21h ; читаємо символ у al

    cmp al, 0Dh ; перевіряємо, чи символ - CR
    je end_reading ; якщо так, завершуємо читання

    mov [di], al ; зберігаємо символ у буфер
    inc di ; переходимо до наступного байту у буфері
    loop read_char 

end_reading:
    mov al, [di - 1] ; перевіряємо останній зчитаний символ
    cmp al, 0Ah ; чи це LF
    jne not_eof ; якщо ні, повертаємо довжину рядка
    mov ax, di ; якщо так, повертаємо довжину рядка
    sub ax, si ; віднімаємо вказівник початку рядка
    ret

not_eof:
    mov al, [di] ; перевіряємо наступний символ
    cmp al, 0Dh ; чи це CR
    jne not_cr ; якщо ні, повертаємо довжину рядка
    mov ax, di ; якщо так, повертаємо довжину рядка
    sub ax, si ; віднімаємо вказівник початку рядка
    ret

not_cr:
    inc ax ; збільшуємо довжину рядка на 1 (для LF)
    ret

read_line ENDP
END start