; ModuleID = 'xdp_prog_kern.c'
source_filename = "xdp_prog_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.anon = type { [1 x i32]*, [32 x i32]*, %struct.flow_id*, %struct.tcp_md* }
%struct.flow_id = type { i32, i16, i32, i16 }
%struct.tcp_md = type { i32, i32, i32, i32, i32 }
%struct.anon.0 = type { [2 x i32]*, [32 x i32]*, i32*, %struct.packet_event* }
%struct.packet_event = type { %struct.flow_id, i32, i8, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.app_event = type { %struct.flow_id, i8*, i8*, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.hdr_cursor = type { i8* }
%struct.iphdr = type { i8, i8, i16, i16, i16, i8, i8, i16, i32, i32 }
%struct.tcphdr = type { i16, i16, i32, i32, i16, i16, i16, i16 }
%struct.event = type { i8, i8* }
%struct.net_event = type { %struct.flow_id, i32 }

@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !0
@tcp_connections = dso_local global %struct.anon zeroinitializer, section ".maps", align 8, !dbg !25
@packet_events = dso_local global %struct.anon.0 zeroinitializer, section ".maps", align 8, !dbg !60
@app_event_processor.____fmt = internal constant [38 x i8] c"\0Atcp_ctx does not exist with the fid\0A\00", align 1, !dbg !116
@app_event_processor.____fmt.1 = internal constant [38 x i8] c"\0AFailed to add packet with seq_num %u\00", align 1, !dbg !133
@app_event_processor.____fmt.2 = internal constant [37 x i8] c"\0Atcp_ctx does not exist with the fid\00", align 1, !dbg !135
@app_event_processor.____fmt.3 = internal constant [66 x i8] c"\0ASend packet with seq_num: %u, window_size: %u, last_seq_sent: %u\00", align 1, !dbg !140
@net_event_processor.____fmt = internal constant [38 x i8] c"\0Atcp_ctx does not exist with the fid\0A\00", align 1, !dbg !160
@net_event_processor.____fmt.4 = internal constant [38 x i8] c"\0Atcp_ctx does not exist with the fid\0A\00", align 1, !dbg !178
@net_event_processor.____fmt.5 = internal constant [49 x i8] c"\0AReceived ack %u, window_size: %u, start_seq: %u\00", align 1, !dbg !180
@net_event_processor.____fmt.6 = internal constant [38 x i8] c"\0AFailed to add packet with seq_num %u\00", align 1, !dbg !185
@net_event_processor.____fmt.7 = internal constant [37 x i8] c"\0Atcp_ctx does not exist with the fid\00", align 1, !dbg !187
@net_event_processor.____fmt.8 = internal constant [62 x i8] c"\0ASend packet with seq_num: %u, window_size: %u, start_seq: %u\00", align 1, !dbg !189
@llvm.used = appending global [4 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.anon.0* @packet_events to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @simply_drop to i8*), i8* bitcast (%struct.anon* @tcp_connections to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @simply_drop(%struct.xdp_md* nocapture readonly %0) #0 section "xdp" !dbg !207 {
  %2 = alloca %struct.flow_id, align 4
  call void @llvm.dbg.declare(metadata %struct.flow_id* %2, metadata !167, metadata !DIExpression()), !dbg !289
  %3 = alloca %struct.packet_event, align 4
  call void @llvm.dbg.declare(metadata %struct.packet_event* %3, metadata !174, metadata !DIExpression()), !dbg !292
  %4 = alloca %struct.packet_event, align 4
  call void @llvm.dbg.declare(metadata %struct.packet_event* %4, metadata !126, metadata !DIExpression()), !dbg !293
  %5 = alloca %struct.app_event, align 8
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !219, metadata !DIExpression()), !dbg !295
  %6 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !296
  %7 = load i32, i32* %6, align 4, !dbg !296, !tbaa !297
  %8 = zext i32 %7 to i64, !dbg !302
  %9 = inttoptr i64 %8 to i8*, !dbg !303
  call void @llvm.dbg.value(metadata i8* %9, metadata !220, metadata !DIExpression()), !dbg !295
  %10 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !304
  %11 = load i32, i32* %10, align 4, !dbg !304, !tbaa !305
  %12 = zext i32 %11 to i64, !dbg !306
  %13 = inttoptr i64 %12 to i8*, !dbg !307
  call void @llvm.dbg.value(metadata i8* %13, metadata !221, metadata !DIExpression()), !dbg !295
  call void @llvm.dbg.value(metadata i64 %12, metadata !275, metadata !DIExpression()), !dbg !295
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !222, metadata !DIExpression(DW_OP_deref)), !dbg !295
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !308, metadata !DIExpression()), !dbg !319
  call void @llvm.dbg.value(metadata i8* %9, metadata !315, metadata !DIExpression()), !dbg !319
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !316, metadata !DIExpression()), !dbg !319
  call void @llvm.dbg.value(metadata i8* %13, metadata !317, metadata !DIExpression()), !dbg !319
  call void @llvm.dbg.value(metadata i32 14, metadata !318, metadata !DIExpression()), !dbg !319
  %14 = getelementptr i8, i8* %13, i64 14, !dbg !321
  %15 = icmp ugt i8* %14, %9, !dbg !323
  %16 = ptrtoint i8* %14 to i64, !dbg !324
  %17 = select i1 %15, i64 %12, i64 %16, !dbg !325
  call void @llvm.dbg.value(metadata i64 %17, metadata !275, metadata !DIExpression()), !dbg !295
  %18 = inttoptr i64 %17 to i8*, !dbg !326
  call void @llvm.dbg.value(metadata i8* %18, metadata !281, metadata !DIExpression()), !dbg !295
  %19 = getelementptr inbounds i8, i8* %18, i64 20, !dbg !327
  %20 = bitcast i8* %19 to %struct.iphdr*, !dbg !327
  %21 = inttoptr i64 %8 to %struct.iphdr*, !dbg !329
  %22 = icmp ugt %struct.iphdr* %20, %21, !dbg !330
  br i1 %22, label %209, label %23, !dbg !331

23:                                               ; preds = %1
  %24 = load i8, i8* %18, align 4, !dbg !332
  %25 = shl i8 %24, 2, !dbg !333
  %26 = and i8 %25, 60, !dbg !333
  call void @llvm.dbg.value(metadata i8 %26, metadata !282, metadata !DIExpression()), !dbg !295
  %27 = icmp ult i8 %26, 20, !dbg !334
  br i1 %27, label %209, label %28, !dbg !336

28:                                               ; preds = %23
  %29 = zext i8 %26 to i64, !dbg !337
  call void @llvm.dbg.value(metadata i64 %29, metadata !282, metadata !DIExpression()), !dbg !295
  %30 = getelementptr i8, i8* %18, i64 %29, !dbg !338
  %31 = icmp ugt i8* %30, %9, !dbg !340
  br i1 %31, label %209, label %32, !dbg !341

32:                                               ; preds = %28
  call void @llvm.dbg.value(metadata i8* %30, metadata !275, metadata !DIExpression()), !dbg !295
  call void @llvm.dbg.value(metadata i8* %18, metadata !235, metadata !DIExpression()), !dbg !295
  %33 = getelementptr inbounds i8, i8* %18, i64 12, !dbg !342
  %34 = bitcast i8* %33 to i32*, !dbg !342
  %35 = load i32, i32* %34, align 4, !dbg !342, !tbaa !343
  call void @llvm.dbg.value(metadata i32 %35, metadata !280, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !295
  %36 = getelementptr inbounds i8, i8* %18, i64 16, !dbg !346
  %37 = bitcast i8* %36 to i32*, !dbg !346
  %38 = load i32, i32* %37, align 4, !dbg !346, !tbaa !347
  call void @llvm.dbg.value(metadata i32 %38, metadata !280, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 32)), !dbg !295
  call void @llvm.dbg.value(metadata i8* %30, metadata !284, metadata !DIExpression()), !dbg !295
  %39 = getelementptr inbounds i8, i8* %30, i64 20, !dbg !348
  %40 = bitcast i8* %39 to %struct.tcphdr*, !dbg !348
  %41 = inttoptr i64 %8 to %struct.tcphdr*, !dbg !350
  %42 = icmp ugt %struct.tcphdr* %40, %41, !dbg !351
  br i1 %42, label %209, label %43, !dbg !352

43:                                               ; preds = %32
  %44 = getelementptr inbounds i8, i8* %30, i64 12, !dbg !353
  %45 = bitcast i8* %44 to i16*, !dbg !353
  %46 = load i16, i16* %45, align 4, !dbg !353
  %47 = lshr i16 %46, 2, !dbg !354
  %48 = and i16 %47, 60, !dbg !354
  call void @llvm.dbg.value(metadata i16 %48, metadata !283, metadata !DIExpression()), !dbg !295
  %49 = icmp ult i16 %48, 20, !dbg !355
  br i1 %49, label %209, label %50, !dbg !357

50:                                               ; preds = %43
  %51 = zext i16 %48 to i64, !dbg !358
  call void @llvm.dbg.value(metadata i64 %51, metadata !283, metadata !DIExpression()), !dbg !295
  %52 = getelementptr i8, i8* %30, i64 %51, !dbg !359
  %53 = icmp ugt i8* %52, %9, !dbg !361
  br i1 %53, label %209, label %54, !dbg !362

54:                                               ; preds = %50
  %55 = ptrtoint i8* %52 to i64, !dbg !363
  call void @llvm.dbg.value(metadata i64 %55, metadata !275, metadata !DIExpression()), !dbg !295
  call void @llvm.dbg.value(metadata i8* %30, metadata !253, metadata !DIExpression()), !dbg !295
  %56 = bitcast i8* %30 to i16*, !dbg !364
  %57 = load i16, i16* %56, align 4, !dbg !364, !tbaa !365
  call void @llvm.dbg.value(metadata i16 %57, metadata !280, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 16)), !dbg !295
  %58 = getelementptr inbounds i8, i8* %30, i64 2, !dbg !366
  %59 = bitcast i8* %58 to i16*, !dbg !366
  %60 = load i16, i16* %59, align 2, !dbg !366, !tbaa !365
  call void @llvm.dbg.value(metadata i16 %60, metadata !280, metadata !DIExpression(DW_OP_LLVM_fragment, 96, 16)), !dbg !295
  %61 = getelementptr inbounds i8, i8* %30, i64 8, !dbg !367
  %62 = bitcast i8* %61 to i32*, !dbg !367
  %63 = load i32, i32* %62, align 4, !dbg !367, !tbaa !368
  call void @llvm.dbg.value(metadata i32 undef, metadata !285, metadata !DIExpression()), !dbg !295
  %64 = bitcast %struct.app_event* %5 to i8*, !dbg !370
  call void @llvm.lifetime.start.p0i8(i64 40, i8* nonnull %64) #3, !dbg !370
  call void @llvm.dbg.declare(metadata %struct.app_event* %5, metadata !288, metadata !DIExpression()), !dbg !371
  call void @llvm.dbg.value(metadata i8 0, metadata !286, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 8)), !dbg !295
  call void @llvm.dbg.value(metadata i8* null, metadata !286, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !295
  call void @llvm.memset.p0i8.i64(i8* nonnull align 8 dereferenceable(40) %64, i8 0, i64 40, i1 false), !dbg !372
  switch i32 %35, label %208 [
    i32 67116554, label %123
    i32 16784906, label %65
  ], !dbg !373

65:                                               ; preds = %54
  call void @llvm.dbg.value(metadata i8 0, metadata !286, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 8)), !dbg !295
  call void @llvm.dbg.value(metadata i8* %64, metadata !286, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !295
  %66 = getelementptr inbounds %struct.app_event, %struct.app_event* %5, i64 0, i32 0, i32 0, !dbg !374
  store i32 16784906, i32* %66, align 8, !dbg !374, !tbaa.struct !378
  %67 = getelementptr inbounds %struct.app_event, %struct.app_event* %5, i64 0, i32 0, i32 1, !dbg !374
  store i16 %57, i16* %67, align 4, !dbg !374, !tbaa.struct !378
  %68 = getelementptr inbounds %struct.app_event, %struct.app_event* %5, i64 0, i32 0, i32 2, !dbg !374
  store i32 %38, i32* %68, align 8, !dbg !374, !tbaa.struct !378
  %69 = getelementptr inbounds %struct.app_event, %struct.app_event* %5, i64 0, i32 0, i32 3, !dbg !374
  store i16 %60, i16* %69, align 4, !dbg !374, !tbaa.struct !378
  %70 = getelementptr inbounds %struct.app_event, %struct.app_event* %5, i64 0, i32 1, !dbg !379
  %71 = bitcast i8** %70 to i64*, !dbg !380
  store i64 %55, i64* %71, align 8, !dbg !380, !tbaa !381
  %72 = getelementptr inbounds %struct.app_event, %struct.app_event* %5, i64 0, i32 2, !dbg !385
  store i8* %9, i8** %72, align 8, !dbg !386, !tbaa !387
  %73 = trunc i64 %55 to i32, !dbg !388
  %74 = sub i32 %7, %73, !dbg !388
  %75 = getelementptr inbounds %struct.app_event, %struct.app_event* %5, i64 0, i32 3, !dbg !389
  store i32 %74, i32* %75, align 8, !dbg !390, !tbaa !391
  call void @llvm.dbg.value(metadata i8* undef, metadata !286, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !295
  call void @llvm.dbg.value(metadata i8 2, metadata !286, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 8)), !dbg !295
  call void @llvm.dbg.value(metadata %struct.event* undef, metadata !94, metadata !DIExpression()) #3, !dbg !392
  call void @llvm.dbg.value(metadata %struct.app_event* undef, metadata !95, metadata !DIExpression()) #3, !dbg !393
  call void @llvm.dbg.value(metadata %struct.app_event* undef, metadata !122, metadata !DIExpression()) #3, !dbg !394
  %76 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.anon* @tcp_connections to i8*), i8* nonnull %64) #3, !dbg !395
  call void @llvm.dbg.value(metadata i8* %76, metadata !123, metadata !DIExpression()) #3, !dbg !394
  %77 = icmp eq i8* %76, null, !dbg !396
  br i1 %77, label %84, label %78, !dbg !398

78:                                               ; preds = %65
  call void @llvm.dbg.value(metadata i8* %76, metadata !123, metadata !DIExpression()) #3, !dbg !394
  call void @llvm.dbg.value(metadata i32 0, metadata !124, metadata !DIExpression()) #3, !dbg !399
  %79 = bitcast %struct.packet_event* %4 to i8*, !dbg !400
  %80 = getelementptr inbounds %struct.packet_event, %struct.packet_event* %4, i64 0, i32 3, !dbg !400
  %81 = getelementptr inbounds %struct.packet_event, %struct.packet_event* %4, i64 0, i32 1, !dbg !400
  %82 = bitcast i32* %81 to i8*, !dbg !400
  %83 = getelementptr inbounds i32, i32* %81, i64 1, !dbg !400
  br label %86, !dbg !401

84:                                               ; preds = %65
  %85 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* getelementptr inbounds ([38 x i8], [38 x i8]* @app_event_processor.____fmt, i64 0, i64 0), i32 38) #3, !dbg !402
  br label %208, !dbg !405

86:                                               ; preds = %112, %78
  %87 = phi i8* [ %76, %78 ], [ %108, %112 ]
  %88 = phi i32 [ 0, %78 ], [ %121, %112 ]
  call void @llvm.dbg.value(metadata i8* %87, metadata !123, metadata !DIExpression()) #3, !dbg !394
  call void @llvm.dbg.value(metadata i32 %88, metadata !124, metadata !DIExpression()) #3, !dbg !399
  call void @llvm.lifetime.start.p0i8(i64 28, i8* nonnull %79) #3, !dbg !406
  store i32 0, i32* %83, align 4, !dbg !407
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 dereferenceable(16) %79, i8* nonnull align 8 dereferenceable(16) %64, i64 16, i1 false) #3, !dbg !407, !tbaa.struct !378
  %89 = bitcast i8* %87 to i32*, !dbg !408
  %90 = load i32, i32* %89, align 4, !dbg !408, !tbaa !409
  store i32 %90, i32* %80, align 4, !dbg !411, !tbaa !412
  %91 = getelementptr inbounds i8, i8* %87, i64 16, !dbg !414
  %92 = bitcast i8* %91 to i32*, !dbg !414
  %93 = load i32, i32* %92, align 4, !dbg !414, !tbaa !415
  %94 = add i32 %93, 1, !dbg !416
  store i32 %94, i32* %81, align 4, !dbg !417, !tbaa !418
  %95 = call i64 inttoptr (i64 2 to i64 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.anon.0* @packet_events to i8*), i8* nonnull %82, i8* nonnull %79, i64 0) #3, !dbg !419
  %96 = trunc i64 %95 to i32, !dbg !419
  call void @llvm.dbg.value(metadata i32 %96, metadata !129, metadata !DIExpression()) #3, !dbg !400
  %97 = icmp slt i32 %96, 0, !dbg !420
  br i1 %97, label %98, label %100, !dbg !422

98:                                               ; preds = %86
  %99 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* getelementptr inbounds ([38 x i8], [38 x i8]* @app_event_processor.____fmt.1, i64 0, i64 0), i32 38, i32 0) #3, !dbg !423
  br label %100, !dbg !426

100:                                              ; preds = %98, %86
  %101 = getelementptr inbounds i8, i8* %87, i64 4, !dbg !427
  %102 = bitcast i8* %101 to i32*, !dbg !427
  %103 = load i32, i32* %102, align 4, !dbg !428, !tbaa !429
  %104 = add i32 %103, 1, !dbg !428
  store i32 %104, i32* %102, align 4, !dbg !428, !tbaa !429
  %105 = load i32, i32* %92, align 4, !dbg !430, !tbaa !415
  %106 = add i32 %105, 1, !dbg !430
  store i32 %106, i32* %92, align 4, !dbg !430, !tbaa !415
  %107 = call i64 inttoptr (i64 2 to i64 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.anon* @tcp_connections to i8*), i8* nonnull %64, i8* nonnull %87, i64 0) #3, !dbg !431
  %108 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.anon* @tcp_connections to i8*), i8* nonnull %64) #3, !dbg !432
  call void @llvm.dbg.value(metadata i8* %108, metadata !123, metadata !DIExpression()) #3, !dbg !394
  %109 = icmp eq i8* %108, null, !dbg !433
  br i1 %109, label %110, label %112, !dbg !435

110:                                              ; preds = %100
  %111 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* getelementptr inbounds ([37 x i8], [37 x i8]* @app_event_processor.____fmt.2, i64 0, i64 0), i32 37) #3, !dbg !436
  call void @llvm.lifetime.end.p0i8(i64 28, i8* nonnull %79) #3, !dbg !439
  br label %208

112:                                              ; preds = %100
  %113 = load i32, i32* %81, align 4, !dbg !440, !tbaa !418
  %114 = getelementptr inbounds i8, i8* %108, i64 4, !dbg !440
  %115 = bitcast i8* %114 to i32*, !dbg !440
  %116 = load i32, i32* %115, align 4, !dbg !440, !tbaa !429
  %117 = getelementptr inbounds i8, i8* %108, i64 16, !dbg !440
  %118 = bitcast i8* %117 to i32*, !dbg !440
  %119 = load i32, i32* %118, align 4, !dbg !440, !tbaa !415
  %120 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* getelementptr inbounds ([66 x i8], [66 x i8]* @app_event_processor.____fmt.3, i64 0, i64 0), i32 66, i32 %113, i32 %116, i32 %119) #3, !dbg !440
  call void @llvm.lifetime.end.p0i8(i64 28, i8* nonnull %79) #3, !dbg !439
  %121 = add nuw nsw i32 %88, 1, !dbg !442
  call void @llvm.dbg.value(metadata i8* %108, metadata !123, metadata !DIExpression()) #3, !dbg !394
  call void @llvm.dbg.value(metadata i32 %121, metadata !124, metadata !DIExpression()) #3, !dbg !399
  %122 = icmp eq i32 %121, 5, !dbg !443
  br i1 %122, label %208, label %86, !dbg !401, !llvm.loop !444

123:                                              ; preds = %54
  %124 = tail call i32 @llvm.bswap.i32(i32 %63), !dbg !367
  call void @llvm.dbg.value(metadata i32 %124, metadata !285, metadata !DIExpression()), !dbg !295
  call void @llvm.dbg.value(metadata i8 2, metadata !286, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 8)), !dbg !295
  call void @llvm.dbg.value(metadata i8* undef, metadata !286, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !295
  call void @llvm.dbg.value(metadata i32 undef, metadata !287, metadata !DIExpression()), !dbg !295
  call void @llvm.dbg.value(metadata i16 undef, metadata !287, metadata !DIExpression()), !dbg !295
  call void @llvm.dbg.value(metadata i32 undef, metadata !287, metadata !DIExpression()), !dbg !295
  call void @llvm.dbg.value(metadata i16 undef, metadata !287, metadata !DIExpression()), !dbg !295
  call void @llvm.dbg.value(metadata i32 undef, metadata !287, metadata !DIExpression()), !dbg !295
  call void @llvm.dbg.value(metadata i8* undef, metadata !286, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !295
  call void @llvm.dbg.value(metadata i8 2, metadata !286, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 8)), !dbg !295
  call void @llvm.dbg.value(metadata %struct.event* undef, metadata !94, metadata !DIExpression()) #3, !dbg !392
  call void @llvm.dbg.value(metadata %struct.net_event* undef, metadata !105, metadata !DIExpression()) #3, !dbg !446
  call void @llvm.dbg.value(metadata %struct.net_event* undef, metadata !166, metadata !DIExpression()) #3, !dbg !447
  %125 = bitcast %struct.flow_id* %2 to i8*, !dbg !448
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %125) #3, !dbg !448
  call void @llvm.memset.p0i8.i64(i8* nonnull align 4 dereferenceable(16) %125, i8 0, i64 16, i1 false) #3, !dbg !449
  %126 = getelementptr inbounds %struct.flow_id, %struct.flow_id* %2, i64 0, i32 0, !dbg !450
  store i32 %38, i32* %126, align 4, !dbg !451, !tbaa !452
  %127 = getelementptr inbounds %struct.flow_id, %struct.flow_id* %2, i64 0, i32 1, !dbg !453
  store i16 %60, i16* %127, align 4, !dbg !454, !tbaa !455
  %128 = getelementptr inbounds %struct.flow_id, %struct.flow_id* %2, i64 0, i32 2, !dbg !456
  store i32 67116554, i32* %128, align 4, !dbg !457, !tbaa !458
  %129 = getelementptr inbounds %struct.flow_id, %struct.flow_id* %2, i64 0, i32 3, !dbg !459
  store i16 %57, i16* %129, align 4, !dbg !460, !tbaa !461
  call void @llvm.dbg.value(metadata %struct.tcp_md* null, metadata !168, metadata !DIExpression()) #3, !dbg !447
  %130 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.anon* @tcp_connections to i8*), i8* nonnull %125) #3, !dbg !462
  call void @llvm.dbg.value(metadata i8* %130, metadata !168, metadata !DIExpression()) #3, !dbg !447
  %131 = icmp eq i8* %130, null, !dbg !463
  br i1 %131, label %132, label %134, !dbg !465

132:                                              ; preds = %123
  %133 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* getelementptr inbounds ([38 x i8], [38 x i8]* @net_event_processor.____fmt, i64 0, i64 0), i32 38) #3, !dbg !466
  br label %207, !dbg !469

134:                                              ; preds = %123
  %135 = getelementptr inbounds i8, i8* %130, i64 12, !dbg !470
  %136 = bitcast i8* %135 to i32*, !dbg !470
  %137 = load i32, i32* %136, align 4, !dbg !470, !tbaa !471
  call void @llvm.dbg.value(metadata i32 %137, metadata !169, metadata !DIExpression()) #3, !dbg !447
  %138 = icmp ult i32 %137, %124, !dbg !472
  br i1 %138, label %139, label %146, !dbg !474

139:                                              ; preds = %134
  %140 = getelementptr inbounds i8, i8* %130, i64 4, !dbg !475
  %141 = bitcast i8* %140 to i32*, !dbg !475
  %142 = load i32, i32* %141, align 4, !dbg !475, !tbaa !429
  %143 = sub i32 %137, %124, !dbg !477
  %144 = add i32 %143, %142, !dbg !477
  store i32 %144, i32* %141, align 4, !dbg !478, !tbaa !429
  store i32 %124, i32* %136, align 4, !dbg !479, !tbaa !471
  %145 = call i64 inttoptr (i64 2 to i64 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.anon* @tcp_connections to i8*), i8* nonnull %125, i8* nonnull %130, i64 0) #3, !dbg !480
  br label %146, !dbg !481

146:                                              ; preds = %139, %134
  %147 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.anon* @tcp_connections to i8*), i8* nonnull %125) #3, !dbg !482
  call void @llvm.dbg.value(metadata i8* %147, metadata !168, metadata !DIExpression()) #3, !dbg !447
  %148 = icmp eq i8* %147, null, !dbg !483
  br i1 %148, label %149, label %151, !dbg !485

149:                                              ; preds = %146
  %150 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* getelementptr inbounds ([38 x i8], [38 x i8]* @net_event_processor.____fmt.4, i64 0, i64 0), i32 38) #3, !dbg !486
  br label %207, !dbg !489

151:                                              ; preds = %146
  %152 = getelementptr inbounds i8, i8* %147, i64 4, !dbg !490
  %153 = bitcast i8* %152 to i32*, !dbg !490
  %154 = load i32, i32* %153, align 4, !dbg !490, !tbaa !429
  %155 = getelementptr inbounds i8, i8* %147, i64 12, !dbg !490
  %156 = bitcast i8* %155 to i32*, !dbg !490
  %157 = load i32, i32* %156, align 4, !dbg !490, !tbaa !471
  %158 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* getelementptr inbounds ([49 x i8], [49 x i8]* @net_event_processor.____fmt.5, i64 0, i64 0), i32 49, i32 %124, i32 %154, i32 %157) #3, !dbg !490
  %159 = icmp slt i32 %137, 100, !dbg !492
  %160 = select i1 %159, i32 %137, i32 100, !dbg !492
  call void @llvm.dbg.value(metadata i32 %160, metadata !169, metadata !DIExpression()) #3, !dbg !447
  call void @llvm.dbg.value(metadata i32 %124, metadata !170, metadata !DIExpression()) #3, !dbg !447
  %161 = icmp slt i32 %124, 100, !dbg !493
  %162 = select i1 %161, i32 %124, i32 100, !dbg !493
  call void @llvm.dbg.value(metadata i32 %162, metadata !170, metadata !DIExpression()) #3, !dbg !447
  call void @llvm.dbg.value(metadata i32 undef, metadata !171, metadata !DIExpression()) #3, !dbg !447
  call void @llvm.dbg.value(metadata i32 %160, metadata !172, metadata !DIExpression()) #3, !dbg !494
  call void @llvm.dbg.value(metadata i8* %147, metadata !168, metadata !DIExpression()) #3, !dbg !447
  %163 = icmp slt i32 %160, %162, !dbg !495
  br i1 %163, label %164, label %207, !dbg !496

164:                                              ; preds = %151
  %165 = bitcast %struct.packet_event* %3 to i8*, !dbg !497
  %166 = getelementptr inbounds %struct.packet_event, %struct.packet_event* %3, i64 0, i32 3, !dbg !497
  %167 = getelementptr inbounds %struct.packet_event, %struct.packet_event* %3, i64 0, i32 1, !dbg !497
  %168 = bitcast i32* %167 to i8*, !dbg !497
  %169 = getelementptr inbounds i32, i32* %167, i64 1, !dbg !497
  br label %170, !dbg !496

170:                                              ; preds = %196, %164
  %171 = phi i8* [ %147, %164 ], [ %192, %196 ]
  %172 = phi i32 [ %160, %164 ], [ %205, %196 ]
  call void @llvm.dbg.value(metadata i8* %171, metadata !168, metadata !DIExpression()) #3, !dbg !447
  call void @llvm.dbg.value(metadata i32 %172, metadata !172, metadata !DIExpression()) #3, !dbg !494
  call void @llvm.lifetime.start.p0i8(i64 28, i8* nonnull %165) #3, !dbg !498
  store i32 0, i32* %169, align 4, !dbg !499
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 dereferenceable(16) %165, i8* nonnull align 4 dereferenceable(16) %125, i64 16, i1 false) #3, !dbg !499, !tbaa.struct !378
  %173 = bitcast i8* %171 to i32*, !dbg !500
  %174 = load i32, i32* %173, align 4, !dbg !500, !tbaa !409
  store i32 %174, i32* %166, align 4, !dbg !501, !tbaa !412
  %175 = getelementptr inbounds i8, i8* %171, i64 16, !dbg !502
  %176 = bitcast i8* %175 to i32*, !dbg !502
  %177 = load i32, i32* %176, align 4, !dbg !502, !tbaa !415
  %178 = add i32 %177, 1, !dbg !503
  store i32 %178, i32* %167, align 4, !dbg !504, !tbaa !418
  %179 = call i64 inttoptr (i64 2 to i64 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.anon.0* @packet_events to i8*), i8* nonnull %168, i8* nonnull %165, i64 0) #3, !dbg !505
  %180 = trunc i64 %179 to i32, !dbg !505
  call void @llvm.dbg.value(metadata i32 %180, metadata !177, metadata !DIExpression()) #3, !dbg !497
  %181 = icmp slt i32 %180, 0, !dbg !506
  br i1 %181, label %182, label %184, !dbg !508

182:                                              ; preds = %170
  %183 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* getelementptr inbounds ([38 x i8], [38 x i8]* @net_event_processor.____fmt.6, i64 0, i64 0), i32 38, i32 0) #3, !dbg !509
  br label %184, !dbg !512

184:                                              ; preds = %182, %170
  %185 = getelementptr inbounds i8, i8* %171, i64 4, !dbg !513
  %186 = bitcast i8* %185 to i32*, !dbg !513
  %187 = load i32, i32* %186, align 4, !dbg !514, !tbaa !429
  %188 = add i32 %187, 1, !dbg !514
  store i32 %188, i32* %186, align 4, !dbg !514, !tbaa !429
  %189 = load i32, i32* %176, align 4, !dbg !515, !tbaa !415
  %190 = add i32 %189, 1, !dbg !515
  store i32 %190, i32* %176, align 4, !dbg !515, !tbaa !415
  %191 = call i64 inttoptr (i64 2 to i64 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.anon* @tcp_connections to i8*), i8* nonnull %125, i8* nonnull %171, i64 0) #3, !dbg !516
  %192 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.anon* @tcp_connections to i8*), i8* nonnull %125) #3, !dbg !517
  call void @llvm.dbg.value(metadata i8* %192, metadata !168, metadata !DIExpression()) #3, !dbg !447
  %193 = icmp eq i8* %192, null, !dbg !518
  br i1 %193, label %194, label %196, !dbg !520

194:                                              ; preds = %184
  %195 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* getelementptr inbounds ([37 x i8], [37 x i8]* @net_event_processor.____fmt.7, i64 0, i64 0), i32 37) #3, !dbg !521
  call void @llvm.lifetime.end.p0i8(i64 28, i8* nonnull %165) #3, !dbg !524
  br label %207

196:                                              ; preds = %184
  %197 = load i32, i32* %167, align 4, !dbg !525, !tbaa !418
  %198 = getelementptr inbounds i8, i8* %192, i64 4, !dbg !525
  %199 = bitcast i8* %198 to i32*, !dbg !525
  %200 = load i32, i32* %199, align 4, !dbg !525, !tbaa !429
  %201 = getelementptr inbounds i8, i8* %192, i64 12, !dbg !525
  %202 = bitcast i8* %201 to i32*, !dbg !525
  %203 = load i32, i32* %202, align 4, !dbg !525, !tbaa !471
  %204 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* getelementptr inbounds ([62 x i8], [62 x i8]* @net_event_processor.____fmt.8, i64 0, i64 0), i32 62, i32 %197, i32 %200, i32 %203) #3, !dbg !525
  call void @llvm.lifetime.end.p0i8(i64 28, i8* nonnull %165) #3, !dbg !524
  %205 = add nsw i32 %172, 1, !dbg !527
  call void @llvm.dbg.value(metadata i8* %192, metadata !168, metadata !DIExpression()) #3, !dbg !447
  call void @llvm.dbg.value(metadata i32 %205, metadata !172, metadata !DIExpression()) #3, !dbg !494
  %206 = icmp slt i32 %205, %162, !dbg !495
  br i1 %206, label %170, label %207, !dbg !496, !llvm.loop !528

207:                                              ; preds = %196, %194, %151, %149, %132
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %125) #3, !dbg !530
  br label %208

208:                                              ; preds = %112, %207, %110, %84, %54
  call void @llvm.lifetime.end.p0i8(i64 40, i8* nonnull %64) #3, !dbg !531
  br label %209

209:                                              ; preds = %208, %32, %43, %50, %28, %23, %1
  %210 = phi i32 [ -1, %1 ], [ -1, %23 ], [ -1, %28 ], [ 1, %208 ], [ -1, %32 ], [ -1, %43 ], [ -1, %50 ], !dbg !295
  ret i32 %210, !dbg !531
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nounwind readnone speculatable willreturn
declare i32 @llvm.bswap.i32(i32) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #2

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #2

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly nounwind willreturn }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!203, !204, !205}
!llvm.ident = !{!206}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 279, type: !200, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 10.0.0-4ubuntu1 ", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !19, globals: !24, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "xdp_prog_kern.c", directory: "/home/a68lin/XDP-Tryouts/xdp/event-processors")
!4 = !{!5, !11}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "event_type", file: !3, line: 16, baseType: !6, size: 32, elements: !7)
!6 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!7 = !{!8, !9, !10}
!8 = !DIEnumerator(name: "APP_EVENT", value: 0, isUnsigned: true)
!9 = !DIEnumerator(name: "PACKET_EVENT", value: 1, isUnsigned: true)
!10 = !DIEnumerator(name: "NET_EVENT", value: 2, isUnsigned: true)
!11 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !12, line: 3150, baseType: !6, size: 32, elements: !13)
!12 = !DIFile(filename: "/usr/include/linux/bpf.h", directory: "")
!13 = !{!14, !15, !16, !17, !18}
!14 = !DIEnumerator(name: "XDP_ABORTED", value: 0, isUnsigned: true)
!15 = !DIEnumerator(name: "XDP_DROP", value: 1, isUnsigned: true)
!16 = !DIEnumerator(name: "XDP_PASS", value: 2, isUnsigned: true)
!17 = !DIEnumerator(name: "XDP_TX", value: 3, isUnsigned: true)
!18 = !DIEnumerator(name: "XDP_REDIRECT", value: 4, isUnsigned: true)
!19 = !{!20, !21, !22}
!20 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!21 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!22 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !23, line: 27, baseType: !6)
!23 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "")
!24 = !{!0, !25, !60, !81, !116, !133, !135, !140, !145, !153, !160, !178, !180, !185, !187, !189, !194}
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(name: "tcp_connections", scope: !2, file: !3, line: 52, type: !27, isLocal: false, isDefinition: true)
!27 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 46, size: 256, elements: !28)
!28 = !{!29, !35, !40, !51}
!29 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !27, file: !3, line: 48, baseType: !30, size: 64)
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 32, elements: !33)
!32 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!33 = !{!34}
!34 = !DISubrange(count: 1)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !27, file: !3, line: 49, baseType: !36, size: 64, offset: 64)
!36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!37 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 1024, elements: !38)
!38 = !{!39}
!39 = !DISubrange(count: 32)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !27, file: !3, line: 50, baseType: !41, size: 64, offset: 128)
!41 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!42 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "flow_id", file: !43, line: 3, size: 128, elements: !44)
!43 = !DIFile(filename: "./common.h", directory: "/home/a68lin/XDP-Tryouts/xdp/event-processors")
!44 = !{!45, !46, !49, !50}
!45 = !DIDerivedType(tag: DW_TAG_member, name: "sender_ip", scope: !42, file: !43, line: 4, baseType: !22, size: 32)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "sender_port", scope: !42, file: !43, line: 5, baseType: !47, size: 16, offset: 32)
!47 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !23, line: 24, baseType: !48)
!48 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "receiver_ip", scope: !42, file: !43, line: 6, baseType: !22, size: 32, offset: 64)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "receiver_port", scope: !42, file: !43, line: 7, baseType: !47, size: 16, offset: 96)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !27, file: !3, line: 51, baseType: !52, size: 64, offset: 192)
!52 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !53, size: 64)
!53 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "tcp_md", file: !43, line: 10, size: 160, elements: !54)
!54 = !{!55, !56, !57, !58, !59}
!55 = !DIDerivedType(tag: DW_TAG_member, name: "segment_size", scope: !53, file: !43, line: 11, baseType: !22, size: 32)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "current_size", scope: !53, file: !43, line: 12, baseType: !22, size: 32, offset: 32)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "initial_seq", scope: !53, file: !43, line: 13, baseType: !22, size: 32, offset: 64)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "window_start_seq", scope: !53, file: !43, line: 14, baseType: !22, size: 32, offset: 96)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "last_seq_sent", scope: !53, file: !43, line: 15, baseType: !22, size: 32, offset: 128)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(name: "packet_events", scope: !2, file: !3, line: 60, type: !62, isLocal: false, isDefinition: true)
!62 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 54, size: 256, elements: !63)
!63 = !{!64, !69, !70, !72}
!64 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !62, file: !3, line: 56, baseType: !65, size: 64)
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66, size: 64)
!66 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 64, elements: !67)
!67 = !{!68}
!68 = !DISubrange(count: 2)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !62, file: !3, line: 57, baseType: !36, size: 64, offset: 64)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !62, file: !3, line: 58, baseType: !71, size: 64, offset: 128)
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 64)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !62, file: !3, line: 59, baseType: !73, size: 64, offset: 192)
!73 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !74, size: 64)
!74 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "packet_event", file: !3, line: 34, size: 224, elements: !75)
!75 = !{!76, !77, !78, !80}
!76 = !DIDerivedType(tag: DW_TAG_member, name: "fid", scope: !74, file: !3, line: 35, baseType: !42, size: 128)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "seq_num", scope: !74, file: !3, line: 36, baseType: !32, size: 32, offset: 128)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !74, file: !3, line: 37, baseType: !79, size: 8, offset: 160)
!79 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "size", scope: !74, file: !3, line: 38, baseType: !22, size: 32, offset: 192)
!81 = !DIGlobalVariableExpression(var: !82, expr: !DIExpression())
!82 = distinct !DIGlobalVariable(name: "____fmt", scope: !83, file: !3, line: 186, type: !112, isLocal: true, isDefinition: true)
!83 = distinct !DISubprogram(name: "dispatcher", scope: !3, file: !3, line: 173, type: !84, scopeLine: 173, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !93)
!84 = !DISubroutineType(types: !85)
!85 = !{null, !86}
!86 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !87, size: 64)
!87 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "event", file: !3, line: 41, size: 128, elements: !88)
!88 = !{!89, !92}
!89 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !87, file: !3, line: 42, baseType: !90, size: 8)
!90 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !23, line: 21, baseType: !91)
!91 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "event_data", scope: !87, file: !3, line: 43, baseType: !20, size: 64, offset: 64)
!93 = !{!94, !95, !105}
!94 = !DILocalVariable(name: "event", arg: 1, scope: !83, file: !3, line: 173, type: !86)
!95 = !DILocalVariable(name: "ae", scope: !96, file: !3, line: 176, type: !98)
!96 = distinct !DILexicalBlock(scope: !97, file: !3, line: 175, column: 25)
!97 = distinct !DILexicalBlock(scope: !83, file: !3, line: 174, column: 26)
!98 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !99, size: 64)
!99 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "app_event", file: !3, line: 22, size: 320, elements: !100)
!100 = !{!101, !102, !103, !104}
!101 = !DIDerivedType(tag: DW_TAG_member, name: "fid", scope: !99, file: !3, line: 23, baseType: !42, size: 128)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !99, file: !3, line: 24, baseType: !20, size: 64, offset: 128)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !99, file: !3, line: 25, baseType: !20, size: 64, offset: 192)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "size", scope: !99, file: !3, line: 26, baseType: !22, size: 32, offset: 256)
!105 = !DILocalVariable(name: "ne", scope: !106, file: !3, line: 181, type: !107)
!106 = distinct !DILexicalBlock(scope: !97, file: !3, line: 180, column: 25)
!107 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !108, size: 64)
!108 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "net_event", file: !3, line: 29, size: 160, elements: !109)
!109 = !{!110, !111}
!110 = !DIDerivedType(tag: DW_TAG_member, name: "fid", scope: !108, file: !3, line: 30, baseType: !42, size: 128)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "ack", scope: !108, file: !3, line: 31, baseType: !22, size: 32, offset: 128)
!112 = !DICompositeType(tag: DW_TAG_array_type, baseType: !113, size: 192, elements: !114)
!113 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !79)
!114 = !{!115}
!115 = !DISubrange(count: 24)
!116 = !DIGlobalVariableExpression(var: !117, expr: !DIExpression())
!117 = distinct !DIGlobalVariable(name: "____fmt", scope: !118, file: !3, line: 79, type: !130, isLocal: true, isDefinition: true)
!118 = distinct !DISubprogram(name: "app_event_processor", scope: !3, file: !3, line: 75, type: !119, scopeLine: 75, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !121)
!119 = !DISubroutineType(types: !120)
!120 = !{null, !98}
!121 = !{!122, !123, !124, !126, !129}
!122 = !DILocalVariable(name: "ae", arg: 1, scope: !118, file: !3, line: 75, type: !98)
!123 = !DILocalVariable(name: "tcp_ctx", scope: !118, file: !3, line: 77, type: !52)
!124 = !DILocalVariable(name: "i", scope: !125, file: !3, line: 88, type: !32)
!125 = distinct !DILexicalBlock(scope: !118, file: !3, line: 88, column: 5)
!126 = !DILocalVariable(name: "pe", scope: !127, file: !3, line: 89, type: !74)
!127 = distinct !DILexicalBlock(scope: !128, file: !3, line: 88, column: 43)
!128 = distinct !DILexicalBlock(scope: !125, file: !3, line: 88, column: 5)
!129 = !DILocalVariable(name: "ret", scope: !127, file: !3, line: 94, type: !32)
!130 = !DICompositeType(tag: DW_TAG_array_type, baseType: !113, size: 304, elements: !131)
!131 = !{!132}
!132 = !DISubrange(count: 38)
!133 = !DIGlobalVariableExpression(var: !134, expr: !DIExpression())
!134 = distinct !DIGlobalVariable(name: "____fmt", scope: !118, file: !3, line: 96, type: !130, isLocal: true, isDefinition: true)
!135 = !DIGlobalVariableExpression(var: !136, expr: !DIExpression())
!136 = distinct !DIGlobalVariable(name: "____fmt", scope: !118, file: !3, line: 104, type: !137, isLocal: true, isDefinition: true)
!137 = !DICompositeType(tag: DW_TAG_array_type, baseType: !113, size: 296, elements: !138)
!138 = !{!139}
!139 = !DISubrange(count: 37)
!140 = !DIGlobalVariableExpression(var: !141, expr: !DIExpression())
!141 = distinct !DIGlobalVariable(name: "____fmt", scope: !118, file: !3, line: 107, type: !142, isLocal: true, isDefinition: true)
!142 = !DICompositeType(tag: DW_TAG_array_type, baseType: !113, size: 528, elements: !143)
!143 = !{!144}
!144 = !DISubrange(count: 66)
!145 = !DIGlobalVariableExpression(var: !146, expr: !DIExpression())
!146 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !147, line: 56, type: !148, isLocal: true, isDefinition: true)
!147 = !DIFile(filename: "../lib/install/include/bpf/bpf_helper_defs.h", directory: "/home/a68lin/XDP-Tryouts/xdp/event-processors")
!148 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !149, size: 64)
!149 = !DISubroutineType(types: !150)
!150 = !{!20, !20, !151}
!151 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !152, size: 64)
!152 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!153 = !DIGlobalVariableExpression(var: !154, expr: !DIExpression())
!154 = distinct !DIGlobalVariable(name: "bpf_map_update_elem", scope: !2, file: !147, line: 78, type: !155, isLocal: true, isDefinition: true)
!155 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !156, size: 64)
!156 = !DISubroutineType(types: !157)
!157 = !{!21, !20, !151, !151, !158}
!158 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !23, line: 31, baseType: !159)
!159 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!160 = !DIGlobalVariableExpression(var: !161, expr: !DIExpression())
!161 = distinct !DIGlobalVariable(name: "____fmt", scope: !162, file: !3, line: 123, type: !130, isLocal: true, isDefinition: true)
!162 = distinct !DISubprogram(name: "net_event_processor", scope: !3, file: !3, line: 111, type: !163, scopeLine: 111, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !165)
!163 = !DISubroutineType(types: !164)
!164 = !{null, !107}
!165 = !{!166, !167, !168, !169, !170, !171, !172, !174, !177}
!166 = !DILocalVariable(name: "ne", arg: 1, scope: !162, file: !3, line: 111, type: !107)
!167 = !DILocalVariable(name: "fid", scope: !162, file: !3, line: 113, type: !42)
!168 = !DILocalVariable(name: "tcp_ctx", scope: !162, file: !3, line: 119, type: !52)
!169 = !DILocalVariable(name: "current_start", scope: !162, file: !3, line: 126, type: !32)
!170 = !DILocalVariable(name: "ack", scope: !162, file: !3, line: 143, type: !32)
!171 = !DILocalVariable(name: "num_to_send", scope: !162, file: !3, line: 147, type: !32)
!172 = !DILocalVariable(name: "i", scope: !173, file: !3, line: 151, type: !32)
!173 = distinct !DILexicalBlock(scope: !162, file: !3, line: 151, column: 5)
!174 = !DILocalVariable(name: "pe", scope: !175, file: !3, line: 152, type: !74)
!175 = distinct !DILexicalBlock(scope: !176, file: !3, line: 151, column: 46)
!176 = distinct !DILexicalBlock(scope: !173, file: !3, line: 151, column: 5)
!177 = !DILocalVariable(name: "ret", scope: !175, file: !3, line: 157, type: !32)
!178 = !DIGlobalVariableExpression(var: !179, expr: !DIExpression())
!179 = distinct !DIGlobalVariable(name: "____fmt", scope: !162, file: !3, line: 134, type: !130, isLocal: true, isDefinition: true)
!180 = !DIGlobalVariableExpression(var: !181, expr: !DIExpression())
!181 = distinct !DIGlobalVariable(name: "____fmt", scope: !162, file: !3, line: 137, type: !182, isLocal: true, isDefinition: true)
!182 = !DICompositeType(tag: DW_TAG_array_type, baseType: !113, size: 392, elements: !183)
!183 = !{!184}
!184 = !DISubrange(count: 49)
!185 = !DIGlobalVariableExpression(var: !186, expr: !DIExpression())
!186 = distinct !DIGlobalVariable(name: "____fmt", scope: !162, file: !3, line: 159, type: !130, isLocal: true, isDefinition: true)
!187 = !DIGlobalVariableExpression(var: !188, expr: !DIExpression())
!188 = distinct !DIGlobalVariable(name: "____fmt", scope: !162, file: !3, line: 166, type: !137, isLocal: true, isDefinition: true)
!189 = !DIGlobalVariableExpression(var: !190, expr: !DIExpression())
!190 = distinct !DIGlobalVariable(name: "____fmt", scope: !162, file: !3, line: 169, type: !191, isLocal: true, isDefinition: true)
!191 = !DICompositeType(tag: DW_TAG_array_type, baseType: !113, size: 496, elements: !192)
!192 = !{!193}
!193 = !DISubrange(count: 62)
!194 = !DIGlobalVariableExpression(var: !195, expr: !DIExpression())
!195 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !147, line: 177, type: !196, isLocal: true, isDefinition: true)
!196 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !197, size: 64)
!197 = !DISubroutineType(types: !198)
!198 = !{!21, !199, !22, null}
!199 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !113, size: 64)
!200 = !DICompositeType(tag: DW_TAG_array_type, baseType: !79, size: 32, elements: !201)
!201 = !{!202}
!202 = !DISubrange(count: 4)
!203 = !{i32 7, !"Dwarf Version", i32 4}
!204 = !{i32 2, !"Debug Info Version", i32 3}
!205 = !{i32 1, !"wchar_size", i32 4}
!206 = !{!"clang version 10.0.0-4ubuntu1 "}
!207 = distinct !DISubprogram(name: "simply_drop", scope: !3, file: !3, line: 194, type: !208, scopeLine: 195, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !218)
!208 = !DISubroutineType(types: !209)
!209 = !{!32, !210}
!210 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !211, size: 64)
!211 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !12, line: 3161, size: 160, elements: !212)
!212 = !{!213, !214, !215, !216, !217}
!213 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !211, file: !12, line: 3162, baseType: !22, size: 32)
!214 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !211, file: !12, line: 3163, baseType: !22, size: 32, offset: 32)
!215 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !211, file: !12, line: 3164, baseType: !22, size: 32, offset: 64)
!216 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !211, file: !12, line: 3166, baseType: !22, size: 32, offset: 96)
!217 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !211, file: !12, line: 3167, baseType: !22, size: 32, offset: 128)
!218 = !{!219, !220, !221, !222, !235, !253, !275, !280, !281, !282, !283, !284, !285, !286, !287, !288}
!219 = !DILocalVariable(name: "ctx", arg: 1, scope: !207, file: !3, line: 194, type: !210)
!220 = !DILocalVariable(name: "data_end", scope: !207, file: !3, line: 198, type: !20)
!221 = !DILocalVariable(name: "data", scope: !207, file: !3, line: 199, type: !20)
!222 = !DILocalVariable(name: "eth", scope: !207, file: !3, line: 202, type: !223)
!223 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !224, size: 64)
!224 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !225, line: 163, size: 112, elements: !226)
!225 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "")
!226 = !{!227, !231, !232}
!227 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !224, file: !225, line: 164, baseType: !228, size: 48)
!228 = !DICompositeType(tag: DW_TAG_array_type, baseType: !91, size: 48, elements: !229)
!229 = !{!230}
!230 = !DISubrange(count: 6)
!231 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !224, file: !225, line: 165, baseType: !228, size: 48, offset: 48)
!232 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !224, file: !225, line: 166, baseType: !233, size: 16, offset: 96)
!233 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !234, line: 25, baseType: !47)
!234 = !DIFile(filename: "/usr/include/linux/types.h", directory: "")
!235 = !DILocalVariable(name: "iphdr", scope: !207, file: !3, line: 203, type: !236)
!236 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !237, size: 64)
!237 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !238, line: 86, size: 160, elements: !239)
!238 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "")
!239 = !{!240, !241, !242, !243, !244, !245, !246, !247, !248, !250, !252}
!240 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !237, file: !238, line: 88, baseType: !90, size: 4, flags: DIFlagBitField, extraData: i64 0)
!241 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !237, file: !238, line: 89, baseType: !90, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!242 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !237, file: !238, line: 96, baseType: !90, size: 8, offset: 8)
!243 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !237, file: !238, line: 97, baseType: !233, size: 16, offset: 16)
!244 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !237, file: !238, line: 98, baseType: !233, size: 16, offset: 32)
!245 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !237, file: !238, line: 99, baseType: !233, size: 16, offset: 48)
!246 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !237, file: !238, line: 100, baseType: !90, size: 8, offset: 64)
!247 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !237, file: !238, line: 101, baseType: !90, size: 8, offset: 72)
!248 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !237, file: !238, line: 102, baseType: !249, size: 16, offset: 80)
!249 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !234, line: 31, baseType: !47)
!250 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !237, file: !238, line: 103, baseType: !251, size: 32, offset: 96)
!251 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !234, line: 27, baseType: !22)
!252 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !237, file: !238, line: 104, baseType: !251, size: 32, offset: 128)
!253 = !DILocalVariable(name: "tcphdr", scope: !207, file: !3, line: 204, type: !254)
!254 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !255, size: 64)
!255 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "tcphdr", file: !256, line: 25, size: 160, elements: !257)
!256 = !DIFile(filename: "/usr/include/linux/tcp.h", directory: "")
!257 = !{!258, !259, !260, !261, !262, !263, !264, !265, !266, !267, !268, !269, !270, !271, !272, !273, !274}
!258 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !255, file: !256, line: 26, baseType: !233, size: 16)
!259 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !255, file: !256, line: 27, baseType: !233, size: 16, offset: 16)
!260 = !DIDerivedType(tag: DW_TAG_member, name: "seq", scope: !255, file: !256, line: 28, baseType: !251, size: 32, offset: 32)
!261 = !DIDerivedType(tag: DW_TAG_member, name: "ack_seq", scope: !255, file: !256, line: 29, baseType: !251, size: 32, offset: 64)
!262 = !DIDerivedType(tag: DW_TAG_member, name: "res1", scope: !255, file: !256, line: 31, baseType: !47, size: 4, offset: 96, flags: DIFlagBitField, extraData: i64 96)
!263 = !DIDerivedType(tag: DW_TAG_member, name: "doff", scope: !255, file: !256, line: 32, baseType: !47, size: 4, offset: 100, flags: DIFlagBitField, extraData: i64 96)
!264 = !DIDerivedType(tag: DW_TAG_member, name: "fin", scope: !255, file: !256, line: 33, baseType: !47, size: 1, offset: 104, flags: DIFlagBitField, extraData: i64 96)
!265 = !DIDerivedType(tag: DW_TAG_member, name: "syn", scope: !255, file: !256, line: 34, baseType: !47, size: 1, offset: 105, flags: DIFlagBitField, extraData: i64 96)
!266 = !DIDerivedType(tag: DW_TAG_member, name: "rst", scope: !255, file: !256, line: 35, baseType: !47, size: 1, offset: 106, flags: DIFlagBitField, extraData: i64 96)
!267 = !DIDerivedType(tag: DW_TAG_member, name: "psh", scope: !255, file: !256, line: 36, baseType: !47, size: 1, offset: 107, flags: DIFlagBitField, extraData: i64 96)
!268 = !DIDerivedType(tag: DW_TAG_member, name: "ack", scope: !255, file: !256, line: 37, baseType: !47, size: 1, offset: 108, flags: DIFlagBitField, extraData: i64 96)
!269 = !DIDerivedType(tag: DW_TAG_member, name: "urg", scope: !255, file: !256, line: 38, baseType: !47, size: 1, offset: 109, flags: DIFlagBitField, extraData: i64 96)
!270 = !DIDerivedType(tag: DW_TAG_member, name: "ece", scope: !255, file: !256, line: 39, baseType: !47, size: 1, offset: 110, flags: DIFlagBitField, extraData: i64 96)
!271 = !DIDerivedType(tag: DW_TAG_member, name: "cwr", scope: !255, file: !256, line: 40, baseType: !47, size: 1, offset: 111, flags: DIFlagBitField, extraData: i64 96)
!272 = !DIDerivedType(tag: DW_TAG_member, name: "window", scope: !255, file: !256, line: 55, baseType: !233, size: 16, offset: 112)
!273 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !255, file: !256, line: 56, baseType: !249, size: 16, offset: 128)
!274 = !DIDerivedType(tag: DW_TAG_member, name: "urg_ptr", scope: !255, file: !256, line: 57, baseType: !233, size: 16, offset: 144)
!275 = !DILocalVariable(name: "nh", scope: !207, file: !3, line: 205, type: !276)
!276 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "hdr_cursor", file: !277, line: 33, size: 64, elements: !278)
!277 = !DIFile(filename: "./../common/parsing_helpers.h", directory: "/home/a68lin/XDP-Tryouts/xdp/event-processors")
!278 = !{!279}
!279 = !DIDerivedType(tag: DW_TAG_member, name: "pos", scope: !276, file: !277, line: 34, baseType: !20, size: 64)
!280 = !DILocalVariable(name: "fid", scope: !207, file: !3, line: 208, type: !42)
!281 = !DILocalVariable(name: "iph", scope: !207, file: !3, line: 215, type: !236)
!282 = !DILocalVariable(name: "hdrsize", scope: !207, file: !3, line: 216, type: !32)
!283 = !DILocalVariable(name: "len", scope: !207, file: !3, line: 231, type: !32)
!284 = !DILocalVariable(name: "h", scope: !207, file: !3, line: 232, type: !254)
!285 = !DILocalVariable(name: "ack", scope: !207, file: !3, line: 247, type: !22)
!286 = !DILocalVariable(name: "e", scope: !207, file: !3, line: 251, type: !87)
!287 = !DILocalVariable(name: "ne", scope: !207, file: !3, line: 252, type: !108)
!288 = !DILocalVariable(name: "ae", scope: !207, file: !3, line: 253, type: !99)
!289 = !DILocation(line: 113, column: 20, scope: !162, inlinedAt: !290)
!290 = distinct !DILocation(line: 182, column: 13, scope: !106, inlinedAt: !291)
!291 = distinct !DILocation(line: 275, column: 5, scope: !207)
!292 = !DILocation(line: 152, column: 29, scope: !175, inlinedAt: !290)
!293 = !DILocation(line: 89, column: 29, scope: !127, inlinedAt: !294)
!294 = distinct !DILocation(line: 177, column: 13, scope: !96, inlinedAt: !291)
!295 = !DILocation(line: 0, scope: !207)
!296 = !DILocation(line: 198, column: 41, scope: !207)
!297 = !{!298, !299, i64 4}
!298 = !{!"xdp_md", !299, i64 0, !299, i64 4, !299, i64 8, !299, i64 12, !299, i64 16}
!299 = !{!"int", !300, i64 0}
!300 = !{!"omnipotent char", !301, i64 0}
!301 = !{!"Simple C/C++ TBAA"}
!302 = !DILocation(line: 198, column: 30, scope: !207)
!303 = !DILocation(line: 198, column: 22, scope: !207)
!304 = !DILocation(line: 199, column: 37, scope: !207)
!305 = !{!298, !299, i64 0}
!306 = !DILocation(line: 199, column: 26, scope: !207)
!307 = !DILocation(line: 199, column: 18, scope: !207)
!308 = !DILocalVariable(name: "nh", arg: 1, scope: !309, file: !3, line: 62, type: !312)
!309 = distinct !DISubprogram(name: "parse_ethhdr_new", scope: !3, file: !3, line: 62, type: !310, scopeLine: 65, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !314)
!310 = !DISubroutineType(types: !311)
!311 = !{!32, !312, !20, !313}
!312 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !276, size: 64)
!313 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !223, size: 64)
!314 = !{!308, !315, !316, !317, !318}
!315 = !DILocalVariable(name: "data_end", arg: 2, scope: !309, file: !3, line: 63, type: !20)
!316 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !309, file: !3, line: 64, type: !313)
!317 = !DILocalVariable(name: "eth", scope: !309, file: !3, line: 66, type: !223)
!318 = !DILocalVariable(name: "hdrsize", scope: !309, file: !3, line: 67, type: !32)
!319 = !DILocation(line: 0, scope: !309, inlinedAt: !320)
!320 = distinct !DILocation(line: 211, column: 5, scope: !207)
!321 = !DILocation(line: 68, column: 14, scope: !322, inlinedAt: !320)
!322 = distinct !DILexicalBlock(scope: !309, file: !3, line: 68, column: 6)
!323 = !DILocation(line: 68, column: 24, scope: !322, inlinedAt: !320)
!324 = !DILocation(line: 70, column: 10, scope: !309, inlinedAt: !320)
!325 = !DILocation(line: 68, column: 6, scope: !309, inlinedAt: !320)
!326 = !DILocation(line: 215, column: 28, scope: !207)
!327 = !DILocation(line: 217, column: 10, scope: !328)
!328 = distinct !DILexicalBlock(scope: !207, file: !3, line: 217, column: 6)
!329 = !DILocation(line: 217, column: 16, scope: !328)
!330 = !DILocation(line: 217, column: 14, scope: !328)
!331 = !DILocation(line: 217, column: 6, scope: !207)
!332 = !DILocation(line: 219, column: 17, scope: !207)
!333 = !DILocation(line: 219, column: 21, scope: !207)
!334 = !DILocation(line: 220, column: 13, scope: !335)
!335 = distinct !DILexicalBlock(scope: !207, file: !3, line: 220, column: 5)
!336 = !DILocation(line: 220, column: 5, scope: !207)
!337 = !DILocation(line: 220, column: 5, scope: !335)
!338 = !DILocation(line: 222, column: 13, scope: !339)
!339 = distinct !DILexicalBlock(scope: !207, file: !3, line: 222, column: 6)
!340 = !DILocation(line: 222, column: 23, scope: !339)
!341 = !DILocation(line: 222, column: 6, scope: !207)
!342 = !DILocation(line: 226, column: 28, scope: !207)
!343 = !{!344, !299, i64 12}
!344 = !{!"iphdr", !300, i64 0, !300, i64 0, !300, i64 1, !345, i64 2, !345, i64 4, !345, i64 6, !300, i64 8, !300, i64 9, !345, i64 10, !299, i64 12, !299, i64 16}
!345 = !{!"short", !300, i64 0}
!346 = !DILocation(line: 227, column: 30, scope: !207)
!347 = !{!299, !299, i64 0}
!348 = !DILocation(line: 233, column: 8, scope: !349)
!349 = distinct !DILexicalBlock(scope: !207, file: !3, line: 233, column: 6)
!350 = !DILocation(line: 233, column: 14, scope: !349)
!351 = !DILocation(line: 233, column: 12, scope: !349)
!352 = !DILocation(line: 233, column: 6, scope: !207)
!353 = !DILocation(line: 236, column: 11, scope: !207)
!354 = !DILocation(line: 236, column: 16, scope: !207)
!355 = !DILocation(line: 237, column: 9, scope: !356)
!356 = distinct !DILexicalBlock(scope: !207, file: !3, line: 237, column: 5)
!357 = !DILocation(line: 237, column: 5, scope: !207)
!358 = !DILocation(line: 237, column: 5, scope: !356)
!359 = !DILocation(line: 240, column: 13, scope: !360)
!360 = distinct !DILexicalBlock(scope: !207, file: !3, line: 240, column: 6)
!361 = !DILocation(line: 240, column: 19, scope: !360)
!362 = !DILocation(line: 240, column: 6, scope: !207)
!363 = !DILocation(line: 243, column: 9, scope: !207)
!364 = !DILocation(line: 245, column: 31, scope: !207)
!365 = !{!345, !345, i64 0}
!366 = !DILocation(line: 246, column: 33, scope: !207)
!367 = !DILocation(line: 247, column: 17, scope: !207)
!368 = !{!369, !299, i64 8}
!369 = !{!"tcphdr", !345, i64 0, !345, i64 2, !299, i64 4, !299, i64 8, !345, i64 12, !345, i64 12, !345, i64 13, !345, i64 13, !345, i64 13, !345, i64 13, !345, i64 13, !345, i64 13, !345, i64 13, !345, i64 13, !345, i64 14, !345, i64 16, !345, i64 18}
!370 = !DILocation(line: 253, column: 5, scope: !207)
!371 = !DILocation(line: 253, column: 22, scope: !207)
!372 = !DILocation(line: 256, column: 5, scope: !207)
!373 = !DILocation(line: 257, column: 9, scope: !207)
!374 = !DILocation(line: 267, column: 18, scope: !375)
!375 = distinct !DILexicalBlock(scope: !376, file: !3, line: 264, column: 41)
!376 = distinct !DILexicalBlock(scope: !377, file: !3, line: 264, column: 14)
!377 = distinct !DILexicalBlock(scope: !207, file: !3, line: 257, column: 9)
!378 = !{i64 0, i64 4, !347, i64 4, i64 2, !365, i64 8, i64 4, !347, i64 12, i64 2, !365}
!379 = !DILocation(line: 268, column: 12, scope: !375)
!380 = !DILocation(line: 268, column: 17, scope: !375)
!381 = !{!382, !384, i64 16}
!382 = !{!"app_event", !383, i64 0, !384, i64 16, !384, i64 24, !299, i64 32}
!383 = !{!"flow_id", !299, i64 0, !345, i64 4, !299, i64 8, !345, i64 12}
!384 = !{!"any pointer", !300, i64 0}
!385 = !DILocation(line: 269, column: 12, scope: !375)
!386 = !DILocation(line: 269, column: 21, scope: !375)
!387 = !{!382, !384, i64 24}
!388 = !DILocation(line: 270, column: 19, scope: !375)
!389 = !DILocation(line: 270, column: 12, scope: !375)
!390 = !DILocation(line: 270, column: 17, scope: !375)
!391 = !{!382, !299, i64 32}
!392 = !DILocation(line: 0, scope: !83, inlinedAt: !291)
!393 = !DILocation(line: 0, scope: !96, inlinedAt: !291)
!394 = !DILocation(line: 0, scope: !118, inlinedAt: !294)
!395 = !DILocation(line: 77, column: 30, scope: !118, inlinedAt: !294)
!396 = !DILocation(line: 78, column: 9, scope: !397, inlinedAt: !294)
!397 = distinct !DILexicalBlock(scope: !118, file: !3, line: 78, column: 8)
!398 = !DILocation(line: 78, column: 8, scope: !118, inlinedAt: !294)
!399 = !DILocation(line: 0, scope: !125, inlinedAt: !294)
!400 = !DILocation(line: 0, scope: !127, inlinedAt: !294)
!401 = !DILocation(line: 88, column: 5, scope: !125, inlinedAt: !294)
!402 = !DILocation(line: 79, column: 9, scope: !403, inlinedAt: !294)
!403 = distinct !DILexicalBlock(scope: !404, file: !3, line: 79, column: 9)
!404 = distinct !DILexicalBlock(scope: !397, file: !3, line: 78, column: 18)
!405 = !DILocation(line: 109, column: 1, scope: !118, inlinedAt: !294)
!406 = !DILocation(line: 89, column: 9, scope: !127, inlinedAt: !294)
!407 = !DILocation(line: 91, column: 22, scope: !127, inlinedAt: !294)
!408 = !DILocation(line: 92, column: 27, scope: !127, inlinedAt: !294)
!409 = !{!410, !299, i64 0}
!410 = !{!"tcp_md", !299, i64 0, !299, i64 4, !299, i64 8, !299, i64 12, !299, i64 16}
!411 = !DILocation(line: 92, column: 17, scope: !127, inlinedAt: !294)
!412 = !{!413, !299, i64 24}
!413 = !{!"packet_event", !383, i64 0, !299, i64 16, !300, i64 20, !299, i64 24}
!414 = !DILocation(line: 93, column: 31, scope: !127, inlinedAt: !294)
!415 = !{!410, !299, i64 16}
!416 = !DILocation(line: 93, column: 45, scope: !127, inlinedAt: !294)
!417 = !DILocation(line: 93, column: 20, scope: !127, inlinedAt: !294)
!418 = !{!413, !299, i64 16}
!419 = !DILocation(line: 94, column: 19, scope: !127, inlinedAt: !294)
!420 = !DILocation(line: 95, column: 17, scope: !421, inlinedAt: !294)
!421 = distinct !DILexicalBlock(scope: !127, file: !3, line: 95, column: 13)
!422 = !DILocation(line: 95, column: 13, scope: !127, inlinedAt: !294)
!423 = !DILocation(line: 96, column: 13, scope: !424, inlinedAt: !294)
!424 = distinct !DILexicalBlock(scope: !425, file: !3, line: 96, column: 13)
!425 = distinct !DILexicalBlock(scope: !421, file: !3, line: 95, column: 22)
!426 = !DILocation(line: 97, column: 9, scope: !425, inlinedAt: !294)
!427 = !DILocation(line: 98, column: 18, scope: !127, inlinedAt: !294)
!428 = !DILocation(line: 98, column: 31, scope: !127, inlinedAt: !294)
!429 = !{!410, !299, i64 4}
!430 = !DILocation(line: 99, column: 32, scope: !127, inlinedAt: !294)
!431 = !DILocation(line: 100, column: 9, scope: !127, inlinedAt: !294)
!432 = !DILocation(line: 102, column: 19, scope: !127, inlinedAt: !294)
!433 = !DILocation(line: 103, column: 13, scope: !434, inlinedAt: !294)
!434 = distinct !DILexicalBlock(scope: !127, file: !3, line: 103, column: 12)
!435 = !DILocation(line: 103, column: 12, scope: !127, inlinedAt: !294)
!436 = !DILocation(line: 104, column: 13, scope: !437, inlinedAt: !294)
!437 = distinct !DILexicalBlock(scope: !438, file: !3, line: 104, column: 13)
!438 = distinct !DILexicalBlock(scope: !434, file: !3, line: 103, column: 22)
!439 = !DILocation(line: 108, column: 5, scope: !128, inlinedAt: !294)
!440 = !DILocation(line: 107, column: 9, scope: !441, inlinedAt: !294)
!441 = distinct !DILexicalBlock(scope: !127, file: !3, line: 107, column: 9)
!442 = !DILocation(line: 88, column: 39, scope: !128, inlinedAt: !294)
!443 = !DILocation(line: 88, column: 23, scope: !128, inlinedAt: !294)
!444 = distinct !{!444, !401, !445}
!445 = !DILocation(line: 108, column: 5, scope: !125, inlinedAt: !294)
!446 = !DILocation(line: 0, scope: !106, inlinedAt: !291)
!447 = !DILocation(line: 0, scope: !162, inlinedAt: !290)
!448 = !DILocation(line: 113, column: 5, scope: !162, inlinedAt: !290)
!449 = !DILocation(line: 114, column: 5, scope: !162, inlinedAt: !290)
!450 = !DILocation(line: 115, column: 9, scope: !162, inlinedAt: !290)
!451 = !DILocation(line: 115, column: 19, scope: !162, inlinedAt: !290)
!452 = !{!383, !299, i64 0}
!453 = !DILocation(line: 116, column: 9, scope: !162, inlinedAt: !290)
!454 = !DILocation(line: 116, column: 21, scope: !162, inlinedAt: !290)
!455 = !{!383, !345, i64 4}
!456 = !DILocation(line: 117, column: 9, scope: !162, inlinedAt: !290)
!457 = !DILocation(line: 117, column: 21, scope: !162, inlinedAt: !290)
!458 = !{!383, !299, i64 8}
!459 = !DILocation(line: 118, column: 9, scope: !162, inlinedAt: !290)
!460 = !DILocation(line: 118, column: 23, scope: !162, inlinedAt: !290)
!461 = !{!383, !345, i64 12}
!462 = !DILocation(line: 121, column: 15, scope: !162, inlinedAt: !290)
!463 = !DILocation(line: 122, column: 9, scope: !464, inlinedAt: !290)
!464 = distinct !DILexicalBlock(scope: !162, file: !3, line: 122, column: 8)
!465 = !DILocation(line: 122, column: 8, scope: !162, inlinedAt: !290)
!466 = !DILocation(line: 123, column: 9, scope: !467, inlinedAt: !290)
!467 = distinct !DILexicalBlock(scope: !468, file: !3, line: 123, column: 9)
!468 = distinct !DILexicalBlock(scope: !464, file: !3, line: 122, column: 18)
!469 = !DILocation(line: 124, column: 9, scope: !468, inlinedAt: !290)
!470 = !DILocation(line: 126, column: 34, scope: !162, inlinedAt: !290)
!471 = !{!410, !299, i64 12}
!472 = !DILocation(line: 127, column: 16, scope: !473, inlinedAt: !290)
!473 = distinct !DILexicalBlock(scope: !162, file: !3, line: 127, column: 8)
!474 = !DILocation(line: 127, column: 8, scope: !162, inlinedAt: !290)
!475 = !DILocation(line: 128, column: 42, scope: !476, inlinedAt: !290)
!476 = distinct !DILexicalBlock(scope: !473, file: !3, line: 127, column: 45)
!477 = !DILocation(line: 128, column: 55, scope: !476, inlinedAt: !290)
!478 = !DILocation(line: 128, column: 31, scope: !476, inlinedAt: !290)
!479 = !DILocation(line: 129, column: 35, scope: !476, inlinedAt: !290)
!480 = !DILocation(line: 130, column: 9, scope: !476, inlinedAt: !290)
!481 = !DILocation(line: 131, column: 5, scope: !476, inlinedAt: !290)
!482 = !DILocation(line: 132, column: 15, scope: !162, inlinedAt: !290)
!483 = !DILocation(line: 133, column: 9, scope: !484, inlinedAt: !290)
!484 = distinct !DILexicalBlock(scope: !162, file: !3, line: 133, column: 8)
!485 = !DILocation(line: 133, column: 8, scope: !162, inlinedAt: !290)
!486 = !DILocation(line: 134, column: 9, scope: !487, inlinedAt: !290)
!487 = distinct !DILexicalBlock(scope: !488, file: !3, line: 134, column: 9)
!488 = distinct !DILexicalBlock(scope: !484, file: !3, line: 133, column: 18)
!489 = !DILocation(line: 135, column: 9, scope: !488, inlinedAt: !290)
!490 = !DILocation(line: 137, column: 5, scope: !491, inlinedAt: !290)
!491 = distinct !DILexicalBlock(scope: !162, file: !3, line: 137, column: 5)
!492 = !DILocation(line: 140, column: 8, scope: !162, inlinedAt: !290)
!493 = !DILocation(line: 144, column: 8, scope: !162, inlinedAt: !290)
!494 = !DILocation(line: 0, scope: !173, inlinedAt: !290)
!495 = !DILocation(line: 151, column: 34, scope: !176, inlinedAt: !290)
!496 = !DILocation(line: 151, column: 5, scope: !173, inlinedAt: !290)
!497 = !DILocation(line: 0, scope: !175, inlinedAt: !290)
!498 = !DILocation(line: 152, column: 9, scope: !175, inlinedAt: !290)
!499 = !DILocation(line: 154, column: 18, scope: !175, inlinedAt: !290)
!500 = !DILocation(line: 155, column: 27, scope: !175, inlinedAt: !290)
!501 = !DILocation(line: 155, column: 17, scope: !175, inlinedAt: !290)
!502 = !DILocation(line: 156, column: 31, scope: !175, inlinedAt: !290)
!503 = !DILocation(line: 156, column: 45, scope: !175, inlinedAt: !290)
!504 = !DILocation(line: 156, column: 20, scope: !175, inlinedAt: !290)
!505 = !DILocation(line: 157, column: 19, scope: !175, inlinedAt: !290)
!506 = !DILocation(line: 158, column: 17, scope: !507, inlinedAt: !290)
!507 = distinct !DILexicalBlock(scope: !175, file: !3, line: 158, column: 13)
!508 = !DILocation(line: 158, column: 13, scope: !175, inlinedAt: !290)
!509 = !DILocation(line: 159, column: 13, scope: !510, inlinedAt: !290)
!510 = distinct !DILexicalBlock(scope: !511, file: !3, line: 159, column: 13)
!511 = distinct !DILexicalBlock(scope: !507, file: !3, line: 158, column: 22)
!512 = !DILocation(line: 160, column: 9, scope: !511, inlinedAt: !290)
!513 = !DILocation(line: 161, column: 18, scope: !175, inlinedAt: !290)
!514 = !DILocation(line: 161, column: 31, scope: !175, inlinedAt: !290)
!515 = !DILocation(line: 162, column: 32, scope: !175, inlinedAt: !290)
!516 = !DILocation(line: 163, column: 9, scope: !175, inlinedAt: !290)
!517 = !DILocation(line: 164, column: 19, scope: !175, inlinedAt: !290)
!518 = !DILocation(line: 165, column: 13, scope: !519, inlinedAt: !290)
!519 = distinct !DILexicalBlock(scope: !175, file: !3, line: 165, column: 12)
!520 = !DILocation(line: 165, column: 12, scope: !175, inlinedAt: !290)
!521 = !DILocation(line: 166, column: 13, scope: !522, inlinedAt: !290)
!522 = distinct !DILexicalBlock(scope: !523, file: !3, line: 166, column: 13)
!523 = distinct !DILexicalBlock(scope: !519, file: !3, line: 165, column: 22)
!524 = !DILocation(line: 170, column: 5, scope: !176, inlinedAt: !290)
!525 = !DILocation(line: 169, column: 9, scope: !526, inlinedAt: !290)
!526 = distinct !DILexicalBlock(scope: !175, file: !3, line: 169, column: 9)
!527 = !DILocation(line: 151, column: 42, scope: !176, inlinedAt: !290)
!528 = distinct !{!528, !496, !529}
!529 = !DILocation(line: 170, column: 5, scope: !173, inlinedAt: !290)
!530 = !DILocation(line: 171, column: 1, scope: !162, inlinedAt: !290)
!531 = !DILocation(line: 277, column: 1, scope: !207)
