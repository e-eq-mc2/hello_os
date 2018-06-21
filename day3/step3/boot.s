.code16
jmp entry

// 以下は標準的なFAT12フォーマットフロッピーディスクのための記述
.ascii "HELLOIPL"           // ブートセクタの名前を自由に書いてよい(8バイト)             
.word 512                   // 1セクタの大きさ(512にしなければいけない)                  
.byte 1                     // クラスタの大きさ(1セクタにしなければいけない)             
.word 1                     // FATがどこから始まるか(普通は1セクタ目からにする)          
.byte 2                     // FATの個数(2にしなければいけない)                          
.word 224                   // ルートディレクトリ領域の大きさ(普通は224エントリにする)   
.word 2880                  // このドライブの大きさ(2880セクタにしなければいけない)      
.byte 0xf0                  // メディアのタイプ(0xf0にしなければいけない)                
.word 9                     // FAT領域の長さ(9セクタにしなければいけない)                
.word 18                    // 1トラックにいくつのセクタがあるか(18にしなければいけない) 
.word 2                     // ヘッドの数(2にしなければいけない)                         
.int 0                      // パーティションを使ってないのでここは必ず0                 
.int 2880                   // このドライブの大きさをもう一度書く                        
.byte 0, 0, 0x29            // よく分からないけどこの値にしておくといいらしい            
.int 0xffffffff             // たぶんボリュームシリアル番号                              
.ascii "HELLO-OS   "        // ディスクの名前(11バイト)                                  
.ascii "FAT12   "           // フォーマットの名前(8バイト)                               
.org . + 18                 // とりあえず18バイトあけておく                              

entry:
movw $0, %ax
movw %ax, %ss
movw $0x7c00, %sp
movw %ax, %ds
movw %ax, %es

movw $mag_hello, %si
call putstr

// ディスクを読む
movw $0x820, %ax
movw %ax, %es
movb $0, %ch                // シリンダ
movb $0, %dh                // ヘッド
movb $2, %cl                // セクタ

movw $0, %si

readloop:

movb $0x02, %ah             // AH=0x02 : ディスク読み込み
movb $1, %al                // 処理するセクタ数;(連続したセクタを処理できる)
movw $0x0, %bx              // ES:BX = バッファアドレス
movb $0x00, %dl             // ドライブ番号 DL=0x00 : Aドライブ
int $0x13                   // ディスク関係 AH=0x02 : ディスク読み込み
                            //戻り値:
                            //FLAGS.CF == 0 : エラーなし、AH == 0
                            //FLAGS.CF == 1 : エラーあり、AHにエラーコード(リセットファンクションと同じ)
jnc next

addw $1, %si
cmpw $5, %si
jae failed

movb $0x00, %ah
movb $0x00, %dl             // ドライブ番号 DL=0x00 : Aドライブ
int $0x13                   // ディスク関係 AH=0x00 : システムのリセット (ドライブをリ セット)
jmp readloop

next:
movw %es, %ax
addw $0x20, %ax
movw %ax, %es

addb $1, %cl                // セクタ
cmpb $18, %cl 
jbe readloop

movb $1, %cl                // セクタ
addb $1, %dh                // ヘッダ
cmpb $2, %dh 
jb readloop

pushw %si
movw $mag_readloop, %si
call putstr
popw %si

movb $0, %dh                // ヘッダ
addb $1, %ch                // シリンダ
cmpb $10, %ch 
jb readloop

succeeded:
movw $mag_succeeded, %si
call putstr
jmp fin

failed:
movw $mag_failed, %si
call putstr
jmp fin

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
mag_hello: .ascii "hello, world\r\n\0"
mag_readloop: .ascii "R\r\n\0"
mag_succeeded: .ascii "READ SUCCEEDED\r\n\0"
mag_failed: .ascii "FAILED\r\n\0"
CYLS: .byte 10

fin:
jmp 0xc200

.org 510
.byte 0x55, 0xaa
