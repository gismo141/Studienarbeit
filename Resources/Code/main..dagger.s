	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 13, 3
	.globl	_main_init_regset
	.align	4, 0x90
_main_init_regset:                      ## @main_init_regset
	.cfi_startproc
## BB#0:
	movl	%edx, %eax
	leaq	-8(%rsi,%rax), %rdx
	movq	$-1, -8(%rsi,%rax)
	movq	%rdx, 80(%rdi)
	movl	%ecx, %eax
	movq	%rax, 48(%rdi)
	movq	%r8, 72(%rdi)
	retq
	.cfi_endproc

	.globl	_main_fini_regset
	.align	4, 0x90
_main_fini_regset:                      ## @main_fini_regset
	.cfi_startproc
## BB#0:
	movl	16(%rdi), %eax
	retq
	.cfi_endproc

	.globl	_fn_100000F80
	.align	4, 0x90
_fn_100000F80:                          ## @fn_100000F80
	.cfi_startproc
## BB#0:                                ## %exit_fn_100000F80
	pushq	%rbx
Ltmp0:
	.cfi_def_cfa_offset 16
Ltmp1:
	.cfi_offset %rbx, -16
	movq	64(%rdi), %rax
	movq	%rax, -8(%rsp)
	movl	%eax, -12(%rsp)
	movw	%ax, -14(%rsp)
	movq	24(%rdi), %rax
	movq	%rax, -24(%rsp)
	movq	80(%rdi), %rcx
	movq	%rcx, -32(%rsp)
	movl	%ecx, -36(%rsp)
	movw	%cx, -38(%rsp)
	movb	%cl, -39(%rsp)
	movl	%eax, -44(%rsp)
	movw	%ax, -46(%rsp)
	movb	%al, -47(%rsp)
	movq	48(%rdi), %rax
	movq	%rax, -56(%rsp)
	movl	%eax, -60(%rsp)
	movq	72(%rdi), %rax
	movq	%rax, -72(%rsp)
	movq	16(%rdi), %rax
	movq	%rax, -80(%rsp)
	movl	%eax, -84(%rsp)
	movw	%ax, -86(%rsp)
	movb	%al, -87(%rsp)
	movb	%ah, -88(%rsp)  # NOREX
	movq	-24(%rsp), %rcx
	movq	-32(%rsp), %rax
	movq	%rcx, -8(%rax)
	movl	$0, -12(%rax)
	movq	-56(%rsp), %rcx
	movl	%ecx, -16(%rax)
	movq	-72(%rsp), %r8
	movq	%r8, -24(%rax)
	movl	-16(%rax), %ebx
	movq	-8(%rax), %rsi
	movq	(%rax), %rdx
	addq	$8, %rax
	movb	%bh, -88(%rsp)  # NOREX
	movb	%bl, -87(%rsp)
	movw	%bx, -86(%rsp)
	movw	%si, -46(%rsp)
	movb	%sil, -47(%rsp)
	movl	%ebx, -84(%rsp)
	movl	%esi, -44(%rsp)
	movl	%ecx, -60(%rsp)
	movl	%edx, -12(%rsp)
	movl	%eax, -36(%rsp)
	movw	%dx, -14(%rsp)
	movq	%rbx, -80(%rsp)
	movq	%rsi, -24(%rsp)
	movq	%rcx, -56(%rsp)
	movq	%rdx, -8(%rsp)
	movq	%r8, -72(%rsp)
	movq	%rax, -32(%rsp)
	movw	%ax, -38(%rsp)
	movb	%al, -39(%rsp)
	movq	-80(%rsp), %rax
	movq	%rax, 16(%rdi)
	movq	-24(%rsp), %rax
	movq	%rax, 24(%rdi)
	movq	-56(%rsp), %rax
	movq	%rax, 48(%rdi)
	movq	-8(%rsp), %rax
	movq	%rax, 64(%rdi)
	movq	-72(%rsp), %rax
	movq	%rax, 72(%rdi)
	movq	-32(%rsp), %rax
	movq	%rax, 80(%rdi)
	popq	%rbx
	retq
	.cfi_endproc

	.globl	_main
	.align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## BB#0:
	pushq	%rbx
Ltmp2:
	.cfi_def_cfa_offset 16
	subq	$10880, %rsp            ## imm = 0x2A80
Ltmp3:
	.cfi_def_cfa_offset 10896
Ltmp4:
	.cfi_offset %rbx, -16
	movq	%rsi, %rax
	movl	%edi, %ecx
	leaq	8192(%rsp), %rbx
	leaq	(%rsp), %rsi
	movl	$8192, %edx             ## imm = 0x2000
	movq	%rbx, %rdi
	movq	%rax, %r8
	callq	_main_init_regset
	movq	%rbx, %rdi
	callq	_fn_100000F80
	movq	%rbx, %rdi
	callq	_main_fini_regset
	addq	$10880, %rsp            ## imm = 0x2A80
	popq	%rbx
	retq
	.cfi_endproc


.subsections_via_symbols
