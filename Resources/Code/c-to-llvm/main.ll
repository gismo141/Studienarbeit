; ModuleID = 'main.cpp'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32
	-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64
	-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.9.0"

; Function Attrs: nounwind ssp uwtable
define i32 @main(i32, i8**) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  store i32 0, i32* %3
  store i32 %0, i32* %4, align 4
  store i8** %1, i8*** %5, align 8
  ret i32 141
}

attributes #0 = { nounwind ssp uwtable "less-precise-fpmad"="false"
	"no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf"
	"no-infs-fp-math"="false" "no-nans-fp-math"="false"
	"stack-protector-buffer-size"="8" "unsafe-fp-math"="false"
	"use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"Apple LLVM version 5.1 (clang-503.0.40)
	(based on LLVM 3.4svn)"}
