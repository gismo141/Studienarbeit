; ModuleID = 'output'

%regset = type { i16, i16, i32, i16, i16, i16, i16, i64, i64, i64, i64, \
  i64, i64, i64, i64, i64, i16, i64, i64, i64, i64, i64, i64, i64, i64, \
  i64, i64, i64, i64, i64, i64, i64, i64, i32, i32, i32, i32, i32, i32, \
  i32, i32, i80, i80, i80, i80, i80, i80, i80, i16, i16, i16, i16, i16, \
  i16, i16, i16, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, \
  i64, i64, i64, i64, i64, i80, i80, i80, i80, i80, i80, i80, i80, i512, \
  i512, i512, i512, i512, i512, i512, i512, i512, i512, i512, i512, i512, \
  i512, i512, i512, i512, i512, i512, i512, i512, i512, i512, i512, i512, \
  i512, i512, i512, i512, i512, i512, i512 }

define void @main_init_regset(%regset*, i8*, i32, i32, i8**) {
  %6 = ptrtoint i8* %1 to i64
  %7 = zext i32 %2 to i64
  %8 = add i64 %6, %7
  %9 = sub i64 %8, 8
  %10 = inttoptr i64 %9 to i64*
  store i64 -1, i64* %10
  %11 = getelementptr inbounds %regset* %0, i32 0, i32 15
  store i64 %9, i64* %11
  %12 = zext i32 %3 to i64
  %13 = getelementptr inbounds %regset* %0, i32 0, i32 11
  store i64 %12, i64* %13
  %14 = ptrtoint i8** %4 to i64
  %15 = getelementptr inbounds %regset* %0, i32 0, i32 14
  store i64 %14, i64* %15
  ret void
}

define i32 @main_fini_regset(%regset*) {
  %2 = getelementptr inbounds %regset* %0, i32 0, i32 7
  %3 = load i64* %2
  %4 = trunc i64 %3 to i32
  ret i32 %4
}

define void @fn_100000F80(%regset* noalias nocapture) {
entry_fn_100000F80:
  %RIP_ptr = getelementptr inbounds %regset* %0, i32 0, i32 13
  %RIP_init = load i64* %RIP_ptr
  %RIP = alloca i64
  store i64 %RIP_init, i64* %RIP
  %EIP_init = trunc i64 %RIP_init to i32
  %EIP = alloca i32
  store i32 %EIP_init, i32* %EIP
  %IP_init = trunc i64 %RIP_init to i16
  %IP = alloca i16
  store i16 %IP_init, i16* %IP
  %RBP_ptr = getelementptr inbounds %regset* %0, i32 0, i32 8
  %RBP_init = load i64* %RBP_ptr
  %RBP = alloca i64
  store i64 %RBP_init, i64* %RBP
  %RSP_ptr = getelementptr inbounds %regset* %0, i32 0, i32 15
  %RSP_init = load i64* %RSP_ptr
  %RSP = alloca i64
  store i64 %RSP_init, i64* %RSP
  %ESP_init = trunc i64 %RSP_init to i32
  %ESP = alloca i32
  store i32 %ESP_init, i32* %ESP
  %SP_init = trunc i64 %RSP_init to i16
  %SP = alloca i16
  store i16 %SP_init, i16* %SP
  %SPL_init = trunc i64 %RSP_init to i8
  %SPL = alloca i8
  store i8 %SPL_init, i8* %SPL
  %EBP_init = trunc i64 %RBP_init to i32
  %EBP = alloca i32
  store i32 %EBP_init, i32* %EBP
  %BP_init = trunc i64 %RBP_init to i16
  %BP = alloca i16
  store i16 %BP_init, i16* %BP
  %BPL_init = trunc i64 %RBP_init to i8
  %BPL = alloca i8
  store i8 %BPL_init, i8* %BPL
  %RAX_ptr = getelementptr inbounds %regset* %0, i32 0, i32 7
  %RAX_init = load i64* %RAX_ptr
  %RAX = alloca i64
  store i64 %RAX_init, i64* %RAX
  %EAX_init = trunc i64 %RAX_init to i32
  %EAX = alloca i32
  store i32 %EAX_init, i32* %EAX
  %AX_init = trunc i64 %RAX_init to i16
  %AX = alloca i16
  store i16 %AX_init, i16* %AX
  %AL_init = trunc i64 %RAX_init to i8
  %AL = alloca i8
  store i8 %AL_init, i8* %AL
  %1 = lshr i64 %RAX_init, 8
  %AH_init = trunc i64 %1 to i8
  %AH = alloca i8
  store i8 %AH_init, i8* %AH
  %RDI_ptr = getelementptr inbounds %regset* %0, i32 0, i32 11
  %RDI_init = load i64* %RDI_ptr
  %RDI = alloca i64
  store i64 %RDI_init, i64* %RDI
  %EDI_init = trunc i64 %RDI_init to i32
  %EDI = alloca i32
  store i32 %EDI_init, i32* %EDI
  %RSI_ptr = getelementptr inbounds %regset* %0, i32 0, i32 14
  %RSI_init = load i64* %RSI_ptr
  %RSI = alloca i64
  store i64 %RSI_init, i64* %RSI
  br label %bb_100000F80

exit_fn_100000F80:                                ; preds = %bb_100000F80
  %2 = load i64* %RAX
  store i64 %2, i64* %RAX_ptr
  %3 = load i64* %RBP
  store i64 %3, i64* %RBP_ptr
  %4 = load i64* %RDI
  store i64 %4, i64* %RDI_ptr
  %5 = load i64* %RIP
  store i64 %5, i64* %RIP_ptr
  %6 = load i64* %RSI
  store i64 %6, i64* %RSI_ptr
  %7 = load i64* %RSP
  store i64 %7, i64* %RSP_ptr
  ret void

bb_100000F80:                                     ; preds = %entry_fn_100000F80
  %EIP_0 = trunc i64 4294971264 to i32
  %8 = trunc i64 4294971264 to i32
  %IP_0 = trunc i64 4294971264 to i16
  %9 = trunc i64 4294971264 to i16
  %RIP_1 = add i64 4294971264, 1
  %EIP_1 = trunc i64 %RIP_1 to i32
  %IP_1 = trunc i64 %RIP_1 to i16
  %RBP_0 = load i64* %RBP
  %RSP_0 = load i64* %RSP
  %10 = sub i64 %RSP_0, 8
  %11 = inttoptr i64 %10 to i64*
  store i64 %RBP_0, i64* %11
  %RSP_1 = sub i64 %RSP_0, 8
  %ESP_0 = trunc i64 %RSP_1 to i32
  %12 = trunc i64 %RSP_1 to i32
  %SP_0 = trunc i64 %RSP_1 to i16
  %13 = trunc i64 %RSP_1 to i16
  %SPL_0 = trunc i64 %RSP_1 to i8
  %14 = trunc i64 %RSP_1 to i8
  %RIP_2 = add i64 %RIP_1, 3
  %EIP_2 = trunc i64 %RIP_2 to i32
  %IP_2 = trunc i64 %RIP_2 to i16
  %EBP_0 = trunc i64 %RSP_1 to i32
  %15 = trunc i64 %RSP_1 to i32
  %BP_0 = trunc i64 %RSP_1 to i16
  %16 = trunc i64 %RSP_1 to i16
  %BPL_0 = trunc i64 %RSP_1 to i8
  %17 = trunc i64 %RSP_1 to i8
  %RIP_3 = add i64 %RIP_2, 5
  %EIP_3 = trunc i64 %RIP_3 to i32
  %IP_3 = trunc i64 %RIP_3 to i16
  %RAX_0 = load i64* %RAX
  %18 = trunc i64 %RAX_0 to i32
  %RAX_1 = zext i32 141 to i64
  %AX_0 = trunc i32 141 to i16
  %19 = trunc i64 %RAX_1 to i16
  %AL_0 = trunc i32 141 to i8
  %20 = trunc i64 %RAX_1 to i8
  %21 = lshr i32 141, 8
  %AH_0 = trunc i32 %21 to i8
  %22 = lshr i64 %RAX_1, 8
  %23 = trunc i64 %22 to i8
  %RIP_4 = add i64 %RIP_3, 7
  %EIP_4 = trunc i64 %RIP_4 to i32
  %IP_4 = trunc i64 %RIP_4 to i16
  %24 = add i64 %RSP_1, -4
  %25 = inttoptr i64 %24 to i32*
  store i32 0, i32* %25
  %RIP_5 = add i64 %RIP_4, 3
  %EIP_5 = trunc i64 %RIP_5 to i32
  %IP_5 = trunc i64 %RIP_5 to i16
  %RDI_0 = load i64* %RDI
  %EDI_0 = trunc i64 %RDI_0 to i32
  %26 = add i64 %RSP_1, -8
  %27 = inttoptr i64 %26 to i32*
  store i32 %EDI_0, i32* %27
  %RIP_6 = add i64 %RIP_5, 4
  %EIP_6 = trunc i64 %RIP_6 to i32
  %IP_6 = trunc i64 %RIP_6 to i16
  %RSI_0 = load i64* %RSI
  %28 = add i64 %RSP_1, -16
  %29 = inttoptr i64 %28 to i64*
  store i64 %RSI_0, i64* %29
  %RIP_7 = add i64 %RIP_6, 1
  %EIP_7 = trunc i64 %RIP_7 to i32
  %IP_7 = trunc i64 %RIP_7 to i16
  %RSP_2 = add i64 %RSP_1, 8
  %ESP_1 = trunc i64 %RSP_2 to i32
  %SP_1 = trunc i64 %RSP_2 to i16
  %SPL_1 = trunc i64 %RSP_2 to i8
  %30 = sub i64 %RSP_2, 8
  %31 = inttoptr i64 %30 to i64*
  %RBP_1 = load i64* %31
  %EBP_1 = trunc i64 %RBP_1 to i32
  %BP_1 = trunc i64 %RBP_1 to i16
  %BPL_1 = trunc i64 %RBP_1 to i8
  %RIP_8 = add i64 %RIP_7, 1
  %EIP_8 = trunc i64 %RIP_8 to i32
  %IP_8 = trunc i64 %RIP_8 to i16
  %RSP_3 = add i64 %RSP_2, 8
  %32 = inttoptr i64 %RSP_2 to i64*
  %RIP_9 = load i64* %32
  %ESP_2 = trunc i64 %RSP_3 to i32
  %SP_2 = trunc i64 %RSP_3 to i16
  %SPL_2 = trunc i64 %RSP_3 to i8
  %EIP_9 = trunc i64 %RIP_9 to i32
  %IP_9 = trunc i64 %RIP_9 to i16
  store i8 %AH_0, i8* %AH
  store i8 %AL_0, i8* %AL
  store i16 %AX_0, i16* %AX
  store i16 %BP_1, i16* %BP
  store i8 %BPL_1, i8* %BPL
  store i32 141, i32* %EAX
  store i32 %EBP_1, i32* %EBP
  store i32 %EDI_0, i32* %EDI
  store i32 %EIP_9, i32* %EIP
  store i32 %ESP_2, i32* %ESP
  store i16 %IP_9, i16* %IP
  store i64 %RAX_1, i64* %RAX
  store i64 %RBP_1, i64* %RBP
  store i64 %RDI_0, i64* %RDI
  store i64 %RIP_9, i64* %RIP
  store i64 %RSI_0, i64* %RSI
  store i64 %RSP_3, i64* %RSP
  store i16 %SP_2, i16* %SP
  store i8 %SPL_2, i8* %SPL
  br label %exit_fn_100000F80
}

; Function Attrs: noreturn nounwind
declare void @llvm.trap() #0

define i32 @main(i32, i8**) {
  %3 = alloca %regset
  %4 = alloca [8192 x i8]
  %5 = getelementptr inbounds [8192 x i8]* %4, i32 0, i32 0
  call void @main_init_regset(%regset* %3, i8* %5, i32 8192, i32 %0, i8** %1)
  call void @fn_100000F80(%regset* %3)
  %6 = call i32 @main_fini_regset(%regset* %3)
  ret i32 %6
}

attributes #0 = { noreturn nounwind }
