; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=mips-unknwon-linux-gnu -mcpu=mips32r2 \
; RUN:   -mattr=+use-indirect-jump-hazard,+long-calls,+noabicalls %s -o - \
; RUN:   -verify-machineinstrs | FileCheck -check-prefix=O32 %s

; RUN: llc -mtriple=mips64-unknown-linux-gnu -mcpu=mips64r2 -target-abi n32 \
; RUN:   -mattr=+use-indirect-jump-hazard,+long-calls,+noabicalls %s -o - \
; RUN:   -verify-machineinstrs | FileCheck -check-prefix=N32 %s

; RUN: llc -mtriple=mips64-unknown-linux-gnu -mcpu=mips64r2 -target-abi n64 \
; RUN:   -mattr=+use-indirect-jump-hazard,+long-calls,+noabicalls %s -o - \
; RUN:   -verify-machineinstrs | FileCheck -check-prefix=N64 %s

declare void @callee()
declare void @llvm.memset.p0i8.i32(i8* nocapture writeonly, i8, i32, i32, i1)

@val = internal unnamed_addr global [20 x i32] zeroinitializer, align 4

; Test that the long call sequence uses the hazard barrier instruction variant.
define void @caller() {
; O32-LABEL: caller:
; O32:       # BB#0:
; O32-NEXT:    addiu $sp, $sp, -24
; O32-NEXT:  $cfi0:
; O32-NEXT:    .cfi_def_cfa_offset 24
; O32-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; O32-NEXT:  $cfi1:
; O32-NEXT:    .cfi_offset 31, -4
; O32-NEXT:    lui $1, %hi(callee)
; O32-NEXT:    addiu $25, $1, %lo(callee)
; O32-NEXT:    jalr.hb $25
; O32-NEXT:    nop
; O32-NEXT:    lui $1, %hi(val)
; O32-NEXT:    addiu $1, $1, %lo(val)
; O32-NEXT:    lui $2, 20560
; O32-NEXT:    ori $2, $2, 20560
; O32-NEXT:    sw $2, 96($1)
; O32-NEXT:    sw $2, 92($1)
; O32-NEXT:    sw $2, 88($1)
; O32-NEXT:    sw $2, 84($1)
; O32-NEXT:    sw $2, 80($1)
; O32-NEXT:    lw $ra, 20($sp) # 4-byte Folded Reload
; O32-NEXT:    jr $ra
; O32-NEXT:    addiu $sp, $sp, 24
;
; N32-LABEL: caller:
; N32:       # BB#0:
; N32-NEXT:    addiu $sp, $sp, -16
; N32-NEXT:  .Lcfi0:
; N32-NEXT:    .cfi_def_cfa_offset 16
; N32-NEXT:    sd $ra, 8($sp) # 8-byte Folded Spill
; N32-NEXT:  .Lcfi1:
; N32-NEXT:    .cfi_offset 31, -8
; N32-NEXT:    lui $1, %hi(callee)
; N32-NEXT:    addiu $25, $1, %lo(callee)
; N32-NEXT:    jalr.hb $25
; N32-NEXT:    nop
; N32-NEXT:    lui $1, %hi(val)
; N32-NEXT:    addiu $1, $1, %lo(val)
; N32-NEXT:    lui $2, 1285
; N32-NEXT:    daddiu $2, $2, 1285
; N32-NEXT:    dsll $2, $2, 16
; N32-NEXT:    daddiu $2, $2, 1285
; N32-NEXT:    dsll $2, $2, 20
; N32-NEXT:    daddiu $2, $2, 20560
; N32-NEXT:    sdl $2, 88($1)
; N32-NEXT:    sdl $2, 80($1)
; N32-NEXT:    lui $3, 20560
; N32-NEXT:    ori $3, $3, 20560
; N32-NEXT:    sw $3, 96($1)
; N32-NEXT:    sdr $2, 95($1)
; N32-NEXT:    sdr $2, 87($1)
; N32-NEXT:    ld $ra, 8($sp) # 8-byte Folded Reload
; N32-NEXT:    jr $ra
; N32-NEXT:    addiu $sp, $sp, 16
;
; N64-LABEL: caller:
; N64:       # BB#0:
; N64-NEXT:    daddiu $sp, $sp, -16
; N64-NEXT:  .Lcfi0:
; N64-NEXT:    .cfi_def_cfa_offset 16
; N64-NEXT:    sd $ra, 8($sp) # 8-byte Folded Spill
; N64-NEXT:  .Lcfi1:
; N64-NEXT:    .cfi_offset 31, -8
; N64-NEXT:    lui $1, %highest(callee)
; N64-NEXT:    daddiu $1, $1, %higher(callee)
; N64-NEXT:    dsll $1, $1, 16
; N64-NEXT:    daddiu $1, $1, %hi(callee)
; N64-NEXT:    dsll $1, $1, 16
; N64-NEXT:    daddiu $25, $1, %lo(callee)
; N64-NEXT:    jalr.hb $25
; N64-NEXT:    nop
; N64-NEXT:    lui $1, %highest(val)
; N64-NEXT:    daddiu $1, $1, %higher(val)
; N64-NEXT:    dsll $1, $1, 16
; N64-NEXT:    daddiu $1, $1, %hi(val)
; N64-NEXT:    dsll $1, $1, 16
; N64-NEXT:    daddiu $1, $1, %lo(val)
; N64-NEXT:    lui $2, 1285
; N64-NEXT:    daddiu $2, $2, 1285
; N64-NEXT:    dsll $2, $2, 16
; N64-NEXT:    daddiu $2, $2, 1285
; N64-NEXT:    dsll $2, $2, 20
; N64-NEXT:    daddiu $2, $2, 20560
; N64-NEXT:    lui $3, 20560
; N64-NEXT:    sdl $2, 88($1)
; N64-NEXT:    sdl $2, 80($1)
; N64-NEXT:    ori $3, $3, 20560
; N64-NEXT:    sw $3, 96($1)
; N64-NEXT:    sdr $2, 95($1)
; N64-NEXT:    sdr $2, 87($1)
; N64-NEXT:    ld $ra, 8($sp) # 8-byte Folded Reload
; N64-NEXT:    jr $ra
; N64-NEXT:    daddiu $sp, $sp, 16
  call void @callee()
  call void @llvm.memset.p0i8.i32(i8* bitcast (i32* getelementptr inbounds ([20 x i32], [20 x i32]* @val, i64 1, i32 0) to i8*), i8 80, i32 20, i32 4, i1 false)
  ret  void
}

