# chen larry

                            .section	.rodata

int_format:		.string "%d"
str_format:		.string " %s"

                                .text

# declaration of run_main
.globl run_main
.type run_main, @function
# run_main
run_main:
            # push all callee saved
            pushq   %r13                        # allocate for option
            pushq   %r14                        # allocate for pstring 1
            pushq   %r15                        # allocate for pstring 2
            pushq   %rbp                        # save old rbp
            movq    %rsp, %rbp                  # rbp <- rsp

            # scan length
            sub     $4, %rsp                    # allocate 4 bytes
            movq    $int_format, %rdi           # rdi = "%d"
            leaq    (%rsp), %rsi                # rsi sending with allocated value for scanf
            xorq 	%rax, %rax
            call 	scanf
            # allocate place to pstring
            movzbl  (%rsp), %r10d               # r10 = length
            sub     $2, %rsp                    # allocate 2 bytes for length and '\0'
            sub     %r10, %rsp                  # allocate length bytes for string
            # save length in memory
            movb    %r10b, (%rsp)
            # scan string to memory
            movq    $str_format, %rdi
            leaq    1(%rsp), %rsi
            xorq    %rax, %rax
            call    scanf
            # save '\0' in memory
            leaq    1(%rsp,%r10,1), %r11
            movb    $0, (%r11)
            # save pointer to pstring 1
            movq    %rsp, %r14

            # scan length
            sub     $4, %rsp                    # allocate 4 bytes
            movq    $int_format, %rdi           # rdi = "%d"
            leaq    (%rsp), %rsi                # rsi sending with allocated value for scanf
            xorq 	%rax, %rax
            call 	scanf
            # allocate place to pstring
            movzbl  (%rsp), %r10d               # r10 = length
            sub     $2, %rsp                    # allocate 2 bytes for length and '\0'
            sub     %r10, %rsp                  # allocate length bytes for string
            # save length in memory
            movb    %r10b, (%rsp)
            # scan string to memory
            movq    $str_format, %rdi
            leaq    1(%rsp), %rsi
            xorq    %rax, %rax
            call    scanf
            # save '\0' in memory
            leaq    1(%rsp,%r10,1), %r11
            movb    $0, (%r11)
            # save pointer to pstring 2
            movq    %rsp, %r15

            # scan option
            sub     $4, %rsp                    # allocate 4 bytes
            movq    $int_format, %rdi           # rdi = "%d"
            leaq    (%rsp), %rsi                # rsi sending with allocated value for scanf
            xorq 	%rax, %rax
            call 	scanf
            # save option
            movzbl  (%rsp), %r13d

            # call run_func
            movq    %r13, %rdi                  # first argument is option
            movq    %r14, %rsi                  # second argument is pstring1
            movq    %r15, %rdx                  # third argument is pstring2
            call    run_func

            # pop all callee saved
            movq    %rbp, %rsp                  # rsp <- rbp
            popq    %rbp
            popq    %r15
            popq    %r14
            popq    %r13

            ret
