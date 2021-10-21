#   209192798 chen larry

                        .section .rodata

# formats
int_format:		.string "%d"
chr_format:		.string " %c"

invalid_msg: 	.string "invalid option!\n"
length_msg:		.string "first pstring length: %d, second pstring length: %d\n"
newchar_msg: 	.string "old char: %c, new char: %c, first string: %s, second string: %s\n"
newstring_msg:	.string "length: %d, string: %s\n"
compare_msg:  	.string "compare result: %d\n"

# jump table
.align  8
.jump_table:
    .quad   .case5060
    .quad   .default
    .quad   .case52
    .quad   .case53
    .quad   .case54
    .quad   .case55
    .quad   .default
    .quad   .default
    .quad   .default
    .quad   .default
    .quad   .case5060

                                .text

# declaration of run_func
.globl run_func
.type run_func, @function
# run_func
run_func:

    # push all callee saved
    pushq   %r13
    pushq   %r14
    pushq   %r15
    pushq   %rbp                                # save old rbp
    movq    %rsp, %rbp                          # rbp <- rsp

    # save arguments
    movq    %rdi, %r13                          # first argument in r13 option
    movq    %rsi, %r14                          # second argument in r14 string 1
    movq    %rdx, %r15                          # third argument in r15 string 2

    leaq    -50(%rdi), %rsi
    cmpq    $10, %rsi
    ja      .default
    jmp     *.jump_table(,%rsi,8)

    # case input is 50 or 60
    .case5060:
            # first string length
            movq   %r14, %rdi                   # send first string
            call   pstrlen
            movq   %rax, %r10                   # save return value in r10
            # second string length
            movq    %r15, %rdi                  # send second string
            call   pstrlen
            movq   %rax, %r11                   # save return value in r11
            # print
            movq	$length_msg, %rdi           # rdi = "first pstring length: %d, second pstring length: %d\n"
            movq    %r10, %rsi                  # n1 -> rsi
            movq    %r11, %rdx                  # n2 -> rdx
            xorq 	%rax, %rax
            call 	printf
            # return
            jmp     .return
    .case52:
            # scan one char
            sub     $1, %rsp                    # allocated 1 byte
            movq    $chr_format, %rdi           # rdi = " %c"
            leaq    (%rsp), %rsi                # rsi sending with allocated value
            xorq 	%rax, %rax                  # make %rax 0 for scanf
            call 	scanf                       # input the first char
            # scan two char
            sub     $1, %rsp                    # allocated 1 byte
            movq    $chr_format, %rdi           # rdi = "%c"
            leaq    (%rsp), %rsi                # rsi sending with allocated value
            xorq 	%rax, %rax                  # make %rax 0 for scanf
            call 	scanf                       # input the second char
            # replaceChar string 1
            movq    %r14, %rdi                  # first string -> rdi
            xorq    %rsi, %rsi
            movb    1(%rsp), %sil               # old char -> rsi
            xorq    %rdx, %rdx
            movb    (%rsp), %dl                 # new char -> rdx
            call    replaceChar                 # replaceChar(rdi, rsi, rdx)
            # replaceChar string 2
            movq    %r15, %rdi                  # second string -> rdi
            xorq    %rsi, %rsi
            movb    1(%rsp), %sil               # old char -> rsi
            xorq    %rdx, %rdx
            movb    (%rsp), %dl                 # new char -> rdx
            call    replaceChar                 # replaceChar(rdi, rsi, rdx)
            # print
            movq	$newchar_msg, %rdi          # rdi = "old char: %c, new char: %c, first string: %s, second string: %s\n"
            xorq    %rsi, %rsi
            movb    1(%rsp), %sil               # old char -> rsi
            xorq    %rdx, %rdx
            movb    (%rsp), %dl                 # new char -> rdx
            leaq    1(%r14), %rcx               # first string -> rcx
            leaq    1(%r15), %r8                # second string -> rdi
            xorq 	%rax, %rax
            call 	printf
            # return
            jmp     .return

    .case53:
            # scan first index
            sub     $4, %rsp                    # allocated 4 bytes (use only 1 byte)
            movq    $int_format, %rdi           # rdi = "%d"
            leaq    (%rsp), %rsi                # rsi sending with allocated value for scanf
            xorq 	%rax, %rax                  # make %rax 0 for scanf
            call 	scanf                       # input the first index
            # scan second index
            sub     $4, %rsp
            movq    $int_format, %rdi
            leaq    (%rsp), %rsi
            xorq 	%rax, %rax
            call 	scanf
            # call function
            movq    %r14, %rdi                  # dst string -> rdi
            movq    %r15, %rsi                  # src string -> rsi
            movzbl  4(%rsp), %edx               # i -> rdx
            movzbl  (%rsp), %ecx                # j -> rcx
            call    pstrijcpy
            # print first string
            movq    $newstring_msg, %rdi        # rdi = "length: %d, string: %s\n"
            xorq    %rsi, %rsi
            movb    (%r14), %sil                # len -> rsi
            leaq    1(%r14), %rdx               # string -> rdx
            xorq    %rax, %rax
            call    printf
            # print second string
            movq    $newstring_msg, %rdi        # rdi = "length: %d, string: %s\n"
            xorq    %rsi, %rsi
            movb    (%r15), %sil                # len -> rsi
            leaq    1(%r15), %rdx               # string -> rdx
            xorq    %rax, %rax
            call    printf
            # return
            jmp     .return

    .case54:
            # swapCase to first string
            movq    %r14, %rdi                  # string 1 -> rdi
            call    swapCase
            # swapCase to second string
            movq    %r15, %rdi                  # string 2 -> rdi
            call    swapCase
            # print first string
            movq    $newstring_msg, %rdi        # rdi = "length: %d, string: %s\n"
            xorq    %rsi, %rsi
            movb    (%r14), %sil                # len -> rsi
            leaq    1(%r14), %rdx               # string -> rdx
            xorq    %rax, %rax
            call    printf
            # print second string
            movq    $newstring_msg, %rdi        # rdi = "length: %d, string: %s\n"
            xorq    %rsi, %rsi
            movb    (%r15), %sil                # len -> rsi
            leaq    1(%r15), %rdx               # string -> rdx
            xorq    %rax, %rax
            call    printf
            # return
            jmp     .return

    .case55:
            # scan first index
            sub     $4, %rsp                    # allocated 4 bytes (use only 1 byte)
            movq    $int_format, %rdi           # rdi = "%d"
            leaq    (%rsp), %rsi                # rsi sending with allocated value for scanf
            xorq 	%rax, %rax                  # make %rax 0 for scanf
            call 	scanf                       # input the first index
            # scan second index
            sub     $4, %rsp
            movq    $int_format, %rdi
            leaq    (%rsp), %rsi
            xorq 	%rax, %rax
            call 	scanf
            # call function
            movq    %r14, %rdi                  # dst string -> rdi
            movq    %r15, %rsi                  # src string -> rsi
            movzbl  4(%rsp), %edx               # i -> rdx
            movzbl  (%rsp), %ecx                # j -> rcx
            call    pstrijcmp
            # print
            movq    $compare_msg, %rdi          # rdi = "compare result: %d\n"
            movq    %rax, %rsi                  # return value -> rsi
            xorq    %rax, %rax
            call    printf
            # return
            jmp     .return
    .default:
            # print
            movq    $invalid_msg, %rdi
            xorq    %rax, %rax
            call    printf
            jmp     .return

    .return:
            # pop all callee saved
            movq    %rbp, %rsp                  # rsp <- rbp
            popq    %rbp
            popq    %r15
            popq    %r14
            popq    %r13

            ret
