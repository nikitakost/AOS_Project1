.model small
.stack 100h

.data
    MAX_ROWS equ 100
    MAX_LENGTH equ 255
    buffer db MAX_ROWS * (MAX_LENGTH + 2) dup (?) ; 2 байти для CR LF
    substring db 'substring', 0 ; Підрядок для пошуку
    results dw MAX_ROWS dup(?)   ; Масив для збереження кількостей входжень та індексів рядків
    count dw ?                   ; Кількість зчитаних рядків (змінна)

.code
start:
    mov ax, @data
    mov ds, ax

    mov si, offset buffer      ; початок буфера
    mov cx, MAX_ROWS           ; кількість рядків, які треба зчитати
    mov count, 0               

read_lines:
    call read_line            
    test ax, ax
    jz end_program            ; якщо ax = 0, то EOF

    ; Зберігаємо кількість входжень підрядка в результати
    mov bx, offset results    ; адреса підмасиву в масиві результатів
    push ax                   ; Зберігаємо кількість входжень підрядка
    push cx                   ; Зберігаємо адресу рядка
    call count_substrings
    mov [bx], ax              ; Зберігаємо кількість входжень
    pop cx                    ; Відновлюємо адресу рядка
    pop ax                    ; Відновлюємо кількість входжень
    inc bx                    ; Переходимо до наступного елементу в масиві результатів
    mov [bx], count           ; Зберігаємо індекс рядка
    inc count                 ; Збільшуємо кількість зчитаних рядків

    add si, ax                ; si = si + довжина рядка
    inc si                    ; переходимо на наступний байт (0x0D або 0x0A)
    loop read_lines 

    ; Сортуємо результати за кількістю входжень підрядка
    mov cx, count             ; Кількість елементів у масиві results
    mov bx, offset results    ; Адреса масиву results
    call bubble_sort

    ; Виводимо відсортовані результати
    mov cx, count             ; Кількість елементів з results
    mov bx, offset results    ; Адреса початку масиву результатів
    call print_results

end_program:
    mov ax, 4C00h
    int 21h

read_line PROC
    mov cx, MAX_LENGTH 
    mov di, si  
read_char:
    mov ah, 01h               ; чекаємо введення символу
    int 21h                   ; читаємо символ у al

    cmp al, 0Dh               ; перевіряємо, чи символ - CR
    je end_reading            ; якщо так, завершуємо читання

    mov [di], al              ; зберігаємо символ у буфер
    inc di                    ; переходимо до наступного байту у буфері
    loop read_char 

end_reading:
    mov al, [di - 1]          ; перевіряємо останній зчитаний символ
    cmp al, 0Ah               ; чи це LF
    jne not_eof               ; якщо ні, повертаємо довжину рядка
    mov ax, di                ; якщо так, повертаємо довжину рядка
    sub ax, si                ; віднімаємо вказівник початку рядка
    ret

not_eof:
    mov al, [di]              ; перевіряємо наступний символ
    cmp al, 0Dh               ; чи це CR
    jne not_cr                
    mov ax, di                ; якщо так, повертаємо довжину рядка
    sub ax, si                ; віднімаємо вказівник початку рядка
    ret

not_cr:
    inc ax                    ; збільшуємо довжину рядка на 1 (для LF)
    ret
read_line ENDP

count_substrings PROC
    xor cx, cx                ; Обнуляємо кількість входжень
    mov dx, si                ; Зберігаємо адресу початку рядка у DX
search_loop:
    mov al, [di]              ; Завантажуємо поточний символ підрядка у AL
    cmp al, 0                 ; Перевіряємо, чи досягли кінця підрядка
    je end_search       
    mov al, [si]              ; Завантажуємо поточний символ рядка у AL
    cmp al, 0                 ; Перевіряємо, чи досягли кінця рядка
    je end_search       
    cmp al, [di]              ; Порівнюємо поточний символ рядка з першим символом підрядка
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

bubble_sort PROC
    mov dx, cx          ; Копіюємо кількість елементів у DX
    dec dx              ; DX = CX - 1 (верхня межа ітерації)
    jz end_bubble_sort  ; Якщо кількість елементів 0 або 1, то вихід початкова адреса масиву
    mov di, bx          
    
outer_loop:
    xor ax, ax          ; Очищаємо флаг, що відбувся обмін
    mov cx, dx          ; Копіюємо верхню межу ітерації у CX
    mov bx, di          ; Копіюємо початкову адресу масиву у BX
    
inner_loop:
    mov ax, [bx]        ; Завантажуємо перший елемент
    cmp ax, [bx + 2]    ; Порівнюємо з наступним елементом
    jbe skip_swap       ; Якщо не потрібно міняти місцями, пропускаємо
    xchg [bx], [bx + 2] ; Міняємо місцями
    mov ax, 1           ; Встановлюємо флаг обміну
skip_swap:
    add bx, 2           ; Переходимо до наступного елементу
    loop inner_loop     ; Повторюємо внутрішню ітерацію
    cmp ax, 0           ; Перевіряємо, чи відбувся обмін
    jnz outer_loop      ; Якщо так, повторюємо зовнішню ітерацію
    dec dx              ; Зменшуємо верхню межу ітерації
    jnz outer_loop      ; Повторюємо зовнішню ітерацію, якщо ще є елементи для сортування
end_bubble_sort:
    ret
bubble_sort ENDP

;"<кількість входжень> <індекс рядка у текстовому файлі починаючи з 0>".
print_results PROC
    mov si, bx              ; Завантажуємо адресу масиву результатів у регістр si

print_loop:
    mov ax, [si]            ; Завантажуємо кількість входжень у регістр ax
    call print_number       ; Виводимо кількість входжень
    mov dl, ' '             ; Виводимо пробіл між кількістю входжень та індексом
    mov ah, 02h             ; Функція виводу символу
    int 21h

    inc si                  ; Переходимо до наступного елементу масиву результатів
    mov ax, [si]            ; Завантажуємо індекс рядка у регістр ax
    call print_number       ; Виводимо індекс рядка
    mov dl, 0Ah             ; Виводимо символ нового рядка
    mov ah, 02h             ; Функція виводу символу
    int 21h

    inc si                  ; Переходимо до наступного елементу масиву результатів
    loop print_loop         ; Повторюємо для кожного елементу масиву
    ret

print_results ENDP

;виводить лесяткове представлення числа
print_number PROC
    ; Виводимо цифру, якщо вона не нуль
    cmp ax, 0
    jz no_output
    mov cx, 10              ; Дільник для перетворення числа в рядок
    mov bx, 0               ; Лічильник для зберігання кількості цифр у числі
digit_loop:
    xor dx, dx              ; Очищаємо dx перед діленням
    div cx                  ; Ділимо ax на 10
    push dx                 ; Зберігаємо остачу у стеку
    inc bx                  ; Збільшуємо лічильник цифр
    test ax, ax             ; Перевіряємо, чи досягли межі
    jnz digit_loop          ; Якщо ні, продовжуємо

output_loop:
    pop dx                  ; Відновлюємо цифру із стеку
    add dl, '0'             ; Конвертуємо числу у ASCII
    mov ah, 02h             ; Функція виводу символу
    int 21h                 ; Виводимо цифру
    dec bx                  ; Зменшуємо лічильник цифр
    jnz output_loop         ; Повторюємо, поки не виведемо всі цифри
no_output:
    ret
print_number ENDP
