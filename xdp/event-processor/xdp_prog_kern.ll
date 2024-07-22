; ModuleID = 'xdp_prog_kern.c'
source_filename = "xdp_prog_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.anon.1 = type { [1 x i32]*, [32 x i32]*, %struct.flow_id*, %struct.tcp_md* }
%struct.flow_id = type { i32, i16, i32, i16 }
%struct.tcp_md = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.anon.2 = type { [2 x i32]*, [5 x i32]*, i32*, %struct.packet_event* }
%struct.packet_event = type { %struct.flow_id*, i32, i32 }
%struct.anon.3 = type { [1 x i32]*, %struct.flow_id*, %struct.map_elem*, [5 x i32]* }
%struct.map_elem = type { %struct.flow_id*, i32, %struct.bpf_timer }
%struct.bpf_timer = type { i128 }
%struct.anon.4 = type { [1 x i32]*, %struct.flow_id*, %struct.timeout_event*, [1000 x i32]* }
%struct.timeout_event = type { %struct.flow_id*, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.hdr_cursor = type { i8* }
%struct.iphdr = type { i8, i8, i16, i16, i16, i8, i8, i16, %union.anon }
%union.anon = type { %struct.anon }
%struct.anon = type { i32, i32 }
%struct.tcphdr = type { i16, i16, i32, i32, i16, i16, i16, i16 }
%struct.event = type { i8, i8* }
%struct.net_event = type { %struct.flow_id*, i32 }
%struct.app_event = type { %struct.flow_id*, i32 }

@simply_drop.____fmt = internal constant [3 x i8] c"%d\00", align 1, !dbg !0
@simply_drop.____fmt.1 = internal constant [7 x i8] c"ID: %u\00", align 1, !dbg !47
@tcp_connections = dso_local global %struct.anon.1 zeroinitializer, section ".maps", align 8, !dbg !69
@simply_drop.____fmt.2 = internal constant [36 x i8] c"tcp_ctx does not exist with the fid\00", align 1, !dbg !54
@simply_drop.____fmt.3 = internal constant [28 x i8] c"New added:%u, cur_length:%u\00", align 1, !dbg !59
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !64
@window_packets = dso_local global %struct.anon.2 zeroinitializer, section ".maps", align 8, !dbg !103
@timer_array = dso_local global %struct.anon.3 zeroinitializer, section ".maps", align 8, !dbg !126
@timeout_array = dso_local global %struct.anon.4 zeroinitializer, section ".maps", align 8, !dbg !142
@app_event_processor.____fmt = internal constant [38 x i8] c"\0Atcp_ctx does not exist with the fid\0A\00", align 1, !dbg !217
@app_event_processor.____fmt.4 = internal constant [33 x i8] c"new timer added based on flow id\00", align 1, !dbg !235
@app_event_processor.____fmt.5 = internal constant [27 x i8] c"new map_entry added failed\00", align 1, !dbg !240
@app_event_processor.____fmt.6 = internal constant [19 x i8] c"App_event recalled\00", align 1, !dbg !245
@app_event_processor.____fmt.7 = internal constant [29 x i8] c"Error while setting callback\00", align 1, !dbg !250
@app_event_processor.____fmt.8 = internal constant [19 x i8] c"Timer start failed\00", align 1, !dbg !255
@app_event_processor.____fmt.9 = internal constant [26 x i8] c"timer starts successfully\00", align 1, !dbg !257
@app_event_send.____fmt = internal constant [38 x i8] c"\0Atcp_ctx does not exist with the fid\0A\00", align 1, !dbg !267
@enque.____fmt = internal constant [37 x i8] c"\0Atcp_ctx does not exist with the fid\00", align 1, !dbg !277
@enque.____fmt.10 = internal constant [47 x i8] c"The window is full, the packet cannot be added\00", align 1, !dbg !290
@send_packet.____fmt = internal constant [16 x i8] c"send packet: %u\00", align 1, !dbg !295
@timer_callback.____fmt = internal constant [19 x i8] c"Packet %d timeouts\00", align 1, !dbg !316
@timer_callback.____fmt.11 = internal constant [19 x i8] c"Timer start failed\00", align 1, !dbg !327
@net_event_processor.____fmt = internal constant [38 x i8] c"\0Atcp_ctx does not exist with the fid\0A\00", align 1, !dbg !334
@net_event_processor.____fmt.12 = internal constant [20 x i8] c"map_entry not found\00", align 1, !dbg !346
@net_event_processor.____fmt.13 = internal constant [17 x i8] c"Received ack: %u\00", align 1, !dbg !351
@net_event_processor.____fmt.14 = internal constant [30 x i8] c"All packets sent and received\00", align 1, !dbg !356
@net_event_processor.____fmt.15 = internal constant [29 x i8] c"Error while setting callback\00", align 1, !dbg !361
@net_event_processor.____fmt.16 = internal constant [19 x i8] c"Timer start failed\00", align 1, !dbg !363
@net_event_processor.____fmt.17 = internal constant [26 x i8] c"timer starts successfully\00", align 1, !dbg !365
@update_window.____fmt = internal constant [38 x i8] c"\0Atcp_ctx does not exist with the fid\0A\00", align 1, !dbg !372
@deque.____fmt = internal constant [37 x i8] c"\0Atcp_ctx does not exist with the fid\00", align 1, !dbg !380
@deque.____fmt.18 = internal constant [46 x i8] c"The window is empty, no packet can be removed\00", align 1, !dbg !389
@deque.____fmt.19 = internal constant [33 x i8] c"The remove packet does not exist\00", align 1, !dbg !394
@resend_packet.____fmt = internal constant [40 x i8] c"There is not packet needed to be resent\00", align 1, !dbg !396
@resend_packet.____fmt.20 = internal constant [36 x i8] c"tcp_ctx does not exist with the fid\00", align 1, !dbg !411
@resend_packet.____fmt.21 = internal constant [24 x i8] c"Resent packet not found\00", align 1, !dbg !413
@llvm.compiler.used = appending global [6 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @simply_drop to i8*), i8* bitcast (%struct.anon.1* @tcp_connections to i8*), i8* bitcast (%struct.anon.4* @timeout_array to i8*), i8* bitcast (%struct.anon.3* @timer_array to i8*), i8* bitcast (%struct.anon.2* @window_packets to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @simply_drop(%struct.xdp_md* nocapture noundef readonly %0) #0 section "xdp" !dbg !2 {
  %2 = alloca %struct.flow_id, align 8
  %3 = alloca %struct.map_elem, align 8
  %4 = alloca %struct.flow_id, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !416, metadata !DIExpression()), !dbg !511
  %5 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !512
  %6 = load i32, i32* %5, align 4, !dbg !512, !tbaa !513
  %7 = zext i32 %6 to i64, !dbg !518
  %8 = inttoptr i64 %7 to i8*, !dbg !519
  call void @llvm.dbg.value(metadata i8* %8, metadata !417, metadata !DIExpression()), !dbg !511
  %9 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !520
  %10 = load i32, i32* %9, align 4, !dbg !520, !tbaa !521
  %11 = zext i32 %10 to i64, !dbg !522
  %12 = inttoptr i64 %11 to i8*, !dbg !523
  call void @llvm.dbg.value(metadata i8* %12, metadata !418, metadata !DIExpression()), !dbg !511
  %13 = tail call i32 inttoptr (i64 8 to i32 ()*)() #6, !dbg !524
  call void @llvm.dbg.value(metadata i32 %13, metadata !419, metadata !DIExpression()), !dbg !511
  %14 = tail call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @simply_drop.____fmt, i64 0, i64 0), i32 noundef 3, i32 noundef %13) #6, !dbg !525
  call void @llvm.dbg.value(metadata i8* %12, metadata !484, metadata !DIExpression()), !dbg !511
  call void @llvm.dbg.value(metadata i32 0, metadata !489, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !511
  call void @llvm.dbg.value(metadata i16 0, metadata !489, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 16)), !dbg !511
  call void @llvm.dbg.value(metadata i16 0, metadata !489, metadata !DIExpression(DW_OP_LLVM_fragment, 48, 16)), !dbg !511
  call void @llvm.dbg.value(metadata i32 0, metadata !489, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 32)), !dbg !511
  call void @llvm.dbg.value(metadata i16 0, metadata !489, metadata !DIExpression(DW_OP_LLVM_fragment, 96, 16)), !dbg !511
  call void @llvm.dbg.value(metadata i16 0, metadata !489, metadata !DIExpression(DW_OP_LLVM_fragment, 112, 16)), !dbg !511
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !420, metadata !DIExpression(DW_OP_deref)), !dbg !511
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !527, metadata !DIExpression()), !dbg !538
  call void @llvm.dbg.value(metadata i8* %8, metadata !534, metadata !DIExpression()), !dbg !538
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !535, metadata !DIExpression()), !dbg !538
  call void @llvm.dbg.value(metadata i8* %12, metadata !536, metadata !DIExpression()), !dbg !538
  call void @llvm.dbg.value(metadata i32 14, metadata !537, metadata !DIExpression()), !dbg !538
  %15 = getelementptr i8, i8* %12, i64 14, !dbg !540
  %16 = icmp ugt i8* %15, %8, !dbg !542
  %17 = select i1 %16, i8* %12, i8* %15, !dbg !543
  call void @llvm.dbg.value(metadata i8* %17, metadata !484, metadata !DIExpression()), !dbg !511
  call void @llvm.dbg.value(metadata i8* %17, metadata !490, metadata !DIExpression()), !dbg !511
  %18 = getelementptr inbounds i8, i8* %17, i64 20, !dbg !544
  %19 = bitcast i8* %18 to %struct.iphdr*, !dbg !544
  %20 = inttoptr i64 %7 to %struct.iphdr*, !dbg !546
  %21 = icmp ugt %struct.iphdr* %19, %20, !dbg !547
  br i1 %21, label %237, label %22, !dbg !548

22:                                               ; preds = %1
  %23 = load i8, i8* %17, align 4, !dbg !549
  %24 = shl i8 %23, 2, !dbg !550
  %25 = and i8 %24, 60, !dbg !550
  call void @llvm.dbg.value(metadata i8 %25, metadata !491, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !511
  %26 = icmp ult i8 %25, 20, !dbg !551
  br i1 %26, label %237, label %27, !dbg !553

27:                                               ; preds = %22
  %28 = zext i8 %25 to i64
  call void @llvm.dbg.value(metadata i64 %28, metadata !491, metadata !DIExpression()), !dbg !511
  %29 = getelementptr i8, i8* %17, i64 %28, !dbg !554
  %30 = icmp ugt i8* %29, %8, !dbg !556
  br i1 %30, label %237, label %31, !dbg !557

31:                                               ; preds = %27
  call void @llvm.dbg.value(metadata i8* %29, metadata !484, metadata !DIExpression()), !dbg !511
  call void @llvm.dbg.value(metadata i8* %17, metadata !433, metadata !DIExpression()), !dbg !511
  %32 = getelementptr inbounds i8, i8* %17, i64 4, !dbg !558
  %33 = bitcast i8* %32 to i16*, !dbg !558
  %34 = load i16, i16* %33, align 4, !dbg !558, !tbaa !559
  %35 = tail call i16 @llvm.bswap.i16(i16 %34), !dbg !558
  call void @llvm.dbg.value(metadata i16 %35, metadata !492, metadata !DIExpression()), !dbg !511
  %36 = zext i16 %35 to i32, !dbg !562
  %37 = tail call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @simply_drop.____fmt.1, i64 0, i64 0), i32 noundef 7, i32 noundef %36) #6, !dbg !562
  %38 = getelementptr inbounds i8, i8* %17, i64 12, !dbg !564
  %39 = bitcast i8* %38 to i32*, !dbg !564
  %40 = load i32, i32* %39, align 4, !dbg !564, !tbaa !565
  call void @llvm.dbg.value(metadata i32 %40, metadata !489, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !511
  %41 = getelementptr inbounds i8, i8* %17, i64 16, !dbg !566
  %42 = bitcast i8* %41 to i32*, !dbg !566
  %43 = load i32, i32* %42, align 4, !dbg !566, !tbaa !565
  call void @llvm.dbg.value(metadata i32 %43, metadata !489, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 32)), !dbg !511
  call void @llvm.dbg.value(metadata i8* %29, metadata !494, metadata !DIExpression()), !dbg !511
  %44 = getelementptr inbounds i8, i8* %29, i64 20, !dbg !567
  %45 = bitcast i8* %44 to %struct.tcphdr*, !dbg !567
  %46 = inttoptr i64 %7 to %struct.tcphdr*, !dbg !569
  %47 = icmp ugt %struct.tcphdr* %45, %46, !dbg !570
  br i1 %47, label %237, label %48, !dbg !571

48:                                               ; preds = %31
  %49 = getelementptr inbounds i8, i8* %29, i64 12, !dbg !572
  %50 = bitcast i8* %49 to i16*, !dbg !572
  %51 = load i16, i16* %50, align 4, !dbg !572
  %52 = lshr i16 %51, 2, !dbg !573
  %53 = and i16 %52, 60, !dbg !573
  call void @llvm.dbg.value(metadata i16 %53, metadata !493, metadata !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !511
  %54 = icmp ult i16 %53, 20, !dbg !574
  br i1 %54, label %237, label %55, !dbg !576

55:                                               ; preds = %48
  %56 = zext i16 %53 to i64
  call void @llvm.dbg.value(metadata i64 %56, metadata !493, metadata !DIExpression()), !dbg !511
  %57 = getelementptr i8, i8* %29, i64 %56, !dbg !577
  %58 = icmp ugt i8* %57, %8, !dbg !579
  br i1 %58, label %237, label %59, !dbg !580

59:                                               ; preds = %55
  call void @llvm.dbg.value(metadata i8* %57, metadata !484, metadata !DIExpression()), !dbg !511
  call void @llvm.dbg.value(metadata i8* %29, metadata !462, metadata !DIExpression()), !dbg !511
  %60 = bitcast i8* %29 to i16*, !dbg !581
  %61 = load i16, i16* %60, align 4, !dbg !581, !tbaa !582
  call void @llvm.dbg.value(metadata i16 %61, metadata !489, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 16)), !dbg !511
  %62 = getelementptr inbounds i8, i8* %29, i64 2, !dbg !584
  %63 = bitcast i8* %62 to i16*, !dbg !584
  %64 = load i16, i16* %63, align 2, !dbg !584, !tbaa !585
  call void @llvm.dbg.value(metadata i16 %64, metadata !489, metadata !DIExpression(DW_OP_LLVM_fragment, 96, 16)), !dbg !511
  %65 = getelementptr inbounds i8, i8* %29, i64 8, !dbg !586
  %66 = bitcast i8* %65 to i32*, !dbg !586
  %67 = load i32, i32* %66, align 4, !dbg !586, !tbaa !587
  %68 = tail call i32 @llvm.bswap.i32(i32 %67), !dbg !586
  call void @llvm.dbg.value(metadata i32 %68, metadata !495, metadata !DIExpression()), !dbg !511
  call void @llvm.dbg.value(metadata i8 0, metadata !496, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 8)), !dbg !511
  call void @llvm.dbg.value(metadata i8* null, metadata !496, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !511
  call void @llvm.dbg.value(metadata %struct.flow_id* null, metadata !497, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !511
  call void @llvm.dbg.value(metadata i32 0, metadata !497, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 32)), !dbg !511
  call void @llvm.dbg.value(metadata i32 0, metadata !497, metadata !DIExpression(DW_OP_LLVM_fragment, 96, 32)), !dbg !511
  call void @llvm.dbg.value(metadata %struct.flow_id* null, metadata !498, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !511
  call void @llvm.dbg.value(metadata i32 0, metadata !498, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 32)), !dbg !511
  call void @llvm.dbg.value(metadata i32 0, metadata !498, metadata !DIExpression(DW_OP_LLVM_fragment, 96, 32)), !dbg !511
  %69 = bitcast %struct.flow_id* %4 to i8*, !dbg !588
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %69) #6, !dbg !588
  call void @llvm.dbg.declare(metadata %struct.flow_id* %4, metadata !499, metadata !DIExpression()), !dbg !589
  %70 = getelementptr inbounds %struct.flow_id, %struct.flow_id* %4, i64 0, i32 1, !dbg !590
  %71 = bitcast i16* %70 to i8*, !dbg !590
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(16) %71, i8 0, i64 12, i1 false), !dbg !590
  %72 = getelementptr inbounds %struct.flow_id, %struct.flow_id* %4, i64 0, i32 0, !dbg !591
  store i32 %43, i32* %72, align 4, !dbg !592, !tbaa !593
  %73 = getelementptr inbounds %struct.flow_id, %struct.flow_id* %4, i64 0, i32 1, !dbg !595
  store i16 %64, i16* %73, align 4, !dbg !596, !tbaa !597
  %74 = getelementptr inbounds %struct.flow_id, %struct.flow_id* %4, i64 0, i32 2, !dbg !598
  store i32 %40, i32* %74, align 4, !dbg !599, !tbaa !600
  %75 = getelementptr inbounds %struct.flow_id, %struct.flow_id* %4, i64 0, i32 3, !dbg !601
  store i16 %61, i16* %75, align 4, !dbg !602, !tbaa !603
  switch i16 %35, label %236 [
    i16 2, label %76
    i16 3, label %81
    i16 1, label %197
  ], !dbg !604

76:                                               ; preds = %59
  %77 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon.1* @tcp_connections to i8*), i8* noundef nonnull %69) #6, !dbg !605
  call void @llvm.dbg.value(metadata i8* %77, metadata !500, metadata !DIExpression()), !dbg !606
  %78 = icmp eq i8* %77, null, !dbg !607
  br i1 %78, label %79, label %136, !dbg !609

79:                                               ; preds = %76
  %80 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @simply_drop.____fmt.2, i64 0, i64 0), i32 noundef 36) #6, !dbg !610
  br label %236

81:                                               ; preds = %59
  call void @llvm.dbg.value(metadata i8 2, metadata !496, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 8)), !dbg !511
  call void @llvm.dbg.value(metadata i8* undef, metadata !496, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !511
  call void @llvm.dbg.value(metadata %struct.flow_id* %4, metadata !497, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !511
  call void @llvm.dbg.value(metadata i32 %68, metadata !497, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 32)), !dbg !511
  call void @llvm.dbg.value(metadata %struct.event* undef, metadata !198, metadata !DIExpression()) #6, !dbg !613
  call void @llvm.dbg.value(metadata %struct.net_event* undef, metadata !207, metadata !DIExpression()) #6, !dbg !617
  call void @llvm.dbg.value(metadata %struct.net_event* undef, metadata !340, metadata !DIExpression()) #6, !dbg !618
  call void @llvm.dbg.value(metadata %struct.tcp_md* null, metadata !341, metadata !DIExpression()) #6, !dbg !618
  %82 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon.1* @tcp_connections to i8*), i8* noundef nonnull %69) #6, !dbg !620
  call void @llvm.dbg.value(metadata i8* %82, metadata !341, metadata !DIExpression()) #6, !dbg !618
  %83 = icmp eq i8* %82, null, !dbg !621
  br i1 %83, label %84, label %86, !dbg !623

84:                                               ; preds = %81
  %85 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @net_event_processor.____fmt, i64 0, i64 0), i32 noundef 38) #6, !dbg !624
  br label %236, !dbg !627

86:                                               ; preds = %81
  %87 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon.3* @timer_array to i8*), i8* noundef nonnull %69) #6, !dbg !628
  call void @llvm.dbg.value(metadata i8* %87, metadata !342, metadata !DIExpression()) #6, !dbg !618
  %88 = icmp eq i8* %87, null, !dbg !629
  br i1 %88, label %89, label %91, !dbg !631

89:                                               ; preds = %86
  %90 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @net_event_processor.____fmt.12, i64 0, i64 0), i32 noundef 20) #6, !dbg !632
  br label %236, !dbg !635

91:                                               ; preds = %86
  %92 = getelementptr inbounds i8, i8* %82, i64 8, !dbg !636
  %93 = bitcast i8* %92 to i32*, !dbg !636
  %94 = load i32, i32* %93, align 4, !dbg !636, !tbaa !638
  %95 = icmp ugt i32 %68, %94, !dbg !640
  br i1 %95, label %96, label %236, !dbg !641

96:                                               ; preds = %91
  %97 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @net_event_processor.____fmt.13, i64 0, i64 0), i32 noundef 17, i32 noundef %68) #6, !dbg !642
  %98 = getelementptr inbounds i8, i8* %82, i64 24, !dbg !644
  %99 = bitcast i8* %98 to i32*, !dbg !644
  %100 = load i32, i32* %99, align 4, !dbg !644, !tbaa !645
  %101 = getelementptr inbounds i8, i8* %82, i64 12, !dbg !646
  %102 = bitcast i8* %101 to i32*, !dbg !646
  %103 = load i32, i32* %102, align 4, !dbg !646, !tbaa !647
  %104 = add i32 %103, 1, !dbg !648
  call void @llvm.dbg.value(metadata !DIArgList(i32 %100, i32 %104), metadata !343, metadata !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_minus, DW_OP_stack_value)) #6, !dbg !618
  %105 = icmp eq i32 %100, %104, !dbg !649
  %106 = icmp eq i32 %68, %100
  %107 = select i1 %105, i1 %106, i1 false, !dbg !651
  br i1 %107, label %108, label %113, !dbg !651

108:                                              ; preds = %96
  %109 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([30 x i8], [30 x i8]* @net_event_processor.____fmt.14, i64 0, i64 0), i32 noundef 30) #6, !dbg !652
  %110 = getelementptr inbounds i8, i8* %87, i64 16, !dbg !655
  %111 = bitcast i8* %110 to %struct.bpf_timer*, !dbg !655
  %112 = call i64 inttoptr (i64 172 to i64 (%struct.bpf_timer*)*)(%struct.bpf_timer* noundef nonnull %111) #6, !dbg !656
  br label %236, !dbg !657

113:                                              ; preds = %96
  %114 = load i32, i32* %93, align 4, !dbg !658, !tbaa !638
  %115 = sub i32 %68, %114, !dbg !659
  call void @llvm.dbg.value(metadata i32 %115, metadata !344, metadata !DIExpression()) #6, !dbg !618
  store i32 %68, i32* %93, align 4, !dbg !660, !tbaa !638
  %116 = call i64 inttoptr (i64 2 to i64 (i8*, i8*, i8*, i64)*)(i8* noundef bitcast (%struct.anon.1* @tcp_connections to i8*), i8* noundef nonnull %69, i8* noundef nonnull %82, i64 noundef 0) #6, !dbg !661
  %117 = call i64 inttoptr (i64 181 to i64 (i32, i8*, i8*, i64)*)(i32 noundef %115, i8* noundef bitcast (i64 (i32, %struct.flow_id*)* @update_window to i8*), i8* noundef nonnull %69, i64 noundef 0) #6, !dbg !662
  %118 = load i32, i32* %93, align 4, !dbg !663, !tbaa !638
  %119 = getelementptr inbounds i8, i8* %87, i64 8, !dbg !664
  %120 = bitcast i8* %119 to i32*, !dbg !664
  store i32 %118, i32* %120, align 8, !dbg !665, !tbaa !666
  %121 = getelementptr inbounds i8, i8* %87, i64 16, !dbg !670
  %122 = bitcast i8* %121 to %struct.bpf_timer*, !dbg !670
  %123 = call i64 inttoptr (i64 170 to i64 (%struct.bpf_timer*, i8*)*)(%struct.bpf_timer* noundef nonnull %122, i8* noundef bitcast (i32 (i8*, %struct.flow_id*, %struct.map_elem*)* @timer_callback to i8*)) #6, !dbg !671
  %124 = trunc i64 %123 to i32, !dbg !671
  call void @llvm.dbg.value(metadata i32 %124, metadata !345, metadata !DIExpression()) #6, !dbg !618
  %125 = icmp eq i32 %124, 0, !dbg !672
  br i1 %125, label %128, label %126, !dbg !674

126:                                              ; preds = %113
  %127 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @net_event_processor.____fmt.15, i64 0, i64 0), i32 noundef 29) #6, !dbg !675
  br label %236, !dbg !678

128:                                              ; preds = %113
  %129 = call i64 inttoptr (i64 171 to i64 (%struct.bpf_timer*, i64, i64)*)(%struct.bpf_timer* noundef nonnull %122, i64 noundef 1000000000, i64 noundef 0) #6, !dbg !679
  %130 = trunc i64 %129 to i32, !dbg !679
  call void @llvm.dbg.value(metadata i32 %130, metadata !345, metadata !DIExpression()) #6, !dbg !618
  %131 = icmp eq i32 %130, 0, !dbg !680
  br i1 %131, label %134, label %132, !dbg !682

132:                                              ; preds = %128
  %133 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @net_event_processor.____fmt.16, i64 0, i64 0), i32 noundef 19) #6, !dbg !683
  br label %236, !dbg !686

134:                                              ; preds = %128
  %135 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @net_event_processor.____fmt.17, i64 0, i64 0), i32 noundef 26) #6, !dbg !687
  br label %236, !dbg !690

136:                                              ; preds = %76
  call void @llvm.dbg.value(metadata i8* %77, metadata !500, metadata !DIExpression()), !dbg !606
  %137 = ptrtoint i8* %57 to i64, !dbg !691
  %138 = getelementptr inbounds i8, i8* %77, i64 24, !dbg !692
  %139 = bitcast i8* %138 to i32*, !dbg !692
  %140 = load i32, i32* %139, align 4, !dbg !693, !tbaa !645
  %141 = trunc i64 %137 to i32, !dbg !693
  %142 = sub i32 %6, %141, !dbg !693
  %143 = add i32 %140, %142, !dbg !693
  store i32 %143, i32* %139, align 4, !dbg !693, !tbaa !645
  %144 = sub i64 %7, %137, !dbg !694
  %145 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([28 x i8], [28 x i8]* @simply_drop.____fmt.3, i64 0, i64 0), i32 noundef 28, i64 noundef %144, i32 noundef %143) #6, !dbg !694
  %146 = call i64 inttoptr (i64 2 to i64 (i8*, i8*, i8*, i64)*)(i8* noundef bitcast (%struct.anon.1* @tcp_connections to i8*), i8* noundef nonnull %69, i8* noundef nonnull %77, i64 noundef 0) #6, !dbg !696
  call void @llvm.dbg.value(metadata i8 0, metadata !496, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 8)), !dbg !511
  call void @llvm.dbg.value(metadata i8* undef, metadata !496, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !511
  call void @llvm.dbg.value(metadata %struct.flow_id* %4, metadata !498, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !511
  call void @llvm.dbg.value(metadata %struct.event* undef, metadata !198, metadata !DIExpression()) #6, !dbg !697
  call void @llvm.dbg.value(metadata %struct.app_event* undef, metadata !199, metadata !DIExpression()) #6, !dbg !701
  call void @llvm.dbg.value(metadata %struct.app_event* undef, metadata !223, metadata !DIExpression()) #6, !dbg !702
  %147 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon.1* @tcp_connections to i8*), i8* noundef nonnull %69) #6, !dbg !704
  call void @llvm.dbg.value(metadata i8* %147, metadata !224, metadata !DIExpression()) #6, !dbg !702
  %148 = icmp eq i8* %147, null, !dbg !705
  br i1 %148, label %149, label %151, !dbg !707

149:                                              ; preds = %136
  %150 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @app_event_processor.____fmt, i64 0, i64 0), i32 noundef 38) #6, !dbg !708
  br label %236, !dbg !711

151:                                              ; preds = %136
  call void @llvm.dbg.value(metadata i8* %147, metadata !224, metadata !DIExpression()) #6, !dbg !702
  %152 = getelementptr inbounds i8, i8* %147, i64 24, !dbg !712
  %153 = bitcast i8* %152 to i32*, !dbg !712
  %154 = load i32, i32* %153, align 4, !dbg !712, !tbaa !645
  %155 = getelementptr inbounds i8, i8* %147, i64 12, !dbg !713
  %156 = bitcast i8* %155 to i32*, !dbg !713
  %157 = load i32, i32* %156, align 4, !dbg !713, !tbaa !647
  %158 = xor i32 %157, -1, !dbg !714
  %159 = add i32 %154, %158, !dbg !715
  call void @llvm.dbg.value(metadata i32 %159, metadata !225, metadata !DIExpression()) #6, !dbg !702
  %160 = icmp slt i32 %159, 5, !dbg !716
  %161 = select i1 %160, i32 %159, i32 5, !dbg !717
  call void @llvm.dbg.value(metadata i32 %161, metadata !226, metadata !DIExpression()) #6, !dbg !702
  %162 = call i64 inttoptr (i64 181 to i64 (i32, i8*, i8*, i64)*)(i32 noundef %161, i8* noundef bitcast (i64 (i32, %struct.flow_id*)* @app_event_send to i8*), i8* noundef nonnull %69, i64 noundef 0) #6, !dbg !718
  %163 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon.3* @timer_array to i8*), i8* noundef nonnull %69) #6, !dbg !719
  call void @llvm.dbg.value(metadata i8* %163, metadata !227, metadata !DIExpression()) #6, !dbg !702
  %164 = icmp eq i8* %163, null, !dbg !720
  br i1 %164, label %165, label %174, !dbg !721

165:                                              ; preds = %151
  %166 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([33 x i8], [33 x i8]* @app_event_processor.____fmt.4, i64 0, i64 0), i32 noundef 33) #6, !dbg !722
  %167 = bitcast %struct.map_elem* %3 to i8*, !dbg !724
  call void @llvm.lifetime.start.p0i8(i64 32, i8* nonnull %167) #6, !dbg !724
  call void @llvm.dbg.declare(metadata %struct.map_elem* %3, metadata !228, metadata !DIExpression()) #6, !dbg !725
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(32) %167, i8 0, i64 32, i1 false) #6, !dbg !726
  %168 = call i64 inttoptr (i64 2 to i64 (i8*, i8*, i8*, i64)*)(i8* noundef bitcast (%struct.anon.3* @timer_array to i8*), i8* noundef nonnull %69, i8* noundef nonnull %167, i64 noundef 0) #6, !dbg !727
  %169 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon.3* @timer_array to i8*), i8* noundef nonnull %69) #6, !dbg !728
  call void @llvm.dbg.value(metadata i8* %169, metadata !227, metadata !DIExpression()) #6, !dbg !702
  %170 = icmp eq i8* %169, null, !dbg !729
  br i1 %170, label %171, label %173, !dbg !731

171:                                              ; preds = %165
  %172 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @app_event_processor.____fmt.5, i64 0, i64 0), i32 noundef 27) #6, !dbg !732
  call void @llvm.lifetime.end.p0i8(i64 32, i8* nonnull %167) #6, !dbg !735
  br label %236

173:                                              ; preds = %165
  call void @llvm.lifetime.end.p0i8(i64 32, i8* nonnull %167) #6, !dbg !735
  br label %174

174:                                              ; preds = %173, %151
  %175 = phi i8* [ %163, %151 ], [ %169, %173 ]
  call void @llvm.dbg.value(metadata i8* %175, metadata !227, metadata !DIExpression()) #6, !dbg !702
  %176 = getelementptr inbounds i8, i8* %175, i64 8, !dbg !736
  %177 = bitcast i8* %176 to i32*, !dbg !736
  store i32 0, i32* %177, align 8, !dbg !737, !tbaa !666
  %178 = bitcast i8* %175 to %struct.flow_id**, !dbg !738
  store %struct.flow_id* %4, %struct.flow_id** %178, align 8, !dbg !739, !tbaa !740
  %179 = getelementptr inbounds i8, i8* %175, i64 16, !dbg !741
  %180 = bitcast i8* %179 to %struct.bpf_timer*, !dbg !741
  %181 = call i64 inttoptr (i64 169 to i64 (%struct.bpf_timer*, i8*, i64)*)(%struct.bpf_timer* noundef nonnull %180, i8* noundef bitcast (%struct.anon.3* @timer_array to i8*), i64 noundef 7) #6, !dbg !742
  call void @llvm.dbg.value(metadata i64 %181, metadata !231, metadata !DIExpression()) #6, !dbg !702
  %182 = icmp eq i64 %181, 0, !dbg !743
  br i1 %182, label %185, label %183, !dbg !745

183:                                              ; preds = %174
  %184 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @app_event_processor.____fmt.6, i64 0, i64 0), i32 noundef 19) #6, !dbg !746
  br label %185, !dbg !749

185:                                              ; preds = %183, %174
  %186 = call i64 inttoptr (i64 170 to i64 (%struct.bpf_timer*, i8*)*)(%struct.bpf_timer* noundef nonnull %180, i8* noundef bitcast (i32 (i8*, %struct.flow_id*, %struct.map_elem*)* @timer_callback to i8*)) #6, !dbg !750
  call void @llvm.dbg.value(metadata i64 %186, metadata !231, metadata !DIExpression()) #6, !dbg !702
  %187 = icmp eq i64 %186, 0, !dbg !751
  br i1 %187, label %190, label %188, !dbg !753

188:                                              ; preds = %185
  %189 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @app_event_processor.____fmt.7, i64 0, i64 0), i32 noundef 29) #6, !dbg !754
  br label %236, !dbg !757

190:                                              ; preds = %185
  %191 = call i64 inttoptr (i64 171 to i64 (%struct.bpf_timer*, i64, i64)*)(%struct.bpf_timer* noundef nonnull %180, i64 noundef 1000000000, i64 noundef 0) #6, !dbg !758
  call void @llvm.dbg.value(metadata i64 %191, metadata !231, metadata !DIExpression()) #6, !dbg !702
  %192 = icmp eq i64 %191, 0, !dbg !759
  br i1 %192, label %195, label %193, !dbg !761

193:                                              ; preds = %190
  %194 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @app_event_processor.____fmt.8, i64 0, i64 0), i32 noundef 19) #6, !dbg !762
  br label %236, !dbg !765

195:                                              ; preds = %190
  %196 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @app_event_processor.____fmt.9, i64 0, i64 0), i32 noundef 26) #6, !dbg !766
  br label %236, !dbg !769

197:                                              ; preds = %59
  %198 = bitcast %struct.flow_id* %2 to i8*, !dbg !770
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %198), !dbg !770
  %199 = getelementptr inbounds %struct.flow_id, %struct.flow_id* %2, i64 0, i32 0, !dbg !770
  store i32 %40, i32* %199, align 8, !dbg !770
  %200 = getelementptr inbounds %struct.flow_id, %struct.flow_id* %2, i64 0, i32 1, !dbg !770
  store i16 %61, i16* %200, align 4, !dbg !770
  %201 = getelementptr inbounds i8, i8* %198, i64 6, !dbg !770
  %202 = bitcast i8* %201 to i16*, !dbg !770
  call void @llvm.dbg.value(metadata i16 0, metadata !489, metadata !DIExpression(DW_OP_LLVM_fragment, 48, 16)), !dbg !511
  store i16 0, i16* %202, align 2, !dbg !770
  %203 = getelementptr inbounds %struct.flow_id, %struct.flow_id* %2, i64 0, i32 2, !dbg !770
  store i32 %43, i32* %203, align 8, !dbg !770
  %204 = getelementptr inbounds %struct.flow_id, %struct.flow_id* %2, i64 0, i32 3, !dbg !770
  store i16 %64, i16* %204, align 4, !dbg !770
  %205 = getelementptr inbounds i8, i8* %198, i64 14, !dbg !770
  %206 = bitcast i8* %205 to i16*, !dbg !770
  call void @llvm.dbg.value(metadata i16 0, metadata !489, metadata !DIExpression(DW_OP_LLVM_fragment, 112, 16)), !dbg !511
  store i16 0, i16* %206, align 2, !dbg !770
  call void @llvm.dbg.declare(metadata %struct.flow_id* %2, metadata !402, metadata !DIExpression()) #6, !dbg !770
  %207 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon.4* @timeout_array to i8*), i8* noundef nonnull %198) #6, !dbg !774
  call void @llvm.dbg.value(metadata i8* %207, metadata !403, metadata !DIExpression()) #6, !dbg !775
  %208 = icmp eq i8* %207, null, !dbg !776
  br i1 %208, label %209, label %211, !dbg !778

209:                                              ; preds = %197
  %210 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([40 x i8], [40 x i8]* @resend_packet.____fmt, i64 0, i64 0), i32 noundef 40) #6, !dbg !779
  br label %235, !dbg !782

211:                                              ; preds = %197
  %212 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon.1* @tcp_connections to i8*), i8* noundef nonnull %198) #6, !dbg !783
  call void @llvm.dbg.value(metadata i8* %212, metadata !404, metadata !DIExpression()) #6, !dbg !775
  %213 = icmp eq i8* %212, null, !dbg !784
  br i1 %213, label %214, label %216, !dbg !786

214:                                              ; preds = %211
  %215 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @resend_packet.____fmt.20, i64 0, i64 0), i32 noundef 36) #6, !dbg !787
  br label %235, !dbg !790

216:                                              ; preds = %211
  %217 = getelementptr inbounds i8, i8* %212, i64 8, !dbg !791
  %218 = bitcast i8* %217 to i32*, !dbg !791
  %219 = load i32, i32* %218, align 4, !dbg !791, !tbaa !638
  %220 = getelementptr inbounds i8, i8* %207, i64 8, !dbg !792
  %221 = bitcast i8* %220 to i32*, !dbg !792
  %222 = load i32, i32* %221, align 8, !dbg !792, !tbaa !793
  %223 = icmp eq i32 %219, %222, !dbg !795
  br i1 %223, label %224, label %235, !dbg !796

224:                                              ; preds = %216
  %225 = getelementptr inbounds i8, i8* %212, i64 16, !dbg !797
  %226 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon.2* @window_packets to i8*), i8* noundef nonnull %225) #6, !dbg !798
  call void @llvm.dbg.value(metadata i8* %226, metadata !405, metadata !DIExpression()) #6, !dbg !799
  %227 = icmp eq i8* %226, null, !dbg !800
  br i1 %227, label %228, label %230, !dbg !802

228:                                              ; preds = %224
  %229 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([24 x i8], [24 x i8]* @resend_packet.____fmt.21, i64 0, i64 0), i32 noundef 24) #6, !dbg !803
  br label %235, !dbg !806

230:                                              ; preds = %224
  call void @llvm.dbg.value(metadata i8* %226, metadata !405, metadata !DIExpression()) #6, !dbg !799
  call void @llvm.dbg.value(metadata i8* %226, metadata !301, metadata !DIExpression()) #6, !dbg !807
  %231 = getelementptr inbounds i8, i8* %226, i64 8, !dbg !809
  %232 = bitcast i8* %231 to i32*, !dbg !809
  %233 = load i32, i32* %232, align 8, !dbg !809, !tbaa !811
  %234 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @send_packet.____fmt, i64 0, i64 0), i32 noundef 16, i32 noundef %233) #6, !dbg !809
  br label %235, !dbg !813

235:                                              ; preds = %209, %214, %216, %228, %230
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %198), !dbg !814
  br label %236, !dbg !815

236:                                              ; preds = %59, %195, %193, %188, %171, %149, %134, %132, %126, %108, %91, %89, %84, %79, %235
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %69) #6, !dbg !816
  br label %237

237:                                              ; preds = %236, %31, %48, %55, %27, %22, %1
  %238 = phi i32 [ -1, %1 ], [ -1, %22 ], [ -1, %27 ], [ 1, %236 ], [ -1, %31 ], [ -1, %48 ], [ -1, %55 ], !dbg !511
  ret i32 %238, !dbg !816
}

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #3

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
declare i16 @llvm.bswap.i16(i16) #1

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
declare i32 @llvm.bswap.i32(i32) #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nounwind
define internal i64 @app_event_send(i32 noundef %0, %struct.flow_id* noundef %1) #0 !dbg !269 {
  %3 = alloca i32, align 4
  %4 = alloca %struct.packet_event, align 8
  call void @llvm.dbg.value(metadata i32 %0, metadata !273, metadata !DIExpression()), !dbg !817
  call void @llvm.dbg.value(metadata %struct.flow_id* %1, metadata !274, metadata !DIExpression()), !dbg !817
  %5 = bitcast %struct.flow_id* %1 to i8*, !dbg !818
  %6 = tail call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon.1* @tcp_connections to i8*), i8* noundef %5) #6, !dbg !819
  call void @llvm.dbg.value(metadata i8* %6, metadata !275, metadata !DIExpression()), !dbg !817
  %7 = icmp eq i8* %6, null, !dbg !820
  br i1 %7, label %8, label %10, !dbg !822

8:                                                ; preds = %2
  %9 = tail call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @app_event_send.____fmt, i64 0, i64 0), i32 noundef 38) #6, !dbg !823
  br label %53, !dbg !826

10:                                               ; preds = %2
  call void @llvm.dbg.value(metadata i8* %6, metadata !275, metadata !DIExpression()), !dbg !817
  %11 = bitcast %struct.packet_event* %4 to i8*, !dbg !827
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %11) #6, !dbg !827
  call void @llvm.dbg.declare(metadata %struct.packet_event* %4, metadata !276, metadata !DIExpression()), !dbg !828
  %12 = getelementptr inbounds %struct.packet_event, %struct.packet_event* %4, i64 0, i32 0, !dbg !829
  store %struct.flow_id* %1, %struct.flow_id** %12, align 8, !dbg !830, !tbaa !831
  %13 = bitcast i8* %6 to i32*, !dbg !832
  %14 = load i32, i32* %13, align 4, !dbg !832, !tbaa !833
  %15 = getelementptr inbounds %struct.packet_event, %struct.packet_event* %4, i64 0, i32 2, !dbg !834
  store i32 %14, i32* %15, align 4, !dbg !835, !tbaa !836
  %16 = getelementptr inbounds i8, i8* %6, i64 12, !dbg !837
  %17 = bitcast i8* %16 to i32*, !dbg !837
  %18 = load i32, i32* %17, align 4, !dbg !837, !tbaa !647
  %19 = add i32 %18, 1, !dbg !838
  %20 = getelementptr inbounds %struct.packet_event, %struct.packet_event* %4, i64 0, i32 1, !dbg !839
  store i32 %19, i32* %20, align 8, !dbg !840, !tbaa !811
  call void @llvm.dbg.value(metadata %struct.packet_event* %4, metadata !283, metadata !DIExpression()) #6, !dbg !841
  call void @llvm.dbg.value(metadata %struct.flow_id* %1, metadata !284, metadata !DIExpression()) #6, !dbg !841
  %21 = tail call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon.1* @tcp_connections to i8*), i8* noundef %5) #6, !dbg !843
  call void @llvm.dbg.value(metadata i8* %21, metadata !285, metadata !DIExpression()) #6, !dbg !841
  %22 = icmp eq i8* %21, null, !dbg !844
  br i1 %22, label %23, label %25, !dbg !846

23:                                               ; preds = %10
  %24 = tail call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([37 x i8], [37 x i8]* @enque.____fmt, i64 0, i64 0), i32 noundef 37) #6, !dbg !847
  br label %49, !dbg !850

25:                                               ; preds = %10
  %26 = getelementptr inbounds i8, i8* %21, i64 20, !dbg !851
  %27 = bitcast i8* %26 to i32*, !dbg !851
  %28 = load i32, i32* %27, align 4, !dbg !851, !tbaa !853
  %29 = getelementptr inbounds i8, i8* %21, i64 4, !dbg !854
  %30 = bitcast i8* %29 to i32*, !dbg !854
  %31 = load i32, i32* %30, align 4, !dbg !854, !tbaa !855
  %32 = icmp eq i32 %28, %31, !dbg !856
  br i1 %32, label %33, label %35, !dbg !857

33:                                               ; preds = %25
  %34 = tail call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([47 x i8], [47 x i8]* @enque.____fmt.10, i64 0, i64 0), i32 noundef 47) #6, !dbg !858
  br label %49, !dbg !861

35:                                               ; preds = %25
  call void @llvm.dbg.value(metadata %struct.packet_event* %4, metadata !301, metadata !DIExpression()) #6, !dbg !862
  %36 = tail call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @send_packet.____fmt, i64 0, i64 0), i32 noundef 16, i32 noundef %19) #6, !dbg !864
  %37 = bitcast i32* %3 to i8*, !dbg !865
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %37) #6, !dbg !865
  %38 = getelementptr inbounds i8, i8* %21, i64 16, !dbg !866
  %39 = bitcast i8* %38 to i32*, !dbg !866
  %40 = load i32, i32* %39, align 4, !dbg !866, !tbaa !867
  %41 = load i32, i32* %27, align 4, !dbg !868, !tbaa !853
  %42 = add i32 %41, %40, !dbg !869
  %43 = load i32, i32* %30, align 4, !dbg !870, !tbaa !855
  %44 = urem i32 %42, %43, !dbg !871
  call void @llvm.dbg.value(metadata i32 %44, metadata !286, metadata !DIExpression()) #6, !dbg !841
  store i32 %44, i32* %3, align 4, !dbg !872, !tbaa !873
  call void @llvm.dbg.value(metadata i32* %3, metadata !286, metadata !DIExpression(DW_OP_deref)) #6, !dbg !841
  %45 = call i64 inttoptr (i64 2 to i64 (i8*, i8*, i8*, i64)*)(i8* noundef bitcast (%struct.anon.2* @window_packets to i8*), i8* noundef nonnull %37, i8* noundef nonnull %11, i64 noundef 0) #6, !dbg !874
  %46 = load i32, i32* %27, align 4, !dbg !875, !tbaa !853
  %47 = add i32 %46, 1, !dbg !875
  store i32 %47, i32* %27, align 4, !dbg !875, !tbaa !853
  %48 = call i64 inttoptr (i64 2 to i64 (i8*, i8*, i8*, i64)*)(i8* noundef bitcast (%struct.anon.1* @tcp_connections to i8*), i8* noundef %5, i8* noundef nonnull %21, i64 noundef 0) #6, !dbg !876
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %37) #6, !dbg !877
  br label %49

49:                                               ; preds = %23, %33, %35
  %50 = load i32, i32* %17, align 4, !dbg !878, !tbaa !647
  %51 = add i32 %50, 1, !dbg !878
  store i32 %51, i32* %17, align 4, !dbg !878, !tbaa !647
  %52 = call i64 inttoptr (i64 2 to i64 (i8*, i8*, i8*, i64)*)(i8* noundef bitcast (%struct.anon.1* @tcp_connections to i8*), i8* noundef %5, i8* noundef nonnull %6, i64 noundef 0) #6, !dbg !879
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %11) #6, !dbg !880
  br label %53

53:                                               ; preds = %49, %8
  ret i64 0, !dbg !880
}

; Function Attrs: alwaysinline nounwind
define internal i32 @timer_callback(i8* nocapture noundef readnone %0, %struct.flow_id* noundef %1, %struct.map_elem* noundef %2) #4 !dbg !318 {
  %4 = alloca %struct.timeout_event, align 8
  call void @llvm.dbg.value(metadata i8* %0, metadata !322, metadata !DIExpression()), !dbg !881
  call void @llvm.dbg.value(metadata %struct.flow_id* %1, metadata !323, metadata !DIExpression()), !dbg !881
  call void @llvm.dbg.value(metadata %struct.map_elem* %2, metadata !324, metadata !DIExpression()), !dbg !881
  %5 = getelementptr inbounds %struct.map_elem, %struct.map_elem* %2, i64 0, i32 1, !dbg !882
  %6 = load i32, i32* %5, align 8, !dbg !882, !tbaa !666
  %7 = tail call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @timer_callback.____fmt, i64 0, i64 0), i32 noundef 19, i32 noundef %6) #6, !dbg !882
  %8 = bitcast %struct.timeout_event* %4 to i8*, !dbg !884
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %8) #6, !dbg !884
  call void @llvm.dbg.declare(metadata %struct.timeout_event* %4, metadata !325, metadata !DIExpression()), !dbg !885
  %9 = getelementptr inbounds %struct.timeout_event, %struct.timeout_event* %4, i64 0, i32 1, !dbg !886
  %10 = bitcast i32* %9 to i64*, !dbg !886
  store i64 0, i64* %10, align 8, !dbg !886
  %11 = load i32, i32* %5, align 8, !dbg !887, !tbaa !666
  %12 = getelementptr inbounds %struct.timeout_event, %struct.timeout_event* %4, i64 0, i32 1, !dbg !888
  store i32 %11, i32* %12, align 8, !dbg !889, !tbaa !793
  %13 = getelementptr inbounds %struct.timeout_event, %struct.timeout_event* %4, i64 0, i32 0, !dbg !890
  store %struct.flow_id* %1, %struct.flow_id** %13, align 8, !dbg !891, !tbaa !892
  %14 = bitcast %struct.flow_id* %1 to i8*, !dbg !893
  %15 = call i64 inttoptr (i64 2 to i64 (i8*, i8*, i8*, i64)*)(i8* noundef bitcast (%struct.anon.4* @timeout_array to i8*), i8* noundef %14, i8* noundef nonnull %8, i64 noundef 0) #6, !dbg !894
  %16 = getelementptr inbounds %struct.map_elem, %struct.map_elem* %2, i64 0, i32 2, !dbg !895
  %17 = call i64 inttoptr (i64 171 to i64 (%struct.bpf_timer*, i64, i64)*)(%struct.bpf_timer* noundef nonnull %16, i64 noundef 1000000000, i64 noundef 0) #6, !dbg !896
  %18 = trunc i64 %17 to i32, !dbg !896
  call void @llvm.dbg.value(metadata i32 %18, metadata !326, metadata !DIExpression()), !dbg !881
  %19 = icmp eq i32 %18, 0, !dbg !897
  br i1 %19, label %22, label %20, !dbg !899

20:                                               ; preds = %3
  %21 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @timer_callback.____fmt.11, i64 0, i64 0), i32 noundef 19) #6, !dbg !900
  br label %22, !dbg !903

22:                                               ; preds = %3, %20
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %8) #6, !dbg !904
  ret i32 0, !dbg !904
}

; Function Attrs: nounwind
define internal i64 @update_window(i32 noundef %0, %struct.flow_id* noundef %1) #0 !dbg !374 {
  %3 = alloca i32, align 4
  %4 = alloca %struct.packet_event, align 8
  call void @llvm.dbg.value(metadata i32 %0, metadata !376, metadata !DIExpression()), !dbg !905
  call void @llvm.dbg.value(metadata %struct.flow_id* %1, metadata !377, metadata !DIExpression()), !dbg !905
  %5 = bitcast %struct.flow_id* %1 to i8*, !dbg !906
  %6 = tail call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon.1* @tcp_connections to i8*), i8* noundef %5) #6, !dbg !907
  call void @llvm.dbg.value(metadata i8* %6, metadata !378, metadata !DIExpression()), !dbg !905
  %7 = icmp eq i8* %6, null, !dbg !908
  br i1 %7, label %8, label %10, !dbg !910

8:                                                ; preds = %2
  %9 = tail call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @update_window.____fmt, i64 0, i64 0), i32 noundef 38) #6, !dbg !911
  br label %89, !dbg !914

10:                                               ; preds = %2
  call void @llvm.dbg.value(metadata %struct.flow_id* %1, metadata !386, metadata !DIExpression()) #6, !dbg !915
  %11 = tail call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon.1* @tcp_connections to i8*), i8* noundef %5) #6, !dbg !917
  call void @llvm.dbg.value(metadata i8* %11, metadata !387, metadata !DIExpression()) #6, !dbg !915
  %12 = icmp eq i8* %11, null, !dbg !918
  br i1 %12, label %13, label %15, !dbg !920

13:                                               ; preds = %10
  %14 = tail call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([37 x i8], [37 x i8]* @deque.____fmt, i64 0, i64 0), i32 noundef 37) #6, !dbg !921
  br label %39, !dbg !924

15:                                               ; preds = %10
  %16 = getelementptr inbounds i8, i8* %11, i64 20, !dbg !925
  %17 = bitcast i8* %16 to i32*, !dbg !925
  %18 = load i32, i32* %17, align 4, !dbg !925, !tbaa !853
  %19 = icmp eq i32 %18, 0, !dbg !927
  br i1 %19, label %20, label %22, !dbg !928

20:                                               ; preds = %15
  %21 = tail call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([46 x i8], [46 x i8]* @deque.____fmt.18, i64 0, i64 0), i32 noundef 46) #6, !dbg !929
  br label %39, !dbg !932

22:                                               ; preds = %15
  %23 = getelementptr inbounds i8, i8* %11, i64 16, !dbg !933
  %24 = bitcast i8* %23 to i32*, !dbg !933
  %25 = tail call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon.2* @window_packets to i8*), i8* noundef nonnull %23) #6, !dbg !934
  call void @llvm.dbg.value(metadata i8* %25, metadata !388, metadata !DIExpression()) #6, !dbg !915
  %26 = icmp eq i8* %25, null, !dbg !935
  br i1 %26, label %27, label %29, !dbg !937

27:                                               ; preds = %22
  %28 = tail call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([33 x i8], [33 x i8]* @deque.____fmt.19, i64 0, i64 0), i32 noundef 33) #6, !dbg !938
  br label %39, !dbg !941

29:                                               ; preds = %22
  %30 = load i32, i32* %24, align 4, !dbg !942, !tbaa !867
  %31 = add i32 %30, 1, !dbg !943
  %32 = getelementptr inbounds i8, i8* %11, i64 4, !dbg !944
  %33 = bitcast i8* %32 to i32*, !dbg !944
  %34 = load i32, i32* %33, align 4, !dbg !944, !tbaa !855
  %35 = urem i32 %31, %34, !dbg !945
  store i32 %35, i32* %24, align 4, !dbg !946, !tbaa !867
  %36 = load i32, i32* %17, align 4, !dbg !947, !tbaa !853
  %37 = add i32 %36, -1, !dbg !947
  store i32 %37, i32* %17, align 4, !dbg !947, !tbaa !853
  %38 = tail call i64 inttoptr (i64 2 to i64 (i8*, i8*, i8*, i64)*)(i8* noundef bitcast (%struct.anon.1* @tcp_connections to i8*), i8* noundef %5, i8* noundef nonnull %11, i64 noundef 0) #6, !dbg !948
  br label %39, !dbg !949

39:                                               ; preds = %13, %20, %27, %29
  %40 = getelementptr inbounds i8, i8* %6, i64 24, !dbg !950
  %41 = bitcast i8* %40 to i32*, !dbg !950
  %42 = load i32, i32* %41, align 4, !dbg !950, !tbaa !645
  %43 = getelementptr inbounds i8, i8* %6, i64 12, !dbg !952
  %44 = bitcast i8* %43 to i32*, !dbg !952
  %45 = load i32, i32* %44, align 4, !dbg !952, !tbaa !647
  %46 = add i32 %45, 1, !dbg !953
  %47 = icmp eq i32 %42, %46, !dbg !954
  br i1 %47, label %89, label %48, !dbg !955

48:                                               ; preds = %39
  %49 = bitcast %struct.packet_event* %4 to i8*, !dbg !956
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %49) #6, !dbg !956
  call void @llvm.dbg.declare(metadata %struct.packet_event* %4, metadata !379, metadata !DIExpression()), !dbg !957
  %50 = getelementptr inbounds %struct.packet_event, %struct.packet_event* %4, i64 0, i32 0, !dbg !958
  store %struct.flow_id* %1, %struct.flow_id** %50, align 8, !dbg !959, !tbaa !831
  %51 = bitcast i8* %6 to i32*, !dbg !960
  %52 = load i32, i32* %51, align 4, !dbg !960, !tbaa !833
  %53 = getelementptr inbounds %struct.packet_event, %struct.packet_event* %4, i64 0, i32 2, !dbg !961
  store i32 %52, i32* %53, align 4, !dbg !962, !tbaa !836
  %54 = load i32, i32* %44, align 4, !dbg !963, !tbaa !647
  %55 = add i32 %54, 1, !dbg !964
  %56 = getelementptr inbounds %struct.packet_event, %struct.packet_event* %4, i64 0, i32 1, !dbg !965
  store i32 %55, i32* %56, align 8, !dbg !966, !tbaa !811
  call void @llvm.dbg.value(metadata %struct.packet_event* %4, metadata !283, metadata !DIExpression()) #6, !dbg !967
  call void @llvm.dbg.value(metadata %struct.flow_id* %1, metadata !284, metadata !DIExpression()) #6, !dbg !967
  %57 = tail call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon.1* @tcp_connections to i8*), i8* noundef %5) #6, !dbg !969
  call void @llvm.dbg.value(metadata i8* %57, metadata !285, metadata !DIExpression()) #6, !dbg !967
  %58 = icmp eq i8* %57, null, !dbg !970
  br i1 %58, label %59, label %61, !dbg !971

59:                                               ; preds = %48
  %60 = tail call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([37 x i8], [37 x i8]* @enque.____fmt, i64 0, i64 0), i32 noundef 37) #6, !dbg !972
  br label %85, !dbg !973

61:                                               ; preds = %48
  %62 = getelementptr inbounds i8, i8* %57, i64 20, !dbg !974
  %63 = bitcast i8* %62 to i32*, !dbg !974
  %64 = load i32, i32* %63, align 4, !dbg !974, !tbaa !853
  %65 = getelementptr inbounds i8, i8* %57, i64 4, !dbg !975
  %66 = bitcast i8* %65 to i32*, !dbg !975
  %67 = load i32, i32* %66, align 4, !dbg !975, !tbaa !855
  %68 = icmp eq i32 %64, %67, !dbg !976
  br i1 %68, label %69, label %71, !dbg !977

69:                                               ; preds = %61
  %70 = tail call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([47 x i8], [47 x i8]* @enque.____fmt.10, i64 0, i64 0), i32 noundef 47) #6, !dbg !978
  br label %85, !dbg !979

71:                                               ; preds = %61
  call void @llvm.dbg.value(metadata %struct.packet_event* %4, metadata !301, metadata !DIExpression()) #6, !dbg !980
  %72 = tail call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @send_packet.____fmt, i64 0, i64 0), i32 noundef 16, i32 noundef %55) #6, !dbg !982
  %73 = bitcast i32* %3 to i8*, !dbg !983
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %73) #6, !dbg !983
  %74 = getelementptr inbounds i8, i8* %57, i64 16, !dbg !984
  %75 = bitcast i8* %74 to i32*, !dbg !984
  %76 = load i32, i32* %75, align 4, !dbg !984, !tbaa !867
  %77 = load i32, i32* %63, align 4, !dbg !985, !tbaa !853
  %78 = add i32 %77, %76, !dbg !986
  %79 = load i32, i32* %66, align 4, !dbg !987, !tbaa !855
  %80 = urem i32 %78, %79, !dbg !988
  call void @llvm.dbg.value(metadata i32 %80, metadata !286, metadata !DIExpression()) #6, !dbg !967
  store i32 %80, i32* %3, align 4, !dbg !989, !tbaa !873
  call void @llvm.dbg.value(metadata i32* %3, metadata !286, metadata !DIExpression(DW_OP_deref)) #6, !dbg !967
  %81 = call i64 inttoptr (i64 2 to i64 (i8*, i8*, i8*, i64)*)(i8* noundef bitcast (%struct.anon.2* @window_packets to i8*), i8* noundef nonnull %73, i8* noundef nonnull %49, i64 noundef 0) #6, !dbg !990
  %82 = load i32, i32* %63, align 4, !dbg !991, !tbaa !853
  %83 = add i32 %82, 1, !dbg !991
  store i32 %83, i32* %63, align 4, !dbg !991, !tbaa !853
  %84 = call i64 inttoptr (i64 2 to i64 (i8*, i8*, i8*, i64)*)(i8* noundef bitcast (%struct.anon.1* @tcp_connections to i8*), i8* noundef %5, i8* noundef nonnull %57, i64 noundef 0) #6, !dbg !992
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %73) #6, !dbg !993
  br label %85

85:                                               ; preds = %59, %69, %71
  %86 = load i32, i32* %44, align 4, !dbg !994, !tbaa !647
  %87 = add i32 %86, 1, !dbg !994
  store i32 %87, i32* %44, align 4, !dbg !994, !tbaa !647
  %88 = call i64 inttoptr (i64 2 to i64 (i8*, i8*, i8*, i64)*)(i8* noundef bitcast (%struct.anon.1* @tcp_connections to i8*), i8* noundef %5, i8* noundef nonnull %6, i64 noundef 0) #6, !dbg !995
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %49) #6, !dbg !996
  br label %89

89:                                               ; preds = %39, %85, %8
  ret i64 0, !dbg !996
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #5

attributes #0 = { nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #3 = { argmemonly mustprogress nofree nounwind willreturn writeonly }
attributes #4 = { alwaysinline nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #5 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!20}
!llvm.module.flags = !{!506, !507, !508, !509}
!llvm.ident = !{!510}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "____fmt", scope: !2, file: !3, line: 338, type: !503, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "simply_drop", scope: !3, file: !3, line: 332, type: !4, scopeLine: 333, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !415)
!3 = !DIFile(filename: "xdp_prog_kern.c", directory: "/home/a68lin/XDP-Tryouts/xdp/event-processor", checksumkind: CSK_MD5, checksum: "b9d2f7df6d7ffb29b15619f42fd0ceac")
!4 = !DISubroutineType(types: !5)
!5 = !{!6, !7}
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!8 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !9, line: 5442, size: 192, elements: !10)
!9 = !DIFile(filename: "/usr/include/linux/bpf.h", directory: "", checksumkind: CSK_MD5, checksum: "5ad8bc925dae1ec87bbb04b3148b183b")
!10 = !{!11, !15, !16, !17, !18, !19}
!11 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !8, file: !9, line: 5443, baseType: !12, size: 32)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !13, line: 27, baseType: !14)
!13 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!14 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!15 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !8, file: !9, line: 5444, baseType: !12, size: 32, offset: 32)
!16 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !8, file: !9, line: 5445, baseType: !12, size: 32, offset: 64)
!17 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !8, file: !9, line: 5447, baseType: !12, size: 32, offset: 96)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !8, file: !9, line: 5448, baseType: !12, size: 32, offset: 128)
!19 = !DIDerivedType(tag: DW_TAG_member, name: "egress_ifindex", scope: !8, file: !9, line: 5450, baseType: !12, size: 32, offset: 160)
!20 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !21, retainedTypes: !41, globals: !46, splitDebugInlining: false, nameTableKind: None)
!21 = !{!22, !29, !35}
!22 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !9, line: 5431, baseType: !14, size: 32, elements: !23)
!23 = !{!24, !25, !26, !27, !28}
!24 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!25 = !DIEnumerator(name: "XDP_DROP", value: 1)
!26 = !DIEnumerator(name: "XDP_PASS", value: 2)
!27 = !DIEnumerator(name: "XDP_TX", value: 3)
!28 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!29 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !9, line: 1168, baseType: !14, size: 32, elements: !30)
!30 = !{!31, !32, !33, !34}
!31 = !DIEnumerator(name: "BPF_ANY", value: 0)
!32 = !DIEnumerator(name: "BPF_NOEXIST", value: 1)
!33 = !DIEnumerator(name: "BPF_EXIST", value: 2)
!34 = !DIEnumerator(name: "BPF_F_LOCK", value: 4)
!35 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "event_type", file: !3, line: 19, baseType: !14, size: 32, elements: !36)
!36 = !{!37, !38, !39, !40}
!37 = !DIEnumerator(name: "APP_EVENT", value: 0)
!38 = !DIEnumerator(name: "PACKET_EVENT", value: 1)
!39 = !DIEnumerator(name: "NET_EVENT", value: 2)
!40 = !DIEnumerator(name: "TIMEOUT_EVENT", value: 3)
!41 = !{!42, !43, !44, !12}
!42 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!43 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!44 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !13, line: 24, baseType: !45)
!45 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!46 = !{!0, !47, !54, !59, !64, !69, !103, !126, !142, !159, !165, !171, !178, !185, !217, !235, !240, !245, !250, !255, !257, !262, !267, !277, !290, !295, !305, !311, !316, !327, !329, !334, !346, !351, !356, !361, !363, !365, !367, !372, !380, !389, !394, !396, !411, !413}
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(name: "____fmt", scope: !2, file: !3, line: 369, type: !49, isLocal: true, isDefinition: true)
!49 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 56, elements: !52)
!50 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !51)
!51 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!52 = !{!53}
!53 = !DISubrange(count: 7)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "____fmt", scope: !2, file: !3, line: 413, type: !56, isLocal: true, isDefinition: true)
!56 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 288, elements: !57)
!57 = !{!58}
!58 = !DISubrange(count: 36)
!59 = !DIGlobalVariableExpression(var: !60, expr: !DIExpression())
!60 = distinct !DIGlobalVariable(name: "____fmt", scope: !2, file: !3, line: 417, type: !61, isLocal: true, isDefinition: true)
!61 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 224, elements: !62)
!62 = !{!63}
!63 = !DISubrange(count: 28)
!64 = !DIGlobalVariableExpression(var: !65, expr: !DIExpression())
!65 = distinct !DIGlobalVariable(name: "_license", scope: !20, file: !3, line: 442, type: !66, isLocal: false, isDefinition: true)
!66 = !DICompositeType(tag: DW_TAG_array_type, baseType: !51, size: 32, elements: !67)
!67 = !{!68}
!68 = !DISubrange(count: 4)
!69 = !DIGlobalVariableExpression(var: !70, expr: !DIExpression())
!70 = distinct !DIGlobalVariable(name: "tcp_connections", scope: !20, file: !3, line: 58, type: !71, isLocal: false, isDefinition: true)
!71 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 52, size: 256, elements: !72)
!72 = !{!73, !78, !83, !92}
!73 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !71, file: !3, line: 54, baseType: !74, size: 64)
!74 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !75, size: 64)
!75 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 32, elements: !76)
!76 = !{!77}
!77 = !DISubrange(count: 1)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !71, file: !3, line: 55, baseType: !79, size: 64, offset: 64)
!79 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !80, size: 64)
!80 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 1024, elements: !81)
!81 = !{!82}
!82 = !DISubrange(count: 32)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !71, file: !3, line: 56, baseType: !84, size: 64, offset: 128)
!84 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !85, size: 64)
!85 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "flow_id", file: !86, line: 3, size: 128, elements: !87)
!86 = !DIFile(filename: "./common.h", directory: "/home/a68lin/XDP-Tryouts/xdp/event-processor", checksumkind: CSK_MD5, checksum: "23119144d5fc7b4eabbc877082e69c73")
!87 = !{!88, !89, !90, !91}
!88 = !DIDerivedType(tag: DW_TAG_member, name: "sender_ip", scope: !85, file: !86, line: 4, baseType: !12, size: 32)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "sender_port", scope: !85, file: !86, line: 5, baseType: !44, size: 16, offset: 32)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "receiver_ip", scope: !85, file: !86, line: 6, baseType: !12, size: 32, offset: 64)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "receiver_port", scope: !85, file: !86, line: 7, baseType: !44, size: 16, offset: 96)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !71, file: !3, line: 57, baseType: !93, size: 64, offset: 192)
!93 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !94, size: 64)
!94 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "tcp_md", file: !86, line: 10, size: 224, elements: !95)
!95 = !{!96, !97, !98, !99, !100, !101, !102}
!96 = !DIDerivedType(tag: DW_TAG_member, name: "segment_size", scope: !94, file: !86, line: 12, baseType: !12, size: 32)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "window_size", scope: !94, file: !86, line: 14, baseType: !12, size: 32, offset: 32)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "window_start_seq", scope: !94, file: !86, line: 16, baseType: !12, size: 32, offset: 64)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "last_seq_sent", scope: !94, file: !86, line: 18, baseType: !12, size: 32, offset: 96)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !94, file: !86, line: 22, baseType: !12, size: 32, offset: 128)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "cur_size", scope: !94, file: !86, line: 24, baseType: !12, size: 32, offset: 160)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "data_size", scope: !94, file: !86, line: 27, baseType: !12, size: 32, offset: 192)
!103 = !DIGlobalVariableExpression(var: !104, expr: !DIExpression())
!104 = distinct !DIGlobalVariable(name: "window_packets", scope: !20, file: !3, line: 66, type: !105, isLocal: false, isDefinition: true)
!105 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 60, size: 256, elements: !106)
!106 = !{!107, !112, !117, !119}
!107 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !105, file: !3, line: 62, baseType: !108, size: 64)
!108 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !109, size: 64)
!109 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 64, elements: !110)
!110 = !{!111}
!111 = !DISubrange(count: 2)
!112 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !105, file: !3, line: 63, baseType: !113, size: 64, offset: 64)
!113 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !114, size: 64)
!114 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 160, elements: !115)
!115 = !{!116}
!116 = !DISubrange(count: 5)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !105, file: !3, line: 64, baseType: !118, size: 64, offset: 128)
!118 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !105, file: !3, line: 65, baseType: !120, size: 64, offset: 192)
!120 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !121, size: 64)
!121 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "packet_event", file: !3, line: 36, size: 128, elements: !122)
!122 = !{!123, !124, !125}
!123 = !DIDerivedType(tag: DW_TAG_member, name: "fid", scope: !121, file: !3, line: 37, baseType: !84, size: 64)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "seq_num", scope: !121, file: !3, line: 38, baseType: !6, size: 32, offset: 64)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "size", scope: !121, file: !3, line: 39, baseType: !12, size: 32, offset: 96)
!126 = !DIGlobalVariableExpression(var: !127, expr: !DIExpression())
!127 = distinct !DIGlobalVariable(name: "timer_array", scope: !20, file: !3, line: 79, type: !128, isLocal: false, isDefinition: true)
!128 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 74, size: 256, elements: !129)
!129 = !{!130, !131, !132, !141}
!130 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !128, file: !3, line: 75, baseType: !74, size: 64)
!131 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !128, file: !3, line: 76, baseType: !84, size: 64, offset: 64)
!132 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !128, file: !3, line: 77, baseType: !133, size: 64, offset: 128)
!133 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !134, size: 64)
!134 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "map_elem", file: !3, line: 68, size: 256, elements: !135)
!135 = !{!136, !137, !138}
!136 = !DIDerivedType(tag: DW_TAG_member, name: "fid", scope: !134, file: !3, line: 69, baseType: !84, size: 64)
!137 = !DIDerivedType(tag: DW_TAG_member, name: "seq_num", scope: !134, file: !3, line: 70, baseType: !6, size: 32, offset: 64)
!138 = !DIDerivedType(tag: DW_TAG_member, name: "timer", scope: !134, file: !3, line: 71, baseType: !139, size: 128, align: 64, offset: 128)
!139 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_timer", file: !9, line: 6185, size: 128, align: 64, elements: !140)
!140 = !{}
!141 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !128, file: !3, line: 78, baseType: !113, size: 64, offset: 192)
!142 = !DIGlobalVariableExpression(var: !143, expr: !DIExpression())
!143 = distinct !DIGlobalVariable(name: "timeout_array", scope: !20, file: !3, line: 86, type: !144, isLocal: false, isDefinition: true)
!144 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 81, size: 256, elements: !145)
!145 = !{!146, !147, !148, !154}
!146 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !144, file: !3, line: 82, baseType: !74, size: 64)
!147 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !144, file: !3, line: 83, baseType: !84, size: 64, offset: 64)
!148 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !144, file: !3, line: 84, baseType: !149, size: 64, offset: 128)
!149 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !150, size: 64)
!150 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "timeout_event", file: !3, line: 42, size: 128, elements: !151)
!151 = !{!152, !153}
!152 = !DIDerivedType(tag: DW_TAG_member, name: "fid", scope: !150, file: !3, line: 43, baseType: !84, size: 64)
!153 = !DIDerivedType(tag: DW_TAG_member, name: "seq_num", scope: !150, file: !3, line: 44, baseType: !6, size: 32, offset: 64)
!154 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !144, file: !3, line: 85, baseType: !155, size: 64, offset: 192)
!155 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !156, size: 64)
!156 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 32000, elements: !157)
!157 = !{!158}
!158 = !DISubrange(count: 1000)
!159 = !DIGlobalVariableExpression(var: !160, expr: !DIExpression())
!160 = distinct !DIGlobalVariable(name: "bpf_get_smp_processor_id", scope: !20, file: !161, line: 206, type: !162, isLocal: true, isDefinition: true)
!161 = !DIFile(filename: "../lib/install/include/bpf/bpf_helper_defs.h", directory: "/home/a68lin/XDP-Tryouts/xdp/event-processor", checksumkind: CSK_MD5, checksum: "7422ca06c9dc86eba2f268a57d8acf2f")
!162 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !163, size: 64)
!163 = !DISubroutineType(types: !164)
!164 = !{!12}
!165 = !DIGlobalVariableExpression(var: !166, expr: !DIExpression())
!166 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !20, file: !161, line: 177, type: !167, isLocal: true, isDefinition: true)
!167 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !168, size: 64)
!168 = !DISubroutineType(types: !169)
!169 = !{!43, !170, !12, null}
!170 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!171 = !DIGlobalVariableExpression(var: !172, expr: !DIExpression())
!172 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !20, file: !161, line: 56, type: !173, isLocal: true, isDefinition: true)
!173 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !174, size: 64)
!174 = !DISubroutineType(types: !175)
!175 = !{!42, !42, !176}
!176 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !177, size: 64)
!177 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!178 = !DIGlobalVariableExpression(var: !179, expr: !DIExpression())
!179 = distinct !DIGlobalVariable(name: "bpf_map_update_elem", scope: !20, file: !161, line: 78, type: !180, isLocal: true, isDefinition: true)
!180 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !181, size: 64)
!181 = !DISubroutineType(types: !182)
!182 = !{!43, !42, !176, !176, !183}
!183 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !13, line: 31, baseType: !184)
!184 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!185 = !DIGlobalVariableExpression(var: !186, expr: !DIExpression())
!186 = distinct !DIGlobalVariable(name: "____fmt", scope: !187, file: !3, line: 294, type: !214, isLocal: true, isDefinition: true)
!187 = distinct !DISubprogram(name: "dispatcher", scope: !3, file: !3, line: 281, type: !188, scopeLine: 281, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !197)
!188 = !DISubroutineType(types: !189)
!189 = !{null, !190}
!190 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !191, size: 64)
!191 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "event", file: !3, line: 47, size: 128, elements: !192)
!192 = !{!193, !196}
!193 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !191, file: !3, line: 48, baseType: !194, size: 8)
!194 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !13, line: 21, baseType: !195)
!195 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!196 = !DIDerivedType(tag: DW_TAG_member, name: "event_data", scope: !191, file: !3, line: 49, baseType: !42, size: 64, offset: 64)
!197 = !{!198, !199, !207}
!198 = !DILocalVariable(name: "event", arg: 1, scope: !187, file: !3, line: 281, type: !190)
!199 = !DILocalVariable(name: "ae", scope: !200, file: !3, line: 284, type: !202)
!200 = distinct !DILexicalBlock(scope: !201, file: !3, line: 283, column: 25)
!201 = distinct !DILexicalBlock(scope: !187, file: !3, line: 282, column: 26)
!202 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !203, size: 64)
!203 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "app_event", file: !3, line: 26, size: 128, elements: !204)
!204 = !{!205, !206}
!205 = !DIDerivedType(tag: DW_TAG_member, name: "fid", scope: !203, file: !3, line: 27, baseType: !84, size: 64)
!206 = !DIDerivedType(tag: DW_TAG_member, name: "size", scope: !203, file: !3, line: 28, baseType: !12, size: 32, offset: 64)
!207 = !DILocalVariable(name: "ne", scope: !208, file: !3, line: 289, type: !209)
!208 = distinct !DILexicalBlock(scope: !201, file: !3, line: 288, column: 25)
!209 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !210, size: 64)
!210 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "net_event", file: !3, line: 31, size: 128, elements: !211)
!211 = !{!212, !213}
!212 = !DIDerivedType(tag: DW_TAG_member, name: "fid", scope: !210, file: !3, line: 32, baseType: !84, size: 64)
!213 = !DIDerivedType(tag: DW_TAG_member, name: "ack", scope: !210, file: !3, line: 33, baseType: !12, size: 32, offset: 64)
!214 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 192, elements: !215)
!215 = !{!216}
!216 = !DISubrange(count: 24)
!217 = !DIGlobalVariableExpression(var: !218, expr: !DIExpression())
!218 = distinct !DIGlobalVariable(name: "____fmt", scope: !219, file: !3, line: 173, type: !232, isLocal: true, isDefinition: true)
!219 = distinct !DISubprogram(name: "app_event_processor", scope: !3, file: !3, line: 169, type: !220, scopeLine: 169, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !222)
!220 = !DISubroutineType(types: !221)
!221 = !{null, !202}
!222 = !{!223, !224, !225, !226, !227, !228, !231}
!223 = !DILocalVariable(name: "ae", arg: 1, scope: !219, file: !3, line: 169, type: !202)
!224 = !DILocalVariable(name: "tcp_ctx", scope: !219, file: !3, line: 171, type: !93)
!225 = !DILocalVariable(name: "data_rest", scope: !219, file: !3, line: 176, type: !6)
!226 = !DILocalVariable(name: "num_to_send", scope: !219, file: !3, line: 177, type: !6)
!227 = !DILocalVariable(name: "map_entry", scope: !219, file: !3, line: 181, type: !133)
!228 = !DILocalVariable(name: "me", scope: !229, file: !3, line: 184, type: !134)
!229 = distinct !DILexicalBlock(scope: !230, file: !3, line: 182, column: 21)
!230 = distinct !DILexicalBlock(scope: !219, file: !3, line: 182, column: 9)
!231 = !DILocalVariable(name: "i", scope: !219, file: !3, line: 195, type: !43)
!232 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 304, elements: !233)
!233 = !{!234}
!234 = !DISubrange(count: 38)
!235 = !DIGlobalVariableExpression(var: !236, expr: !DIExpression())
!236 = distinct !DIGlobalVariable(name: "____fmt", scope: !219, file: !3, line: 183, type: !237, isLocal: true, isDefinition: true)
!237 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 264, elements: !238)
!238 = !{!239}
!239 = !DISubrange(count: 33)
!240 = !DIGlobalVariableExpression(var: !241, expr: !DIExpression())
!241 = distinct !DIGlobalVariable(name: "____fmt", scope: !219, file: !3, line: 189, type: !242, isLocal: true, isDefinition: true)
!242 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 216, elements: !243)
!243 = !{!244}
!244 = !DISubrange(count: 27)
!245 = !DIGlobalVariableExpression(var: !246, expr: !DIExpression())
!246 = distinct !DIGlobalVariable(name: "____fmt", scope: !219, file: !3, line: 197, type: !247, isLocal: true, isDefinition: true)
!247 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 152, elements: !248)
!248 = !{!249}
!249 = !DISubrange(count: 19)
!250 = !DIGlobalVariableExpression(var: !251, expr: !DIExpression())
!251 = distinct !DIGlobalVariable(name: "____fmt", scope: !219, file: !3, line: 201, type: !252, isLocal: true, isDefinition: true)
!252 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 232, elements: !253)
!253 = !{!254}
!254 = !DISubrange(count: 29)
!255 = !DIGlobalVariableExpression(var: !256, expr: !DIExpression())
!256 = distinct !DIGlobalVariable(name: "____fmt", scope: !219, file: !3, line: 206, type: !247, isLocal: true, isDefinition: true)
!257 = !DIGlobalVariableExpression(var: !258, expr: !DIExpression())
!258 = distinct !DIGlobalVariable(name: "____fmt", scope: !219, file: !3, line: 210, type: !259, isLocal: true, isDefinition: true)
!259 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 208, elements: !260)
!260 = !{!261}
!261 = !DISubrange(count: 26)
!262 = !DIGlobalVariableExpression(var: !263, expr: !DIExpression())
!263 = distinct !DIGlobalVariable(name: "bpf_loop", scope: !20, file: !161, line: 4216, type: !264, isLocal: true, isDefinition: true)
!264 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !265, size: 64)
!265 = !DISubroutineType(types: !266)
!266 = !{!43, !12, !42, !42, !183}
!267 = !DIGlobalVariableExpression(var: !268, expr: !DIExpression())
!268 = distinct !DIGlobalVariable(name: "____fmt", scope: !269, file: !3, line: 155, type: !232, isLocal: true, isDefinition: true)
!269 = distinct !DISubprogram(name: "app_event_send", scope: !3, file: !3, line: 152, type: !270, scopeLine: 152, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !272)
!270 = !DISubroutineType(types: !271)
!271 = !{!43, !12, !84}
!272 = !{!273, !274, !275, !276}
!273 = !DILocalVariable(name: "index", arg: 1, scope: !269, file: !3, line: 152, type: !12)
!274 = !DILocalVariable(name: "fid", arg: 2, scope: !269, file: !3, line: 152, type: !84)
!275 = !DILocalVariable(name: "tcp_ctx", scope: !269, file: !3, line: 153, type: !93)
!276 = !DILocalVariable(name: "pe", scope: !269, file: !3, line: 158, type: !121)
!277 = !DIGlobalVariableExpression(var: !278, expr: !DIExpression())
!278 = distinct !DIGlobalVariable(name: "____fmt", scope: !279, file: !3, line: 97, type: !287, isLocal: true, isDefinition: true)
!279 = distinct !DISubprogram(name: "enque", scope: !3, file: !3, line: 94, type: !280, scopeLine: 94, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !282)
!280 = !DISubroutineType(types: !281)
!281 = !{!6, !120, !84}
!282 = !{!283, !284, !285, !286}
!283 = !DILocalVariable(name: "pe", arg: 1, scope: !279, file: !3, line: 94, type: !120)
!284 = !DILocalVariable(name: "fid", arg: 2, scope: !279, file: !3, line: 94, type: !84)
!285 = !DILocalVariable(name: "tcp_ctx", scope: !279, file: !3, line: 95, type: !93)
!286 = !DILocalVariable(name: "key", scope: !279, file: !3, line: 107, type: !12)
!287 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 296, elements: !288)
!288 = !{!289}
!289 = !DISubrange(count: 37)
!290 = !DIGlobalVariableExpression(var: !291, expr: !DIExpression())
!291 = distinct !DIGlobalVariable(name: "____fmt", scope: !279, file: !3, line: 102, type: !292, isLocal: true, isDefinition: true)
!292 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 376, elements: !293)
!293 = !{!294}
!294 = !DISubrange(count: 47)
!295 = !DIGlobalVariableExpression(var: !296, expr: !DIExpression())
!296 = distinct !DIGlobalVariable(name: "____fmt", scope: !297, file: !3, line: 90, type: !302, isLocal: true, isDefinition: true)
!297 = distinct !DISubprogram(name: "send_packet", scope: !3, file: !3, line: 88, type: !298, scopeLine: 88, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !300)
!298 = !DISubroutineType(types: !299)
!299 = !{!6, !120}
!300 = !{!301}
!301 = !DILocalVariable(name: "pe", arg: 1, scope: !297, file: !3, line: 88, type: !120)
!302 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 128, elements: !303)
!303 = !{!304}
!304 = !DISubrange(count: 16)
!305 = !DIGlobalVariableExpression(var: !306, expr: !DIExpression())
!306 = distinct !DIGlobalVariable(name: "bpf_timer_init", scope: !20, file: !161, line: 3992, type: !307, isLocal: true, isDefinition: true)
!307 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !308, size: 64)
!308 = !DISubroutineType(types: !309)
!309 = !{!43, !310, !42, !183}
!310 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !139, size: 64)
!311 = !DIGlobalVariableExpression(var: !312, expr: !DIExpression())
!312 = distinct !DIGlobalVariable(name: "bpf_timer_set_callback", scope: !20, file: !161, line: 4007, type: !313, isLocal: true, isDefinition: true)
!313 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !314, size: 64)
!314 = !DISubroutineType(types: !315)
!315 = !{!43, !310, !42}
!316 = !DIGlobalVariableExpression(var: !317, expr: !DIExpression())
!317 = distinct !DIGlobalVariable(name: "____fmt", scope: !318, file: !3, line: 138, type: !247, isLocal: true, isDefinition: true)
!318 = distinct !DISubprogram(name: "timer_callback", scope: !3, file: !3, line: 137, type: !319, scopeLine: 137, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !321)
!319 = !DISubroutineType(types: !320)
!320 = !{!6, !42, !84, !133}
!321 = !{!322, !323, !324, !325, !326}
!322 = !DILocalVariable(name: "map", arg: 1, scope: !318, file: !3, line: 137, type: !42)
!323 = !DILocalVariable(name: "fid", arg: 2, scope: !318, file: !3, line: 137, type: !84)
!324 = !DILocalVariable(name: "val", arg: 3, scope: !318, file: !3, line: 137, type: !133)
!325 = !DILocalVariable(name: "te", scope: !318, file: !3, line: 139, type: !150)
!326 = !DILocalVariable(name: "i", scope: !318, file: !3, line: 144, type: !6)
!327 = !DIGlobalVariableExpression(var: !328, expr: !DIExpression())
!328 = distinct !DIGlobalVariable(name: "____fmt", scope: !318, file: !3, line: 146, type: !247, isLocal: true, isDefinition: true)
!329 = !DIGlobalVariableExpression(var: !330, expr: !DIExpression())
!330 = distinct !DIGlobalVariable(name: "bpf_timer_start", scope: !20, file: !161, line: 4043, type: !331, isLocal: true, isDefinition: true)
!331 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !332, size: 64)
!332 = !DISubroutineType(types: !333)
!333 = !{!43, !310, !183, !183}
!334 = !DIGlobalVariableExpression(var: !335, expr: !DIExpression())
!335 = distinct !DIGlobalVariable(name: "____fmt", scope: !336, file: !3, line: 241, type: !232, isLocal: true, isDefinition: true)
!336 = distinct !DISubprogram(name: "net_event_processor", scope: !3, file: !3, line: 235, type: !337, scopeLine: 235, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !339)
!337 = !DISubroutineType(types: !338)
!338 = !{null, !209}
!339 = !{!340, !341, !342, !343, !344, !345}
!340 = !DILocalVariable(name: "ne", arg: 1, scope: !336, file: !3, line: 235, type: !209)
!341 = !DILocalVariable(name: "tcp_ctx", scope: !336, file: !3, line: 237, type: !93)
!342 = !DILocalVariable(name: "map_entry", scope: !336, file: !3, line: 244, type: !133)
!343 = !DILocalVariable(name: "data_rest", scope: !336, file: !3, line: 252, type: !6)
!344 = !DILocalVariable(name: "num_to_send", scope: !336, file: !3, line: 259, type: !6)
!345 = !DILocalVariable(name: "i", scope: !336, file: !3, line: 266, type: !6)
!346 = !DIGlobalVariableExpression(var: !347, expr: !DIExpression())
!347 = distinct !DIGlobalVariable(name: "____fmt", scope: !336, file: !3, line: 246, type: !348, isLocal: true, isDefinition: true)
!348 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 160, elements: !349)
!349 = !{!350}
!350 = !DISubrange(count: 20)
!351 = !DIGlobalVariableExpression(var: !352, expr: !DIExpression())
!352 = distinct !DIGlobalVariable(name: "____fmt", scope: !336, file: !3, line: 251, type: !353, isLocal: true, isDefinition: true)
!353 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 136, elements: !354)
!354 = !{!355}
!355 = !DISubrange(count: 17)
!356 = !DIGlobalVariableExpression(var: !357, expr: !DIExpression())
!357 = distinct !DIGlobalVariable(name: "____fmt", scope: !336, file: !3, line: 254, type: !358, isLocal: true, isDefinition: true)
!358 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 240, elements: !359)
!359 = !{!360}
!360 = !DISubrange(count: 30)
!361 = !DIGlobalVariableExpression(var: !362, expr: !DIExpression())
!362 = distinct !DIGlobalVariable(name: "____fmt", scope: !336, file: !3, line: 268, type: !252, isLocal: true, isDefinition: true)
!363 = !DIGlobalVariableExpression(var: !364, expr: !DIExpression())
!364 = distinct !DIGlobalVariable(name: "____fmt", scope: !336, file: !3, line: 273, type: !247, isLocal: true, isDefinition: true)
!365 = !DIGlobalVariableExpression(var: !366, expr: !DIExpression())
!366 = distinct !DIGlobalVariable(name: "____fmt", scope: !336, file: !3, line: 277, type: !259, isLocal: true, isDefinition: true)
!367 = !DIGlobalVariableExpression(var: !368, expr: !DIExpression())
!368 = distinct !DIGlobalVariable(name: "bpf_timer_cancel", scope: !20, file: !161, line: 4057, type: !369, isLocal: true, isDefinition: true)
!369 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !370, size: 64)
!370 = !DISubroutineType(types: !371)
!371 = !{!43, !310}
!372 = !DIGlobalVariableExpression(var: !373, expr: !DIExpression())
!373 = distinct !DIGlobalVariable(name: "____fmt", scope: !374, file: !3, line: 217, type: !232, isLocal: true, isDefinition: true)
!374 = distinct !DISubprogram(name: "update_window", scope: !3, file: !3, line: 214, type: !270, scopeLine: 214, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !375)
!375 = !{!376, !377, !378, !379}
!376 = !DILocalVariable(name: "index", arg: 1, scope: !374, file: !3, line: 214, type: !12)
!377 = !DILocalVariable(name: "fid", arg: 2, scope: !374, file: !3, line: 214, type: !84)
!378 = !DILocalVariable(name: "tcp_ctx", scope: !374, file: !3, line: 215, type: !93)
!379 = !DILocalVariable(name: "pe", scope: !374, file: !3, line: 224, type: !121)
!380 = !DIGlobalVariableExpression(var: !381, expr: !DIExpression())
!381 = distinct !DIGlobalVariable(name: "____fmt", scope: !382, file: !3, line: 117, type: !287, isLocal: true, isDefinition: true)
!382 = distinct !DISubprogram(name: "deque", scope: !3, file: !3, line: 114, type: !383, scopeLine: 114, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !385)
!383 = !DISubroutineType(types: !384)
!384 = !{!6, !84}
!385 = !{!386, !387, !388}
!386 = !DILocalVariable(name: "fid", arg: 1, scope: !382, file: !3, line: 114, type: !84)
!387 = !DILocalVariable(name: "tcp_ctx", scope: !382, file: !3, line: 115, type: !93)
!388 = !DILocalVariable(name: "pe", scope: !382, file: !3, line: 126, type: !120)
!389 = !DIGlobalVariableExpression(var: !390, expr: !DIExpression())
!390 = distinct !DIGlobalVariable(name: "____fmt", scope: !382, file: !3, line: 122, type: !391, isLocal: true, isDefinition: true)
!391 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 368, elements: !392)
!392 = !{!393}
!393 = !DISubrange(count: 46)
!394 = !DIGlobalVariableExpression(var: !395, expr: !DIExpression())
!395 = distinct !DIGlobalVariable(name: "____fmt", scope: !382, file: !3, line: 128, type: !237, isLocal: true, isDefinition: true)
!396 = !DIGlobalVariableExpression(var: !397, expr: !DIExpression())
!397 = distinct !DIGlobalVariable(name: "____fmt", scope: !398, file: !3, line: 313, type: !408, isLocal: true, isDefinition: true)
!398 = distinct !DISubprogram(name: "resend_packet", scope: !3, file: !3, line: 310, type: !399, scopeLine: 310, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !401)
!399 = !DISubroutineType(types: !400)
!400 = !{null, !85}
!401 = !{!402, !403, !404, !405}
!402 = !DILocalVariable(name: "fid", arg: 1, scope: !398, file: !3, line: 310, type: !85)
!403 = !DILocalVariable(name: "te", scope: !398, file: !3, line: 311, type: !149)
!404 = !DILocalVariable(name: "tcp_ctx", scope: !398, file: !3, line: 316, type: !93)
!405 = !DILocalVariable(name: "pe", scope: !406, file: !3, line: 322, type: !120)
!406 = distinct !DILexicalBlock(scope: !407, file: !3, line: 321, column: 50)
!407 = distinct !DILexicalBlock(scope: !398, file: !3, line: 321, column: 8)
!408 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 320, elements: !409)
!409 = !{!410}
!410 = !DISubrange(count: 40)
!411 = !DIGlobalVariableExpression(var: !412, expr: !DIExpression())
!412 = distinct !DIGlobalVariable(name: "____fmt", scope: !398, file: !3, line: 318, type: !56, isLocal: true, isDefinition: true)
!413 = !DIGlobalVariableExpression(var: !414, expr: !DIExpression())
!414 = distinct !DIGlobalVariable(name: "____fmt", scope: !398, file: !3, line: 324, type: !214, isLocal: true, isDefinition: true)
!415 = !{!416, !417, !418, !419, !420, !433, !462, !484, !489, !490, !491, !492, !493, !494, !495, !496, !497, !498, !499, !500}
!416 = !DILocalVariable(name: "ctx", arg: 1, scope: !2, file: !3, line: 332, type: !7)
!417 = !DILocalVariable(name: "data_end", scope: !2, file: !3, line: 335, type: !42)
!418 = !DILocalVariable(name: "data", scope: !2, file: !3, line: 336, type: !42)
!419 = !DILocalVariable(name: "cpu", scope: !2, file: !3, line: 337, type: !6)
!420 = !DILocalVariable(name: "eth", scope: !2, file: !3, line: 340, type: !421)
!421 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !422, size: 64)
!422 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !423, line: 168, size: 112, elements: !424)
!423 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "ab0320da726e75d904811ce344979934")
!424 = !{!425, !429, !430}
!425 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !422, file: !423, line: 169, baseType: !426, size: 48)
!426 = !DICompositeType(tag: DW_TAG_array_type, baseType: !195, size: 48, elements: !427)
!427 = !{!428}
!428 = !DISubrange(count: 6)
!429 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !422, file: !423, line: 170, baseType: !426, size: 48, offset: 48)
!430 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !422, file: !423, line: 171, baseType: !431, size: 16, offset: 96)
!431 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !432, line: 25, baseType: !44)
!432 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "52ec79a38e49ac7d1dc9e146ba88a7b1")
!433 = !DILocalVariable(name: "iphdr", scope: !2, file: !3, line: 341, type: !434)
!434 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !435, size: 64)
!435 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !436, line: 87, size: 160, elements: !437)
!436 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "", checksumkind: CSK_MD5, checksum: "042b09a58768855e3578a0a8eba49be7")
!437 = !{!438, !439, !440, !441, !442, !443, !444, !445, !446, !448}
!438 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !435, file: !436, line: 89, baseType: !194, size: 4, flags: DIFlagBitField, extraData: i64 0)
!439 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !435, file: !436, line: 90, baseType: !194, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!440 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !435, file: !436, line: 97, baseType: !194, size: 8, offset: 8)
!441 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !435, file: !436, line: 98, baseType: !431, size: 16, offset: 16)
!442 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !435, file: !436, line: 99, baseType: !431, size: 16, offset: 32)
!443 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !435, file: !436, line: 100, baseType: !431, size: 16, offset: 48)
!444 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !435, file: !436, line: 101, baseType: !194, size: 8, offset: 64)
!445 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !435, file: !436, line: 102, baseType: !194, size: 8, offset: 72)
!446 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !435, file: !436, line: 103, baseType: !447, size: 16, offset: 80)
!447 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !432, line: 31, baseType: !44)
!448 = !DIDerivedType(tag: DW_TAG_member, scope: !435, file: !436, line: 104, baseType: !449, size: 64, offset: 96)
!449 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !435, file: !436, line: 104, size: 64, elements: !450)
!450 = !{!451, !457}
!451 = !DIDerivedType(tag: DW_TAG_member, scope: !449, file: !436, line: 104, baseType: !452, size: 64)
!452 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !449, file: !436, line: 104, size: 64, elements: !453)
!453 = !{!454, !456}
!454 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !452, file: !436, line: 104, baseType: !455, size: 32)
!455 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !432, line: 27, baseType: !12)
!456 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !452, file: !436, line: 104, baseType: !455, size: 32, offset: 32)
!457 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !449, file: !436, line: 104, baseType: !458, size: 64)
!458 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !449, file: !436, line: 104, size: 64, elements: !459)
!459 = !{!460, !461}
!460 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !458, file: !436, line: 104, baseType: !455, size: 32)
!461 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !458, file: !436, line: 104, baseType: !455, size: 32, offset: 32)
!462 = !DILocalVariable(name: "tcphdr", scope: !2, file: !3, line: 342, type: !463)
!463 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !464, size: 64)
!464 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "tcphdr", file: !465, line: 25, size: 160, elements: !466)
!465 = !DIFile(filename: "/usr/include/linux/tcp.h", directory: "", checksumkind: CSK_MD5, checksum: "8d74bf2133e7b3dab885994b9916aa13")
!466 = !{!467, !468, !469, !470, !471, !472, !473, !474, !475, !476, !477, !478, !479, !480, !481, !482, !483}
!467 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !464, file: !465, line: 26, baseType: !431, size: 16)
!468 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !464, file: !465, line: 27, baseType: !431, size: 16, offset: 16)
!469 = !DIDerivedType(tag: DW_TAG_member, name: "seq", scope: !464, file: !465, line: 28, baseType: !455, size: 32, offset: 32)
!470 = !DIDerivedType(tag: DW_TAG_member, name: "ack_seq", scope: !464, file: !465, line: 29, baseType: !455, size: 32, offset: 64)
!471 = !DIDerivedType(tag: DW_TAG_member, name: "res1", scope: !464, file: !465, line: 31, baseType: !44, size: 4, offset: 96, flags: DIFlagBitField, extraData: i64 96)
!472 = !DIDerivedType(tag: DW_TAG_member, name: "doff", scope: !464, file: !465, line: 32, baseType: !44, size: 4, offset: 100, flags: DIFlagBitField, extraData: i64 96)
!473 = !DIDerivedType(tag: DW_TAG_member, name: "fin", scope: !464, file: !465, line: 33, baseType: !44, size: 1, offset: 104, flags: DIFlagBitField, extraData: i64 96)
!474 = !DIDerivedType(tag: DW_TAG_member, name: "syn", scope: !464, file: !465, line: 34, baseType: !44, size: 1, offset: 105, flags: DIFlagBitField, extraData: i64 96)
!475 = !DIDerivedType(tag: DW_TAG_member, name: "rst", scope: !464, file: !465, line: 35, baseType: !44, size: 1, offset: 106, flags: DIFlagBitField, extraData: i64 96)
!476 = !DIDerivedType(tag: DW_TAG_member, name: "psh", scope: !464, file: !465, line: 36, baseType: !44, size: 1, offset: 107, flags: DIFlagBitField, extraData: i64 96)
!477 = !DIDerivedType(tag: DW_TAG_member, name: "ack", scope: !464, file: !465, line: 37, baseType: !44, size: 1, offset: 108, flags: DIFlagBitField, extraData: i64 96)
!478 = !DIDerivedType(tag: DW_TAG_member, name: "urg", scope: !464, file: !465, line: 38, baseType: !44, size: 1, offset: 109, flags: DIFlagBitField, extraData: i64 96)
!479 = !DIDerivedType(tag: DW_TAG_member, name: "ece", scope: !464, file: !465, line: 39, baseType: !44, size: 1, offset: 110, flags: DIFlagBitField, extraData: i64 96)
!480 = !DIDerivedType(tag: DW_TAG_member, name: "cwr", scope: !464, file: !465, line: 40, baseType: !44, size: 1, offset: 111, flags: DIFlagBitField, extraData: i64 96)
!481 = !DIDerivedType(tag: DW_TAG_member, name: "window", scope: !464, file: !465, line: 55, baseType: !431, size: 16, offset: 112)
!482 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !464, file: !465, line: 56, baseType: !447, size: 16, offset: 128)
!483 = !DIDerivedType(tag: DW_TAG_member, name: "urg_ptr", scope: !464, file: !465, line: 57, baseType: !431, size: 16, offset: 144)
!484 = !DILocalVariable(name: "nh", scope: !2, file: !3, line: 343, type: !485)
!485 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "hdr_cursor", file: !486, line: 33, size: 64, elements: !487)
!486 = !DIFile(filename: "./../common/parsing_helpers.h", directory: "/home/a68lin/XDP-Tryouts/xdp/event-processor", checksumkind: CSK_MD5, checksum: "172efdd203783aed49c0ce78645261a8")
!487 = !{!488}
!488 = !DIDerivedType(tag: DW_TAG_member, name: "pos", scope: !485, file: !486, line: 34, baseType: !42, size: 64)
!489 = !DILocalVariable(name: "fid", scope: !2, file: !3, line: 346, type: !85)
!490 = !DILocalVariable(name: "iph", scope: !2, file: !3, line: 354, type: !434)
!491 = !DILocalVariable(name: "hdrsize", scope: !2, file: !3, line: 355, type: !6)
!492 = !DILocalVariable(name: "id", scope: !2, file: !3, line: 368, type: !44)
!493 = !DILocalVariable(name: "len", scope: !2, file: !3, line: 375, type: !6)
!494 = !DILocalVariable(name: "h", scope: !2, file: !3, line: 376, type: !463)
!495 = !DILocalVariable(name: "ack", scope: !2, file: !3, line: 391, type: !12)
!496 = !DILocalVariable(name: "e", scope: !2, file: !3, line: 395, type: !191)
!497 = !DILocalVariable(name: "ne", scope: !2, file: !3, line: 396, type: !210)
!498 = !DILocalVariable(name: "ae", scope: !2, file: !3, line: 397, type: !203)
!499 = !DILocalVariable(name: "reverse_fid", scope: !2, file: !3, line: 402, type: !85)
!500 = !DILocalVariable(name: "tcp_ctx", scope: !501, file: !3, line: 411, type: !93)
!501 = distinct !DILexicalBlock(scope: !502, file: !3, line: 410, column: 18)
!502 = distinct !DILexicalBlock(scope: !2, file: !3, line: 410, column: 9)
!503 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 24, elements: !504)
!504 = !{!505}
!505 = !DISubrange(count: 3)
!506 = !{i32 7, !"Dwarf Version", i32 5}
!507 = !{i32 2, !"Debug Info Version", i32 3}
!508 = !{i32 1, !"wchar_size", i32 4}
!509 = !{i32 7, !"frame-pointer", i32 2}
!510 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!511 = !DILocation(line: 0, scope: !2)
!512 = !DILocation(line: 335, column: 41, scope: !2)
!513 = !{!514, !515, i64 4}
!514 = !{!"xdp_md", !515, i64 0, !515, i64 4, !515, i64 8, !515, i64 12, !515, i64 16, !515, i64 20}
!515 = !{!"int", !516, i64 0}
!516 = !{!"omnipotent char", !517, i64 0}
!517 = !{!"Simple C/C++ TBAA"}
!518 = !DILocation(line: 335, column: 30, scope: !2)
!519 = !DILocation(line: 335, column: 22, scope: !2)
!520 = !DILocation(line: 336, column: 37, scope: !2)
!521 = !{!514, !515, i64 0}
!522 = !DILocation(line: 336, column: 26, scope: !2)
!523 = !DILocation(line: 336, column: 18, scope: !2)
!524 = !DILocation(line: 337, column: 15, scope: !2)
!525 = !DILocation(line: 338, column: 5, scope: !526)
!526 = distinct !DILexicalBlock(scope: !2, file: !3, line: 338, column: 5)
!527 = !DILocalVariable(name: "nh", arg: 1, scope: !528, file: !3, line: 299, type: !531)
!528 = distinct !DISubprogram(name: "parse_ethhdr_new", scope: !3, file: !3, line: 299, type: !529, scopeLine: 300, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !20, retainedNodes: !533)
!529 = !DISubroutineType(types: !530)
!530 = !{!6, !531, !42, !532}
!531 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !485, size: 64)
!532 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !421, size: 64)
!533 = !{!527, !534, !535, !536, !537}
!534 = !DILocalVariable(name: "data_end", arg: 2, scope: !528, file: !3, line: 299, type: !42)
!535 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !528, file: !3, line: 299, type: !532)
!536 = !DILocalVariable(name: "eth", scope: !528, file: !3, line: 301, type: !421)
!537 = !DILocalVariable(name: "hdrsize", scope: !528, file: !3, line: 302, type: !6)
!538 = !DILocation(line: 0, scope: !528, inlinedAt: !539)
!539 = distinct !DILocation(line: 350, column: 5, scope: !2)
!540 = !DILocation(line: 303, column: 14, scope: !541, inlinedAt: !539)
!541 = distinct !DILexicalBlock(scope: !528, file: !3, line: 303, column: 6)
!542 = !DILocation(line: 303, column: 24, scope: !541, inlinedAt: !539)
!543 = !DILocation(line: 303, column: 6, scope: !528, inlinedAt: !539)
!544 = !DILocation(line: 356, column: 10, scope: !545)
!545 = distinct !DILexicalBlock(scope: !2, file: !3, line: 356, column: 6)
!546 = !DILocation(line: 356, column: 16, scope: !545)
!547 = !DILocation(line: 356, column: 14, scope: !545)
!548 = !DILocation(line: 356, column: 6, scope: !2)
!549 = !DILocation(line: 359, column: 17, scope: !2)
!550 = !DILocation(line: 359, column: 21, scope: !2)
!551 = !DILocation(line: 360, column: 13, scope: !552)
!552 = distinct !DILexicalBlock(scope: !2, file: !3, line: 360, column: 5)
!553 = !DILocation(line: 360, column: 5, scope: !2)
!554 = !DILocation(line: 363, column: 13, scope: !555)
!555 = distinct !DILexicalBlock(scope: !2, file: !3, line: 363, column: 6)
!556 = !DILocation(line: 363, column: 23, scope: !555)
!557 = !DILocation(line: 363, column: 6, scope: !2)
!558 = !DILocation(line: 368, column: 16, scope: !2)
!559 = !{!560, !561, i64 4}
!560 = !{!"iphdr", !516, i64 0, !516, i64 0, !516, i64 1, !561, i64 2, !561, i64 4, !561, i64 6, !516, i64 8, !516, i64 9, !561, i64 10, !516, i64 12}
!561 = !{!"short", !516, i64 0}
!562 = !DILocation(line: 369, column: 5, scope: !563)
!563 = distinct !DILexicalBlock(scope: !2, file: !3, line: 369, column: 5)
!564 = !DILocation(line: 370, column: 28, scope: !2)
!565 = !{!516, !516, i64 0}
!566 = !DILocation(line: 371, column: 30, scope: !2)
!567 = !DILocation(line: 377, column: 8, scope: !568)
!568 = distinct !DILexicalBlock(scope: !2, file: !3, line: 377, column: 6)
!569 = !DILocation(line: 377, column: 14, scope: !568)
!570 = !DILocation(line: 377, column: 12, scope: !568)
!571 = !DILocation(line: 377, column: 6, scope: !2)
!572 = !DILocation(line: 380, column: 11, scope: !2)
!573 = !DILocation(line: 380, column: 16, scope: !2)
!574 = !DILocation(line: 381, column: 9, scope: !575)
!575 = distinct !DILexicalBlock(scope: !2, file: !3, line: 381, column: 5)
!576 = !DILocation(line: 381, column: 5, scope: !2)
!577 = !DILocation(line: 384, column: 13, scope: !578)
!578 = distinct !DILexicalBlock(scope: !2, file: !3, line: 384, column: 6)
!579 = !DILocation(line: 384, column: 19, scope: !578)
!580 = !DILocation(line: 384, column: 6, scope: !2)
!581 = !DILocation(line: 389, column: 31, scope: !2)
!582 = !{!583, !561, i64 0}
!583 = !{!"tcphdr", !561, i64 0, !561, i64 2, !515, i64 4, !515, i64 8, !561, i64 12, !561, i64 12, !561, i64 13, !561, i64 13, !561, i64 13, !561, i64 13, !561, i64 13, !561, i64 13, !561, i64 13, !561, i64 13, !561, i64 14, !561, i64 16, !561, i64 18}
!584 = !DILocation(line: 390, column: 33, scope: !2)
!585 = !{!583, !561, i64 2}
!586 = !DILocation(line: 391, column: 17, scope: !2)
!587 = !{!583, !515, i64 8}
!588 = !DILocation(line: 402, column: 5, scope: !2)
!589 = !DILocation(line: 402, column: 20, scope: !2)
!590 = !DILocation(line: 403, column: 5, scope: !2)
!591 = !DILocation(line: 404, column: 17, scope: !2)
!592 = !DILocation(line: 404, column: 27, scope: !2)
!593 = !{!594, !515, i64 0}
!594 = !{!"flow_id", !515, i64 0, !561, i64 4, !515, i64 8, !561, i64 12}
!595 = !DILocation(line: 405, column: 17, scope: !2)
!596 = !DILocation(line: 405, column: 29, scope: !2)
!597 = !{!594, !561, i64 4}
!598 = !DILocation(line: 406, column: 17, scope: !2)
!599 = !DILocation(line: 406, column: 29, scope: !2)
!600 = !{!594, !515, i64 8}
!601 = !DILocation(line: 407, column: 17, scope: !2)
!602 = !DILocation(line: 407, column: 31, scope: !2)
!603 = !{!594, !561, i64 12}
!604 = !DILocation(line: 410, column: 9, scope: !2)
!605 = !DILocation(line: 411, column: 34, scope: !501)
!606 = !DILocation(line: 0, scope: !501)
!607 = !DILocation(line: 412, column: 13, scope: !608)
!608 = distinct !DILexicalBlock(scope: !501, file: !3, line: 412, column: 12)
!609 = !DILocation(line: 412, column: 12, scope: !501)
!610 = !DILocation(line: 413, column: 13, scope: !611)
!611 = distinct !DILexicalBlock(scope: !612, file: !3, line: 413, column: 13)
!612 = distinct !DILexicalBlock(scope: !608, file: !3, line: 412, column: 22)
!613 = !DILocation(line: 0, scope: !187, inlinedAt: !614)
!614 = distinct !DILocation(line: 426, column: 9, scope: !615)
!615 = distinct !DILexicalBlock(scope: !616, file: !3, line: 421, column: 18)
!616 = distinct !DILexicalBlock(scope: !2, file: !3, line: 421, column: 9)
!617 = !DILocation(line: 0, scope: !208, inlinedAt: !614)
!618 = !DILocation(line: 0, scope: !336, inlinedAt: !619)
!619 = distinct !DILocation(line: 290, column: 13, scope: !208, inlinedAt: !614)
!620 = !DILocation(line: 239, column: 15, scope: !336, inlinedAt: !619)
!621 = !DILocation(line: 240, column: 9, scope: !622, inlinedAt: !619)
!622 = distinct !DILexicalBlock(scope: !336, file: !3, line: 240, column: 8)
!623 = !DILocation(line: 240, column: 8, scope: !336, inlinedAt: !619)
!624 = !DILocation(line: 241, column: 9, scope: !625, inlinedAt: !619)
!625 = distinct !DILexicalBlock(scope: !626, file: !3, line: 241, column: 9)
!626 = distinct !DILexicalBlock(scope: !622, file: !3, line: 240, column: 18)
!627 = !DILocation(line: 242, column: 9, scope: !626, inlinedAt: !619)
!628 = !DILocation(line: 244, column: 34, scope: !336, inlinedAt: !619)
!629 = !DILocation(line: 245, column: 10, scope: !630, inlinedAt: !619)
!630 = distinct !DILexicalBlock(scope: !336, file: !3, line: 245, column: 9)
!631 = !DILocation(line: 245, column: 9, scope: !336, inlinedAt: !619)
!632 = !DILocation(line: 246, column: 9, scope: !633, inlinedAt: !619)
!633 = distinct !DILexicalBlock(scope: !634, file: !3, line: 246, column: 9)
!634 = distinct !DILexicalBlock(scope: !630, file: !3, line: 245, column: 21)
!635 = !DILocation(line: 247, column: 9, scope: !634, inlinedAt: !619)
!636 = !DILocation(line: 250, column: 28, scope: !637, inlinedAt: !619)
!637 = distinct !DILexicalBlock(scope: !336, file: !3, line: 250, column: 8)
!638 = !{!639, !515, i64 8}
!639 = !{!"tcp_md", !515, i64 0, !515, i64 4, !515, i64 8, !515, i64 12, !515, i64 16, !515, i64 20, !515, i64 24}
!640 = !DILocation(line: 250, column: 16, scope: !637, inlinedAt: !619)
!641 = !DILocation(line: 250, column: 8, scope: !336, inlinedAt: !619)
!642 = !DILocation(line: 251, column: 5, scope: !643, inlinedAt: !619)
!643 = distinct !DILexicalBlock(scope: !336, file: !3, line: 251, column: 5)
!644 = !DILocation(line: 252, column: 30, scope: !336, inlinedAt: !619)
!645 = !{!639, !515, i64 24}
!646 = !DILocation(line: 252, column: 52, scope: !336, inlinedAt: !619)
!647 = !{!639, !515, i64 12}
!648 = !DILocation(line: 252, column: 66, scope: !336, inlinedAt: !619)
!649 = !DILocation(line: 253, column: 18, scope: !650, inlinedAt: !619)
!650 = distinct !DILexicalBlock(scope: !336, file: !3, line: 253, column: 8)
!651 = !DILocation(line: 253, column: 23, scope: !650, inlinedAt: !619)
!652 = !DILocation(line: 254, column: 9, scope: !653, inlinedAt: !619)
!653 = distinct !DILexicalBlock(scope: !654, file: !3, line: 254, column: 9)
!654 = distinct !DILexicalBlock(scope: !650, file: !3, line: 253, column: 65)
!655 = !DILocation(line: 255, column: 38, scope: !654, inlinedAt: !619)
!656 = !DILocation(line: 255, column: 9, scope: !654, inlinedAt: !619)
!657 = !DILocation(line: 256, column: 9, scope: !654, inlinedAt: !619)
!658 = !DILocation(line: 259, column: 42, scope: !336, inlinedAt: !619)
!659 = !DILocation(line: 259, column: 31, scope: !336, inlinedAt: !619)
!660 = !DILocation(line: 260, column: 31, scope: !336, inlinedAt: !619)
!661 = !DILocation(line: 261, column: 5, scope: !336, inlinedAt: !619)
!662 = !DILocation(line: 262, column: 5, scope: !336, inlinedAt: !619)
!663 = !DILocation(line: 265, column: 35, scope: !336, inlinedAt: !619)
!664 = !DILocation(line: 265, column: 16, scope: !336, inlinedAt: !619)
!665 = !DILocation(line: 265, column: 24, scope: !336, inlinedAt: !619)
!666 = !{!667, !515, i64 8}
!667 = !{!"map_elem", !668, i64 0, !515, i64 8, !669, i64 16}
!668 = !{!"any pointer", !516, i64 0}
!669 = !{!"bpf_timer"}
!670 = !DILocation(line: 266, column: 48, scope: !336, inlinedAt: !619)
!671 = !DILocation(line: 266, column: 13, scope: !336, inlinedAt: !619)
!672 = !DILocation(line: 267, column: 10, scope: !673, inlinedAt: !619)
!673 = distinct !DILexicalBlock(scope: !336, file: !3, line: 267, column: 8)
!674 = !DILocation(line: 267, column: 8, scope: !336, inlinedAt: !619)
!675 = !DILocation(line: 268, column: 9, scope: !676, inlinedAt: !619)
!676 = distinct !DILexicalBlock(scope: !677, file: !3, line: 268, column: 9)
!677 = distinct !DILexicalBlock(scope: !673, file: !3, line: 267, column: 16)
!678 = !DILocation(line: 269, column: 9, scope: !677, inlinedAt: !619)
!679 = !DILocation(line: 271, column: 9, scope: !336, inlinedAt: !619)
!680 = !DILocation(line: 272, column: 11, scope: !681, inlinedAt: !619)
!681 = distinct !DILexicalBlock(scope: !336, file: !3, line: 272, column: 9)
!682 = !DILocation(line: 272, column: 9, scope: !336, inlinedAt: !619)
!683 = !DILocation(line: 273, column: 9, scope: !684, inlinedAt: !619)
!684 = distinct !DILexicalBlock(scope: !685, file: !3, line: 273, column: 9)
!685 = distinct !DILexicalBlock(scope: !681, file: !3, line: 272, column: 17)
!686 = !DILocation(line: 274, column: 9, scope: !685, inlinedAt: !619)
!687 = !DILocation(line: 277, column: 9, scope: !688, inlinedAt: !619)
!688 = distinct !DILexicalBlock(scope: !689, file: !3, line: 277, column: 9)
!689 = distinct !DILexicalBlock(scope: !681, file: !3, line: 276, column: 10)
!690 = !DILocation(line: 279, column: 1, scope: !336, inlinedAt: !619)
!691 = !DILocation(line: 416, column: 40, scope: !501)
!692 = !DILocation(line: 416, column: 18, scope: !501)
!693 = !DILocation(line: 416, column: 28, scope: !501)
!694 = !DILocation(line: 417, column: 9, scope: !695)
!695 = distinct !DILexicalBlock(scope: !501, file: !3, line: 417, column: 9)
!696 = !DILocation(line: 418, column: 9, scope: !501)
!697 = !DILocation(line: 0, scope: !187, inlinedAt: !698)
!698 = distinct !DILocation(line: 432, column: 9, scope: !699)
!699 = distinct !DILexicalBlock(scope: !700, file: !3, line: 428, column: 23)
!700 = distinct !DILexicalBlock(scope: !616, file: !3, line: 428, column: 14)
!701 = !DILocation(line: 0, scope: !200, inlinedAt: !698)
!702 = !DILocation(line: 0, scope: !219, inlinedAt: !703)
!703 = distinct !DILocation(line: 285, column: 13, scope: !200, inlinedAt: !698)
!704 = !DILocation(line: 171, column: 30, scope: !219, inlinedAt: !703)
!705 = !DILocation(line: 172, column: 9, scope: !706, inlinedAt: !703)
!706 = distinct !DILexicalBlock(scope: !219, file: !3, line: 172, column: 8)
!707 = !DILocation(line: 172, column: 8, scope: !219, inlinedAt: !703)
!708 = !DILocation(line: 173, column: 9, scope: !709, inlinedAt: !703)
!709 = distinct !DILexicalBlock(scope: !710, file: !3, line: 173, column: 9)
!710 = distinct !DILexicalBlock(scope: !706, file: !3, line: 172, column: 18)
!711 = !DILocation(line: 174, column: 9, scope: !710, inlinedAt: !703)
!712 = !DILocation(line: 176, column: 30, scope: !219, inlinedAt: !703)
!713 = !DILocation(line: 176, column: 52, scope: !219, inlinedAt: !703)
!714 = !DILocation(line: 176, column: 66, scope: !219, inlinedAt: !703)
!715 = !DILocation(line: 176, column: 40, scope: !219, inlinedAt: !703)
!716 = !DILocation(line: 177, column: 33, scope: !219, inlinedAt: !703)
!717 = !DILocation(line: 177, column: 23, scope: !219, inlinedAt: !703)
!718 = !DILocation(line: 179, column: 5, scope: !219, inlinedAt: !703)
!719 = !DILocation(line: 181, column: 34, scope: !219, inlinedAt: !703)
!720 = !DILocation(line: 182, column: 10, scope: !230, inlinedAt: !703)
!721 = !DILocation(line: 182, column: 9, scope: !219, inlinedAt: !703)
!722 = !DILocation(line: 183, column: 9, scope: !723, inlinedAt: !703)
!723 = distinct !DILexicalBlock(scope: !229, file: !3, line: 183, column: 9)
!724 = !DILocation(line: 184, column: 9, scope: !229, inlinedAt: !703)
!725 = !DILocation(line: 184, column: 25, scope: !229, inlinedAt: !703)
!726 = !DILocation(line: 185, column: 9, scope: !229, inlinedAt: !703)
!727 = !DILocation(line: 186, column: 9, scope: !229, inlinedAt: !703)
!728 = !DILocation(line: 187, column: 21, scope: !229, inlinedAt: !703)
!729 = !DILocation(line: 188, column: 13, scope: !730, inlinedAt: !703)
!730 = distinct !DILexicalBlock(scope: !229, file: !3, line: 188, column: 12)
!731 = !DILocation(line: 188, column: 12, scope: !229, inlinedAt: !703)
!732 = !DILocation(line: 189, column: 13, scope: !733, inlinedAt: !703)
!733 = distinct !DILexicalBlock(scope: !734, file: !3, line: 189, column: 13)
!734 = distinct !DILexicalBlock(scope: !730, file: !3, line: 188, column: 24)
!735 = !DILocation(line: 192, column: 5, scope: !230, inlinedAt: !703)
!736 = !DILocation(line: 193, column: 16, scope: !219, inlinedAt: !703)
!737 = !DILocation(line: 193, column: 24, scope: !219, inlinedAt: !703)
!738 = !DILocation(line: 194, column: 16, scope: !219, inlinedAt: !703)
!739 = !DILocation(line: 194, column: 20, scope: !219, inlinedAt: !703)
!740 = !{!667, !668, i64 0}
!741 = !DILocation(line: 195, column: 46, scope: !219, inlinedAt: !703)
!742 = !DILocation(line: 195, column: 18, scope: !219, inlinedAt: !703)
!743 = !DILocation(line: 196, column: 10, scope: !744, inlinedAt: !703)
!744 = distinct !DILexicalBlock(scope: !219, file: !3, line: 196, column: 8)
!745 = !DILocation(line: 196, column: 8, scope: !219, inlinedAt: !703)
!746 = !DILocation(line: 197, column: 9, scope: !747, inlinedAt: !703)
!747 = distinct !DILexicalBlock(scope: !748, file: !3, line: 197, column: 9)
!748 = distinct !DILexicalBlock(scope: !744, file: !3, line: 196, column: 16)
!749 = !DILocation(line: 198, column: 5, scope: !748, inlinedAt: !703)
!750 = !DILocation(line: 199, column: 9, scope: !219, inlinedAt: !703)
!751 = !DILocation(line: 200, column: 10, scope: !752, inlinedAt: !703)
!752 = distinct !DILexicalBlock(scope: !219, file: !3, line: 200, column: 8)
!753 = !DILocation(line: 200, column: 8, scope: !219, inlinedAt: !703)
!754 = !DILocation(line: 201, column: 9, scope: !755, inlinedAt: !703)
!755 = distinct !DILexicalBlock(scope: !756, file: !3, line: 201, column: 9)
!756 = distinct !DILexicalBlock(scope: !752, file: !3, line: 200, column: 16)
!757 = !DILocation(line: 202, column: 9, scope: !756, inlinedAt: !703)
!758 = !DILocation(line: 204, column: 9, scope: !219, inlinedAt: !703)
!759 = !DILocation(line: 205, column: 11, scope: !760, inlinedAt: !703)
!760 = distinct !DILexicalBlock(scope: !219, file: !3, line: 205, column: 9)
!761 = !DILocation(line: 205, column: 9, scope: !219, inlinedAt: !703)
!762 = !DILocation(line: 206, column: 9, scope: !763, inlinedAt: !703)
!763 = distinct !DILexicalBlock(scope: !764, file: !3, line: 206, column: 9)
!764 = distinct !DILexicalBlock(scope: !760, file: !3, line: 205, column: 17)
!765 = !DILocation(line: 207, column: 9, scope: !764, inlinedAt: !703)
!766 = !DILocation(line: 210, column: 9, scope: !767, inlinedAt: !703)
!767 = distinct !DILexicalBlock(scope: !768, file: !3, line: 210, column: 9)
!768 = distinct !DILexicalBlock(scope: !760, file: !3, line: 209, column: 10)
!769 = !DILocation(line: 212, column: 1, scope: !219, inlinedAt: !703)
!770 = !DILocation(line: 310, column: 58, scope: !398, inlinedAt: !771)
!771 = distinct !DILocation(line: 435, column: 9, scope: !772)
!772 = distinct !DILexicalBlock(scope: !773, file: !3, line: 434, column: 23)
!773 = distinct !DILexicalBlock(scope: !700, file: !3, line: 434, column: 14)
!774 = !DILocation(line: 311, column: 32, scope: !398, inlinedAt: !771)
!775 = !DILocation(line: 0, scope: !398, inlinedAt: !771)
!776 = !DILocation(line: 312, column: 9, scope: !777, inlinedAt: !771)
!777 = distinct !DILexicalBlock(scope: !398, file: !3, line: 312, column: 8)
!778 = !DILocation(line: 312, column: 8, scope: !398, inlinedAt: !771)
!779 = !DILocation(line: 313, column: 9, scope: !780, inlinedAt: !771)
!780 = distinct !DILexicalBlock(scope: !781, file: !3, line: 313, column: 9)
!781 = distinct !DILexicalBlock(scope: !777, file: !3, line: 312, column: 13)
!782 = !DILocation(line: 314, column: 9, scope: !781, inlinedAt: !771)
!783 = !DILocation(line: 316, column: 30, scope: !398, inlinedAt: !771)
!784 = !DILocation(line: 317, column: 9, scope: !785, inlinedAt: !771)
!785 = distinct !DILexicalBlock(scope: !398, file: !3, line: 317, column: 8)
!786 = !DILocation(line: 317, column: 8, scope: !398, inlinedAt: !771)
!787 = !DILocation(line: 318, column: 9, scope: !788, inlinedAt: !771)
!788 = distinct !DILexicalBlock(scope: !789, file: !3, line: 318, column: 9)
!789 = distinct !DILexicalBlock(scope: !785, file: !3, line: 317, column: 18)
!790 = !DILocation(line: 319, column: 9, scope: !789, inlinedAt: !771)
!791 = !DILocation(line: 321, column: 17, scope: !407, inlinedAt: !771)
!792 = !DILocation(line: 321, column: 41, scope: !407, inlinedAt: !771)
!793 = !{!794, !515, i64 8}
!794 = !{!"timeout_event", !668, i64 0, !515, i64 8}
!795 = !DILocation(line: 321, column: 34, scope: !407, inlinedAt: !771)
!796 = !DILocation(line: 321, column: 8, scope: !398, inlinedAt: !771)
!797 = !DILocation(line: 322, column: 82, scope: !406, inlinedAt: !771)
!798 = !DILocation(line: 322, column: 35, scope: !406, inlinedAt: !771)
!799 = !DILocation(line: 0, scope: !406, inlinedAt: !771)
!800 = !DILocation(line: 323, column: 13, scope: !801, inlinedAt: !771)
!801 = distinct !DILexicalBlock(scope: !406, file: !3, line: 323, column: 12)
!802 = !DILocation(line: 323, column: 12, scope: !406, inlinedAt: !771)
!803 = !DILocation(line: 324, column: 13, scope: !804, inlinedAt: !771)
!804 = distinct !DILexicalBlock(scope: !805, file: !3, line: 324, column: 13)
!805 = distinct !DILexicalBlock(scope: !801, file: !3, line: 323, column: 17)
!806 = !DILocation(line: 325, column: 13, scope: !805, inlinedAt: !771)
!807 = !DILocation(line: 0, scope: !297, inlinedAt: !808)
!808 = distinct !DILocation(line: 327, column: 9, scope: !406, inlinedAt: !771)
!809 = !DILocation(line: 90, column: 5, scope: !810, inlinedAt: !808)
!810 = distinct !DILexicalBlock(scope: !297, file: !3, line: 90, column: 5)
!811 = !{!812, !515, i64 8}
!812 = !{!"packet_event", !668, i64 0, !515, i64 8, !515, i64 12}
!813 = !DILocation(line: 328, column: 5, scope: !407, inlinedAt: !771)
!814 = !DILocation(line: 329, column: 1, scope: !398, inlinedAt: !771)
!815 = !DILocation(line: 436, column: 9, scope: !772)
!816 = !DILocation(line: 440, column: 1, scope: !2)
!817 = !DILocation(line: 0, scope: !269)
!818 = !DILocation(line: 153, column: 68, scope: !269)
!819 = !DILocation(line: 153, column: 30, scope: !269)
!820 = !DILocation(line: 154, column: 9, scope: !821)
!821 = distinct !DILexicalBlock(scope: !269, file: !3, line: 154, column: 8)
!822 = !DILocation(line: 154, column: 8, scope: !269)
!823 = !DILocation(line: 155, column: 9, scope: !824)
!824 = distinct !DILexicalBlock(scope: !825, file: !3, line: 155, column: 9)
!825 = distinct !DILexicalBlock(scope: !821, file: !3, line: 154, column: 18)
!826 = !DILocation(line: 156, column: 9, scope: !825)
!827 = !DILocation(line: 158, column: 5, scope: !269)
!828 = !DILocation(line: 158, column: 25, scope: !269)
!829 = !DILocation(line: 160, column: 8, scope: !269)
!830 = !DILocation(line: 160, column: 12, scope: !269)
!831 = !{!812, !668, i64 0}
!832 = !DILocation(line: 161, column: 23, scope: !269)
!833 = !{!639, !515, i64 0}
!834 = !DILocation(line: 161, column: 8, scope: !269)
!835 = !DILocation(line: 161, column: 13, scope: !269)
!836 = !{!812, !515, i64 12}
!837 = !DILocation(line: 162, column: 27, scope: !269)
!838 = !DILocation(line: 162, column: 41, scope: !269)
!839 = !DILocation(line: 162, column: 8, scope: !269)
!840 = !DILocation(line: 162, column: 16, scope: !269)
!841 = !DILocation(line: 0, scope: !279, inlinedAt: !842)
!842 = distinct !DILocation(line: 163, column: 5, scope: !269)
!843 = !DILocation(line: 95, column: 30, scope: !279, inlinedAt: !842)
!844 = !DILocation(line: 96, column: 9, scope: !845, inlinedAt: !842)
!845 = distinct !DILexicalBlock(scope: !279, file: !3, line: 96, column: 8)
!846 = !DILocation(line: 96, column: 8, scope: !279, inlinedAt: !842)
!847 = !DILocation(line: 97, column: 9, scope: !848, inlinedAt: !842)
!848 = distinct !DILexicalBlock(scope: !849, file: !3, line: 97, column: 9)
!849 = distinct !DILexicalBlock(scope: !845, file: !3, line: 96, column: 18)
!850 = !DILocation(line: 98, column: 9, scope: !849, inlinedAt: !842)
!851 = !DILocation(line: 101, column: 17, scope: !852, inlinedAt: !842)
!852 = distinct !DILexicalBlock(scope: !279, file: !3, line: 101, column: 8)
!853 = !{!639, !515, i64 20}
!854 = !DILocation(line: 101, column: 38, scope: !852, inlinedAt: !842)
!855 = !{!639, !515, i64 4}
!856 = !DILocation(line: 101, column: 26, scope: !852, inlinedAt: !842)
!857 = !DILocation(line: 101, column: 8, scope: !279, inlinedAt: !842)
!858 = !DILocation(line: 102, column: 9, scope: !859, inlinedAt: !842)
!859 = distinct !DILexicalBlock(scope: !860, file: !3, line: 102, column: 9)
!860 = distinct !DILexicalBlock(scope: !852, file: !3, line: 101, column: 51)
!861 = !DILocation(line: 103, column: 9, scope: !860, inlinedAt: !842)
!862 = !DILocation(line: 0, scope: !297, inlinedAt: !863)
!863 = distinct !DILocation(line: 106, column: 5, scope: !279, inlinedAt: !842)
!864 = !DILocation(line: 90, column: 5, scope: !810, inlinedAt: !863)
!865 = !DILocation(line: 107, column: 5, scope: !279, inlinedAt: !842)
!866 = !DILocation(line: 107, column: 27, scope: !279, inlinedAt: !842)
!867 = !{!639, !515, i64 16}
!868 = !DILocation(line: 107, column: 43, scope: !279, inlinedAt: !842)
!869 = !DILocation(line: 107, column: 32, scope: !279, inlinedAt: !842)
!870 = !DILocation(line: 107, column: 64, scope: !279, inlinedAt: !842)
!871 = !DILocation(line: 107, column: 53, scope: !279, inlinedAt: !842)
!872 = !DILocation(line: 107, column: 11, scope: !279, inlinedAt: !842)
!873 = !{!515, !515, i64 0}
!874 = !DILocation(line: 108, column: 5, scope: !279, inlinedAt: !842)
!875 = !DILocation(line: 109, column: 23, scope: !279, inlinedAt: !842)
!876 = !DILocation(line: 110, column: 5, scope: !279, inlinedAt: !842)
!877 = !DILocation(line: 112, column: 1, scope: !279, inlinedAt: !842)
!878 = !DILocation(line: 164, column: 28, scope: !269)
!879 = !DILocation(line: 165, column: 5, scope: !269)
!880 = !DILocation(line: 167, column: 1, scope: !269)
!881 = !DILocation(line: 0, scope: !318)
!882 = !DILocation(line: 138, column: 5, scope: !883)
!883 = distinct !DILexicalBlock(scope: !318, file: !3, line: 138, column: 5)
!884 = !DILocation(line: 139, column: 5, scope: !318)
!885 = !DILocation(line: 139, column: 26, scope: !318)
!886 = !DILocation(line: 140, column: 5, scope: !318)
!887 = !DILocation(line: 141, column: 23, scope: !318)
!888 = !DILocation(line: 141, column: 8, scope: !318)
!889 = !DILocation(line: 141, column: 16, scope: !318)
!890 = !DILocation(line: 142, column: 8, scope: !318)
!891 = !DILocation(line: 142, column: 12, scope: !318)
!892 = !{!794, !668, i64 0}
!893 = !DILocation(line: 143, column: 41, scope: !318)
!894 = !DILocation(line: 143, column: 5, scope: !318)
!895 = !DILocation(line: 144, column: 35, scope: !318)
!896 = !DILocation(line: 144, column: 13, scope: !318)
!897 = !DILocation(line: 145, column: 11, scope: !898)
!898 = distinct !DILexicalBlock(scope: !318, file: !3, line: 145, column: 9)
!899 = !DILocation(line: 145, column: 9, scope: !318)
!900 = !DILocation(line: 146, column: 9, scope: !901)
!901 = distinct !DILexicalBlock(scope: !902, file: !3, line: 146, column: 9)
!902 = distinct !DILexicalBlock(scope: !898, file: !3, line: 145, column: 17)
!903 = !DILocation(line: 147, column: 9, scope: !902)
!904 = !DILocation(line: 150, column: 1, scope: !318)
!905 = !DILocation(line: 0, scope: !374)
!906 = !DILocation(line: 215, column: 68, scope: !374)
!907 = !DILocation(line: 215, column: 30, scope: !374)
!908 = !DILocation(line: 216, column: 9, scope: !909)
!909 = distinct !DILexicalBlock(scope: !374, file: !3, line: 216, column: 8)
!910 = !DILocation(line: 216, column: 8, scope: !374)
!911 = !DILocation(line: 217, column: 9, scope: !912)
!912 = distinct !DILexicalBlock(scope: !913, file: !3, line: 217, column: 9)
!913 = distinct !DILexicalBlock(scope: !909, file: !3, line: 216, column: 18)
!914 = !DILocation(line: 218, column: 9, scope: !913)
!915 = !DILocation(line: 0, scope: !382, inlinedAt: !916)
!916 = distinct !DILocation(line: 220, column: 5, scope: !374)
!917 = !DILocation(line: 115, column: 30, scope: !382, inlinedAt: !916)
!918 = !DILocation(line: 116, column: 9, scope: !919, inlinedAt: !916)
!919 = distinct !DILexicalBlock(scope: !382, file: !3, line: 116, column: 8)
!920 = !DILocation(line: 116, column: 8, scope: !382, inlinedAt: !916)
!921 = !DILocation(line: 117, column: 9, scope: !922, inlinedAt: !916)
!922 = distinct !DILexicalBlock(scope: !923, file: !3, line: 117, column: 9)
!923 = distinct !DILexicalBlock(scope: !919, file: !3, line: 116, column: 18)
!924 = !DILocation(line: 118, column: 9, scope: !923, inlinedAt: !916)
!925 = !DILocation(line: 121, column: 17, scope: !926, inlinedAt: !916)
!926 = distinct !DILexicalBlock(scope: !382, file: !3, line: 121, column: 8)
!927 = !DILocation(line: 121, column: 26, scope: !926, inlinedAt: !916)
!928 = !DILocation(line: 121, column: 8, scope: !382, inlinedAt: !916)
!929 = !DILocation(line: 122, column: 9, scope: !930, inlinedAt: !916)
!930 = distinct !DILexicalBlock(scope: !931, file: !3, line: 122, column: 9)
!931 = distinct !DILexicalBlock(scope: !926, file: !3, line: 121, column: 32)
!932 = !DILocation(line: 123, column: 9, scope: !931, inlinedAt: !916)
!933 = !DILocation(line: 126, column: 78, scope: !382, inlinedAt: !916)
!934 = !DILocation(line: 126, column: 31, scope: !382, inlinedAt: !916)
!935 = !DILocation(line: 127, column: 9, scope: !936, inlinedAt: !916)
!936 = distinct !DILexicalBlock(scope: !382, file: !3, line: 127, column: 8)
!937 = !DILocation(line: 127, column: 8, scope: !382, inlinedAt: !916)
!938 = !DILocation(line: 128, column: 9, scope: !939, inlinedAt: !916)
!939 = distinct !DILexicalBlock(scope: !940, file: !3, line: 128, column: 9)
!940 = distinct !DILexicalBlock(scope: !936, file: !3, line: 127, column: 13)
!941 = !DILocation(line: 129, column: 9, scope: !940, inlinedAt: !916)
!942 = !DILocation(line: 131, column: 31, scope: !382, inlinedAt: !916)
!943 = !DILocation(line: 131, column: 36, scope: !382, inlinedAt: !916)
!944 = !DILocation(line: 131, column: 52, scope: !382, inlinedAt: !916)
!945 = !DILocation(line: 131, column: 41, scope: !382, inlinedAt: !916)
!946 = !DILocation(line: 131, column: 19, scope: !382, inlinedAt: !916)
!947 = !DILocation(line: 132, column: 23, scope: !382, inlinedAt: !916)
!948 = !DILocation(line: 133, column: 5, scope: !382, inlinedAt: !916)
!949 = !DILocation(line: 134, column: 5, scope: !382, inlinedAt: !916)
!950 = !DILocation(line: 221, column: 17, scope: !951)
!951 = distinct !DILexicalBlock(scope: !374, file: !3, line: 221, column: 8)
!952 = !DILocation(line: 221, column: 39, scope: !951)
!953 = !DILocation(line: 221, column: 53, scope: !951)
!954 = !DILocation(line: 221, column: 27, scope: !951)
!955 = !DILocation(line: 221, column: 8, scope: !374)
!956 = !DILocation(line: 224, column: 5, scope: !374)
!957 = !DILocation(line: 224, column: 25, scope: !374)
!958 = !DILocation(line: 226, column: 8, scope: !374)
!959 = !DILocation(line: 226, column: 12, scope: !374)
!960 = !DILocation(line: 227, column: 23, scope: !374)
!961 = !DILocation(line: 227, column: 8, scope: !374)
!962 = !DILocation(line: 227, column: 13, scope: !374)
!963 = !DILocation(line: 228, column: 27, scope: !374)
!964 = !DILocation(line: 228, column: 41, scope: !374)
!965 = !DILocation(line: 228, column: 8, scope: !374)
!966 = !DILocation(line: 228, column: 16, scope: !374)
!967 = !DILocation(line: 0, scope: !279, inlinedAt: !968)
!968 = distinct !DILocation(line: 229, column: 5, scope: !374)
!969 = !DILocation(line: 95, column: 30, scope: !279, inlinedAt: !968)
!970 = !DILocation(line: 96, column: 9, scope: !845, inlinedAt: !968)
!971 = !DILocation(line: 96, column: 8, scope: !279, inlinedAt: !968)
!972 = !DILocation(line: 97, column: 9, scope: !848, inlinedAt: !968)
!973 = !DILocation(line: 98, column: 9, scope: !849, inlinedAt: !968)
!974 = !DILocation(line: 101, column: 17, scope: !852, inlinedAt: !968)
!975 = !DILocation(line: 101, column: 38, scope: !852, inlinedAt: !968)
!976 = !DILocation(line: 101, column: 26, scope: !852, inlinedAt: !968)
!977 = !DILocation(line: 101, column: 8, scope: !279, inlinedAt: !968)
!978 = !DILocation(line: 102, column: 9, scope: !859, inlinedAt: !968)
!979 = !DILocation(line: 103, column: 9, scope: !860, inlinedAt: !968)
!980 = !DILocation(line: 0, scope: !297, inlinedAt: !981)
!981 = distinct !DILocation(line: 106, column: 5, scope: !279, inlinedAt: !968)
!982 = !DILocation(line: 90, column: 5, scope: !810, inlinedAt: !981)
!983 = !DILocation(line: 107, column: 5, scope: !279, inlinedAt: !968)
!984 = !DILocation(line: 107, column: 27, scope: !279, inlinedAt: !968)
!985 = !DILocation(line: 107, column: 43, scope: !279, inlinedAt: !968)
!986 = !DILocation(line: 107, column: 32, scope: !279, inlinedAt: !968)
!987 = !DILocation(line: 107, column: 64, scope: !279, inlinedAt: !968)
!988 = !DILocation(line: 107, column: 53, scope: !279, inlinedAt: !968)
!989 = !DILocation(line: 107, column: 11, scope: !279, inlinedAt: !968)
!990 = !DILocation(line: 108, column: 5, scope: !279, inlinedAt: !968)
!991 = !DILocation(line: 109, column: 23, scope: !279, inlinedAt: !968)
!992 = !DILocation(line: 110, column: 5, scope: !279, inlinedAt: !968)
!993 = !DILocation(line: 112, column: 1, scope: !279, inlinedAt: !968)
!994 = !DILocation(line: 230, column: 28, scope: !374)
!995 = !DILocation(line: 231, column: 5, scope: !374)
!996 = !DILocation(line: 233, column: 1, scope: !374)
