.code16
movw $mag_start, %si
call putstr

fin:
hlt                         // 何かあるまでCPUを停止させる
jmp fin                     // 無限ループ

putstr:
pushw %si
pushw %ax
pushw %bx

putloop:
movb (%si), %al
addw $1, %si
cmpb $0, %al
je putend 

movb $0x0e, %ah             // 一文字表示ファンクション
movw $15, %bx               // カラーコード
int $0x10                   // ビデオBIOS呼び出し
jmp putloop

putend:
popw %bx
popw %ax
popw %si
ret

// メッセージ部分
mag_start: .ascii "OS Start\r\n\0"

