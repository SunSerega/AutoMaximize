﻿## uses OpenCLABC;

var S := new MemorySegment(8);

Context.Default.SyncInvoke(
  (S.NewQueue.ThenWriteValue&<byte>(1,0) * S.NewQueue.ThenWriteValue&<word>(2,1)) +
  S.NewQueue.ThenWriteValue&<real>(3,0)
);