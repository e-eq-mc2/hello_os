.equ VRAM ,     0x0ff8      // グラフィックバッファの開始番地

# HLT
.global io_hlt
io_hlt:
    movl $0    , %ecx
    movl (VRAM), %edi
loop2:
    movb $9  , (%edi)
    addl $1  , %ecx
    addl $1  , %edi
    cmpl $320 * 100, %ecx
    jb loop2
ret
