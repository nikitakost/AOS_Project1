read_lines:
    call read_line ; читання рядка
    test ax, ax
    jz end_program ; якщо ax = 0, то EOF
    ; Якщо рядок не пустий, зберігаємо його
    mov di, si
    add di, ax ; di = si + довжина рядка
    mov byte ptr [di], 0 ; додаємо нуль "термінатор" (ідентифікатор закінчення рядка) ASCIIZ
    add si, ax ; si = si + довжина рядка
    inc si ; переходимо на наступний байт (0x0D або 0x0A)
    loop read_lines ; повторюємо для наступного рядка