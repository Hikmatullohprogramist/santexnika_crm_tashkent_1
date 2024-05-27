import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santexnika_crm/screens/settings/cubit/access/access_cubit.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/tools/format_date_time.dart';
import 'package:santexnika_crm/widgets/background_widget.dart';
import 'package:santexnika_crm/widgets/error_widget.dart';
import 'package:santexnika_crm/widgets/loading_widget.dart';
import 'package:santexnika_crm/widgets/mobile_api_error.dart';
import 'package:santexnika_crm/widgets/sized_box.dart';
import 'package:santexnika_crm/widgets/text_widget/rows_text_widget.dart';

class MobilePermissionScreen extends StatefulWidget {
  const MobilePermissionScreen({super.key});

  @override
  State<MobilePermissionScreen> createState() => _MobilePermissionScreenState();
}

class _MobilePermissionScreenState extends State<MobilePermissionScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AccessCubit>().getAccess();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      body: RefreshIndicator(
        onRefresh: () async {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            context.read<AccessCubit>().getAccess();
          });
        },
        child: BlocBuilder<AccessCubit, AccessState>(
          builder: (BuildContext context, state) {
            if (state is AccessLoadingState) {
              return const ApiLoadingWidget();
            } else if (state is AccessErrorState) {
              return MobileAPiError(
                message: state.error,
                onTap: () {
                  context.read<AccessCubit>().getAccess();
                },
              );
            } else if (state is AccessSuccessState) {
              return ListView.builder(
                itemCount: state.data.length,
                itemBuilder: (context, index) {
                  var data = state.data[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MobileBackgroundWidget(
                      child: Column(
                        children: [
                          RowsTextWidget(
                            title: "Nomi: ",
                            name: data.name ?? '',
                          ),
                          const Hg(
                            height: 5,
                          ),
                          RowsTextWidget(
                            title: "Sana: ",
                            name: formatDate(
                              DateTime.parse(
                                data.createdAt.toString(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
