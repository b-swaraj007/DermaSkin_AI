import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'scan_point_model.dart';
export 'scan_point_model.dart';

class ScanPointWidget extends StatefulWidget {
  const ScanPointWidget({
    super.key,
    String? align,
  }) : align = align ?? 'AlignValue(-0.4, -0.3)';

  final String align;

  @override
  State<ScanPointWidget> createState() => _ScanPointWidgetState();
}

class _ScanPointWidgetState extends State<ScanPointWidget> {
  late ScanPointModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ScanPointModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.0,
      height: 20.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).onPrimary27,
        borderRadius: BorderRadius.circular(50.0),
        shape: BoxShape.rectangle,
      ),
      alignment: const AlignmentDirectional(0.0, 0.0),
      child: Container(
        width: 8.0,
        height: 8.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).onPrimary,
          boxShadow: [
            BoxShadow(
              blurRadius: 8.0,
              color: FlutterFlowTheme.of(context).onPrimary,
              offset: const Offset(
                0.0,
                0.0,
              ),
              spreadRadius: 0.0,
            )
          ],
          borderRadius: BorderRadius.circular(50.0),
          shape: BoxShape.rectangle,
        ),
      ),
    );
  }
}
