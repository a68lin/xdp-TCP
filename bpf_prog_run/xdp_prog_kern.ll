; ModuleID = 'xdp_prog_kern.c'
source_filename = "xdp_prog_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.inner_map_queue = type { [22 x i32]*, i32*, [1248 x i32]* }
%struct.anon.0 = type { [2 x i32]*, i32*, i64*, [8 x i32]* }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }

@inner_map_queue0 = dso_local global %struct.inner_map_queue zeroinitializer, section ".maps", align 8, !dbg !0
@inner_map_queue1 = dso_local global %struct.inner_map_queue zeroinitializer, section ".maps", align 8, !dbg !99
@inner_map_queue2 = dso_local global %struct.inner_map_queue zeroinitializer, section ".maps", align 8, !dbg !101
@inner_map_queue3 = dso_local global %struct.inner_map_queue zeroinitializer, section ".maps", align 8, !dbg !103
@inner_map_queue4 = dso_local global %struct.inner_map_queue zeroinitializer, section ".maps", align 8, !dbg !105
@inner_map_queue5 = dso_local global %struct.inner_map_queue zeroinitializer, section ".maps", align 8, !dbg !107
@inner_map_queue6 = dso_local global %struct.inner_map_queue zeroinitializer, section ".maps", align 8, !dbg !109
@inner_map_queue7 = dso_local global %struct.inner_map_queue zeroinitializer, section ".maps", align 8, !dbg !111
@outer_map_queue = dso_local global { [12 x i32]*, [8 x i32]*, i32*, [8 x %struct.inner_map_queue*] } { [12 x i32]* null, [8 x i32]* null, i32* null, [8 x %struct.inner_map_queue*] [%struct.inner_map_queue* @inner_map_queue0, %struct.inner_map_queue* @inner_map_queue1, %struct.inner_map_queue* @inner_map_queue2, %struct.inner_map_queue* @inner_map_queue3, %struct.inner_map_queue* @inner_map_queue4, %struct.inner_map_queue* @inner_map_queue5, %struct.inner_map_queue* @inner_map_queue6, %struct.inner_map_queue* @inner_map_queue7] }, section ".maps", align 8, !dbg !18
@simply_drop.____fmt = internal constant [36 x i8] c"Error while looking up counter map\0A\00", align 1, !dbg !55
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !81
@counter_array = dso_local global %struct.anon.0 zeroinitializer, section ".maps", align 8, !dbg !86
@lookup_map_of_maps_queue.____fmt = internal constant [35 x i8] c"Error while accessing map of maps\0A\00", align 1, !dbg !132
@lookup_map_of_maps_queue.____fmt.1 = internal constant [38 x i8] c"Error while pushing element to queue\0A\00", align 1, !dbg !146
@llvm.used = appending global [12 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.anon.0* @counter_array to i8*), i8* bitcast (%struct.inner_map_queue* @inner_map_queue0 to i8*), i8* bitcast (%struct.inner_map_queue* @inner_map_queue1 to i8*), i8* bitcast (%struct.inner_map_queue* @inner_map_queue2 to i8*), i8* bitcast (%struct.inner_map_queue* @inner_map_queue3 to i8*), i8* bitcast (%struct.inner_map_queue* @inner_map_queue4 to i8*), i8* bitcast (%struct.inner_map_queue* @inner_map_queue5 to i8*), i8* bitcast (%struct.inner_map_queue* @inner_map_queue6 to i8*), i8* bitcast (%struct.inner_map_queue* @inner_map_queue7 to i8*), i8* bitcast ({ [12 x i32]*, [8 x i32]*, i32*, [8 x %struct.inner_map_queue*] }* @outer_map_queue to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @simply_drop to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @simply_drop(%struct.xdp_md* nocapture readonly %0) #0 section "xdp" !dbg !57 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !69, metadata !DIExpression()), !dbg !160
  %7 = tail call i32 inttoptr (i64 8 to i32 ()*)() #3, !dbg !161
  call void @llvm.dbg.value(metadata i32 %7, metadata !70, metadata !DIExpression()), !dbg !160
  %8 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !162
  %9 = load i32, i32* %8, align 4, !dbg !162, !tbaa !163
  %10 = zext i32 %9 to i64, !dbg !168
  call void @llvm.dbg.value(metadata i64 %10, metadata !71, metadata !DIExpression()), !dbg !160
  %11 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !169
  %12 = load i32, i32* %11, align 4, !dbg !169, !tbaa !170
  %13 = zext i32 %12 to i64, !dbg !171
  call void @llvm.dbg.value(metadata i64 %13, metadata !72, metadata !DIExpression()), !dbg !160
  %14 = bitcast i32* %6 to i8*, !dbg !172
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %14), !dbg !172
  call void @llvm.dbg.value(metadata i32 %7, metadata !177, metadata !DIExpression()) #3, !dbg !172
  store i32 %7, i32* %6, align 4, !tbaa !180
  call void @llvm.dbg.value(metadata i32* %6, metadata !177, metadata !DIExpression(DW_OP_deref)) #3, !dbg !172
  %15 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.anon.0* @counter_array to i8*), i8* nonnull %14) #3, !dbg !181
  %16 = bitcast i8* %15 to i64*, !dbg !181
  call void @llvm.dbg.value(metadata i64* %16, metadata !178, metadata !DIExpression()) #3, !dbg !172
  %17 = icmp eq i8* %15, null, !dbg !182
  br i1 %17, label %18, label %19, !dbg !184

18:                                               ; preds = %1
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %14), !dbg !185
  call void @llvm.dbg.value(metadata i64 %21, metadata !73, metadata !DIExpression()), !dbg !160
  br label %23, !dbg !186

19:                                               ; preds = %1
  %20 = load i64, i64* %16, align 8, !dbg !187, !tbaa !188
  %21 = add i64 %20, 1, !dbg !187
  store i64 %21, i64* %16, align 8, !dbg !187, !tbaa !188
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %14), !dbg !185
  call void @llvm.dbg.value(metadata i64 %21, metadata !73, metadata !DIExpression()), !dbg !160
  %22 = icmp eq i64 %21, 0, !dbg !190
  br i1 %22, label %23, label %25, !dbg !186

23:                                               ; preds = %19, %18
  %24 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* getelementptr inbounds ([36 x i8], [36 x i8]* @simply_drop.____fmt, i64 0, i64 0), i32 36) #3, !dbg !192
  br label %27, !dbg !195

25:                                               ; preds = %19
  %26 = icmp ult i64 %21, 10000000, !dbg !196
  br i1 %26, label %27, label %62, !dbg !195

27:                                               ; preds = %23, %25
  %28 = sub nsw i64 %10, %13, !dbg !198
  %29 = icmp eq i64 %28, 1500, !dbg !201
  br i1 %29, label %30, label %46, !dbg !202

30:                                               ; preds = %27
  %31 = bitcast i32* %4 to i8*, !dbg !203
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %31), !dbg !203
  call void @llvm.dbg.value(metadata i32 %7, metadata !138, metadata !DIExpression()) #3, !dbg !203
  store i32 %7, i32* %4, align 4, !tbaa !180
  call void @llvm.dbg.value(metadata i32 0, metadata !139, metadata !DIExpression()) #3, !dbg !203
  call void @llvm.dbg.value(metadata i32* %4, metadata !138, metadata !DIExpression(DW_OP_deref)) #3, !dbg !203
  %32 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast ({ [12 x i32]*, [8 x i32]*, i32*, [8 x %struct.inner_map_queue*] }* @outer_map_queue to i8*), i8* nonnull %31) #3, !dbg !206
  call void @llvm.dbg.value(metadata i8* %32, metadata !140, metadata !DIExpression()) #3, !dbg !203
  %33 = icmp eq i8* %32, null, !dbg !207
  br i1 %33, label %38, label %34, !dbg !209

34:                                               ; preds = %30
  call void @llvm.dbg.value(metadata i32 0, metadata !139, metadata !DIExpression()) #3, !dbg !203
  %35 = bitcast i32* %5 to i8*, !dbg !210
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %35) #3, !dbg !211
  call void @llvm.dbg.value(metadata i32 0, metadata !141, metadata !DIExpression()) #3, !dbg !210
  store i32 0, i32* %5, align 4, !dbg !212, !tbaa !180
  call void @llvm.dbg.value(metadata i32* %5, metadata !141, metadata !DIExpression(DW_OP_deref)) #3, !dbg !210
  %36 = call i64 inttoptr (i64 87 to i64 (i8*, i8*, i64)*)(i8* nonnull %32, i8* nonnull %35, i64 2) #3, !dbg !213
  %37 = icmp slt i64 %36, 0, !dbg !215
  br i1 %37, label %40, label %42, !dbg !216

38:                                               ; preds = %30
  %39 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* getelementptr inbounds ([35 x i8], [35 x i8]* @lookup_map_of_maps_queue.____fmt, i64 0, i64 0), i32 35) #3, !dbg !217
  br label %45, !dbg !220

40:                                               ; preds = %69, %66, %63, %42, %34
  %41 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* getelementptr inbounds ([38 x i8], [38 x i8]* @lookup_map_of_maps_queue.____fmt.1, i64 0, i64 0), i32 38) #3, !dbg !221
  call void @llvm.dbg.value(metadata i32 2, metadata !139, metadata !DIExpression()) #3, !dbg !203
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %35) #3, !dbg !224
  br label %45

42:                                               ; preds = %34
  call void @llvm.dbg.value(metadata i32 2, metadata !139, metadata !DIExpression()) #3, !dbg !203
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %35) #3, !dbg !224
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %35) #3, !dbg !211
  call void @llvm.dbg.value(metadata i32 2, metadata !141, metadata !DIExpression()) #3, !dbg !210
  store i32 2, i32* %5, align 4, !dbg !212, !tbaa !180
  call void @llvm.dbg.value(metadata i32* %5, metadata !141, metadata !DIExpression(DW_OP_deref)) #3, !dbg !210
  %43 = call i64 inttoptr (i64 87 to i64 (i8*, i8*, i64)*)(i8* nonnull %32, i8* nonnull %35, i64 2) #3, !dbg !213
  %44 = icmp slt i64 %43, 0, !dbg !215
  br i1 %44, label %40, label %63, !dbg !216

45:                                               ; preds = %72, %38, %40
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %31), !dbg !225
  br label %62, !dbg !226

46:                                               ; preds = %27
  %47 = bitcast i32* %2 to i8*, !dbg !227
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %47), !dbg !227
  call void @llvm.dbg.value(metadata i32 %7, metadata !138, metadata !DIExpression()) #3, !dbg !227
  store i32 %7, i32* %2, align 4, !tbaa !180
  call void @llvm.dbg.value(metadata i32 1, metadata !139, metadata !DIExpression()) #3, !dbg !227
  call void @llvm.dbg.value(metadata i32* %2, metadata !138, metadata !DIExpression(DW_OP_deref)) #3, !dbg !227
  %48 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast ({ [12 x i32]*, [8 x i32]*, i32*, [8 x %struct.inner_map_queue*] }* @outer_map_queue to i8*), i8* nonnull %47) #3, !dbg !230
  call void @llvm.dbg.value(metadata i8* %48, metadata !140, metadata !DIExpression()) #3, !dbg !227
  %49 = icmp eq i8* %48, null, !dbg !231
  br i1 %49, label %54, label %50, !dbg !232

50:                                               ; preds = %46
  call void @llvm.dbg.value(metadata i32 1, metadata !139, metadata !DIExpression()) #3, !dbg !227
  %51 = bitcast i32* %3 to i8*, !dbg !233
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %51) #3, !dbg !234
  call void @llvm.dbg.value(metadata i32 1, metadata !141, metadata !DIExpression()) #3, !dbg !233
  store i32 1, i32* %3, align 4, !dbg !235, !tbaa !180
  call void @llvm.dbg.value(metadata i32* %3, metadata !141, metadata !DIExpression(DW_OP_deref)) #3, !dbg !233
  %52 = call i64 inttoptr (i64 87 to i64 (i8*, i8*, i64)*)(i8* nonnull %48, i8* nonnull %51, i64 2) #3, !dbg !236
  %53 = icmp slt i64 %52, 0, !dbg !237
  br i1 %53, label %56, label %58, !dbg !238

54:                                               ; preds = %46
  %55 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* getelementptr inbounds ([35 x i8], [35 x i8]* @lookup_map_of_maps_queue.____fmt, i64 0, i64 0), i32 35) #3, !dbg !239
  br label %61, !dbg !240

56:                                               ; preds = %79, %76, %73, %58, %50
  %57 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* getelementptr inbounds ([38 x i8], [38 x i8]* @lookup_map_of_maps_queue.____fmt.1, i64 0, i64 0), i32 38) #3, !dbg !241
  call void @llvm.dbg.value(metadata i32 3, metadata !139, metadata !DIExpression()) #3, !dbg !227
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %51) #3, !dbg !242
  br label %61

58:                                               ; preds = %50
  call void @llvm.dbg.value(metadata i32 3, metadata !139, metadata !DIExpression()) #3, !dbg !227
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %51) #3, !dbg !242
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %51) #3, !dbg !234
  call void @llvm.dbg.value(metadata i32 3, metadata !141, metadata !DIExpression()) #3, !dbg !233
  store i32 3, i32* %3, align 4, !dbg !235, !tbaa !180
  call void @llvm.dbg.value(metadata i32* %3, metadata !141, metadata !DIExpression(DW_OP_deref)) #3, !dbg !233
  %59 = call i64 inttoptr (i64 87 to i64 (i8*, i8*, i64)*)(i8* nonnull %48, i8* nonnull %51, i64 2) #3, !dbg !236
  %60 = icmp slt i64 %59, 0, !dbg !237
  br i1 %60, label %56, label %73, !dbg !238

61:                                               ; preds = %82, %54, %56
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %47), !dbg !243
  br label %62

62:                                               ; preds = %45, %61, %25
  ret i32 1, !dbg !244

63:                                               ; preds = %42
  call void @llvm.dbg.value(metadata i32 4, metadata !139, metadata !DIExpression()) #3, !dbg !203
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %35) #3, !dbg !224
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %35) #3, !dbg !211
  call void @llvm.dbg.value(metadata i32 4, metadata !141, metadata !DIExpression()) #3, !dbg !210
  store i32 4, i32* %5, align 4, !dbg !212, !tbaa !180
  call void @llvm.dbg.value(metadata i32* %5, metadata !141, metadata !DIExpression(DW_OP_deref)) #3, !dbg !210
  %64 = call i64 inttoptr (i64 87 to i64 (i8*, i8*, i64)*)(i8* nonnull %32, i8* nonnull %35, i64 2) #3, !dbg !213
  %65 = icmp slt i64 %64, 0, !dbg !215
  br i1 %65, label %40, label %66, !dbg !216

66:                                               ; preds = %63
  call void @llvm.dbg.value(metadata i32 6, metadata !139, metadata !DIExpression()) #3, !dbg !203
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %35) #3, !dbg !224
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %35) #3, !dbg !211
  call void @llvm.dbg.value(metadata i32 6, metadata !141, metadata !DIExpression()) #3, !dbg !210
  store i32 6, i32* %5, align 4, !dbg !212, !tbaa !180
  call void @llvm.dbg.value(metadata i32* %5, metadata !141, metadata !DIExpression(DW_OP_deref)) #3, !dbg !210
  %67 = call i64 inttoptr (i64 87 to i64 (i8*, i8*, i64)*)(i8* nonnull %32, i8* nonnull %35, i64 2) #3, !dbg !213
  %68 = icmp slt i64 %67, 0, !dbg !215
  br i1 %68, label %40, label %69, !dbg !216

69:                                               ; preds = %66
  call void @llvm.dbg.value(metadata i32 8, metadata !139, metadata !DIExpression()) #3, !dbg !203
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %35) #3, !dbg !224
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %35) #3, !dbg !211
  call void @llvm.dbg.value(metadata i32 8, metadata !141, metadata !DIExpression()) #3, !dbg !210
  store i32 8, i32* %5, align 4, !dbg !212, !tbaa !180
  call void @llvm.dbg.value(metadata i32* %5, metadata !141, metadata !DIExpression(DW_OP_deref)) #3, !dbg !210
  %70 = call i64 inttoptr (i64 87 to i64 (i8*, i8*, i64)*)(i8* nonnull %32, i8* nonnull %35, i64 2) #3, !dbg !213
  %71 = icmp slt i64 %70, 0, !dbg !215
  br i1 %71, label %40, label %72, !dbg !216

72:                                               ; preds = %69
  call void @llvm.dbg.value(metadata i32 10, metadata !139, metadata !DIExpression()) #3, !dbg !203
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %35) #3, !dbg !224
  br label %45, !dbg !225

73:                                               ; preds = %58
  call void @llvm.dbg.value(metadata i32 5, metadata !139, metadata !DIExpression()) #3, !dbg !227
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %51) #3, !dbg !242
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %51) #3, !dbg !234
  call void @llvm.dbg.value(metadata i32 5, metadata !141, metadata !DIExpression()) #3, !dbg !233
  store i32 5, i32* %3, align 4, !dbg !235, !tbaa !180
  call void @llvm.dbg.value(metadata i32* %3, metadata !141, metadata !DIExpression(DW_OP_deref)) #3, !dbg !233
  %74 = call i64 inttoptr (i64 87 to i64 (i8*, i8*, i64)*)(i8* nonnull %48, i8* nonnull %51, i64 2) #3, !dbg !236
  %75 = icmp slt i64 %74, 0, !dbg !237
  br i1 %75, label %56, label %76, !dbg !238

76:                                               ; preds = %73
  call void @llvm.dbg.value(metadata i32 7, metadata !139, metadata !DIExpression()) #3, !dbg !227
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %51) #3, !dbg !242
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %51) #3, !dbg !234
  call void @llvm.dbg.value(metadata i32 7, metadata !141, metadata !DIExpression()) #3, !dbg !233
  store i32 7, i32* %3, align 4, !dbg !235, !tbaa !180
  call void @llvm.dbg.value(metadata i32* %3, metadata !141, metadata !DIExpression(DW_OP_deref)) #3, !dbg !233
  %77 = call i64 inttoptr (i64 87 to i64 (i8*, i8*, i64)*)(i8* nonnull %48, i8* nonnull %51, i64 2) #3, !dbg !236
  %78 = icmp slt i64 %77, 0, !dbg !237
  br i1 %78, label %56, label %79, !dbg !238

79:                                               ; preds = %76
  call void @llvm.dbg.value(metadata i32 9, metadata !139, metadata !DIExpression()) #3, !dbg !227
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %51) #3, !dbg !242
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %51) #3, !dbg !234
  call void @llvm.dbg.value(metadata i32 9, metadata !141, metadata !DIExpression()) #3, !dbg !233
  store i32 9, i32* %3, align 4, !dbg !235, !tbaa !180
  call void @llvm.dbg.value(metadata i32* %3, metadata !141, metadata !DIExpression(DW_OP_deref)) #3, !dbg !233
  %80 = call i64 inttoptr (i64 87 to i64 (i8*, i8*, i64)*)(i8* nonnull %48, i8* nonnull %51, i64 2) #3, !dbg !236
  %81 = icmp slt i64 %80, 0, !dbg !237
  br i1 %81, label %56, label %82, !dbg !238

82:                                               ; preds = %79
  call void @llvm.dbg.value(metadata i32 11, metadata !139, metadata !DIExpression()) #3, !dbg !227
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %51) #3, !dbg !242
  br label %61, !dbg !243
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { nounwind readnone speculatable willreturn }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!156, !157, !158}
!llvm.ident = !{!159}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "inner_map_queue0", scope: !2, file: !3, line: 26, type: !40, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.0.0-2~ubuntu20.04.1", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !14, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "xdp_prog_kern.c", directory: "/home/a68lin/XDP-Tryouts/xdp/bpf_prog_run")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 3150, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/include/linux/bpf.h", directory: "")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0, isUnsigned: true)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1, isUnsigned: true)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2, isUnsigned: true)
!12 = !DIEnumerator(name: "XDP_TX", value: 3, isUnsigned: true)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4, isUnsigned: true)
!14 = !{!15, !16}
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!16 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!17 = !{!18, !55, !81, !86, !0, !99, !101, !103, !105, !107, !109, !111, !113, !119, !126, !132, !146, !151}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "outer_map_queue", scope: !2, file: !3, line: 34, type: !20, isLocal: false, isDefinition: true)
!20 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 29, size: 192, elements: !21)
!21 = !{!22, !28, !33, !37}
!22 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !20, file: !3, line: 30, baseType: !23, size: 64)
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !24, size: 64)
!24 = !DICompositeType(tag: DW_TAG_array_type, baseType: !25, size: 384, elements: !26)
!25 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!26 = !{!27}
!27 = !DISubrange(count: 12)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !20, file: !3, line: 31, baseType: !29, size: 64, offset: 64)
!29 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !30, size: 64)
!30 = !DICompositeType(tag: DW_TAG_array_type, baseType: !25, size: 256, elements: !31)
!31 = !{!32}
!32 = !DISubrange(count: 8)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !20, file: !3, line: 32, baseType: !34, size: 64, offset: 128)
!34 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 64)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !36, line: 27, baseType: !7)
!36 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "")
!37 = !DIDerivedType(tag: DW_TAG_member, name: "values", scope: !20, file: !3, line: 33, baseType: !38, offset: 192)
!38 = !DICompositeType(tag: DW_TAG_array_type, baseType: !39, elements: !53)
!39 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!40 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "inner_map_queue", file: !3, line: 22, size: 192, elements: !41)
!41 = !{!42, !47, !48}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !40, file: !3, line: 23, baseType: !43, size: 64)
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !25, size: 704, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 22)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !40, file: !3, line: 24, baseType: !34, size: 64, offset: 64)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !40, file: !3, line: 25, baseType: !49, size: 64, offset: 128)
!49 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!50 = !DICompositeType(tag: DW_TAG_array_type, baseType: !25, size: 39936, elements: !51)
!51 = !{!52}
!52 = !DISubrange(count: 1248)
!53 = !{!54}
!54 = !DISubrange(count: -1)
!55 = !DIGlobalVariableExpression(var: !56, expr: !DIExpression())
!56 = distinct !DIGlobalVariable(name: "____fmt", scope: !57, file: !3, line: 85, type: !76, isLocal: true, isDefinition: true)
!57 = distinct !DISubprogram(name: "simply_drop", scope: !3, file: !3, line: 73, type: !58, scopeLine: 74, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !68)
!58 = !DISubroutineType(types: !59)
!59 = !{!25, !60}
!60 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !61, size: 64)
!61 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 3161, size: 160, elements: !62)
!62 = !{!63, !64, !65, !66, !67}
!63 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !61, file: !6, line: 3162, baseType: !35, size: 32)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !61, file: !6, line: 3163, baseType: !35, size: 32, offset: 32)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !61, file: !6, line: 3164, baseType: !35, size: 32, offset: 64)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !61, file: !6, line: 3166, baseType: !35, size: 32, offset: 96)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !61, file: !6, line: 3167, baseType: !35, size: 32, offset: 128)
!68 = !{!69, !70, !71, !72, !73}
!69 = !DILocalVariable(name: "ctx", arg: 1, scope: !57, file: !3, line: 73, type: !60)
!70 = !DILocalVariable(name: "cpu", scope: !57, file: !3, line: 76, type: !25)
!71 = !DILocalVariable(name: "data_end", scope: !57, file: !3, line: 78, type: !15)
!72 = !DILocalVariable(name: "data", scope: !57, file: !3, line: 79, type: !15)
!73 = !DILocalVariable(name: "counter", scope: !57, file: !3, line: 83, type: !74)
!74 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !36, line: 31, baseType: !75)
!75 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!76 = !DICompositeType(tag: DW_TAG_array_type, baseType: !77, size: 288, elements: !79)
!77 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !78)
!78 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!79 = !{!80}
!80 = !DISubrange(count: 36)
!81 = !DIGlobalVariableExpression(var: !82, expr: !DIExpression())
!82 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 99, type: !83, isLocal: false, isDefinition: true)
!83 = !DICompositeType(tag: DW_TAG_array_type, baseType: !78, size: 32, elements: !84)
!84 = !{!85}
!85 = !DISubrange(count: 4)
!86 = !DIGlobalVariableExpression(var: !87, expr: !DIExpression())
!87 = distinct !DIGlobalVariable(name: "counter_array", scope: !2, file: !3, line: 20, type: !88, isLocal: false, isDefinition: true)
!88 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 15, size: 256, elements: !89)
!89 = !{!90, !95, !96, !98}
!90 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !88, file: !3, line: 16, baseType: !91, size: 64)
!91 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !92, size: 64)
!92 = !DICompositeType(tag: DW_TAG_array_type, baseType: !25, size: 64, elements: !93)
!93 = !{!94}
!94 = !DISubrange(count: 2)
!95 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !88, file: !3, line: 17, baseType: !34, size: 64, offset: 64)
!96 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !88, file: !3, line: 18, baseType: !97, size: 64, offset: 128)
!97 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !74, size: 64)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !88, file: !3, line: 19, baseType: !29, size: 64, offset: 192)
!99 = !DIGlobalVariableExpression(var: !100, expr: !DIExpression())
!100 = distinct !DIGlobalVariable(name: "inner_map_queue1", scope: !2, file: !3, line: 26, type: !40, isLocal: false, isDefinition: true)
!101 = !DIGlobalVariableExpression(var: !102, expr: !DIExpression())
!102 = distinct !DIGlobalVariable(name: "inner_map_queue2", scope: !2, file: !3, line: 26, type: !40, isLocal: false, isDefinition: true)
!103 = !DIGlobalVariableExpression(var: !104, expr: !DIExpression())
!104 = distinct !DIGlobalVariable(name: "inner_map_queue3", scope: !2, file: !3, line: 26, type: !40, isLocal: false, isDefinition: true)
!105 = !DIGlobalVariableExpression(var: !106, expr: !DIExpression())
!106 = distinct !DIGlobalVariable(name: "inner_map_queue4", scope: !2, file: !3, line: 27, type: !40, isLocal: false, isDefinition: true)
!107 = !DIGlobalVariableExpression(var: !108, expr: !DIExpression())
!108 = distinct !DIGlobalVariable(name: "inner_map_queue5", scope: !2, file: !3, line: 27, type: !40, isLocal: false, isDefinition: true)
!109 = !DIGlobalVariableExpression(var: !110, expr: !DIExpression())
!110 = distinct !DIGlobalVariable(name: "inner_map_queue6", scope: !2, file: !3, line: 27, type: !40, isLocal: false, isDefinition: true)
!111 = !DIGlobalVariableExpression(var: !112, expr: !DIExpression())
!112 = distinct !DIGlobalVariable(name: "inner_map_queue7", scope: !2, file: !3, line: 27, type: !40, isLocal: false, isDefinition: true)
!113 = !DIGlobalVariableExpression(var: !114, expr: !DIExpression())
!114 = distinct !DIGlobalVariable(name: "bpf_get_smp_processor_id", scope: !2, file: !115, line: 206, type: !116, isLocal: true, isDefinition: true)
!115 = !DIFile(filename: "../lib/install/include/bpf/bpf_helper_defs.h", directory: "/home/a68lin/XDP-Tryouts/xdp/bpf_prog_run")
!116 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !117, size: 64)
!117 = !DISubroutineType(types: !118)
!118 = !{!35}
!119 = !DIGlobalVariableExpression(var: !120, expr: !DIExpression())
!120 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !115, line: 56, type: !121, isLocal: true, isDefinition: true)
!121 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !122, size: 64)
!122 = !DISubroutineType(types: !123)
!123 = !{!15, !15, !124}
!124 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !125, size: 64)
!125 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!126 = !DIGlobalVariableExpression(var: !127, expr: !DIExpression())
!127 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !115, line: 177, type: !128, isLocal: true, isDefinition: true)
!128 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !129, size: 64)
!129 = !DISubroutineType(types: !130)
!130 = !{!16, !131, !35, null}
!131 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !77, size: 64)
!132 = !DIGlobalVariableExpression(var: !133, expr: !DIExpression())
!133 = distinct !DIGlobalVariable(name: "____fmt", scope: !134, file: !3, line: 55, type: !143, isLocal: true, isDefinition: true)
!134 = distinct !DISubprogram(name: "lookup_map_of_maps_queue", scope: !3, file: !3, line: 51, type: !135, scopeLine: 51, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !137)
!135 = !DISubroutineType(types: !136)
!136 = !{!25, !25, !25}
!137 = !{!138, !139, !140, !141}
!138 = !DILocalVariable(name: "key", arg: 1, scope: !134, file: !3, line: 51, type: !25)
!139 = !DILocalVariable(name: "number", arg: 2, scope: !134, file: !3, line: 51, type: !25)
!140 = !DILocalVariable(name: "map", scope: !134, file: !3, line: 52, type: !39)
!141 = !DILocalVariable(name: "i", scope: !142, file: !3, line: 60, type: !25)
!142 = distinct !DILexicalBlock(scope: !134, file: !3, line: 59, column: 24)
!143 = !DICompositeType(tag: DW_TAG_array_type, baseType: !77, size: 280, elements: !144)
!144 = !{!145}
!145 = !DISubrange(count: 35)
!146 = !DIGlobalVariableExpression(var: !147, expr: !DIExpression())
!147 = distinct !DIGlobalVariable(name: "____fmt", scope: !134, file: !3, line: 62, type: !148, isLocal: true, isDefinition: true)
!148 = !DICompositeType(tag: DW_TAG_array_type, baseType: !77, size: 304, elements: !149)
!149 = !{!150}
!150 = !DISubrange(count: 38)
!151 = !DIGlobalVariableExpression(var: !152, expr: !DIExpression())
!152 = distinct !DIGlobalVariable(name: "bpf_map_push_elem", scope: !2, file: !115, line: 2278, type: !153, isLocal: true, isDefinition: true)
!153 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !154, size: 64)
!154 = !DISubroutineType(types: !155)
!155 = !{!16, !15, !124, !74}
!156 = !{i32 7, !"Dwarf Version", i32 4}
!157 = !{i32 2, !"Debug Info Version", i32 3}
!158 = !{i32 1, !"wchar_size", i32 4}
!159 = !{!"Ubuntu clang version 11.0.0-2~ubuntu20.04.1"}
!160 = !DILocation(line: 0, scope: !57)
!161 = !DILocation(line: 76, column: 15, scope: !57)
!162 = !DILocation(line: 78, column: 41, scope: !57)
!163 = !{!164, !165, i64 4}
!164 = !{!"xdp_md", !165, i64 0, !165, i64 4, !165, i64 8, !165, i64 12, !165, i64 16}
!165 = !{!"int", !166, i64 0}
!166 = !{!"omnipotent char", !167, i64 0}
!167 = !{!"Simple C/C++ TBAA"}
!168 = !DILocation(line: 78, column: 30, scope: !57)
!169 = !DILocation(line: 79, column: 37, scope: !57)
!170 = !{!164, !165, i64 0}
!171 = !DILocation(line: 79, column: 26, scope: !57)
!172 = !DILocation(line: 0, scope: !173, inlinedAt: !179)
!173 = distinct !DISubprogram(name: "update_counter", scope: !3, file: !3, line: 39, type: !174, scopeLine: 39, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !176)
!174 = !DISubroutineType(types: !175)
!175 = !{!74, !25}
!176 = !{!177, !178}
!177 = !DILocalVariable(name: "key_cpu", arg: 1, scope: !173, file: !3, line: 39, type: !25)
!178 = !DILocalVariable(name: "value", scope: !173, file: !3, line: 40, type: !97)
!179 = distinct !DILocation(line: 83, column: 21, scope: !57)
!180 = !{!165, !165, i64 0}
!181 = !DILocation(line: 40, column: 21, scope: !173, inlinedAt: !179)
!182 = !DILocation(line: 41, column: 9, scope: !183, inlinedAt: !179)
!183 = distinct !DILexicalBlock(scope: !173, file: !3, line: 41, column: 8)
!184 = !DILocation(line: 41, column: 8, scope: !173, inlinedAt: !179)
!185 = !DILocation(line: 49, column: 1, scope: !173, inlinedAt: !179)
!186 = !DILocation(line: 84, column: 8, scope: !57)
!187 = !DILocation(line: 46, column: 12, scope: !173, inlinedAt: !179)
!188 = !{!189, !189, i64 0}
!189 = !{!"long long", !166, i64 0}
!190 = !DILocation(line: 84, column: 16, scope: !191)
!191 = distinct !DILexicalBlock(scope: !57, file: !3, line: 84, column: 8)
!192 = !DILocation(line: 85, column: 9, scope: !193)
!193 = distinct !DILexicalBlock(scope: !194, file: !3, line: 85, column: 9)
!194 = distinct !DILexicalBlock(scope: !191, file: !3, line: 84, column: 22)
!195 = !DILocation(line: 88, column: 8, scope: !57)
!196 = !DILocation(line: 88, column: 16, scope: !197)
!197 = distinct !DILexicalBlock(scope: !57, file: !3, line: 88, column: 8)
!198 = !DILocation(line: 89, column: 21, scope: !199)
!199 = distinct !DILexicalBlock(scope: !200, file: !3, line: 89, column: 12)
!200 = distinct !DILexicalBlock(scope: !197, file: !3, line: 88, column: 28)
!201 = !DILocation(line: 89, column: 28, scope: !199)
!202 = !DILocation(line: 89, column: 12, scope: !200)
!203 = !DILocation(line: 0, scope: !134, inlinedAt: !204)
!204 = distinct !DILocation(line: 90, column: 13, scope: !205)
!205 = distinct !DILexicalBlock(scope: !199, file: !3, line: 89, column: 37)
!206 = !DILocation(line: 52, column: 35, scope: !134, inlinedAt: !204)
!207 = !DILocation(line: 54, column: 9, scope: !208, inlinedAt: !204)
!208 = distinct !DILexicalBlock(scope: !134, file: !3, line: 54, column: 8)
!209 = !DILocation(line: 54, column: 8, scope: !134, inlinedAt: !204)
!210 = !DILocation(line: 0, scope: !142, inlinedAt: !204)
!211 = !DILocation(line: 60, column: 9, scope: !142, inlinedAt: !204)
!212 = !DILocation(line: 60, column: 13, scope: !142, inlinedAt: !204)
!213 = !DILocation(line: 61, column: 12, scope: !214, inlinedAt: !204)
!214 = distinct !DILexicalBlock(scope: !142, file: !3, line: 61, column: 12)
!215 = !DILocation(line: 61, column: 50, scope: !214, inlinedAt: !204)
!216 = !DILocation(line: 61, column: 12, scope: !142, inlinedAt: !204)
!217 = !DILocation(line: 55, column: 9, scope: !218, inlinedAt: !204)
!218 = distinct !DILexicalBlock(scope: !219, file: !3, line: 55, column: 9)
!219 = distinct !DILexicalBlock(scope: !208, file: !3, line: 54, column: 14)
!220 = !DILocation(line: 56, column: 9, scope: !219, inlinedAt: !204)
!221 = !DILocation(line: 62, column: 13, scope: !222, inlinedAt: !204)
!222 = distinct !DILexicalBlock(scope: !223, file: !3, line: 62, column: 13)
!223 = distinct !DILexicalBlock(scope: !214, file: !3, line: 61, column: 55)
!224 = !DILocation(line: 66, column: 5, scope: !134, inlinedAt: !204)
!225 = !DILocation(line: 69, column: 1, scope: !134, inlinedAt: !204)
!226 = !DILocation(line: 91, column: 9, scope: !205)
!227 = !DILocation(line: 0, scope: !134, inlinedAt: !228)
!228 = distinct !DILocation(line: 92, column: 13, scope: !229)
!229 = distinct !DILexicalBlock(scope: !199, file: !3, line: 91, column: 16)
!230 = !DILocation(line: 52, column: 35, scope: !134, inlinedAt: !228)
!231 = !DILocation(line: 54, column: 9, scope: !208, inlinedAt: !228)
!232 = !DILocation(line: 54, column: 8, scope: !134, inlinedAt: !228)
!233 = !DILocation(line: 0, scope: !142, inlinedAt: !228)
!234 = !DILocation(line: 60, column: 9, scope: !142, inlinedAt: !228)
!235 = !DILocation(line: 60, column: 13, scope: !142, inlinedAt: !228)
!236 = !DILocation(line: 61, column: 12, scope: !214, inlinedAt: !228)
!237 = !DILocation(line: 61, column: 50, scope: !214, inlinedAt: !228)
!238 = !DILocation(line: 61, column: 12, scope: !142, inlinedAt: !228)
!239 = !DILocation(line: 55, column: 9, scope: !218, inlinedAt: !228)
!240 = !DILocation(line: 56, column: 9, scope: !219, inlinedAt: !228)
!241 = !DILocation(line: 62, column: 13, scope: !222, inlinedAt: !228)
!242 = !DILocation(line: 66, column: 5, scope: !134, inlinedAt: !228)
!243 = !DILocation(line: 69, column: 1, scope: !134, inlinedAt: !228)
!244 = !DILocation(line: 96, column: 5, scope: !57)
