; ModuleID = 'xdp_prog_kern.c'
source_filename = "xdp_prog_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.anon = type { ptr, ptr, ptr, ptr }
%struct.anon.0 = type { ptr, ptr, ptr, ptr }
%struct.map_elem = type <{ i32, [4 x i8], %struct.bpf_timer }>
%struct.bpf_timer = type { i128 }

@timer_array = dso_local global %struct.anon zeroinitializer, section ".maps", align 8, !dbg !0
@testing_timer.____fmt = internal constant [30 x i8] c"Couldn't get entry of the map\00", align 1, !dbg !15
@testing_timer.____fmt.1 = internal constant [11 x i8] c"BEFORE: %d\00", align 1, !dbg !50
@testing_timer.____fmt.2 = internal constant [36 x i8] c"Error while initializing timer: %ld\00", align 1, !dbg !55
@testing_timer.____fmt.3 = internal constant [34 x i8] c"Error while setting callback: %ld\00", align 1, !dbg !60
@testing_timer.____fmt.4 = internal constant [5 x i8] c"TEST\00", align 1, !dbg !65
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !70
@test_array = dso_local global %struct.anon.0 zeroinitializer, section ".maps", align 8, !dbg !75
@function.____fmt = internal constant [30 x i8] c"Couldn't get entry of the map\00", align 1, !dbg !129
@function.____fmt.5 = internal constant [16 x i8] c"AFTER ENTRY: %d\00", align 1, !dbg !139
@function.____fmt.6 = internal constant [14 x i8] c"AFTER VAL: %d\00", align 1, !dbg !144
@test_function.____fmt = internal constant [22 x i8] c"TESTING FUNCTION CALL\00", align 1, !dbg !149
@llvm.compiler.used = appending global [4 x ptr] [ptr @_license, ptr @test_array, ptr @testing_timer, ptr @timer_array], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @testing_timer(ptr nocapture readnone %0) #0 section "xdp" !dbg !17 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata ptr poison, metadata !33, metadata !DIExpression()), !dbg !173
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #3, !dbg !174
  %3 = tail call i32 inttoptr (i64 8 to ptr)() #3, !dbg !175
  call void @llvm.dbg.value(metadata i32 %3, metadata !34, metadata !DIExpression()), !dbg !173
  store i32 %3, ptr %2, align 4, !dbg !176, !tbaa !177
  call void @llvm.dbg.value(metadata ptr %2, metadata !34, metadata !DIExpression(DW_OP_deref)), !dbg !173
  %4 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @timer_array, ptr noundef nonnull %2) #3, !dbg !181
  call void @llvm.dbg.value(metadata ptr %4, metadata !35, metadata !DIExpression()), !dbg !173
  %5 = icmp eq ptr %4, null, !dbg !182
  br i1 %5, label %6, label %8, !dbg !184

6:                                                ; preds = %1
  %7 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @testing_timer.____fmt, i32 noundef 30) #3, !dbg !185
  br label %24, !dbg !188

8:                                                ; preds = %1
  %9 = load i32, ptr %4, align 8, !dbg !189, !tbaa !191
  %10 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @testing_timer.____fmt.1, i32 noundef 11, i32 noundef %9) #3, !dbg !189
  %11 = getelementptr inbounds %struct.map_elem, ptr %4, i64 0, i32 2, !dbg !194
  %12 = call i64 inttoptr (i64 169 to ptr)(ptr noundef nonnull %11, ptr noundef nonnull @timer_array, i64 noundef 7) #3, !dbg !195
  call void @llvm.dbg.value(metadata i64 %12, metadata !43, metadata !DIExpression()), !dbg !173
  %13 = icmp eq i64 %12, 0, !dbg !196
  br i1 %13, label %16, label %14, !dbg !198

14:                                               ; preds = %8
  %15 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @testing_timer.____fmt.2, i32 noundef 36, i64 noundef %12) #3, !dbg !199
  br label %16, !dbg !201

16:                                               ; preds = %14, %8
  %17 = call i64 inttoptr (i64 170 to ptr)(ptr noundef nonnull %11, ptr noundef nonnull @function) #3, !dbg !202
  call void @llvm.dbg.value(metadata i64 %17, metadata !43, metadata !DIExpression()), !dbg !173
  %18 = icmp eq i64 %17, 0, !dbg !203
  br i1 %18, label %21, label %19, !dbg !205

19:                                               ; preds = %16
  %20 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @testing_timer.____fmt.3, i32 noundef 34, i64 noundef %17) #3, !dbg !206
  br label %21, !dbg !208

21:                                               ; preds = %19, %16
  %22 = call i64 inttoptr (i64 171 to ptr)(ptr noundef nonnull %11, i64 noundef 1000000000, i64 noundef 0) #3, !dbg !209
  %23 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @testing_timer.____fmt.4, i32 noundef 5) #3, !dbg !210
  br label %24

24:                                               ; preds = %21, %6
  %25 = phi i32 [ 0, %21 ], [ 1, %6 ], !dbg !173
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #3, !dbg !212
  ret i32 %25, !dbg !212
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nounwind
define internal i32 @function(ptr noundef %0, ptr noundef %1, ptr nocapture noundef %2) #0 !dbg !131 {
  call void @llvm.dbg.value(metadata ptr %0, metadata !135, metadata !DIExpression()), !dbg !213
  call void @llvm.dbg.value(metadata ptr %1, metadata !136, metadata !DIExpression()), !dbg !213
  call void @llvm.dbg.value(metadata ptr %2, metadata !137, metadata !DIExpression()), !dbg !213
  %4 = tail call ptr inttoptr (i64 1 to ptr)(ptr noundef %0, ptr noundef %1) #3, !dbg !214
  call void @llvm.dbg.value(metadata ptr %4, metadata !138, metadata !DIExpression()), !dbg !213
  %5 = icmp eq ptr %4, null, !dbg !215
  br i1 %5, label %6, label %8, !dbg !217

6:                                                ; preds = %3
  %7 = tail call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @function.____fmt, i32 noundef 30) #3, !dbg !218
  br label %18, !dbg !221

8:                                                ; preds = %3
  %9 = load i32, ptr %4, align 8, !dbg !222, !tbaa !191
  %10 = icmp slt i32 %9, 10, !dbg !224
  br i1 %10, label %11, label %18, !dbg !225

11:                                               ; preds = %8
  %12 = tail call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @function.____fmt.5, i32 noundef 16, i32 noundef %9) #3, !dbg !226
  %13 = load i32, ptr %2, align 8, !dbg !229, !tbaa !191
  %14 = tail call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @function.____fmt.6, i32 noundef 14, i32 noundef %13) #3, !dbg !229
  %15 = load i32, ptr %2, align 8, !dbg !231, !tbaa !191
  %16 = add nsw i32 %15, 1, !dbg !232
  store i32 %16, ptr %2, align 8, !dbg !233, !tbaa !191
  %17 = tail call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @test_function.____fmt, i32 noundef 22) #3, !dbg !234
  br label %18, !dbg !237

18:                                               ; preds = %8, %11, %6
  ret i32 0, !dbg !238
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!168, !169, !170, !171}
!llvm.ident = !{!172}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "timer_array", scope: !2, file: !3, line: 30, type: !162, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 16.0.6 (++20231112100510+7cbf1a259152-1~exp1~20231112100554.106)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !14, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "xdp_prog_kern.c", directory: "/home/pvvalenc/benchmark/benchmark_XDP_map/xdp/timer", checksumkind: CSK_MD5, checksum: "bbad314d6ccf8df87763dae3c67811eb")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 5436, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/include/linux/bpf.h", directory: "", checksumkind: CSK_MD5, checksum: "3810ac036d82ed3898d498c10e871015")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2)
!12 = !DIEnumerator(name: "XDP_TX", value: 3)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!14 = !{!15, !50, !55, !60, !65, !70, !0, !75, !96, !102, !110, !116, !124, !129, !139, !144, !149, !157}
!15 = !DIGlobalVariableExpression(var: !16, expr: !DIExpression())
!16 = distinct !DIGlobalVariable(name: "____fmt", scope: !17, file: !3, line: 88, type: !45, isLocal: true, isDefinition: true)
!17 = distinct !DISubprogram(name: "testing_timer", scope: !3, file: !3, line: 80, type: !18, scopeLine: 81, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !32)
!18 = !DISubroutineType(types: !19)
!19 = !{!20, !21}
!20 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!21 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 64)
!22 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 5447, size: 192, elements: !23)
!23 = !{!24, !27, !28, !29, !30, !31}
!24 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !22, file: !6, line: 5448, baseType: !25, size: 32)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !26, line: 27, baseType: !7)
!26 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!27 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !22, file: !6, line: 5449, baseType: !25, size: 32, offset: 32)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !22, file: !6, line: 5450, baseType: !25, size: 32, offset: 64)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !22, file: !6, line: 5452, baseType: !25, size: 32, offset: 96)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !22, file: !6, line: 5453, baseType: !25, size: 32, offset: 128)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "egress_ifindex", scope: !22, file: !6, line: 5455, baseType: !25, size: 32, offset: 160)
!32 = !{!33, !34, !35, !43}
!33 = !DILocalVariable(name: "ctx", arg: 1, scope: !17, file: !3, line: 80, type: !21)
!34 = !DILocalVariable(name: "cpu", scope: !17, file: !3, line: 82, type: !20)
!35 = !DILocalVariable(name: "map_entry", scope: !17, file: !3, line: 84, type: !36)
!36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!37 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "map_elem", file: !3, line: 19, size: 192, elements: !38)
!38 = !{!39, !40}
!39 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !37, file: !3, line: 20, baseType: !20, size: 32)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "timer", scope: !37, file: !3, line: 21, baseType: !41, size: 128, align: 64, offset: 64)
!41 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_timer", file: !6, line: 6190, size: 128, align: 64, elements: !42)
!42 = !{}
!43 = !DILocalVariable(name: "i", scope: !17, file: !3, line: 104, type: !44)
!44 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !46, size: 240, elements: !48)
!46 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !47)
!47 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!48 = !{!49}
!49 = !DISubrange(count: 30)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "____fmt", scope: !17, file: !3, line: 99, type: !52, isLocal: true, isDefinition: true)
!52 = !DICompositeType(tag: DW_TAG_array_type, baseType: !46, size: 88, elements: !53)
!53 = !{!54}
!54 = !DISubrange(count: 11)
!55 = !DIGlobalVariableExpression(var: !56, expr: !DIExpression())
!56 = distinct !DIGlobalVariable(name: "____fmt", scope: !17, file: !3, line: 106, type: !57, isLocal: true, isDefinition: true)
!57 = !DICompositeType(tag: DW_TAG_array_type, baseType: !46, size: 288, elements: !58)
!58 = !{!59}
!59 = !DISubrange(count: 36)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(name: "____fmt", scope: !17, file: !3, line: 111, type: !62, isLocal: true, isDefinition: true)
!62 = !DICompositeType(tag: DW_TAG_array_type, baseType: !46, size: 272, elements: !63)
!63 = !{!64}
!64 = !DISubrange(count: 34)
!65 = !DIGlobalVariableExpression(var: !66, expr: !DIExpression())
!66 = distinct !DIGlobalVariable(name: "____fmt", scope: !17, file: !3, line: 119, type: !67, isLocal: true, isDefinition: true)
!67 = !DICompositeType(tag: DW_TAG_array_type, baseType: !46, size: 40, elements: !68)
!68 = !{!69}
!69 = !DISubrange(count: 5)
!70 = !DIGlobalVariableExpression(var: !71, expr: !DIExpression())
!71 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 124, type: !72, isLocal: false, isDefinition: true)
!72 = !DICompositeType(tag: DW_TAG_array_type, baseType: !47, size: 32, elements: !73)
!73 = !{!74}
!74 = !DISubrange(count: 4)
!75 = !DIGlobalVariableExpression(var: !76, expr: !DIExpression())
!76 = distinct !DIGlobalVariable(name: "test_array", scope: !2, file: !3, line: 41, type: !77, isLocal: false, isDefinition: true)
!77 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 36, size: 256, elements: !78)
!78 = !{!79, !84, !86, !91}
!79 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !77, file: !3, line: 37, baseType: !80, size: 64)
!80 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !81, size: 64)
!81 = !DICompositeType(tag: DW_TAG_array_type, baseType: !20, size: 64, elements: !82)
!82 = !{!83}
!83 = !DISubrange(count: 2)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !77, file: !3, line: 38, baseType: !85, size: 64, offset: 64)
!85 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !25, size: 64)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !77, file: !3, line: 39, baseType: !87, size: 64, offset: 128)
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !88, size: 64)
!88 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "test_elem", file: !3, line: 32, size: 32, elements: !89)
!89 = !{!90}
!90 = !DIDerivedType(tag: DW_TAG_member, name: "test_val", scope: !88, file: !3, line: 33, baseType: !20, size: 32)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !77, file: !3, line: 40, baseType: !92, size: 64, offset: 192)
!92 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !93, size: 64)
!93 = !DICompositeType(tag: DW_TAG_array_type, baseType: !20, size: 256, elements: !94)
!94 = !{!95}
!95 = !DISubrange(count: 8)
!96 = !DIGlobalVariableExpression(var: !97, expr: !DIExpression())
!97 = distinct !DIGlobalVariable(name: "bpf_get_smp_processor_id", scope: !2, file: !98, line: 206, type: !99, isLocal: true, isDefinition: true)
!98 = !DIFile(filename: "../lib/install/include/bpf/bpf_helper_defs.h", directory: "/home/pvvalenc/benchmark/benchmark_XDP_map/xdp/timer", checksumkind: CSK_MD5, checksum: "7422ca06c9dc86eba2f268a57d8acf2f")
!99 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !100, size: 64)
!100 = !DISubroutineType(types: !101)
!101 = !{!25}
!102 = !DIGlobalVariableExpression(var: !103, expr: !DIExpression())
!103 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !98, line: 56, type: !104, isLocal: true, isDefinition: true)
!104 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !105, size: 64)
!105 = !DISubroutineType(types: !106)
!106 = !{!107, !107, !108}
!107 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!108 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !109, size: 64)
!109 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!110 = !DIGlobalVariableExpression(var: !111, expr: !DIExpression())
!111 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !98, line: 177, type: !112, isLocal: true, isDefinition: true)
!112 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !113, size: 64)
!113 = !DISubroutineType(types: !114)
!114 = !{!44, !115, !25, null}
!115 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46, size: 64)
!116 = !DIGlobalVariableExpression(var: !117, expr: !DIExpression())
!117 = distinct !DIGlobalVariable(name: "bpf_timer_init", scope: !2, file: !98, line: 3992, type: !118, isLocal: true, isDefinition: true)
!118 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !119, size: 64)
!119 = !DISubroutineType(types: !120)
!120 = !{!44, !121, !107, !122}
!121 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !41, size: 64)
!122 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !26, line: 31, baseType: !123)
!123 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!124 = !DIGlobalVariableExpression(var: !125, expr: !DIExpression())
!125 = distinct !DIGlobalVariable(name: "bpf_timer_set_callback", scope: !2, file: !98, line: 4007, type: !126, isLocal: true, isDefinition: true)
!126 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !127, size: 64)
!127 = !DISubroutineType(types: !128)
!128 = !{!44, !121, !107}
!129 = !DIGlobalVariableExpression(var: !130, expr: !DIExpression())
!130 = distinct !DIGlobalVariable(name: "____fmt", scope: !131, file: !3, line: 52, type: !45, isLocal: true, isDefinition: true)
!131 = distinct !DISubprogram(name: "function", scope: !3, file: !3, line: 49, type: !132, scopeLine: 49, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !134)
!132 = !DISubroutineType(types: !133)
!133 = !{!20, !107, !85, !36}
!134 = !{!135, !136, !137, !138}
!135 = !DILocalVariable(name: "map", arg: 1, scope: !131, file: !3, line: 49, type: !107)
!136 = !DILocalVariable(name: "key", arg: 2, scope: !131, file: !3, line: 49, type: !85)
!137 = !DILocalVariable(name: "val", arg: 3, scope: !131, file: !3, line: 49, type: !36)
!138 = !DILocalVariable(name: "entry", scope: !131, file: !3, line: 50, type: !36)
!139 = !DIGlobalVariableExpression(var: !140, expr: !DIExpression())
!140 = distinct !DIGlobalVariable(name: "____fmt", scope: !131, file: !3, line: 66, type: !141, isLocal: true, isDefinition: true)
!141 = !DICompositeType(tag: DW_TAG_array_type, baseType: !46, size: 128, elements: !142)
!142 = !{!143}
!143 = !DISubrange(count: 16)
!144 = !DIGlobalVariableExpression(var: !145, expr: !DIExpression())
!145 = distinct !DIGlobalVariable(name: "____fmt", scope: !131, file: !3, line: 67, type: !146, isLocal: true, isDefinition: true)
!146 = !DICompositeType(tag: DW_TAG_array_type, baseType: !46, size: 112, elements: !147)
!147 = !{!148}
!148 = !DISubrange(count: 14)
!149 = !DIGlobalVariableExpression(var: !150, expr: !DIExpression())
!150 = distinct !DIGlobalVariable(name: "____fmt", scope: !151, file: !3, line: 44, type: !154, isLocal: true, isDefinition: true)
!151 = distinct !DISubprogram(name: "test_function", scope: !3, file: !3, line: 43, type: !152, scopeLine: 43, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !42)
!152 = !DISubroutineType(types: !153)
!153 = !{null}
!154 = !DICompositeType(tag: DW_TAG_array_type, baseType: !46, size: 176, elements: !155)
!155 = !{!156}
!156 = !DISubrange(count: 22)
!157 = !DIGlobalVariableExpression(var: !158, expr: !DIExpression())
!158 = distinct !DIGlobalVariable(name: "bpf_timer_start", scope: !2, file: !98, line: 4043, type: !159, isLocal: true, isDefinition: true)
!159 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !160, size: 64)
!160 = !DISubroutineType(types: !161)
!161 = !{!44, !121, !122, !122}
!162 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 25, size: 256, elements: !163)
!163 = !{!164, !165, !166, !167}
!164 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !162, file: !3, line: 26, baseType: !80, size: 64)
!165 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !162, file: !3, line: 27, baseType: !85, size: 64, offset: 64)
!166 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !162, file: !3, line: 28, baseType: !36, size: 64, offset: 128)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !162, file: !3, line: 29, baseType: !92, size: 64, offset: 192)
!168 = !{i32 7, !"Dwarf Version", i32 5}
!169 = !{i32 2, !"Debug Info Version", i32 3}
!170 = !{i32 1, !"wchar_size", i32 4}
!171 = !{i32 7, !"frame-pointer", i32 2}
!172 = !{!"Ubuntu clang version 16.0.6 (++20231112100510+7cbf1a259152-1~exp1~20231112100554.106)"}
!173 = !DILocation(line: 0, scope: !17)
!174 = !DILocation(line: 82, column: 5, scope: !17)
!175 = !DILocation(line: 82, column: 15, scope: !17)
!176 = !DILocation(line: 82, column: 9, scope: !17)
!177 = !{!178, !178, i64 0}
!178 = !{!"int", !179, i64 0}
!179 = !{!"omnipotent char", !180, i64 0}
!180 = !{!"Simple C/C++ TBAA"}
!181 = !DILocation(line: 86, column: 17, scope: !17)
!182 = !DILocation(line: 87, column: 9, scope: !183)
!183 = distinct !DILexicalBlock(scope: !17, file: !3, line: 87, column: 8)
!184 = !DILocation(line: 87, column: 8, scope: !17)
!185 = !DILocation(line: 88, column: 9, scope: !186)
!186 = distinct !DILexicalBlock(scope: !187, file: !3, line: 88, column: 9)
!187 = distinct !DILexicalBlock(scope: !183, file: !3, line: 87, column: 20)
!188 = !DILocation(line: 89, column: 9, scope: !187)
!189 = !DILocation(line: 99, column: 5, scope: !190)
!190 = distinct !DILexicalBlock(scope: !17, file: !3, line: 99, column: 5)
!191 = !{!192, !178, i64 0}
!192 = !{!"map_elem", !178, i64 0, !193, i64 8}
!193 = !{!"bpf_timer"}
!194 = !DILocation(line: 104, column: 45, scope: !17)
!195 = !DILocation(line: 104, column: 18, scope: !17)
!196 = !DILocation(line: 105, column: 10, scope: !197)
!197 = distinct !DILexicalBlock(scope: !17, file: !3, line: 105, column: 8)
!198 = !DILocation(line: 105, column: 8, scope: !17)
!199 = !DILocation(line: 106, column: 9, scope: !200)
!200 = distinct !DILexicalBlock(scope: !197, file: !3, line: 106, column: 9)
!201 = !DILocation(line: 106, column: 9, scope: !197)
!202 = !DILocation(line: 109, column: 9, scope: !17)
!203 = !DILocation(line: 110, column: 10, scope: !204)
!204 = distinct !DILexicalBlock(scope: !17, file: !3, line: 110, column: 8)
!205 = !DILocation(line: 110, column: 8, scope: !17)
!206 = !DILocation(line: 111, column: 9, scope: !207)
!207 = distinct !DILexicalBlock(scope: !204, file: !3, line: 111, column: 9)
!208 = !DILocation(line: 111, column: 9, scope: !204)
!209 = !DILocation(line: 114, column: 5, scope: !17)
!210 = !DILocation(line: 119, column: 5, scope: !211)
!211 = distinct !DILexicalBlock(scope: !17, file: !3, line: 119, column: 5)
!212 = !DILocation(line: 122, column: 1, scope: !17)
!213 = !DILocation(line: 0, scope: !131)
!214 = !DILocation(line: 50, column: 30, scope: !131)
!215 = !DILocation(line: 51, column: 9, scope: !216)
!216 = distinct !DILexicalBlock(scope: !131, file: !3, line: 51, column: 8)
!217 = !DILocation(line: 51, column: 8, scope: !131)
!218 = !DILocation(line: 52, column: 9, scope: !219)
!219 = distinct !DILexicalBlock(scope: !220, file: !3, line: 52, column: 9)
!220 = distinct !DILexicalBlock(scope: !216, file: !3, line: 51, column: 16)
!221 = !DILocation(line: 53, column: 9, scope: !220)
!222 = !DILocation(line: 65, column: 15, scope: !223)
!223 = distinct !DILexicalBlock(scope: !131, file: !3, line: 65, column: 8)
!224 = !DILocation(line: 65, column: 21, scope: !223)
!225 = !DILocation(line: 65, column: 8, scope: !131)
!226 = !DILocation(line: 66, column: 9, scope: !227)
!227 = distinct !DILexicalBlock(scope: !228, file: !3, line: 66, column: 9)
!228 = distinct !DILexicalBlock(scope: !223, file: !3, line: 65, column: 27)
!229 = !DILocation(line: 67, column: 9, scope: !230)
!230 = distinct !DILexicalBlock(scope: !228, file: !3, line: 67, column: 9)
!231 = !DILocation(line: 68, column: 27, scope: !228)
!232 = !DILocation(line: 68, column: 33, scope: !228)
!233 = !DILocation(line: 68, column: 20, scope: !228)
!234 = !DILocation(line: 44, column: 5, scope: !235, inlinedAt: !236)
!235 = distinct !DILexicalBlock(scope: !151, file: !3, line: 44, column: 5)
!236 = distinct !DILocation(line: 70, column: 9, scope: !228)
!237 = !DILocation(line: 74, column: 5, scope: !228)
!238 = !DILocation(line: 77, column: 1, scope: !131)
