print_decimal:
    mov cx, 10      ; Кофіцієнт для переведення у десяткове число
    mov bx, 10      ; Десятковий множник
    xor dx, dx      

print_decimal_loop:
    xor dx, dx      
    div bx          ; Ділення AX на BX, результат зберігається у AX, остача у DX
    push dx         ; Зберігаємо остачу у стеку
    test ax, ax     
    jnz print_decimal_loop 

print_decimal_output_loop:
    pop dx          
    add dl, '0'     ; Конвертація числа у ASCII цифри
    mov ah, 02h     ; Виведення символу
    int 21h         ; Виведення символу
    loop print_decimal_output_loop ; Повторення, поки не буде виведено всі цифри

    ret