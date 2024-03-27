; AX - кількість входжень підрядка у рядок
count_subStrings PROC
    xor cx, cx          
    mov dx, si          
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
    pop si              
    jz found_subStrings  ; Якщо підрядок знайдено, збільшуємо лічильник
    jmp continue_search ; Продовжуємо пошук
found_subStrings :
    inc cx              ; Збільшуємо лічильник входжень
continue_search:
    inc si              ; Переходимо до наступного символу рядка
    jmp search_loop     ; Повторюємо пошук
end_search:
    mov ax, cx          ; Повертаємо кількість входжень у AX
    ret
count_subStrings ENDP
