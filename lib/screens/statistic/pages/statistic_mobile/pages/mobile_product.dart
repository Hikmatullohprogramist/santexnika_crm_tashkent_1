import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santexnika_crm/screens/statistic/cubits/statistic_cubit.dart';
import 'package:santexnika_crm/tools/appColors.dart';
import 'package:santexnika_crm/widgets/statistic_bar.dart';

import '../../../../../widgets/loading_widget.dart';
import '../../../../../widgets/text_widget/text_widget.dart';
import '../widget/mobile_prouduct_widget.dart';

class MobileProductStatisticUI extends StatefulWidget {
  const MobileProductStatisticUI({super.key});

  @override
  State<MobileProductStatisticUI> createState() =>
      _MobileProductStatisticUIState();
}

class _MobileProductStatisticUIState extends State<MobileProductStatisticUI> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<StatisticCubit>().getStoreStatistic();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bottombarColor,
      body: Column(
        children: [
          StatisticBarWidget(name: "Tovarlar"),
          BlocBuilder<StatisticCubit, StatisticState>(
            builder: (context, state) {
              if (state is StatisticLoading) {
                return const ApiLoadingWidget();
              } else if (state is StatisticError) {
                return Center(
                  child: TextWidget(txt: state.error),
                );
              } else if (state is StatisticSuccessStore) {
                return MobileProductWidget(dataMap: state.data);
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}
