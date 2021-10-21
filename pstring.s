# chen larry

                       .section .rodata

invalid_msg: 	.string "invalid input!\n"

                            .text

# declaration of pstrlen
.globl pstrlen
.type pstrlen, @function
# pstrlen
pstrlen:
        xorq    %rax, %rax                          # rax = 0
        movb 	(%rdi), %al                         # in smallest byte of %rdi is the length
        ret

# declaration of replaceChar
.globl replaceChar
.type replaceChar, @function
# replaceChar
replaceChar:
        movq   %rdi, %rax                           # string address -> rax
        # while loop
        .while:
                    # condition
                    leaq    1(%rdi), %rdi           # rdi ++
                    cmpb     $0, (%rdi)             # compare *rdi & '\0'
                    je       .finish                # if equals finish
                    # body
                    cmpb    (%rdi), %sil            # compare *r10 & old char
                    je      .replace                # if equals, replace
                    jmp     .while                  # continue
        .replace:
                    movb    %dl, (%rdi)             # replace char
                    jmp     .while                  # continue
        .finish:
                    ret

# declaration of pstrijcpy
.globl pstrijcpy
.type pstrijcpy, @function
# pstrijcpy
pstrijcpy:
        # save strings
        movq    %rdi, %r10                          # r10 is string dst
        # if i<=j<=length both strings
        incq    %rcx                                # j++
        cmpb    %dl, %cl                            # compare i and j
        jb      .invalid                            # if i > j, invalid
        cmpb    %cl, (%rdi)                         # compare j and dst length
        jb      .invalid                            # if j > dst length, invalid
        cmpb    %cl, (%rsi)                         # compare j and src length
        jb      .invalid                            # if j > src length, invalid
        # valid
        leaq    (%rdi, %rdx, 1), %rdi               # dst += i
        leaq    (%rsi, %rdx, 1), %rsi               # src += i
        .do_while:
                    leaq    1(%rdi), %rdi           # dst +=1
                    leaq    1(%rsi), %rsi           # src +=1
                    xorq    %r11, %r11
                    movb    (%rsi), %r11b
                    movb    %r11b, (%rdi)           # replace dst with src
                    # condition
                    incq    %rdx
                    cmpq    %rdx, %rcx
                    jne     .do_while               # if i==j, end
        .end:
                    movq    %r10, %rax
                    ret
        .invalid:
                    movq    $invalid_msg, %rdi      # rdi = "invalid input!/n"
                    xorq    %rax, %rax
                    call    printf
                    movq    %r10, %rax
                    ret

# declaration of swapCase
.globl swapCase
.type swapCase, @function
# swapCase
swapCase:
        # save string
        movq    %rdi, %rax                          # string -> r10
        .loop:
                    # condition
                    leaq    1(%rdi), %rdi           # string ++
                    cmpb     $0, (%rdi)             # compare *string & '\0'
                    je       .end_loop              # if equals, end
                    # body
                    cmpb    $65, (%rdi)             # if 65 > *string, continue
                    jb      .loop
                    cmpb    $91, (%rdi)             # if 91 > *string >= 65, big to little
                    jb      .bigtolittle
                    cmpb    $97, (%rdi)             # if 97 > *string >= 91, continue
                    jb      .loop
                    cmpb    $123, (%rdi)            # if 123 > *string >= 97, little to big
                    jb      .littletobig
                    jmp     .loop                   # if *string >= 123, continue
        .bigtolittle:
                    addb    $32, (%rdi)             # *string += 32
                    jmp     .loop
        .littletobig:
                    subb    $32, (%rdi)             # *string -= 32
                    jmp     .loop
        .end_loop:
                    ret

# declaration of pstrijcmp
.globl pstrijcmp
.type pstrijcmp, @function
# pstrijcmp
pstrijcmp:
        # save strings
        movq    %rdi, %r10                          # r10 is string dst
        # if i<=j<=length both strings
        incq    %rcx                                # j++
        cmpb    %dl, %cl                            # compare i and j
        jb      .invalid_case                       # if i > j, invalid
        cmpb    %cl, (%rdi)                         # compare j and pstr1 length
        jb      .invalid_case                       # if j > pstr1 length, invalid
        cmpb    %cl, (%rsi)                         # compare j and pstr2 length
        jb      .invalid_case                       # if j > pstr2 length, invalid
        # valid
        leaq    (%rdi, %rdx, 1), %rdi               # dst += i
        leaq    (%rsi, %rdx, 1), %rsi               # src += i
        .do_while_loop:
                    # body
                    leaq    1(%rdi), %rdi           # pstr1 +=1
                    leaq    1(%rsi), %rsi           # pstr1 +=1
                    xorq    %r11, %r11
                    movb    (%rsi), %r11b
                    cmpb    (%rdi), %r11b
                    jb      .pstr1bigger            # *pstr1 > *pstr2
                    ja      .pstr2bigger            # *pstr2 > *pstr1
                     # condition
                    incq    %rdx
                    cmpq    %rdx, %rcx
                    jne     .do_while_loop          # if i==j, end
        .equals:
                    movq    $0, %rax                # return value is 0
                    ret
        .pstr1bigger:
                    movq    $1, %rax                # return value is 1
                    ret
        .pstr2bigger:
                    movq    $-1, %rax               # return value is -1
                    ret
        .invalid_case:
                    movq    $invalid_msg, %rdi      # rdi = "invalid input!/n"
                    xorq    %rax, %rax
                    call    printf
                    movq    $-2, %rax               # return value is -2
                    ret
