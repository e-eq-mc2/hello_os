void io_hlt();

void Main() {
  char *p = (void *)0x000a0000;
  int i;
  for( i = 0x0000; i < 0xffff; i++ ) {
    p[i] = (char)90;
  }

  while(1) {}
  //
  //io_hlt();

  //while(1) { io_hlt(); }
}
