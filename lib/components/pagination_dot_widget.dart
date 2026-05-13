import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'pagination_dot_model.dart';
export 'pagination_dot_model.dart';

class PaginationDotWidget extends StatefulWidget {
  const PaginationDotWidget({
    super.key,
    bool? active,
  }) : active = active ?? true;

  final bool active;

  @override
  State<PaginationDotWidget> createState() => _PaginationDotWidgetState();
}

class _PaginationDotWidgetState extends State<PaginationDotWidget> {
  late PaginationDotModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaginationDotModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0),
      child: Container(
        child: Container(
          width: widget.active ? 24.0 : 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: widget.active
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate,
            borderRadius: BorderRadius.circular(50.0),
            shape: BoxShape.rectangle,
          ),
        ),
      ),
    );
  }
}
