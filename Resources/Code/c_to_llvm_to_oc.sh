# Schreibe C-Funktion in Datei
echo "int main(int argc, char** argv){return 141;}" > main.c

# Kompiliere C zu Objektcode
clang main.c -o main.out
# Programm ausführen
./main.out
# Rückgabewert erhalten
echo $?
> 141

# Kompiliere C zu LLVM-IR
clang -emit-llvm -S main.c -o main.ll
# Zeige relevanten Inhalt von LLVM-IR
file main.ll
> main.ll: ASCII text
tail -n+4 main.ll | head -n11
> ; Function Attrs: nounwind ssp uwtable
> define i32 @main(i32, i8**) #0 {
>   %3 = alloca i32, align 4
>   %4 = alloca i32, align 4
>   %5 = alloca i8**, align 8
>   store i32 0, i32* %3
>   store i32 %0, i32* %4, align 4
>   store i8** %1, i8*** %5, align 8
>   ret i32 141
> }

# Kompiliere LLVM-IR zu Assembler
llvm-as main.ll -o main.as
file main.as
> main.as: LLVM bit-code object x86_64
# Kompiliere Assembler zu ASCII-Assembler
llc main.as -o main.s
# Zeige Inhalt von Assembler-Datei
cat main.s
>   	.section	__TEXT,__text,regular,pure_instructions
>   	.macosx_version_min 10, 9
>	    .globl	_main
>   	.align	4, 0x90
> _main:                                  ## @main
>   	.cfi_startproc
> ## BB#0:
>   	pushq	%rbp
> Ltmp0:
>   	.cfi_def_cfa_offset 16
> Ltmp1:
>   	.cfi_offset %rbp, -16
>   	movq	%rsp, %rbp
> Ltmp2:
>   	.cfi_def_cfa_register %rbp
>   	movl	$0, -4(%rbp)
>   	movl	%edi, -8(%rbp)
>   	movq	%rsi, -16(%rbp)
>   	movl	$141, %eax
>   	popq	%rbp
>   	retq
>   	.cfi_endproc
>
>
> .subsections_via_symbols

# Kompiliere Assembler zu Objektcode
clang main.as -o main.llvm.out
# Programm ausführen
./main.llvm.out
# Rückgabewert erhalten
echo $?
> 141