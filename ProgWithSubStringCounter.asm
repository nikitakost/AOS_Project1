 .model small
.stack 100h

.data
    MAX_ROWS equ 100
    MAX_LENGTH equ 255
    buffer db MAX_ROWS * (MAX_LENGTH + 2) dup (?) ; 2 байти для CR LF
    substring db 'substring', 0 ; Підрядок для пошуку

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

    
    push di ; Зберігаємо адресу початку рядка
    call count_subStrings
    pop di ; Відновлюємо адресу початку рядка
    ; AX містить кількість входжень підрядка


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

count_subStrings PROC
    xor cx, cx          
    mov dx, si          ; Зберігаємо адресу початку рядка у DX
search_loop:
    mov al, [di]        ; Завантажуємо поточний символ підрядка у AL
    cmp al, 0           ; Перевіряємо, чи досягли кінця підрядка
    je end_search       
    mov al, [si]        ; Завантажуємо поточний символ рядка у AL
    cmp al, 0           ; Перевіряємо, чи досягли кінця рядка
    je end_search       
    cmp al, [di]        ; Порівнюємо поточний символ рядка з першим символом підрядка
    jne continue_search ; Якщо не співпадає, переходимо до наступного символу рядка
    push si             ; Зберігаємо поточну адресу рядка у стеку
    mov cx, si          ; SI - адреса початку рядка у буфері
    mov dx, di          ; DI - адреса початку підрядка у буфері
    repe cmpsb          ; Порівнюємо підрядок із рядком
    pop si              ; Відновлюємо поточну адресу рядка із стеку
    jz found_subStrings ; Якщо підрядок знайдено, збільшуємо лічильник
    jmp continue_search 
found_subStrings :
    inc cx              ; Збільшуємо лічильник входжень
continue_search:
    inc si              ; Переходимо до наступного символу рядка
    jmp search_loop     ; Повторюємо пошук
end_search:
    mov ax, cx          ; Повертаємо кількість входжень у AX
    ret
count_subStrings ENDP